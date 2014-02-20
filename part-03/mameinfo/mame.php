<?php

$subdirs = array();
$subdirs[] = "boxfront";
$subdirs[] = "boxback";
$subdirs[] = "cartridge";
$subdirs[] = "screenshot";
$subdirs[] = "fanart";
$subdirs[] = "action";
$subdirs[] = "title";
$subdirs[] = "3dbox";
$subdirs[] = "romcollection";
$subdirs[] = "developer";
$subdirs[] = "publisher";
$subdirs[] = "gameplay";
$subdirs[] = "cabinet";
$subdirs[] = "marquee";

$sections = array();
$sections[ "- PORTS -"           ] = "ports";
$sections[ "- SCORING -"         ] = "scoring";
$sections[ "- SERIES -"          ] = "series";
$sections[ "- SOURCES -"         ] = "source";
$sections[ "- STAFF -"           ] = "staff";
$sections[ "- TECHNICAL -"       ] = "technical";
$sections[ "- TIPS AND TRICKS -" ] = "tips";
$sections[ "- TRIVIA -"          ] = "trivia";
$sections[ "- UPDATES -"         ] = "updates";

if (! file_exists("romset")) mkdir("romset");

function makexml($content)
{
    $xml  = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n";
    $xml .= "<game>\n";

	foreach ($content as $tag => $val)
	{
		$val = trim($val);

		if (($tag == "info") || ($tag == "artwork")) $val = "  $val";

		$xml .= "<$tag>\n$val\n</$tag>\n";
	}

	$xml .= "</game>\n";

	return $xml;
}

$fd = fopen("mame.txt","r");

$current = "";
$cursect = "info";
$content = array();

while (($line = fgets($fd)) !== false)
{
	$line = utf8_encode(trim($line));

	if (strlen($line) == 0) continue;

	if (substr($line,0,7) == "*#*#*#*") continue;
	if (substr($line,0,7) == "*******") continue;

    if (substr($line,0,15) == "Game Filename: ")
	{
		$filename = trim(substr($line,15));

		$artwork = array();

		for ($inx = 0; $inx < count($subdirs); $inx++)
		{
			$subdir = $subdirs[ $inx ];

			if (file_exists("$subdir/$filename.png")) $artwork[ $subdir ] = "$filename.png"; 
			if (file_exists("$subdir/$filename.gif")) $artwork[ $subdir ] = "$filename.gif"; 
			if (file_exists("$subdir/$filename.jpg")) $artwork[ $subdir ] = "$filename.jpg"; 
			if (file_exists("$subdir/$filename.zip")) $artwork[ $subdir ] = "$filename.zip"; 
		}

		$content[ "artwork" ] = "";

		foreach ($artwork as $subdir => $value)
		{
			$tag = $subdir == "3dbox" ? "dddbox" : $subdir;
			$current .= "Artwork:$subdir: $value\n"; 
			$content[ "artwork" ] .= "  <$tag>http://www.os-smart-tv.net/mame/$subdir/$value</$tag>\n";
		}

		$filename = str_replace("&","&amp;",$filename);
		$filename = str_replace("<","&lt;", $filename);
		$filename = str_replace(">","&gt;", $filename);

		$current = $line . "\n";
		$content[ $cursect ] .= "  <game_filename>$filename</game_filename>\n";

		$cursect = "desc";
		$content[ $cursect ] = "";

		$continue;
	}

    if (substr($line,0,6) == "Game: ")
    {
		if ($current != "")
        {
			$xmldata = makexml($content);
			file_put_contents("romset/$filename.xml",$xmldata);
			file_put_contents("romset/$filename.txt",$current);

			echo "$filename\n";

			//var_dump($content);
			//exit();
    
			$current = "";
			$cursect = "info";
			$content = array();
        }

		$content[ $cursect ] = "";

		$current = $line . "\n";
    } 
	else
	{
		if (strlen($current)) 
		{
			$current .= $line . "\n";
		}
	}

	if (isset($sections[ $line ]))
	{
		$cursect = $sections[ $line ];
		$content[ $cursect ] = "";
		continue;
	}

	if ($cursect == "info")
	{
		if (isset($content[ $cursect ]))
		{
			$parts = explode(": ",$line);
			if (count($parts) == 1) continue;

			$tag = strtolower(str_replace(" ","_",array_shift($parts)));
			$val = implode(": ",$parts);

			$val = str_replace("&","&amp;",$val);
			$val = str_replace("<","&lt;", $val);
			$val = str_replace(">","&gt;", $val);

			$content[ $cursect ] .= "  <$tag>$val</$tag>\n";
		}
	}
	else
	{
		$line = str_replace("&","&amp;",$line);
		$line = str_replace("<","&lt;", $line);
		$line = str_replace(">","&gt;", $line);

		$content[ $cursect ] .= "$line\n";
	}
}

if ($current != "")
{
	$xmldata = makexml($content);
	file_put_contents("romset/$filename.xml",$xmldata);
	file_put_contents("romset/$filename.txt",$current);

	echo "$filename\n";
}

fclose($fd);

?>
