#!/bin/sh
#
# Needs "html-xml-utils" package to work
#

print_descriptions() {

	echo "<html><head><meta http-equiv=Content-Type content=\"text/html; charset=UTF-8\"></head><body>"
	echo "<!--toc-->"

	while read pkg url; do
		purl="https://play.google.com/store/apps/details?id=$pkg&hl=ru"
		tmpf=`mktemp`
		wget -q -O "$tmpf" "$purl"
		title="`hxextract div.document-title "$tmpf" | sed -n 's/.*<div>\([^<]*\)<\/div>.*/\1/p'`"
		if [ "$title" ]; then
            desc="`hxextract div.id-app-orig-desc \"$tmpf\" | perl -e 'undef $/; $_=<STDIN>; m!class="id-app-orig-desc"[^>]*>(.*?)</div>!ms and print $1'`"
			[ "$url" ] || url="$purl"
			echo "<h3>$title</h3><p>URL: <a href=\"$url\">$url</a><br>Play: <a href=\"market://detail?id=$pkg\">market://detail?id=$pkg</a></p><p>$desc</p>"
		else
			if [ "$url" ]; then
				echo "<h3>$pkg</h3><p>URL: <a href=\"$url\">$url</a></p>"
			else
				echo "<h3>$pkg</h3><p>URL: <a href=\"https://www.google.ru/search?q=%22$pkg%22\">$pkg</a></p>"
			fi
		fi
		rm -f "$tmpf"
	done

	echo "</body></html>"
}

print_descriptions | hxclean | hxtoc -l 3 | hxnormalize
