#!/bin/bash  

selected=`find -type d | fzf`

if [[ -z $selected ]]; then
    exit 0
fi

echo -e "\033[31m*** $selected\033[0m"

while [ true ]; do 
	read -p "Find text: " query 
	if find -type d | grep -qs "$selected" ; then
		pdfgrep --color auto -iA 60 -B 30 "$query" -r "$selected" --cache -n --warn-empty| less --silent -I --use-color --incsearch -~ -s
	else
    echo "found nothing" | less -Q
	fi
done
