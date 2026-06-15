*- to convert flac to video
```
ffmpeg -loop 1 -i cover.png -i voice.flac -c:v libx264 -preset medium -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest -r 24 voice.mp4
```
