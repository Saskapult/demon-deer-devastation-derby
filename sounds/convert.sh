for i in *.m4a; do
  ffmpeg -i "$i" -c:a libvorbis "${i%.*}.ogg" && trash "$i";
done
