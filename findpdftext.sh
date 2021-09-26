#!/bin/bash  

selected=`find -type f -iname '*.pdf' | fzf | sed 's/^..//g' | tr -d '\n'`

if [[ -z $selected ]]; then
    exit 0
fi

echo -e "\033[31m*** $selected\033[0m"

while [ true ]; do 
	read -p "Find text: " query 
	if find -type f -iname '*.pdf' | grep -qs "$selected" ; then
		pdfgrep -iA 60 "$query" "$selected" | less -Q 
	else
    echo "found nothing" | less -Q
	fi
done
