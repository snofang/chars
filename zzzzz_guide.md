*- to convert flac to video
```
ffmpeg -loop 1 -i cover.png -i voice.flac -c:v libx264 -preset medium -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest -r 24 voice.mp4
```

*- to convert flac to mp3
```
gahetu_draft$ ffmpeg -i voice.flac -b:a 128k -map_metadata 0 -id3v2_version 3 -q:a 2 voice.mp3
```
