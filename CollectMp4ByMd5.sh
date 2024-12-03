#!/system/bin/sh
#
folder="$(dirname $(realpath $0))"
if [ ! -d "$folder/media/video" ]
then
mkdir -p $folder/media/video
fi
#
if [ -z "$(find $folder -name "*.mp4" -type f)" ]
then
busybox echo -e "Gak ada berkas mp4 di seluruh $folder\n"
kill -9 $$
fi
#
find $folder -name "*.mp4" -type f > $folder/mp4.log
echo "#!/system/bin/sh" > $folder/02-$(basename $0)
cat $folder/mp4.log|busybox awk -v fold=$folder/media/video '{print "md" NR+0 "=\"\$(busybox md5sum \"" $0 "\"|busybox awk \x27{print \$1\x27})\"\nif [ ! -f \"" fold "/\$md" NR+0 ".mp4\" ]\nthen\ncp \"" $0 "\" \"" fold "/\$md" NR+0 ".mp4\"\nfi\n\nif [ -f \"" fold "/\$md" NR+0 ".mp4\" ]\nthen\nrm \"" $0 "\"\nfi"}' >> $folder/02-$(basename $0)
echo "Membuat skrip baru selesai"
sleep 4
sh "$folder/02-$(basename $0)"
busybox echo -e "\nSelesai.\n"
