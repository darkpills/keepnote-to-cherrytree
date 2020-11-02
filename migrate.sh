#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Keepnote to Cherrytree migration script"
	echo ""
	echo "Usage: $0 sourcedir"
	exit 1
fi

sourcedir="$1"

if [ ! -d "$sourcedir" ]; then
	echo "Source dir does not exists!"
	exit 1
fi

sourcedir=`realpath $1`
destinationdir="${sourcedir}-migrated"

echo "[+] Cleaning destination directory $destinationdir"
rm -rf $destinationdir
if [ $? -ne 0 ]; then
	echo "Something went wrong with last operation, exit"
	exit 1
fi

echo "[+] Copying directories and files to destination $destinationdir"
cp -r "$sourcedir" "$destinationdir"
if [ $? -ne 0 ]; then
	echo "Something went wrong with last operation, exit"
	exit 1
fi

echo "[+] Entering into $destinationdir"
cd "$destinationdir"

echo "[+] Cleaning up node.xml files"
find . -depth -name node.xml -type f -delete

echo "[+] Cleaning up tmp files"
find . -depth -name "*.tmp" -type f -delete

echo "[+] Starting files migration"
find . -name "page.html" -type f | sort | while read file; do

	echo "[*] Migrating $file"
	sed -i -e s#" style=\"list-style-type: none\""##g "$file"
	sed -i /"^<li><\/li>$"/d "$file"
	sed -i -e s#"<ul>"#"<br/>"#g "$file" 
	sed -i -e s#"</ul>"#"<br/>"#g "$file"
	#sed -i ':a;N;$!ba;s/\n/ /g' "$file"
	sed -i -e s#"<li>"#"• "#g "$file"
	sed -i -e s#"</li>"#"<br/>"#g "$file"

	
	dirpath=`dirname "$file"`
	dirname=`basename "$dirpath"`


	find "$dirpath" -maxdepth 1 -type f | grep -v ".html$" | while read otherfile; do
		echo "[*] Migrating $otherfile also in the same directory"
		otherfilename=`basename "$otherfile"`
		newotherfilename=`md5sum "$otherfile" | cut -d" " -f1`
		otherfilenameext="${otherfilename##*.}" 
		sed -i -e s#"src=\"$otherfilename\""#"src=\"${newotherfilename}.${otherfilenameext}\""#g "$file"
		mv "$otherfile" "$dirpath/../${newotherfilename}.${otherfilenameext}"
		if [ $? -ne 0 ]; then
			echo "Something went wrong with last operation, exit"
			exit 1
		fi
	done

	mv "$file" "$dirpath/../$dirname.html"
	if [ $? -ne 0 ]; then
		echo "Something went wrong with last operation, exit"
		exit 1
	fi

done

echo "[*] Cleaning up empty directories"
find . -depth -type d -empty -delete
if [ $? -ne 0 ]; then
	echo "Something went wrong with last operation, exit"
	exit 1
fi

echo "[+] Job done!"
echo "Now, open CherryTree:"
echo "Import > From Directory of HTML files > Select $destinationdir"
exit 0