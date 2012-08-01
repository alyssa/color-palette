color-palette
=============

ruby script to get the color palette of a site

output: table of color and frequency

=== Running script:

<<<<<<< HEAD
ruby color.rb 'url to get color palette for'
=======
ruby color.rb 'url'

=== Notes:


* The color palette considers hex, rgb, rgba and english word colors (ex. red, green, blue). 
* All colors are translated to hex just for consistency. 
* This script ignores opacity. 
* script sees #fff and #ffffff as two different colors. (Translating #fff to #ffffff is a no brainer, but thing's get trickier when you have something like #ff0 that translates to #ffff00. If you have any insight on how to translate this correctly, feel free to start your own branch and contribute.)
>>>>>>> 1cf1be72634c362862d17be4de293ec0fc7c9319
