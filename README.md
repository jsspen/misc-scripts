# misc-scripts
Various little scripts to have handy

## CompressTifLZW.bat
Use ImageMagick to compress uncompressed tif files using LZW, copying them to a `Compressed` subdirectory of the root as they're compressed. Drag and drop files onto .bat to run.

## folders-of-images-to-pdf.sh
Take a folder of jpg images and convert them to a single PDF

## folder-to-cbr.bat
Take a folder of images (.jpg, .jpeg, .png, .gif, .webp, .tif, .tiff, .jfif supported) and combine them into a compressed cbr file. Uses alpha order but mixed extensions can cause trouble. Drag and drop files onto .bat to run.

## move.sh
When given a folder with .mkv files it will create directories with matching names for each file and then move them each inside their respective directories.

## move-files-to-folders-with-same-names.bat
Same idea as `move.sh` but in this case any file dropped on the .bat will then create a directory with matching name and move the file into it.

## rename.sh
Flip the name of directories with a `title - year` format to a `year - title` format.