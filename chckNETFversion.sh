wget -O https://en.wikipedia.org/wiki/.NET_Framework#Release_history temp.html
grep -o '/wiki/.NET_Framework_version_history#.NET_Framework' temp.txt | wc -l > tempwc.txt;
export WORD=$(cat tempwc.txt)
sleep 1;
rm temp.txt;
rm tempwc.txt;
if ["12" < $WORD]
	