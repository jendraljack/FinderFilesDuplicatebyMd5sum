#!/system/bin/sh
#
folder="$(realpath /sdcard)"
if [ ! -d "$folder/media/audio" ]
then
mkdir -p $folder/media/audio
fi
#
if [ -z "$(find $folder -name "*.mp3" -type f)" ]
then
busybox echo -e "Gak ada berkas mp3 di seluruh $folder\n"
kill -9 $$
fi
#
find $folder -name "*.mp3" -type f > $folder/mp3.log
echo "#!/system/bin/sh" > $folder/02-$(basename $0)
cat $folder/mp3.log|busybox awk -v fold=$folder/media/audio '{print "md" NR+0 "=\"\$(busybox md5sum \"" $0 "\"|busybox awk \x27{print \$1}\x27)\"\nif [ ! -f \"" fold "/\$md" NR+0 ".mp3\" ]\nthen\nmv \"" $0 "\" \"" fold "/\$md" NR+0 ".mp3\"\nfi\n##\nif [ -f \"" fold "/\$md" NR+0 ".mp3\" ]\nthen\necho \"" fold "/\$md" NR+0 ".mp3 sudah dipindahkan...\"\nif [ \"\$(dirname " $0 ")\" != \"\$(dirname " fold "/md" NR+0 ".mp3)\" ]\nthen\nrm \"" $0 "\"\nfi\nfi\n\n"}' >> $folder/02-$(basename $0)
echo "Membuat skrip baru selesai"
sleep 3
$(readlink /proc/$$/exe) "$folder/02-$(basename $0)"
busybox echo -e "\nSelesai.\n"
