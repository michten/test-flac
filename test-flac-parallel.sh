#!/bin/bash
#
# Do flac file test, print full path of bad files and decoder errors/warnings to stdout.
# This script will run flac command in parallel acording to number of cpu threads in system.
# 
# Usage: bash test-flac-parallel.sh /music/path/you/want/to/scan/
#
#
shopt -s globstar

music_dir_scan_path="$1"
music_dir_scan_path=$(echo "$music_dir_scan_path" | sed 's|/$||')


#max_threads=8
max_threads=$(nproc)
for thr in $(seq "$max_threads"); do
	buffer_flac[thr]=$(mktemp /tmp/test-flac_output_tmp_XXXX)
done
bad_files_list=$(mktemp /tmp/test-flac_badfiles_tmp_XXX)

flac_file_path=("$music_dir_scan_path"/**/*.flac)
flac_test_log() {
	thr=$1
	for ((i="$thr"-1; i<${#flac_file_path[@]}; i+="$max_threads")); do
		#echo -n "$i  "

		flac -wst "${flac_file_path[i]}" &>> "${buffer_flac[thr]}"

		if [ -s "${buffer_flac[thr]}" ]; then
			#echo "---------------------------------- $bad_files_count"
			#echo
			#echo
			#echo '#########  '"${flac_file_path[i]}"
			#echo

			sed -i -e '1 i\ ' -e '1 i\ ' -e '1 i ######### '"${flac_file_path[i]}" -e '$ a #####' -e '$ a\ ' "${buffer_flac[thr]}"
			cat "${buffer_flac[thr]}"
			echo "${flac_file_path[i]}" >> "$bad_files_list"

			truncate -s 0 "${buffer_flac[thr]}"
			# or > ${buffer_flac[thr]}
		fi
	done
}



echo "#########   Flac file test script started at $(date)   #########"
echo "### Scan:   $music_dir_scan_path"
echo "Using $max_threads flac commands in parallel"

for thr in $(seq "$max_threads"); do
	flac_test_log "$thr" &
done
wait
echo
echo '#########   Summary   #########'
echo '### Bad files list:'
cat "$bad_files_list"
echo '###'
echo "#########   End of raport at $(date)   #########"
echo
echo


for thr in $(seq "$max_threads"); do
	rm "${buffer_flac[thr]}"
done
rm "$bad_files_list"
exit 0

