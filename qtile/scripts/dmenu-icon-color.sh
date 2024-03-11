#!/bin/bash

checksetcolor()
{
	for i in $(seq 1 $(echo $colors | wc -w))
	do
		colorsel=$(echo $colors | awk -F " " '{print $(shell_var='"$i"') }')
			
		if [[ $1 = $colorsel ]]
		then
			colortest=1
			break
		else
			colortest=0
		fi
	done

	if [[ $colortest = 1 ]]
	then
		setcolor $color
	else
		echo This color is not available. Check colors with list option.
		exit 1
	fi
}

setcolor()
{
	files=$(ls | grep $1)

	for i in $(seq 1 $(echo $files | wc -w))
	do
		file=$(echo $files | awk -F " " '{print $(shell_var='"$i"') }')
		link=$(echo $file | awk -F "-$1" '{print $2}')
		prefix=$(echo $file | awk -F "-$1" '{print $1}')

		ln -sfn $file $prefix$link
	done
}

main()
{
	cd ~/.icons/Gruvbox-Plus-Dark/places/scalable/

	colors=$(ls | grep linux.svg  | awk -F "-" '{print $2}' | grep -v .svg)

	if [[ $1 = "list" ]]
	then

	echo "${colors/"\ "}"

	elif [[ $1 = "dmenu" ]]
	then

		selected=$(echo "${colors/"\ "}" | $DMENU$DMENU_POS "Icon Colors:")

		if [[ -n $selected ]]
		then
			answer=$(echo -e "No\nYes" | $DMENU$DMENU_POS "Choose $selected?")

			if [[ $answer == "Yes" ]]
			then
				setcolor $selected
				notify-send "Your folder icons are now $selected"
				exit 0
			else
				exit 1
			fi
		else
			exit 0
		fi
	
	elif [[ -n $1 ]]
	then

		color=$(echo $1)
		checksetcolor $color
		echo "Your folder icons are now $color"

	else
		echo You need to specify a color. Check available colors with list option.
		exit 1
	fi
}

main $1