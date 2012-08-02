require 'open-uri'
require 'nokogiri'

class ColorPalette

    def initialize(url)
        url = check_url(url)
        # hashmap with store color -> # of appearances
        @color_map = Hash.new
        urls = get_stylesheet_urls(url)
        build_color_palette(urls)
        sort_palette
    end

    def check_url(url)
        url = "http://" + url if !url.start_with?("http", "https", "ftp")
        url = url.chomp('/') if url.end_with? '/' # chomp will making concatenating relative css files to url easier
        return url
    end

    def get_stylesheet_urls(url)
        urls = Array.new
        begin
            page = Nokogiri::HTML(open(url))
        rescue
            abort("Not a valid link. Try another one.")
        end
        page.css('head').css('link[rel=stylesheet]').each {|stylesheet|
            if !stylesheet['href'].start_with? '/'
                css_url = stylesheet['href']
            else
                css_url = url +  stylesheet['href'] # local files, must add to url for uri parsing
            end
            urls << css_url
        }
        urls
    end

    def build_color_palette(urls)
        urls.each{ |css_url|
        #    puts css_url
            page_source = Nokogiri::HTML(open(css_url)).text
            # |color| will be an array of 5 elements (5 regex groups)
            # group 1: hex
            # group 2,3,4: rgb respectively notes: handles rgba but ignores opacity
            # group 5: a color (as an English word -- ex. white)
            color_array = page_source.scan(/color\s*:\s*(#[0-9A-Fa-f]{3,6}+)\s*|rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*|color\s*:\s*(white|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|orange|purple)/)
            color_array.each{|color|
                #puts color.inspect
                if color[0] != nil
                    color = color[0].downcase
                    color = expand_hex(color) if color.length == 4 # usually length 3 but including '#' so use length 4
                elsif color[1] != nil
                    color = "#" + color[1].to_i.to_s(16) + color[2].to_i.to_s(16) + color[3].to_i.to_s(16)
                    # below is the case that you have r: 0 g: 0 b: 0 => #000 .... need to expand
                    color = expand_hex(color) if color.length == 4 # usually length 3 but including '#' so use length 4
                else
                    color = color[4].downcase
                    hex_color = get_hex(color)
                    color = hex_color if hex_color != nil # try to assign a hex value, if not, will remain as is.
                end
                #puts color
                if @color_map[color] == nil
                    @color_map[color] = 1
                else
                    @color_map[color] += 1
                end
            }
        }
    end

    # helper method for build_color_palette
    def get_hex(color)
        hex = case color
        when "aliceblue"			then "#f0f8ff"
		when "antiquewhite"			then "#faebd7"
		when "aqua"					then "#00ffff"
		when "aquamarine"			then "#7fffd4"
		when "azure"				then "#f0ffff"
		when "beige"				then "#f5f5dc"
		when "bisque"				then "#ffe4c4"
		when "black"				then "#000000"
		when "blanchedalmond"		then "#ffebcd"
		when "blue"					then "#0000ff"
		when "blueviolet"			then "#8a2be2"
		when "brown"				then "#a52a2a"
		when "burlywood"			then "#deb887"
		when "cadetblue"			then "#5f9ea0"
		when "chartreuse"			then "#7fff00"
		when "chocolate"			then "#d2691e"
		when "coral"				then "#ff7f50"
		when "cornflowerblue"		then "#6495ed"
		when "cornsilk"				then "#fff8dc"
		when "crimson"				then "#dc143c"
		when "cyan"					then "#00ffff"
		when "darkblue"				then "#00008b"
		when "darkcyan"				then "#008b8b"
		when "darkgoldenrod"		then "#b8860b"
		when "darkgray"				then "#a9a9a9"
		when "darkgreen"			then "#006400"
		when "darkkhaki"			then "#bdb76b"
		when "darkmagenta"			then "#8b008b"
		when "darkolivegreen"		then "#556b2f"
		when "darkorange"			then "#ff8c00"
		when "darkorchid"			then "#9932cc"
		when "darkred"				then "#8b0000"
		when "darksalmon"			then "#e9967a"
		when "darkseagreen"			then "#8fbc8f"
		when "darkslateblue"		then "#483d8b"
		when "darkslategray"		then "#2f4f4f"
		when "darkturquoise"		then "#00ced1"
		when "darkviolet"			then "#9400d3"
		when "deeppink"				then "#ff1493"
		when "deepskyblue"			then "#00bfff"
		when "dimgray"				then "#696969"
		when "dodgerblue"			then "#1e90ff"
		when "firebrick"			then "#b22222"
		when "floralwhite"			then "#fffaf0"
		when "forestgreen"			then "#228b22"
		when "fuchsia"				then "#ff00ff"
		when "gainsboro"			then "#dcdcdc"
		when "ghostwhite"			then "#f8f8ff"
		when "gold"					then "#ffd700"
		when "goldenrod"			then "#daa520"
		when "gray"					then "#808080"
		when "green"				then "#008000"
		when "greenyellow"			then "#adff2f"
		when "honeydew"				then "#f0fff0"
		when "hotpink"				then "#ff69b4"
		when "indianred"			then "#cd5c5c"
		when "indigo"				then "#4b0082"
		when "ivory"				then "#fffff0"
		when "khaki"				then "#f0e68c"
		when "lavender"				then "#e6e6fa"
		when "lavenderblush"		then "#fff0f5"
		when "lawngreen"			then "#7cfc00"
		when "lemonchiffon"			then "#fffacd"
		when "lightblue"			then "#add8e6"
		when "lightcoral"			then "#f08080"
		when "lightcyan"			then "#e0ffff"
		when "lightgoldenrodyellow"	then "#fafad2"
		when "lightgreen"			then "#90ee90"
		when "lightgrey"			then "#d3d3d3"
		when "lightpink"			then "#ffb6c1"
		when "lightsalmon"			then "#ffa07a"
		when "lightseagreen"		then "#20b2aa"
		when "lightskyblue"			then "#87cefa"
		when "lightslategray"		then "#778899"
		when "lightsteelblue"		then "#b0c4de"
		when "lightyellow"			then "#ffffe0"
		when "lime"					then "#00ff00"
		when "limegreen"			then "#32cd32"
		when "linen"				then "#faf0e6"
		when "magenta"				then "#ff00ff"
		when "maroon"				then "#800000"
		when "mediumauqamarine"		then "#66cdaa"
		when "mediumblue"			then "#0000cd"
		when "mediumorchid"			then "#ba55d3"
		when "mediumpurple"			then "#9370d8"
		when "mediumseagreen"		then "#3cb371"
		when "mediumslateblue"		then "#7b68ee"
		when "mediumspringgreen"	then "#00fa9a"
		when "mediumturquoise"		then "#48d1cc"
		when "mediumvioletred"		then "#c71585"
		when "midnightblue"			then "#191970"
		when "mintcream"			then "#f5fffa"
		when "mistyrose"			then "#ffe4e1"
		when "moccasin"				then "#ffe4b5"
		when "navajowhite"			then "#ffdead"
		when "navy"					then "#000080"
		when "oldlace"				then "#fdf5e6"
		when "olive"				then "#808000"
		when "olivedrab"			then "#688e23"
		when "orange"				then "#ffa500"
		when "orangered"			then "#ff4500"
		when "orchid"				then "#da70d6"
		when "palegoldenrod"		then "#eee8aa"
		when "palegreen"			then "#98fb98"
		when "paleturquoise"		then "#afeeee"
		when "palevioletred"		then "#d87093"
		when "papayawhip"			then "#ffefd5"
		when "peachpuff"			then "#ffdab9"
		when "peru"					then "#cd853f"
		when "pink"					then "#ffc0cb"
		when "plum"					then "#dda0dd"
		when "powderblue"			then "#b0e0e6"
		when "purple"				then "#800080"
		when "red"					then "#ff0000"
		when "rosybrown"			then "#bc8f8f"
		when "royalblue"			then "#4169e1"
		when "saddlebrown"			then "#8b4513"
		when "salmon"				then "#fa8072"
		when "sandybrown"			then "#f4a460"
		when "seagreen"				then "#2e8b57"
		when "seashell"				then "#fff5ee"
		when "sienna"				then "#a0522d"
		when "silver"				then "#c0c0c0"
		when "skyblue"				then "#87ceeb"
		when "slateblue"			then "#6a5acd"
		when "slategray"			then "#708090"
		when "snow"					then "#fffafa"
		when "springgreen"			then "#00ff7f"
		when "steelblue"			then "#4682b4"
		when "tan"					then "#d2b48c"
		when "teal"					then "#008080"
		when "thistle"				then "#d8bfd8"
		when "tomato"				then "#ff6347"
		when "turquoise"			then "#40e0d0"
		when "violet"				then "#ee82ee"
		when "wheat"				then "#f5deb3"
		when "white"				then "#ffffff"
		when "whitesmoke"			then "#f5f5f5"
		when "yellow"				then "#ffff00"
		when "yellowgreen"			then "#9acd32"
        end
    end

    # helper method for build_color_palette
    def expand_hex(color)
        new_hex = color[0]
        for i in 1..3
            new_hex += color[i]+color[i]
        end
        new_hex
    end

    # will sort hash map and add those keys to an array then return array
    def sort_palette
        @color_palette = Array.new
        @color_map = @color_map.sort_by {|k,v| v}.reverse
        @color_map.each{|key, value|
            @color_palette << key
        }
        #    color_palette.each{|color| puts color}
        return @color_palette
    end

    def print_color_palette
        @color_palette.each{|c| puts c}
    end

    def print_palette_with_freq
        puts "number of unique colors: " + @color_map.size.to_s
        printf("--------|-----------\n")
        printf("%.8s\t|%s\n", "Color", "Frequency")
        printf("--------|-----------\n")
        @color_map.each{|key, value|
            printf("%.8s |%d\n", key, value)
        }

    end
end

if ARGV.length == 0
    abort("must provide a url")
elsif ARGV.length > 1
    abort("Too much info, buddy. I just need one url.")
elsif ARGV.length == 1
    param_url = ARGV[0]
end

cp = ColorPalette.new("#{param_url}")
puts "Palette for " + param_url
cp.print_palette_with_freq