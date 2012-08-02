color-palette
=============

Ruby and PHP script to get the color palette of a site

* The Ruby script can get any external url. For example, you could use it on amazon.com
* The PHP script is for a site that you own. This enables it to be used on parts of your site that require login, for example

output: table of color and frequency

Running Ruby script:
--------------------

    ruby color.rb 'url'

Running PHP script:
-------------------

* Drop the color.php script into a web server

         $c = new ColorPalette();
         $c->PrintColorPalette();

* ColorPalette also takes two optional parameters:

         ColorPalette($startingDir = '.', $fileTypes = array('php', 'html', 'ctp', 'css', 'js'));`

* You can also run color.php with

         $c = new ColorPalette();
         $colorArray = c->buildColorPalette(); //Now contains all of the color counts

Notes:
------

* The color palette considers hex, rgb, rgba and english word colors (ex. red, green, blue).
* All colors are translated to hex just for consistency.
* This script ignores opacity.