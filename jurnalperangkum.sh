#!/bin/bash
NAME_FILE=$1
result="$" 

read -p "Perlu dirangkum? [Y,n]: " input 
# Kata Kunci
RESULT=$( pdfgrep --page-range 1 -ioc "Abstrak" "$NAME_FILE" )

ABSTRAK=$(pdfgrep --page-range 1 -iA 30 'Abstrak|ABSTRAK' $NAME_FILE |awk '(/ABSTRAK/)||(/Abstrak/){flag=1;next}(/KATA KUNCI/)||(/ABSTRACT/)||(/Kata Kunci/)||(/Keywords/)||(/LATAR BELAKANG/)||(/Latar Belakang/)||(/Pendahuluan/)||(/PENDAHULUAN/)||(/Introduction/)||(/INTRODUCTION/)||(/KEYWORDS/){flag=0}flag'|xargs)

KESIMPULAN=$(pdfgrep -iA 30 'Kesimpulan|Conclusion|PENUTUP|Simpulan' $NAME_FILE | awk '(/Kesimpulan$/)||(/^Conclusion$/)||(/PENUTUP/)||(/^Penutup$/)||(/Simpulan/)||(/SIMPULAN/){flag=1;next}(/^Saran$/)||(/DAFTAR PUSTAKA/)||(/Daftar Pustaka/){flag=0}flag'|xargs)

KATAKUNCI=$(pdfgrep --page-range 1 -i 'Kata Kunci|KATA KUNCI' $NAME_FILE \
||pdfgrep --page-range 1 -i 'Keywords|KEYWORDS' $NAME_FILE | xargs)

ABSTRACT=$(pdfgrep --page-range 1  -iA 30 'ABSTRACT|Abstract' $NAME_FILE|awk '(/ABSTRACT/)||(/Abstract/){flag=1;next}(/LATAR BELAKANG/)||(/Latar Belakang/)||(/Pendahuluan/)||(/PENDAHULUAN/)||(/Introduction/)||(/INTRODUCTION/)||(/Keywords/)||(/KEYWORDS/){flag=0}flag'|xargs)

TEORI=$(echo -e '\n\033[31mTeori:\033[0m'; pdfgrep -iof model_theory.txt $NAME_FILE | xargs)

if [[ $input ==  "n" || $input == "N" ]] ; 
then

# kalau tidak perlu dirangkum tidak dimasukin ke python

pdfgrep --page-range 1 -i 'Kata Kunci|KATA KUNCI' $NAME_FILE \
||pdfgrep --page-range 1 -i 'Keywords|KEYWORDS' $NAME_FILE | xargs;\
if [[ $RESULT -ge 1 ]];	
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
echo "$TEORI"
# python script from pdfgrep and awk
elif [[ $input == "Y" || $input == "y" ]] ;
then
echo -e '\n\033[31mRingkasan:\033[0m'&&

if [[ $RESULT -ge 1 ]];	
then 
# find Abstrak if pdf is Indonesia 
echo "$ABSTRAK $KESIMPULAN" | python3 sumarrizertext.py ;

else 
# find Abstrak if pdf is English
echo "$ABSTRACT $KESIMPULAN" | python3 sumarrizertext.py ;

fi 
echo "$KATAKUNCI" ;
echo "$TEORI"

# Kalau outputnya salah bukan y atau n 
else 
	echo "Harap masukan input dengan benar.."
fi

