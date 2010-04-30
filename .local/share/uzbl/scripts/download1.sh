#!/bin/sh
# Download Redirector using the Content Header

#| Locations
dest="$HOME"
desttorrent="$HOME/Downloads/tor"
url="$8"
ampacheIDLoc="/tmp/ampacheID"

#| Commands
COOKIES="$XDG_DATA_HOME/uzbl/cookies.txt"

# Some sites block the default wget --user-agent..
GET="wget --user-agent=Firefox --content-disposition --load-cookies=$COOKIES"
GETCURL="curl -b $COOKIES"

#| Fix wget retardedness with cookies for ampache, curl too...
if echo $url | grep -E "ampache"; then
	sed -n "s/^.*FALSE.*FALSE.*ampache\t\(.*\)$/\1/g w $ampacheIDLoc" $COOKIES
	ampacheID="`cat $ampacheIDLoc`"
	GET="$GET --header=Cookie:ampache=$ampacheID"
	GETCURL="curl -b ampache_remember=Rappelez-vous%2C+rappelez-vous+le+27+mars;ampache=$ampacheID"
fi

#| Content Header
ct=`$GETCURL -I "$url" 2>/dev/null | sed -n 's/.*Content-Type: \([-a-z\/]*\).*/\1/p'`

#| Proxy Handling
http_proxy="$9"
export http_proxy

#| Make sure there is actually a URL
test "x$url" = "x" && { echo "you must supply a url! ($url)"; exit 1; }

#| Determine File Type
case "$ct" in
application/x-bittorrent) #| Bittorrent
	echo "---------- Bittorrent ----------"
	#( cd "$desttorrent"; $GET "$url" -O `date +%s`.torrent ) # Doesn't seem to be needed so far
	( cd "$desttorrent"; $GET "$url" )
	;;
audio/x-mpegurl|audio/mpegurl) #| m3u playlist
	echo "------------- m3u --------------"
	#| Redirect wget to stdout, then send it to my mpd m3u script to start playing the playlist
	$GET "$url" -qO- | m3u-handler
	;;
*) #| General Downloads
	echo "----------- General ------------"
	( cd "$dest"; $GET "$url" )
	;;
esac

echo "------------- End --------------"

exit 0

