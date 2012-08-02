<?php
class ColorPalette{

	private $dir;
	private $fileTypes;

	public function __construct($dir = '.', $fileTypes = array('php', 'html', 'ctp', 'css', 'js')){
		$this->dir = $dir;
		if(!is_dir($this->dir)) die($dir . ' is not a valid directory');
		$this->fileTypes = $fileTypes;
	}

	public function buildColorPalette(){
		$allFiles = $this->_traverse($this->dir);
		$allMatches = array();
		$colorRegex = '/color\s*:\s*(#[0-9A-Fa-f]{3,6}+)\s*|rgba?\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*|color\s*:\s*(white|aqua|black|blue|fuchsia|gray|green|lime|maroon|navy|olive|orange|purple)/';
		$colorArr = array();
		foreach($allFiles as $filePath){
			$matches = array();
			try{
				$handle = @fopen($filePath, 'r');
				if ($handle) {
					while (($buffer = fgets($handle)) !== false) {
						preg_match($colorRegex, $buffer, $matches);
						if(!empty($matches)){
							$allMatches[] = $matches;
						}
					}
					if (!feof($handle)) {
						echo "Error: unexpected fgets() fail\n";
					}
					fclose($handle);
				}
			} catch(Exception $e){
				echo("<p>{$e}</p>");
			}
		}
		//clear up some memory
		unset($allFiles);
		foreach($allMatches as $match){
			$color = 0;
			if(isset($match[5])){ //'color: white'
				$color = $this->_getHex(strtolower($match[5]));
			} else if(isset($match[4])){ //color: rgba(0,0,0)
				$color = $this->_expandHex('#' . intval($color[2]) . intval($color[3]) . intval($color[4]));
			} else if(isset($match[1])){ //color: #000 or #000000
				$color = strlen($match[1]) < 7 ? $this->_expandHex($match[1]) : $match[1];
			}
			if(isset($colorArr[$color])) $colorArr[$color]++;
			else $colorArr[$color] = 1;
		}
		return $colorArr;
	}

	public function printColorTable(){
		$cpalette = $this->buildColorPalette();
		arsort($cpalette);
		echo('<p>Number of unique colors: ' . count($cpalette) . '</p>');
		echo('<table>');
		echo('<tr><th>Color</th><th>Count</th></tr>');
		foreach($cpalette as $color => $count){
			echo("<tr><td>{$color}</td><td>{$count}</td></tr>");
		}
		echo('</table>');
	}

	private function _traverse($dir){
		$dirContents = scandir($dir);
		$allContents = array();
		foreach($dirContents as $item){
			$itemPath = $dir . '/' . $item;
			if(is_dir($itemPath)){
				if($item[0] != '.'){
					$allContents = array_merge($allContents, $this->_traverse($itemPath));
				}
			} else if(is_file($itemPath)){
				if(in_array(pathinfo($item, PATHINFO_EXTENSION), $this->fileTypes)){
					$allContents[] = $itemPath;
				}
			}
		}
		return $allContents;
	}

	private function _getHex($color){
		//from http://www.yourhtmlsource.com/stylesheets/namedcolours.html
		switch($color){
			case 'aliceblue': return '#f0f8ff';
			case 'antiquewhite': return '#faebd7';
			case 'aqua': return '#00ffff';
			case 'aquamarine': return '#7fffd4';
			case 'azure': return '#f0ffff';
			case 'beige': return '#f5f5dc';
			case 'bisque': return '#ffe4c4';
			case 'black': return '#000000';
			case 'blanchedalmond': return '#ffebcd';
			case 'blue': return '#0000ff';
			case 'blueviolet': return '#8a2be2';
			case 'brown': return '#a52a2a';
			case 'burlywood': return '#deb887';
			case 'cadetblue': return '#5f9ea0';
			case 'chartreuse': return '#7fff00';
			case 'chocolate': return '#d2691e';
			case 'coral': return '#ff7f50';
			case 'cornflowerblue': return '#6495ed';
			case 'cornsilk': return '#fff8dc';
			case 'crimson': return '#dc143c';
			case 'cyan': return '#00ffff';
			case 'darkblue': return '#00008b';
			case 'darkcyan': return '#008b8b';
			case 'darkgoldenrod': return '#b8860b';
			case 'darkgray': return '#a9a9a9';
			case 'darkgreen': return '#006400';
			case 'darkkhaki': return '#bdb76b';
			case 'darkmagenta': return '#8b008b';
			case 'darkolivegreen': return '#556b2f';
			case 'darkorange': return '#ff8c00';
			case 'darkorchid': return '#9932cc';
			case 'darkred': return '#8b0000';
			case 'darksalmon': return '#e9967a';
			case 'darkseagreen': return '#8fbc8f';
			case 'darkslateblue': return '#483d8b';
			case 'darkslategray': return '#2f4f4f';
			case 'darkturquoise': return '#00ced1';
			case 'darkviolet': return '#9400d3';
			case 'deeppink': return '#ff1493';
			case 'deepskyblue': return '#00bfff';
			case 'dimgray': return '#696969';
			case 'dodgerblue': return '#1e90ff';
			case 'firebrick': return '#b22222';
			case 'floralwhite': return '#fffaf0';
			case 'forestgreen': return '#228b22';
			case 'fuchsia': return '#ff00ff';
			case 'gainsboro': return '#dcdcdc';
			case 'ghostwhite': return '#f8f8ff';
			case 'gold': return '#ffd700';
			case 'goldenrod': return '#daa520';
			case 'gray': return '#808080';
			case 'green': return '#008000';
			case 'greenyellow': return '#adff2f';
			case 'honeydew': return '#f0fff0';
			case 'hotpink': return '#ff69b4';
			case 'indianred': return '#cd5c5c';
			case 'indigo': return '#4b0082';
			case 'ivory': return '#fffff0';
			case 'khaki': return '#f0e68c';
			case 'lavender': return '#e6e6fa';
			case 'lavenderblush': return '#fff0f5';
			case 'lawngreen': return '#7cfc00';
			case 'lemonchiffon': return '#fffacd';
			case 'lightblue': return '#add8e6';
			case 'lightcoral': return '#f08080';
			case 'lightcyan': return '#e0ffff';
			case 'lightgoldenrodyellow': return '#fafad2';
			case 'lightgreen': return '#90ee90';
			case 'lightgrey': return '#d3d3d3';
			case 'lightpink': return '#ffb6c1';
			case 'lightsalmon': return '#ffa07a';
			case 'lightseagreen': return '#20b2aa';
			case 'lightskyblue': return '#87cefa';
			case 'lightslategray': return '#778899';
			case 'lightsteelblue': return '#b0c4de';
			case 'lightyellow': return '#ffffe0';
			case 'lime': return '#00ff00';
			case 'limegreen': return '#32cd32';
			case 'linen': return '#faf0e6';
			case 'magenta': return '#ff00ff';
			case 'maroon': return '#800000';
			case 'mediumauqamarine': return '#66cdaa';
			case 'mediumblue': return '#0000cd';
			case 'mediumorchid': return '#ba55d3';
			case 'mediumpurple': return '#9370d8';
			case 'mediumseagreen': return '#3cb371';
			case 'mediumslateblue': return '#7b68ee';
			case 'mediumspringgreen': return '#00fa9a';
			case 'mediumturquoise': return '#48d1cc';
			case 'mediumvioletred': return '#c71585';
			case 'midnightblue': return '#191970';
			case 'mintcream': return '#f5fffa';
			case 'mistyrose': return '#ffe4e1';
			case 'moccasin': return '#ffe4b5';
			case 'navajowhite': return '#ffdead';
			case 'navy': return '#000080';
			case 'oldlace': return '#fdf5e6';
			case 'olive': return '#808000';
			case 'olivedrab': return '#688e23';
			case 'orange': return '#ffa500';
			case 'orangered': return '#ff4500';
			case 'orchid': return '#da70d6';
			case 'palegoldenrod': return '#eee8aa';
			case 'palegreen': return '#98fb98';
			case 'paleturquoise': return '#afeeee';
			case 'palevioletred': return '#d87093';
			case 'papayawhip': return '#ffefd5';
			case 'peachpuff': return '#ffdab9';
			case 'peru': return '#cd853f';
			case 'pink': return '#ffc0cb';
			case 'plum': return '#dda0dd';
			case 'powderblue': return '#b0e0e6';
			case 'purple': return '#800080';
			case 'red': return '#ff0000';
			case 'rosybrown': return '#bc8f8f';
			case 'royalblue': return '#4169e1';
			case 'saddlebrown': return '#8b4513';
			case 'salmon': return '#fa8072';
			case 'sandybrown': return '#f4a460';
			case 'seagreen': return '#2e8b57';
			case 'seashell': return '#fff5ee';
			case 'sienna': return '#a0522d';
			case 'silver': return '#c0c0c0';
			case 'skyblue': return '#87ceeb';
			case 'slateblue': return '#6a5acd';
			case 'slategray': return '#708090';
			case 'snow': return '#fffafa';
			case 'springgreen': return '#00ff7f';
			case 'steelblue': return '#4682b4';
			case 'tan': return '#d2b48c';
			case 'teal': return '#008080';
			case 'thistle': return '#d8bfd8';
			case 'tomato': return '#ff6347';
			case 'turquoise': return '#40e0d0';
			case 'violet': return '#ee82ee';
			case 'wheat': return '#f5deb3';
			case 'white': return '#ffffff';
			case 'whitesmoke': return '#f5f5f5';
			case 'yellow': return '#ffff00';
			case 'yellowgreen': return '#9acd32';
		}
	}

	private function _expandHex($color){
		return $color[0] . $color[1] . $color[1] . $color[2] . $color[2] . $color[3] . $color[3];
	}
}

//DEBUG

$c = new ColorPalette('.');
$cpalette = $c->printColorTable();