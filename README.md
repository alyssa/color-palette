Color-Palette
=============

ruby script to get the color palette of a site

output: table of color and frequency

##Setup##

Clone the repo

```
$ git clone the_repo
```

Change into the folder

```
$ cd color-palette
```

When prompted, accept the .rvmrc file.

```
y [enter]
```

If you weren't prompted for the .rvmrc file, then you may not have rvm installed.
If you don't have rvm, [install rvm](https://rvm.io/rvm/install/)

Install the bundle

```
$ bundle install
```

If you don't have bundler, then install bundler.

```
$ gem install bundler
```


##Run the script:##

```
$ ruby color.rb your_url
```

=== Notes:

* The color palette considers hex, rgb, rgba and english word colors (ex. red, green, blue).
* All colors are translated to hex just for consistency.
* This script ignores opacity.
* generates html file so you can visually see color palette