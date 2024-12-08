#!/system/bin/sh
parent="$(realpath /sdcard)"
curpath="$(dirname $(realpath $0))"
if [ -z "$1" ]
then
echo "Usage: bash $0 filesFormat/mp4/mp3"
kill -9 $$
fi

find $parent -name "*.$@" -type f > $curpath/files.log
if [ -z "$(cat $curpath/files.log)" ]
then
echo "No files *.$@ in $parent"
kill -9 $$
fi
#
if [ ! -d "$parent/media/$@" ]
then
mkdir -p $parent/media/$@
fi
#
echo "#!/system/bin/sh" > $curpath/02-$(basename $0)
cat $curpath/files.log|busybox awk -v format=$@ '{print "if [ \"" $0 "\" != \"\$(realpath /sdcard)/media/" format "/\$(busybox md5sum \"" $0 "\"|busybox awk \x27{print \$1}\x27)." format "\" ]\nthen\nmv -f \"" $0 "\" \"\$(realpath /sdcard)/media/" format "/\$(busybox md5sum \"" $0 "\"|busybox awk \x27{print \$1}\x27)." format"\"\nfi"}' >> $curpath/02-$(basename $0)
$(readlink /proc/$$/exe) $curpath/02-$(basename $0)
