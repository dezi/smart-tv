<?php

$rootmod = $argv[ 1 ];

function dolib($name,$path,&$mods,&$fwrk,$excl,$level = 1)
{
	if (isset($mods[ $name ])) return;
	
	$pad = str_pad("",$level * 4," ");
	
	//
	// Prefer locally builds objects before standard objects
	// when analyzing shared objects.
	//

	$localpath = "/usr/local/lib/" . array_pop(explode("/",$path));

	if (file_exists("/usr/bin/otool"))
	{
		$ismac = true;
		
		if (file_exists($localpath))
			exec("otool -L $localpath",$lines);
		else
			exec("otool -L $path",$lines);
			
		array_shift($lines);
	}
	else
	{
		$ismac = false;
		
		if (file_exists($localpath))
			exec("ldd $localpath",$lines);
		else
			exec("ldd $path",$lines);
	}
	
	$childs = 0;
	
	foreach ($lines as $line)
	{
		$line = trim($line);
		
		if (substr($line,0,13) == "/lib/ld-linux") continue;
		if (substr($line,0,15) == "/lib64/ld-linux") continue;
		if (substr($line,0,15) == "linux-vdso.so.1") continue;
		if (substr($line,0,18) == "/usr/lib/libSystem") continue;

		if (substr($line,0,27) == "/System/Library/Frameworks/")
		{
			$fwork = explode(".",substr($line,27));
			
			$fwrk[ $fwork[ 0 ] ] = true;
			
			echo "$pad$line\n";
			
			continue;
		}

		if ($ismac)
		{
			$parts = explode(" (",$line);
			array_pop($parts);
			
			$ppp = explode("/",$parts[ 0 ]);
			$lll = array_pop($ppp);
			
			array_unshift($parts,"=>");
			array_unshift($parts,$lll);
			
			$line = implode(" ",$parts);
		}
		else
		{
			$parts = explode(" ",$line);
			array_pop($parts);
			$line = implode(" ",$parts);
		}
		
		if ($name == $parts[ 0 ]) continue;
		if (isset($excl[ $parts[ 0 ] ])) continue;
		
		echo "$pad$line\n";
		
		dolib($parts[ 0 ],$parts[ 2 ],$mods,$fwrk,$excl,$level + 1);
		
		$childs++;
	}
	
	if ($ismac)
	{
		$parts = explode(".dylib",$name);
	}
	else
	{
		$parts = explode(".so",$name);
	}
	
	$lname = $parts[ 0 ];

	if ($lname == "libts-0.0"         ) $lname = "libts";
	if ($lname == "libSDL-1.2"        ) $lname = "libSDL";
	if ($lname == "libfusion-1.2"     ) $lname = "libfusion";
	if ($lname == "libdirect-1.2"     ) $lname = "libdirect";
	if ($lname == "libdirectfb-1.2"   ) $lname = "libdirectfb";

	//
	// Try to identify the matching static archives.
	//
	
	$mods[ $name ][ "childs" ] = $childs;
	$mods[ $name ][ "shared" ] = $path;
	$mods[ $name ][ "sname"  ] = $lname . ".a";

	while (true)
	{
		$sname = $lname . ".a";

		$test = "/lib/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/lib64/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/lib/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/lib64/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/lib/arm-linux-gnueabihf/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/lib/arm-linux-gnueabihf/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/lib/gcc/arm-linux-gnueabihf/4.8/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/lib/gcc/x86_64-redhat-linux/4.4.4/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/local/lib/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;

		$test = "/usr/local/lib64/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;
	
		$test = "/opt/local/lib/$sname";
		if (file_exists($test)) $mods[ $name ][ "static" ] = $test;
		
		if (! $ismac) break;
		if (! strlen($lname)) break;
		
		if (isset($mods[ $name ][ "static" ])) 
		{
			$mods[ $name ][ "sname"  ] = $sname;

			break;
		}
		
		$lname = substr($lname,0,-1);
	}
	

	//
	// Special hack for pulse
	//

	$test = "/usr/local/lib/pulseaudio/$sname";
	if (file_exists($test)) $mods[ $name ][ "static" ] = $test;
}

$excl = array();

$excl[ "libgcc_s.so.1"     ] = true;
$excl[ "libauto.dylib"     ] = true;
$excl[ "libobjc.A.dylib"   ] = true;
$excl[ "libc++abi.dylib"   ] = true;
$excl[ "libresolv.9.dylib" ] = true;
$excl[ "libstdc++.6.dylib" ] = true;

$extrashared = "";
$extrastatic = "";
$extraboth   = "";

$staticpath = "./ffmpeg-static";

if (file_exists($staticpath))
{
	@exec("rm -f $staticpath/*");
}
else
{
	@mkdir($staticpath);
}

$fwrk = array();

while (true)
{
	$mods = array();

	dolib("ffmpeg",$rootmod,$mods,$fwrk,$excl);
	
	var_dump($fwrk);
	
	if (count($mods) < 2) break;
	
	$thisshared = "";
	$thisstatic = "";
	$thisboth   = "";
	
	foreach ($mods as $name => $data)
	{
		if ($data[ "childs" ] > 0) continue;
		
		$sname = $data[ "sname" ];	
		$target = isset($data[ "static" ]) ? $data[ "static" ] : "";

		$isstatic = false;
		
		if ($target == "")
		{
			$parts = explode(".so",$name);
			$static = $parts[ 0 ] . ".a";
			$search = "sudo apt-file search $static";
		
			//echo "$search\n";
			//passthru("sudo apt-file search $static");
		
			//continue;
		}
		else
		{
			if (($sname != "libc.a") &&
			    ($sname != "librt.a") &&
			    ($sname != "libdl.a") &&
			    ($sname != "libgcc_s.a") &&
			    ($sname != "libpthread.a") &&
		 	    ($sname != "libaacplus.a"))
			{
				echo "ln -sf $target .\n";
				if (file_exists($staticpath)) exec("ln -sf $target $staticpath\n");
				
				$isstatic = true;
			}
		}
		
		$excl[ $name ] = true;

		$lname = substr($sname,3,-2);
		
		if ($lname == "glapi") continue;
		
		if ($lname == "ts-0.0"      ) $lname = "ts";
		if ($lname == "SDL-1.2"     ) $lname = "SDL";
		if ($lname == "lber-2.4"    ) $lname = "lber";
		if ($lname == "ldap_r-2.4"  ) $lname = "ldap";

		if ($lname == "ncursesw")
		{
			//
			// Has a hidden dependency to libgpm.a
			//

			$target = "/usr/lib/arm-linux-gnueabihf/libgpm.a";

			echo "ln -sf $target .\n";
			if (file_exists($staticpath)) exec("ln -sf $target $staticpath\n");

			$lname = "ncursesw.a -l:gpm";
		}
		
		if ($isstatic) 
		{
			if (file_exists("/usr/bin/otool"))
			{
				$thisstatic = $thisstatic . " -l$lname";
				$thisboth   = $thisboth   . " -l$lname";
			}
			else
			{
				$thisstatic = $thisstatic . " -l:lib$lname.a";
				$thisboth   = $thisboth   . " -l:lib$lname.a";
			}
		}
		else
		{
			$thisshared = $thisshared . " -l$lname";
			$thisboth   = $thisboth   . " -l$lname";
		}
	}
	
	$extrashared = trim(trim($thisshared) . " " . $extrashared);
	$extrastatic = trim(trim($thisstatic) . " " . $extrastatic);
	$extraboth   = trim(trim($thisboth)   . " " . $extraboth  );
}

if (file_exists("/usr/bin/otool"))
{
	//
	// Add static only libs on OSX.
	//
	
	$target = "/opt/local/lib/libvpx.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lvpx " . $extraboth;
		$extrastatic = "-lvpx " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}
	
	$target = "/usr/local/lib/libgsm.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lgsm " . $extraboth;
		$extrastatic = "-lgsm " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}
		
	$target = "/opt/local/lib/libpng.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lpng " . $extraboth;
		$extrastatic = "-lpng " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}

	$target = "/opt/local/lib/libffi.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lffi " . $extraboth;
		$extrastatic = "-lffi " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}

	$target = "/opt/local/lib/libintl.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lintl " . $extraboth;
		$extrastatic = "-lintl " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}
			
	$target = "/usr/local/lib/libp11-kit.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lp11-kit " . $extraboth;
		$extrastatic = "-lp11-kit " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}

	$target = "/usr/local/lib/libSDLmain.a";
	
	if (file_exists($target)) 
	{
		$extraboth   = "-lSDLmain " . $extraboth;
		$extrastatic = "-lSDLmain " . $extrastatic;
		
		echo "ln -sf $target .\n";
		exec("ln -sf $target $staticpath\n");
	}
	
	$extraboth = $extraboth . " -lstdc++";
	
	//
	// Add OSX frameworks.
	//

	foreach ($fwrk as $name => $dummy)
	{
		$extraboth = $extraboth . " -framework $name";
	}
	
	//
	// Suppress a linker warning.
	//
	
	$extraboth = "-Wl,-no_pie " . $extraboth;
}

$extralibs = "EXTRALIBS=-v -L../ffmpeg-static $extraboth";

echo "STATIC=$extrastatic\n";
echo "SHARED=$extrashared\n";
echo "\n";

echo "$extralibs\n";
echo "\n";

if (file_exists("ffmpeg-git/config.mak"))
{
	file_put_contents("ffmpeg-git/config.mak",$extralibs,FILE_APPEND);
	@unlink("ffmpeg-git/ffmpeg");
	@unlink("ffmpeg-git/ffmpeg_g");
	@unlink("ffmpeg-git/ffplay");
	@unlink("ffmpeg-git/ffplay_g");
	@unlink("ffmpeg-git/ffprobe");
	@unlink("ffmpeg-git/ffprobe_g");
	@unlink("ffmpeg-git/ffserver");
	@unlink("ffmpeg-git/ffserver_g");
}

?>
