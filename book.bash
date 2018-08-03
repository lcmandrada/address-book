#!/bin/bash
# Luke Clark M. Andrada
# address book
# enter A to add a contact
# enter E to edit an existing contact
# enter D to delete an existing contact
# enter V to view every contact
# enter S to sort and view every contact
# enter F to find an existing contact
# enter L to load contacts by batch
# enter Q to quit

# set user directory as working directory
cd ~

# init directory and files
BOOK=".book"
CONTACT="$BOOK/contact"
CONTACTZ="$BOOK/contactz"
LOG="$BOOK/log"
TEMP="$BOOK/wolfs"
mkdir "$BOOK" 2> /dev/null

# init light blue
C='\033[1;34m'
# init light cyan
NC='\033[1;36m'
# init light gray
NNC='\033[0;37m'

# initialize labels
LABEL[0]="${NC}First Name: ${C}"
LABEL[1]="${NC}Middle Name: ${C}"
LABEL[2]="${NC}Last Name: ${C}"
LABEL[3]="${NC}Title: ${C}"
LABEL[4]="${NC}Company: ${C}"
LABEL[5]="${NC}Birthday: ${C}"
LABEL[6]="${NC}Address: ${C}"
LABEL[7]="${NC}Telephone: ${C}"
LABEL[8]="${NC}Mobile: ${C}"
LABEL[9]="${NC}Email: ${C}"

LABELZ[0]="${C}First Name: "
LABELZ[1]="${C}Middle Name: "
LABELZ[2]="${C}Last Name: "
LABELZ[3]="${C}Title: "
LABELZ[4]="${C}Company: "
LABELZ[5]="${C}Birthday: "
LABELZ[6]="${C}Address: "
LABELZ[7]="${C}Telephone: "
LABELZ[8]="${C}Mobile: "
LABELZ[9]="${C}Email: "

MENU[0]="${NC}Address Book\n"
MENU[1]="\b${C}Hi! Select a function\nby entering its letter.\n\n"
MENU[2]="\b   ${C}A${NC}dd a contact\n"
MENU[3]="\b    ${C}E${NC}dit an existing contact\n"
MENU[4]="\b     ${C}D${NC}elete an existing contact\n"
MENU[5]="\b      ${C}V${NC}iew every contact\n"
MENU[6]="\b      ${C}S${NC}ort and view every contact\n"
MENU[7]="\b     ${C}F${NC}ind an existing contact\n"
MENU[8]="\b    ${C}L${NC}oad contacts by batch\n"
MENU[9]="\b   ${C}Q${NC}uit\n"

RULES[0]="${NC}Add contact"
RULES[1]="${NC}Edit contact"
RULES[2]="${NC}Delete contact"
RULES[3]="${NC}View contacts${C}"
RULES[4]="${NC}Sort contacts${C}"
RULES[5]="${NC}Find contact"
RULES[6]="${NC}Load contacts"
RULES[7]="${C}Enter appropriate info."
RULES[8]="Observe correct format."
RULES[9]="Start with letter or digit."
RULES[10]="Contact should not exist yet."
RULES[11]="Enter blank or ZERO for no info."
RULES[12]="Enter ESC to go back."
RULES[13]="Contact should exist."
RULES[14]="Enter ZERO for no info."
RULES[15]="Select view to reset contacts filter."
RULES[16]="Select find to filter contacts recursively."
RULES[17]="Select sort to organize filtered contacts increasingly."
RULES[18]="Select exit to go back."
RULES[19]=""
RULES[20]="Enter blank to keep an info."

FIND[0]="${NC}Find: ${C}"
FIND[1]="${NC}Field: ${C}"

VIEW[0]="   ${NC}1 ${C}View\n"
VIEW[1]="\b   ${NC}2 ${C}Find\n"
VIEW[2]="\b   ${NC}3 ${C}Sort\n"
VIEW[3]="\b   ${NC}4 ${C}Exit\n"



# display OPTION
# print contact and info
# handle spaces
# color for find and sort

display () {
	# print contact and info
	for COUNT in {0..9}
	do
		# print nothing if ZERO
		if [ "$(echo "$INFO" | cut -f"$(echo "$COUNT+1" | bc)" -d: | sed 's/SPACE/ /g')" = "ZERO" ]
		then
			case $1 in
				# do not color for default
				0) echo -e "${LABEL["$COUNT"]}" >> "$TEMP" ;;
				# color for find and sort
				1)
					if [ "$(echo "$COUNT+1" | bc)" = "$COUNTZ" ]
					then
						echo -e "${LABELZ["$COUNT"]}" >> "$TEMP"
					else
						echo -e "${LABEL["$COUNT"]}" >> "$TEMP"
					fi
					;;
			esac
		# print info if not ZERO
		else
			case $1 in
				# do not color for default
				0) echo -e "${LABEL["$COUNT"]}$(echo "$INFO" | cut -f"$(echo "$COUNT+1" | bc)" -d: | sed 's/SPACE/ /g')" >> "$TEMP" ;;
				# color for find and sort
				1)
					if [ "$(echo "$COUNT+1" | bc)" = "$COUNTZ" ]
					then
						echo -e "${LABELZ["$COUNT"]}$(echo "$INFO" | cut -f"$(echo "$COUNT+1" | bc)" -d: | sed 's/SPACE/ /g')" >> "$TEMP"
					else
						echo -e "${LABEL["$COUNT"]}$(echo "$INFO" | cut -f"$(echo "$COUNT+1" | bc)" -d: | sed 's/SPACE/ /g')" >> "$TEMP"
					fi
					;;
			esac
		fi
	done
	return 0
}



# accept LABEL FIELD OPTION
# only letters and periods for first, middle and last name, title and company
# only valid MM/DD/YYYY for birthday
# only letters, digits, periods and commas for address
# only valid ## ### #### for telephone
# only valid #### ### #### for mobile
# only letters, digits and punctuations for email
# only Y or N
# info should start with letter or digit

accept () {
	while true
	do
		# do not add if contact is existing
		if [ "$3" -eq 0 ]
		then
			if [ "$(grep -i "^$(echo "$CON" | cut -f2-4 -d:):" "$CONTACT" 2> /dev/null)" -a "$COUNT" -eq 3 ]
			then
				return 2
			fi
		elif [ "$3" -eq 2 ]
		# do not edit if contact is existing
		then
			if [ "$(grep -i "^$(echo "$CONZ" | cut -f2-4 -d:):" "$CONTACT" 2> /dev/null)" -a "$COUNT" -eq 3 -a ! "$(echo "$CONZ" | cut -f2-4 -d:)" = "$(echo "$CON" | cut -f1-3 -d:)" ]
			then
				return 2
			fi
		fi

		# load info if load
		if [ "$3" -eq 4 ]
		then
			VAR="$(echo "$INFO" | cut -f"$(echo "$COUNT+1" | bc)" -d:)"

			# skip if zero
			if [ "$VAR" = "ZERO" ]
			then
				break
			fi
		# read info if others
		else
			echo -ne "$1"
			read VAR
		fi

		# skip if ESC
		if [ "$VAR" = "ESC" ]
		then
			case "$2" in
				# do not skip for Y or N
				10) ;;
				*) break ;;
			esac
		# skip if ZERO
		elif [ -z "$VAR" ]
		then
			case "$3" in
				# for default
				[01])
					case "$2" in
						# skip for company, telephone, mobile and email
						[4789])
							VAR="ZERO"
							break
							;;
						*) ;;
					esac
					;;
				# for edit
				2) break ;;
				# for find
				3)
					case "$2" in
						# find ZERO
						[0])
							VAR="ZERO"
							break
							;;
						*) ;;
					esac
					;;
				*) ;;
				esac
		fi

		# save info
		echo "$VAR" > "$TEMP"

		# check for find
		if [ "$3" -eq 3 ]
		then
			case "$2" in
				# only letters, digits and punctuations for find and load
				0)
					if [ "$(grep "^[[:alnum:][:space:][:punct:]]*$" "$TEMP")" ]
					then
						break
					else
						echo -e "Only letters, digits and punctuations.\n"
					fi
					;;
				# only digits for field
				1)
					if [ "$(grep "^[[:digit:]]*$" "$TEMP")" ]
					then
						# only 0 to 9
						if [ "$(cat "$TEMP")" -gt 0 -a "$(cat "$TEMP")" -lt 11 ]
						then
							break
						else
							echo -e "Only 1 to 10.\n"
						fi
					else
						echo -e "Only digits.\n"
					fi
					;;
				*) ;;
			esac
		# check for default
		else
			case "$2" in
			# only letters and periods for first, middle and last name, title and company
			[0-4])
				# info 0 to 3 are not optional
				if [ "$VAR" = "ZERO" -a "$2" -ne 4 ]
				then
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}No blank info.${C}"
						return 2
					# for default
					else
						echo -e "No blank info.\n"
					fi
				# info 4 is optional
				elif [ "$VAR" = "ZERO" -a "$2" -eq 4 ]
				then
					break
				# break if format is correct
				elif [ "$(grep "^[[:alpha:]][[:alpha:][:space:].]*$" "$TEMP")" ]
				then
					break
				# loop if format is correct
				else
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}Only letters and periods.${C}"
						return 2
					# for default
					else
						echo -e "Only letters and periods.\n"
					fi
				fi
				;;
			# only valid MM/DD/YYYY for birthday
			5)
				# info 5 is not optional
				if [ "$VAR" = "ZERO" ]
				then
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}No blank info.${C}"
						return 2
					# for default
					else
						echo -e "No blank info.\n"
					fi
				# check if format is correct
				elif [ "$(grep "^[0-1][0-9]/[0-3][0-9]/[12][0-9][0-9][0-9]$" "$TEMP")" ]
				then
					# save info
					VARZ[0]="$(echo "$VAR" | cut -f1 -d/)"
					VARZ[1]="$(echo "$VAR" | cut -f2 -d/)"
					VARZ[2]="$(echo "$VAR" | cut -f3 -d/)"

					# only valid month, day and year
					if [ "${VARZ[0]}" -gt 0 -a "${VARZ[1]}" -gt 0 -a "${VARZ[2]}" -ge 1900 -a "${VARZ[2]}" -le "$(date +'%Y')" ]
					then
						case "${VARZ[0]}" in
							# for 31 days
							01|03|05|07|08|10|12)
								if [ "${VARZ[1]}" -lt 32 ]
								then
									break
								fi
								;;
							# for 30 days
							04|06|09|11)
								if [ "${VARZ[1]}" -lt 31 ]
								then
									break
								fi
								;;
							# for february
							02)
								# for leap year
								if [ "$(echo "${VARZ[2]}%4" | bc)" -eq 0 -a "${VARZ[1]}" -lt 30 ]
								then
									break
								# for not leap year
								elif [ "${VARZ[1]}" -lt 29 ]
								then
									break
								fi
								;;
							*) ;;
						esac
						# loop if birthday is not valid
						# for load
						if [ "$3" -eq 4 ]
						then
							echo -e "     ${NC}Invalid birthday.${C}"
							return 2
						# for default
						else
							echo -e "Invalid birthday.\n"
						fi
					# loop if birthday is not valid
					else
						# for load
						if [ "$3" -eq 4 ]
						then
							echo -e "     ${NC}Invalid birthday.${C}"
							return 2
						# for default
						else
							echo -e "Invalid birthday.\n"
						fi
					fi
				# loop if format is not correct
				else
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}Only digits in MM/DD/YYYY.${C}"
						return 2
					# for default
					else
						echo -e "Only digits in MM/DD/YYYY.\n"
					fi
				fi
				;;
			# only letters, digits, periods and commas for address
			6)
				# info 6 is not optional
				if [ "$VAR" = "ZERO" ]
				then
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}No blank info.${C}"
						return 2
					# for default
					else
						echo -e "No blank info.\n"
					fi
				# break if format is correct
				elif [ "$(grep "^[[:alnum:]][[:alnum:][:space:].,]*$" "$TEMP")" ]
				then
					break
				# loop if format is not correct
				else
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}Only letters, digits, periods and commas.${C}"
						return 2
					# for default
					else
						echo -e "Only letters, digits, periods and commas.\n"
					fi
				fi
				;;
			# only valid ## ### #### for telephone
			7)
				# info 7 is optional
				if [ "$VAR" = "ZERO" ]
				then
					break
				# break if format is correct
				elif [ "$(grep "^[0-8][2-9] [0-9]\{3\} [0-9]\{4\}$" "$TEMP")" ]
				then
					break
				# loop if format is not correct
				else
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}Only digits in ## ### ####.${C}"
						return 2
					# for default
					else
						echo -e "Only digits in ## ### ####.\n"
					fi
				fi
				;;
			# only valid #### ### #### for mobile
			8)
				# info 8 is optional
				if [ "$VAR" = "ZERO" ]
				then
					break
				# break if format is correct
				elif [ "$(grep "^[0-9]\{4\} [0-9]\{3\} [0-9]\{4\}$" "$TEMP")" ]
				then
					break
				# loop if format is correct
				else
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}Only digits in #### ### ####.${C}"
						return 2
					# for default
					else
						echo -e "Only digits in #### ### ####.\n"
					fi
				fi
				;;
			# only letters, digits and punctuations for email
			9)
				# info 9 is optional
				if [ "$VAR" = "ZERO" ]
				then
					break
				# break if format is correct
				elif [ "$(grep "^[[:alpha:]][[:alnum:][:punct:]]*@[[:alnum:]][[:alnum:]]*\.[[:alnum:]][[:alnum:].]*$" "$TEMP")" ]
				then
					break
				# loop if format is correct
				else
					# for load
					if [ "$3" -eq 4 ]
					then
						echo -e "     ${NC}Only letters, digits and punctuations in user@domain.${C}"
						return 2
					# for default
					else
						echo -e "Only letters, digits and punctuations in user@domain.\n"
					fi
				fi
				;;
			# only Y or N
			10)
				case "$VAR" in
					# good return if Y
					[Yy]) break ;;
					# bad return if N
					[Nn]) return 1 ;;
					*) echo -e "Only Y or N.\n" ;;
				esac
				;;
			*) ;;
			esac
		fi
		continue
	done
	return 0
}



# get LIMIT OPTION
# get info
# go back if ESC
# build contact

get () {
	# skip init for edit
	if [ "$2" -ne 2 ]
	then
		CON=""
	fi
	# init for default
	CONZ=""
	FLAG="0"
	FLAGZ="0"

	# get info for different options
	for COUNT in $(seq 0 "$1")
	do
		case "$2" in
			# for add
			0) accept "${LABEL["$COUNT"]}" "$COUNT" 0 ;;
			# for delete
			1) accept "${LABEL["$COUNT"]}" "$COUNT" 1 ;;
			# for edit
			2) accept "${LABEL["$COUNT"]%:*} [${C}$(echo "$CON" | cut -f"$(echo "$COUNT+1" | bc)" -d: | sed 's/ZERO//g')${NC}]: ${C}" "$COUNT" 2 ;;
			# for find
			3) accept "${FIND["$COUNT"]}" "$COUNT" 3 ;;
			# for load
			4) accept "${LABEL["$COUNT"]}" "$COUNT" 4 ;;
			*) ;;
		esac

		# skip if format is not correct for load
		# stop if contact is existing for add and edit
		if [ "$?" -eq 2 ]
		then
			return 2
		fi

		# go back if ESC
		if [ "$VAR" = "ESC" ]
		then
			echo -e "\nEscaping."
			sleep 1
			return 1
		fi

		case "$2" in
			# build contact for add, delete and load
			[014]) CON="$CON:$VAR" ;;
			# build contact for edit
			2)
				# edit if info is nonzero
				if [ -n "$VAR" ]
				then
					CONZ="$CONZ:$VAR"
					# do not edit if info is kept
					if [ ! "$(echo "$CON" | cut -f"$(echo "$COUNT+1" | bc)" -d:)" = "$VAR" ]
					then
					FLAG="1"
					fi
				# do not edit if info is zero
				else
					CONZ="$CONZ:$(echo "$CON" | cut -f"$(echo "$COUNT+1" | bc)" -d:)"
				fi
				;;
			# build contact for find
			3) CONZ="$CONZ:$VAR" ;;
			*) ;;
			esac
	done

	# delete first colon
	CON="${CON#:}"
	CONZ="${CONZ#:}"

	# for easy output
	CONY="$(echo "$CON" | cut -f1-3 -d: | sed 's/:/ /g')"
	return 0
}



# del
# delete contact

del () {
	# find invert contact
	grep -vi "^$1" "$CONTACT" > "$TEMP"
	# overwrite contacts
	cat "$TEMP" > "$CONTACT"
	return 0
}



# insert

insert () {
	# sort if size is not 0 or 1
	if [ "${#SORT[*]}" -ne 0 -o "${#SORT[*]}" -ne 1 ]
	then
		# iterate contacts
		for IND in $(seq 1 "$(echo "${#SORT[*]}-1" | bc)")
		do
			# sort contacts
			for (( INDZ="$IND"; INDZ>0; INDZ-- ))
			do
				# get info
				HIGH="$(echo "${SORT["$INDZ"]}" | cut -f"$VAR" -d: | sed 's/SPACE/ /g')"
				LOW="$(echo "${SORT["$(echo "$INDZ-1" | bc)"]}" | cut -f"$VAR" -d: | sed 's/SPACE/ /g')"

				# set character check limit to shorter string
				if [ "${#HIGH}" -lt "${#LOW}" ]
				then
					LIMIT="${#HIGH}"
					FLAG="2"
				elif [ "${#HIGH}" -eq "${#LOW}" ]
				then
					LIMIT="${#HIGH}"
					FLAG="1"
				else
					LIMIT="${#LOW}"
					FLAG="0"
				fi

				# fix limit for array
				(( LIMIT-- ))

				# iterate every character
				for CHAR in $(seq 0 "$LIMIT")
				do
					# translate upper to lower for case-insensitivity
					HIGHZ="$(echo "${HIGH:$CHAR:1}" | tr "[:upper:]" "[:lower:]")"
					LOWZ="$(echo "${LOW:$CHAR:1}" | tr "[:upper:]" "[:lower:]")"

					# do not swap if high = low
					if [ "$(expr "$HIGHZ" \= "$LOWZ")" -eq 1 ]
					then
						FLAGZ="0"
					# do not swap but break if high > low
					elif [ "$(expr "$HIGHZ" \> "$LOWZ")" -eq 1 ]
					then
						FLAGZ="2"
						break
					# swap and break if high < low
					elif [ "$(expr "${HIGH:$CHAR:1}" \< "${LOW:$CHAR:1}")" -eq 1 ]
					then
						swap
						FLAGZ="1"
						break
					fi
				done

				# check if no swap and high = low
				if [ "$FLAGZ" -eq 0 ]
				then
					# swap if high length < low length
					if [ "$FLAG" -eq 2 ]
					then
						swap
					# do not swap if high length > low length
					else
						break
					fi
				fi
			done
		done

		# save selected field
		COUNTZ="${VAR}"
		# print sorted contacts
		for INFO in ${SORT[*]}
		do
			display 1
			echo "" >> "$TEMP"
		done
	fi
	return 0
}



# swap
# swap contacts

swap () {
	# save high contact
	VARZ="${SORT["$INDZ"]}"
	# save low to high contact
	SORT["$INDZ"]="${SORT["$(echo "$INDZ-1" | bc)"]}"
	# save high to low contact
	SORT["$(echo "$INDZ-1" | bc)"]="$VARZ"
	return 0
}



# log OPTION
# log functions

log () {
	# log function
	echo "$CONY was "$1" at $(date) by $USER." >> "$LOG"
	# print function
	echo -e "\n$CONY was "$1" at $(date) by $USER.\n"
	return 0
}



# field
# print fields

field () {
	# iterate every field
	for COUNT in {1..10}
	do
		# print for 10
		if [ "$COUNT" -eq 10 ]
		then
			echo -e "  $(echo "${NC}$COUNT ${LABELZ["$(echo "$COUNT-1" | bc)"]}" | sed 's/://g')"
		# print for less than 10
		else
			echo -e "   $(echo "${NC}$COUNT ${LABELZ["$(echo "$COUNT-1" | bc)"]}" | sed 's/://g')"
		fi
	done
	echo ""
	return 0
}



# viewz
# view every contact

viewz () {
	# reset contact filters
	cat "$CONTACT" > "$CONTACTZ"

	# print rules
	for RULE in 3 7 15 16 17 18 19
	do
		echo -e "${RULES["$RULE"]}" >> "$TEMP"
	done

	# iterate every contact
	for INFO in $(cat "$CONTACT" 2> /dev/null | sed 's/ /SPACE/g')
	do
		# print contact and info
		display 0
		echo "" >> "$TEMP"
	done

	echo -e "${NC}Enter ${C}q${NC} to continue.${C}" >> "$TEMP"
	clear
	# for better output
	cat "$TEMP" | less -r
	return 0
}



# add
# enter appropriate info
# observe correct format
# start with letter or digit
# contact should not exist yet
# enter blank or ZERO for no info
# enter ESC to go back

add () {
	while true
	do
		# print rules
		clear
		for RULE in 0 7 8 9 10 11 12 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# get info
		get 9 0

		# get status
		STATUS="$?"

		# go back if ESC
		if [ "$STATUS" -eq 1 ]
		then
			return 1
		# do not add if contact is existing
		elif [ "$STATUS" -eq 2 ]
		then
			echo -e "\n$(echo "$CON" | cut -f2-4 -d: | sed 's/:/ /g') already exists and therefore was not added.\n"
		# add and log if contact is not existing
		else
			echo "$CON" >> "$CONTACT"
			log "added"
		fi

		# loop
		accept "${NC}Do you want to try again? ${C}" 10 1
		if [ "$?" -eq 1 ]
		then
			return 0
		fi
	done
}



# edit
# enter appropriate info
# observe correct format
# enter blank to keep an info
# start with letter or digit
# contact should exist
# enter ZERO for no info
# enter ESC to go back

edit () {
	while true
	do
		# print rules
		clear
		for RULE in 1 7 8 20 9 13 14 12 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# get info
		get 2 1

		# go back if ESC
		if [ "$?" -eq 1 ]
		then
			return 1
		fi

		# get entire info
		CON="$(grep -i "^$CON:" "$CONTACT" 2> /dev/null)"

		# edit if contact is existing
		if [ "$(grep -i "^$(echo "$CON" | cut -f1-3 -d:):" "$CONTACT" 2> /dev/null)" ]
		then
			echo ""
			# get edit info
			get 9 2

			# get status
			STATUS="$?"

			# go back if ESC
			if [ "$STATUS" -eq 1 ]
			then
				return 1
			# stop if contact is existing
			elif [ "$STATUS" -eq 2 ]
			then
				echo -e "\n$(echo "$CONZ" | cut -f2-4 -d: | sed 's/:/ /g') already exists and therefore $CONY was not edited.\n"
			# save and log if info was edited
			elif [ "$FLAG" -eq 1 ]
			then
				del "$(echo "$CON" | cut -f1-3 -d:):"
				echo "$CONZ" >> "$CONTACT"
				log "edited"
			# do not save if info was not edited
			else
				echo -e "\n$CONY was not edited.\n"
			fi
		# do not edit if contact is not existing
		else
			echo -e "\nNo $CONY found.\n"
		fi

		# loop
		accept "${NC}Do you want to try again? ${C}" 10 1
		if [ "$?" -eq 1 ]
		then
			return 0
		fi
	done
}



# delete
# enter appropriate info
# observe correct format
# start with letter or digit
# contact should exist
# enter ESC to go back

delete () {
	while true
	do
		# print rules
		clear
		for RULE in 2 7 8 9 13 12 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# get info
		get 2 1

		# go back if ESC
		if [ "$?" -eq 1 ]
		then
			return 1
		fi

		# get entire info
		CON="$(grep -i "^$CON:" "$CONTACT" 2> /dev/null)"

		# delete if contact is existing
		if [ "$(grep -i "^$(echo "$CON" | cut -f1-3 -d:):" "$CONTACT" 2> /dev/null)" ]
		then
			# print contact
			INFO="$CON"
			echo "" > "$TEMP"
			display 0
			cat "$TEMP"
			echo ""

			# ask delete
			accept "${NC}Do you want to delete ${C}$CONY${NC}? ${C}" 10 1
			# do not delete if N
			if [ "$?" -eq 1 ]
			then
				echo -e "\n$CONY was not deleted.\n"
			# delete and log if y
			else
					del "$(echo "$CON" | cut -f1-3 -d:):"
					log "deleted"
			fi
		# do not delete if contact is not existing
		else
			echo -e "\nNo $CONY found.\n"
		fi

		# loop
		accept "${NC}Do you want to try again? ${C}" 10 1
		if [ "$?" -eq 1 ]
		then
			return 0
		fi
	done
}



# view
# select view to reset contacts filter
# select find to filter contacts recursively
# select sort to organize filtered contacts increasingly
# select exit to go back

view () {
	# reset contact filters
	cat "$CONTACT" > "$CONTACTZ"

	while true
	do
		# print rules
		clear
		for RULE in 3 7 15 16 17 18 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# print options
		echo -e "${VIEW[*]}"

		while true
		do
			# get option
			echo -ne "${NC}Option: ${C}"
			read OPT

			case $OPT in
				1)
					echo -n "" > "$TEMP"
					viewz
					break
					;;
				2)
					find 1
					break
					;;
				3)
					sort 1
					break
					;;
				4) return 0 ;;
				*) echo -e "Only 1 to 4.\n" ;;
			esac
		done
	done
}



# find
# enter appropriate info
# observe correct format
# start with letter or digit
# contact should exist
# enter ESC to go back

find () {
	while true
	do
		# print rules
		clear
		for RULE in 5 7 8 9 13 12 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# print fields
		field

		# get info
		get 1 3

		# go back if ESC
		if [ "$?" -eq 1 ]
		then
			return 1
		fi

		# save info
		VARZ[0]="$(echo "$CONZ" | cut -f1 -d:)"
		VARZ[1]="$(echo "$CONZ" | cut -f2 -d:)"

		# reference original file for default find
		if [ "$1" -eq 0 ]
		then
			SOURCE="$CONTACT"
		# reference filtered file for recursive find
		else
			SOURCE="$CONTACTZ"
		fi

		# get entire info
		CON="$(grep -i "${VARZ[0]}" "$SOURCE" 2> /dev/null)"

		# recheck if info is existing
		if [ "$(grep -i "${VARZ[0]}" "$SOURCE" 2> /dev/null)" ]
		then
			# handle spaces
			CON="$(echo "$CON" | sed 's/ /SPACE/g')"
			echo ""

			# clear files
			echo -n "" > "$TEMP"
			echo -n "" > "$CONTACTZ"

			# print rules
			for RULE in 5 7 8 9 13 12 19
			do
				echo -e "${RULES["$RULE"]}" >> "$TEMP"
			done

			# iterate every contact
			for INFO in ${CON[*]}
			do
				# print contact if info and field checks
				if [ "$(echo "$INFO" | cut -f"${VARZ[1]}" -d: | sed 's/SPACE/ /g' | grep -i "${VARZ[0]}")" ]
				then
					# filter find
					echo "${INFO//SPACE/ }" >> "$CONTACTZ"

					# print contact
					COUNTZ="${VARZ[1]}"
					display 1
					FLAG="1"
					echo "" >> "$TEMP"
				fi
			done

			# do not print contact if info and field do not check
			if [ "$FLAG" -eq 0 ]
			then
				echo -e "No ${VARZ[0]/ZERO/blank} found.\n"
			# print contact if info and field checks
			else
				clear
				echo -e "${NC}Enter ${C}q${NC} to continue.${C}" >> "$TEMP"
				# for better output
				cat "$TEMP" | less -r

				# print rules
				for RULE in 5 7 8 9 13 12 19
				do
					echo -e "${RULES["$RULE"]}"
				done
			fi
		# do not recheck if info is existing
		else
			echo -e "\nNo ${VARZ[0]/ZERO/blank} found.\n"
			echo -n "" > "$CONTACTZ"
		fi

		# loop
		accept "${NC}Do you want to try again? ${C}" 10 1
		if [ "$?" -eq 1 ]
		then
			return 0
		fi
	done
}



# load
# enter appropriate info
# contact should not exist yet
# enter ESC to go back

load () {
	while true
	do
		# print rules
		clear
		for RULE in 6 7 10 12 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# init
		GOOD=0
		LINE=1

		# get info
		accept "${NC}File: ${C}" 0 3

		# go back if ESC
		if [ "$VAR" = "ESC" ]
		then
			echo -e "\nEscaping."
			sleep 1
			return 1
		fi

		echo ""
		# check if file is existing
		if [ -e "$VAR" ]
		then
			# iterate every contact
			for INFO in $(cat "$VAR" | sed 's/ /SPACE/g')
			do
				# rebuild spaces
				INFO="${INFO//SPACE/ }"

				# check if format is correct
				if [ "$(echo "$INFO" | grep -o ":" | wc -l)" -eq 9 ]
				then
					# skip if contact is existing
					if [ "$(grep "^$(echo "$INFO" | cut -f1-3 -d:):" "$CONTACT" 2> /dev/null)" ]
					then
						# for less than 10
						if [ "$LINE" -lt 10 ]
						then
							echo -ne "   ${NC}$LINE ${C}$(echo "$INFO" | cut -f1-3 -d: | sed 's/:/ /g') already exists."
						# for greater than 9
						else
							echo -ne "  ${NC}$LINE ${C}$(echo "$INFO" | cut -f1-3 -d: | sed 's/:/ /g') already exists."
						fi
						(( LINE++ ))
					# check if info is correct
					else
						# load info
						get 9 4

						# save status
						STATUS="$?"

						# go back if ESC
						if [ "$STATUS" -eq 1 ]
						then
							return 1
						# skip if info is not correct
						elif [ "$STATUS" -eq 2 ]
						then
							# for less than 10
							if [ "$LINE" -lt 10 ]
							then
								echo -ne "   ${NC}$LINE ${C}Invalid info in field $(echo "$COUNT+1" | bc)."
							# for greater than 9
							else
								echo -ne "  ${NC}$LINE ${C}Invalid info in field $(echo "$COUNT+1" | bc)."
							fi
							(( LINE++ ))
						# add and log if info is correct
						else
							echo "$INFO" >> "$CONTACT"
							echo "$CONY was added at $(date) by $USER." >> "$LOG"
							# for less than 10
							if [ "$LINE" -lt 10 ]
							then
								echo -ne "   ${NC}$LINE ${C}$CONY was added at $(date) by $USER."
							# for greater than 9
							else
								echo -ne "  ${NC}$LINE ${C}$CONY was added at $(date) by $USER."
							fi
							(( GOOD++ ))
							(( LINE++ ))
						fi
					fi
				# skip if format is correct
				else
					# for less than 10
					if [ "$LINE" -lt 10 ]
					then
						echo -e "   ${NC}$LINE ${C}Invalid contact."
					# for greater than 9
					else
						echo -e "  ${NC}$LINE ${C}Invalid contact."
					fi
					(( LINE++ ))
				fi
				echo ""
			done

			# print contact counter
			# for less than 10
			if [ "$GOOD" -lt 10 ]
			then
				echo -e "\n   ${NC}$GOOD ${C}contact/s added.\n"
			# for greater than 9
			else
				echo -e "\n  ${NC}$GOOD ${C}contact/s added.\n"
			fi
		# skip if file is not existing
		else
			echo -e "No ${VAR//ZERO/blank} found.\n"
		fi

		# loop
		accept "${NC}Do you want to try again? ${C}" 10 1
		if [ "$?" -eq 1 ]
		then
			return 0
		fi
	done
}



# sort
# enter appropriate info

sort () {
	while true
	do
		# print rules
		clear
		for RULE in 4 7 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# print field
		field

		# init
		ZERO=( )
		ZEROC="0"
		DIGIT=( )
		DIGITC="0"
		AM=( )
		AMC="0"
		NZ=( )
		NZC="0"

		# get info
		accept "${NC}Field: ${C}" 1 3

		# go back if ESC
		if [ "$VAR" = "ESC" ]
		then
			echo -e "\nEscaping."
			sleep 1
			return 1
		fi

		# reference original file for default sort
		if [ "$1" -eq 0 ]
		then
			SOURCE="$CONTACT"
		# reference filtered file for recursive sort
		else
			SOURCE="$CONTACTZ"
		fi

		# partition list
		for INFO in $(cat "$SOURCE" 2> /dev/null | sed 's/ /SPACE/g')
		do
			# save info
			INFOZ="$(echo "$INFO" | cut -f"$VAR" -d:)"

			# build zero
			if [ "$INFOZ" = "ZERO" ]
			then
				ZERO["$ZEROC"]="$INFO"
				(( ZEROC++ ))
			else
				# partition case-insensitive info
				case "$(echo "${INFOZ:0:1}" | tr "[:upper:]" "[:lower:]")" in
					# build digit
					[0-9])
						DIGIT["$DIGITC"]="$INFO"
						(( DIGITC++ ))
						;;
					# build A to M
					[a-m])
						AM["$AMC"]="$INFO"
						(( AMC++ ))
						;;
					# build N to Z
					[n-z])
						NZ["$NZC"]="$INFO"
						(( NZC++ ))
						;;
					# build zero
					*)
						ZERO["$ZEROC"]="$INFO"
						(( ZEROC++ ))
						;;
				esac
			fi
		done

		# clear file
		echo -n "" > "$TEMP"
		# print rules
		for RULE in 4 7 19
		do
			echo -e "${RULES["$RULE"]}" >> "$TEMP"
		done

		# insertion sort
		# clear and sort and print
		SORT=( )
		SORT=( ${ZERO[*]} )
		insert
		SORT=( )
		SORT=( ${DIGIT[*]} )
		insert
		SORT=( )
		SORT=( ${AM[*]} )
		insert
		SORT=( )
		SORT=( ${NZ[*]} )
		insert

		clear
		echo -e "${NC}Enter ${C}q${NC} to continue.${C}" >> "$TEMP"
		# for better output
		cat "$TEMP" | less -r

		# print rules
		for RULE in 4 7 19
		do
			echo -e "${RULES["$RULE"]}"
		done

		# loop
		accept "${NC}Do you want to try again? ${C}" 10 1
		if [ "$?" -eq 1 ]
		then
			return 0
		fi
	done
}



# quit
# restore and clean

quit () {
	# set old directory as working directory
	cd "$OLDPWD"

	# clean up
	rm -f "$TEMP" 2> /dev/null
	rm -f "$CONTACTZ" 2> /dev/null

	# exit
	echo -e "\nQuitting.${NNC}"
	sleep 1
	clear
	exit 0
}



# menu

while true
do
	# print menu
	clear
	echo -e "${MENU[*]}"

	# get option
	echo -ne "Option: ${C}"
	read OPT

	# select option
	case $OPT in
		[Aa]) add ;;
		[Ee]) edit ;;
		[Dd]) delete ;;
		[Vv]) view ;;
		[Ss]) sort 0 ;;
		[Ff]) find 0 ;;
		[Ll]) load ;;
		[Qq]) quit ;;
		*)
			echo -e "\nInvalid option."
			sleep 1
			;;
	esac
done
