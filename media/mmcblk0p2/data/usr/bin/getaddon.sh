#!/usr/bin/env bash

ifError()
{
    errMsg=$1
    retVal=$?
    if [ ! $retVal -eq 0 ]; then
        echo $errMsg
    fi
    exit $retVal
}

finish()
{
    if [ -f "$tmpArchive" ]; then
        rm "$tmpArchive"
        echo "Temprary archive $tmpArchive was successfully removed."
    fi
}
trap finish EXIT

tmpArchive="/tmp/xiaofang-addons.tar.gz"
addonArchive="http://shop.staging.sitnikov.kiev.ua/downloader.php?url=https://api.github.com/repos/isitnikov/xiaofang-addons/tarball/master"
echo "Getting an archive from github..."
wget -O "$tmpArchive" "$addonArchive"
wait
#ifError "An error occured. Exit."
cd /
 tar --strip-components=1 --exclude=LICENSE --exclude=README.md -xf "$tmpArchive" --directory /media
ifError "An error occured. Exit."
echo "Done!"
exit 0