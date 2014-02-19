<?php

if (! file_exists("romset")) mkdir("romset");

$fd = fopen("mame.txt","r");

$current = "";

while (($line = fgets($fd)) !== false)
{
	$line = trim($line);

	if (strlen($line) == 0) continue;

	if (substr($line,0,7) == "*#*#*#*") continue;
	if (substr($line,0,7) == "*******") continue;

    if (substr($line,0,15) == "Game Filename: ")
	{
		$filename = trim(substr($line,15));
	}

    if (substr($line,0,6) == "Game: ")
    {
		if ($current != "")
        {
			file_put_contents("desc/$filename.txt",$current);

			echo "$filename\n";
    
			$current = "";
        }
		
		$current = $line . "\n";
    } 
	else
	{
		if (strlen($current)) $current .= $line . "\n";
	}
}

fclose($fd);

?>
