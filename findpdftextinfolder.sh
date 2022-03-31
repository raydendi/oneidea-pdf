#!/bin/bash  

selected=`find -type d | fzf`

if [[ -z $selected ]]; then
    exit 0
fi

echo -e "\033[31m*** $selected\033[0m"

while [ true ]; do 
	read -p "Find text: " query 
	if find -type d | grep -qs "$selected" ; then
		pdfgrep -iA 60 "$query" -r "$selected" | less -Q 
	else
    echo "found nothing" | less -Q
	fi
done
