#!/bin/bash
INPUTNAME="$1"


ReplaceName () {
FINDSPACE=$( find $INPUTNAME -name "* *" || find $INPUTNAME -name "\ " | wc -l ) 
if [[ $FINDSPACE -gt 0 ]];
then 
echo "wasdfafsadfsd sdfs"
else
echo $INPUTNAME
fi
}

NAME_FILE="$( ReplaceName )"

Result () {
ISJURNAL=$( pdfgrep --page-range 1 -ioc "Abstrak|Abstract|Kesimpulan|Conclusion|Penutup|Simpulan" "$NAME_FILE"  )
ISABSTRAK=$( pdfgrep --page-range 1 -ioc "Abstrak" "$NAME_FILE" )

ABSTRAK=$(pdfgrep --page-range 1 -iA 30 'Abstrak|ABSTRAK' "$NAME_FILE" |awk '(/ABSTRAK/)||(/Abstrak/){flag=1;next}(/KATA KUNCI/)||(/ABSTRACT/)||(/Kata Kunci/)||(/Keywords/)||(/LATAR BELAKANG/)||(/Latar Belakang/)||(/Pendahuluan/)||(/PENDAHULUAN/)||(/Introduction/)||(/INTRODUCTION/)||(/KEYWORDS/){flag=0}flag'|xargs)
ABSTRACT=$(pdfgrep --page-range 1  -iA 30 'ABSTRACT|Abstract' "$NAME_FILE" |awk '(/ABSTRACT/)||(/Abstract/){flag=1;next}(/LATAR BELAKANG/)||(/Latar Belakang/)||(/Pendahuluan/)||(/PENDAHULUAN/)||(/Introduction/)||(/INTRODUCTION/)||(/Keywords/)||(/KEYWORDS/){flag=0}flag'|xargs)
KESIMPULAN=$(pdfgrep -iA 30 'Kesimpulan|Conclusion|PENUTUP|Simpulan' "$NAME_FILE" | awk '(/Kesimpulan$/)||(/^Conclusion$/)||(/PENUTUP/)||(/^Penutup$/)||(/Simpulan/)||(/SIMPULAN/){flag=1;next}(/^Saran$/)||(/DAFTAR PUSTAKA/)||(/Daftar Pustaka/){flag=0}flag'|xargs)
KATAKUNCI=$(pdfgrep --page-range 1 -i 'Kata Kunci|KATA KUNCI' "$NAME_FILE" \
||pdfgrep --page-range 1 -i 'Keywords|KEYWORDS' "$NAME_FILE" | xargs)


TEORI=$( pdfgrep -iof model_theory.txt "$NAME_FILE" )

ETC=$( pdfgrep -iA 50 'Mengadili|Kesimpulan|Conclusion|Preface|Abstraksi|Menimbang' "$NAME_FILE" | xargs )

#  JENIS JURNAL! 
if [[ $ISJURNAL -ge 1 ]];
then

read -p "Perlu dirangkum? [Y,n]: " input 
if [[ $input ==  "n" || $input == "N" ]] ; 
then

# kalau tidak perlu dirangkum tidak dimasukin ke summarizertext.py 

if [[ $ISABSTRAK -ge 1 ]];	
then 
# find Abstrak if pdf is Indonesia 
echo -e '\033[31mAbstrak:\033[0m'&&
echo "$ABSTRAK" ;
echo -e '\n\033[31mKesimpulan\033[0m'&&\
echo "$KESIMPULAN" ;
else 
# find Abstrak if pdf is English
echo -e '\n\033[31mAbstrak:\033[0m'&&
echo "$ABSTRACT"
echo -e '\033[31mKesimpulan:\033[0m'&&\
echo "$KESIMPULAN" ;
fi 
echo "$KATAKUNCI" ;
echo -e '\n\033[31mTeori:\033[0m';
echo "$TEORI" | sort -uk2 -f | sort -nk1 | xargs



# if perlu dirangkum 
elif [[ $input == "Y" || $input == "y" ]] ;
then

echo -e '\n\033[31mRingkasan:\033[0m'&&

if [[ $ISABSTRAK -ge 1 ]];	
then 
echo "$ABSTRAK $KESIMPULAN" | python3 summarizer.py | xargs ;
else 
echo "$ABSTRACT $KESIMPULAN" | python3 summarizer.py | xargs ;

fi 

echo "$KATAKUNCI" ;
echo -e '\n\033[31mTeori:\033[0m';
echo "$TEORI" | sort -uk2 -f | sort -nk1 | xargs
# if the ouput either y or n 
else 
	echo "Harap masukan input dengan benar.."
fi

# JENIS SELAIN JURNAL 
else
echo -e '\n\033[31mRingkasan:\033[0m'&&
echo -e "$ETC" | python3 summarizer.py | xargs ;
#	echo "$ABSTRACT $KESIMPULAN" | python3 summarizer.py ;
fi
}

Result
