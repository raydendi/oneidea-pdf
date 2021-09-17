#!/bin/bash  
selected=`find -type f | fzf | sed 's/^..//g' | tr -d '\n'`

if [[ -z $selected ]]; then
    exit 0
fi

read -p "Find text: " query

if ls -f | grep -qs "$selected" ; then
	#	selected=${selected// \\ //}
	#selected=$( echo $selected | sed "s= =\\\ =g" )
	#echo "$selected"
	pdfgrep -iA 50 "$query" "$selected" | less -Q
else
     echo "found nothing"
fi

