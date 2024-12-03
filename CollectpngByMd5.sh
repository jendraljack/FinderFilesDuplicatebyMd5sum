#!/system/bin/sh
#
folder="$(dirname $(realpath $0))"
if [ ! -d "$folder/media/image" ]
then
mkdir -p $folder/media/image
fi
#
if [ -z "$(find $folder -name "*.png" -type f)" ]
then
busybox echo -e "Gak ada berkas png di seluruh $folder\n\nSkrip Oleh KambingHitam\n"
kill -9 $$
fi
#
find $folder -name "*.png" -type f > $folder/png.log
echo "#!/system/bin/sh" > $folder/02-$(basename $0)
cat $folder/png.log|busybox awk -v fold=$folder/media/image '{print "md" NR+0 "=\"\$(busybox md5sum \"" $0 "\"|busybox awk \x27{print \$1\x27})\"\nif [ ! -f \"" fold "/\$md" NR+0 ".png\" ]\nthen\ncp \"" $0 "\" \"" fold "/\$md" NR+0 ".png\"\nfi\n\nif [ -f \"" fold "/\$md" NR+0 ".png\" ]\nthen\nrm \"" $0 "\"\nfi"}' >> $folder/02-$(basename $0)
echo "Membuat skrip baru selesai"
sleep 4
sh "$folder/02-$(basename $0)"
busybox echo -e "\nSelesai.\n\nSkrip oleh KambingHitam\n"
