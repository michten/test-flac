#!/bin/bash
# Make flac test report, show path of bad files only
#
#
### This is bad in for loop, don't work with whitespace:
#find ~/Music -type f -iname '*.flac' -print0 | xargs --null flac -wst

### This is OK:  Make sure globstar is enabled
#shopt -s globstar
#for i in **/*.txt; do # Whitespace-safe and recursive
#    process "$i"
#done
shopt -s globstar

music_dir_scan_path="$1"
music_dir_scan_path=$(echo "$music_dir_scan_path" | sed 's|/$||')
buffer_flac=$(mktemp /tmp/tempXXX)


echo "#########   Flac file test script started at $(date)   #########"
echo "### Scan:   $music_dir_scan_path"

count=0
for flac_file_path in "$music_dir_scan_path"/**/*.flac; do
	
	echo -n "$count  "
	((count+=1))
	
	flac -wst "$flac_file_path" &>> "$buffer_flac"

	if [ -s $buffer_flac ]; then
		echo
		echo
		echo '######### '"$flac_file_path"
		#cat "$buffer_flac"
		truncate -s 0 "$buffer_flac"
		# or > $buffer_flac
	fi
done

echo "#########   End of raport at $(date)   #########"
echo
echo


rm "$buffer_flac"
exit 0
