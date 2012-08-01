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
        puts url
        urls = Array.new
        
        page = Nokogiri::HTML(open(url))      
        urls << url # will check homepage just in case there is embedded css
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
            page_source = Nokogiri::HTML(open(css_url)).text 
            # |color| will be an array of 5 elements (5 regex groups)
            # group 1: hex
            # group 2,3,4: rgb respectively notes: handles rgba but ignores opacity
            # group 5: a color (as an English word -- ex. white)
            color_array = page_source.scan(/color\s*:\s*(#[0-9A-Fa-f]{3,6}+)\s*;|rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*|color\s*:\s*(white|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|orange|purple)/)
            color_array.each{|color|
       #         puts color.inspect
                if color[0] != nil
                    color = color[0].downcase
                elsif color[1] != nil
                    color = "#" + color[1].to_i.to_s(16) + color[2].to_i.to_s(16) + color[3].to_i.to_s(16)
                else
                    color = color[4].downcase
                    hex_color = get_hex(color)
                    color = hex_color if hex_color != nil # try to assign a hex value, if not, will remain as is (ex. white, blue, etc.)
                end
        #        puts color
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
            when "white"    then "#ffffff"        
            when "black"    then "#000000"
            when "fuchsia"  then "#ff00ff"
            when "gray"     then "#808080"
            when "green"    then "#008000"
            when "lime"     then "#00ff00"
            when "maroon"   then "#800000"
            when "olive"    then "#808000"
            when "orange"   then "#ffA500"
            when "purple"   then "#800080"
        end  
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
    
    def get_color_palette
        @color_palette
    end

end

#ARGV.each do|a|
#  puts "Argument: #{a}"
#end

if ARGV.length == 0
    puts "must provide an argument"
elsif ARGV.length > 1
    puts "i only need one param, namely a url."
elsif ARGV.length == 1
    param_url = ARGV[0]
end
puts param_url

cp = ColorPalette.new("#{param_url}")

cp.get_color_palette.each{|c| puts c}
