#!/bin/bash

# Author: Srikanth Kaza
# Use   : sh grub2-select.sh

# Grub2 config file
grub_cfg="/etc/grub2.cfg"

# Temparory file to grep for entries
tmp_grub_entries_file="/tmp/grub2-select.entries"

# Getting all the list of entries in config file
# to a temparory file
grep "^menuentry" $grub_cfg | cut -d "'" -f 2 > $tmp_grub_entries_file

entries=`cat $tmp_grub_entries_file`

# Counting entries
entries_count=`cat $tmp_grub_entries_file | wc -l`

echo -e "\nEntries in grub2 config file:"
echo -e "=============================="
j=0
while [ $j -lt $entries_count ]
do
	let "j=j+1"
	echo -n "$j): "
	echo "$entries" | head -n $j | tail -n 1
done
echo -e "==============================\n"

old_default=`grub2-editenv list`
echo "Old default:"
echo $old_default

echo -en "\nPlease select your option: "
read option

if [ $option -lt 1 ] || [ $option -ge $entries_count ]
then
	echo -e "Invalid option\n"
	exit
fi

echo -e "\nYour selection: $option"
selected=`echo "$entries" | head -n $option | tail -n 1`
echo "Entry: $selected"

# Make a backup of grub2 config
cp $grub_cfg $grub_cfg-grub2-select.back

# Set selected entry as default
grub2-set-default "$selected"

# Regenerate config file
grub2-mkconfig -o $grub_cfg

new_default=`grub2-editenv list`
echo "New default:"
echo $new_default
