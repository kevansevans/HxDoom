# HxDoom readme

# What is HxDoom?
Haxe Doom is a Haxe library adaption of id Software's Doom, or more specifically, "id Tech 1". This is an attempt to create a standardized Doom library that can be used by anyone to create any sort of Doom program that they may need.

## Principles of HxDoom
**Do it the Haxe way:** All Haxe targets must be supported and avoid any platform specific code. Yes, that includes Flash and PHP.

**Dependency injection where possible:** Developers shouldn't have to fork a library to make small changes or to add support for custom formats.

**Modding at the source level** Developers should have the ability to create custom content at the source code level.

**K.I.S.S.:** Keep it simple, stupid.

# How do I use HxDoom?
Skip to Step 2 if you're already familiar with haxe and know how to install a Haxelib.
1) **Installing Haxe and HxDoom**
 - Download and install the latest version of Haxe from https://haxe.org/download/
 - The earliest version supported is 4.1.2, as HxDoom uses the newly featured ``contains`` function for arrays. There are no current plans to support any older versions of Haxe.
 - After install, open your systems terminal and run the command ``haxelib setup``. Unix users may need to use ``sudo``.
 - Run the command ``haxelib install hxdoom``. This will download and extract the latest version of HxDoom for you. To install an indev version of HxDoom, run the following command:
 ``haxelib git hxdoom https://github.com/kevansevans/HxDoom/tree/master/library``
2) **Initializing HxDoom**
- With your framework or IDE of choice, include hxdoom as a required library.
- Within your source, we need to establish the minimal environment for it to run. This is handled through the class ``hxdoom.Engine``. ``Engine`` is the main entry point for everything the library is meant to handle if the developer doesn't want to do most of the heavy lifting by writing their own code. All other HxDoom modules and cores will typically interface through this class, so it's not recommended changing it's behavior.
- Within your source should be:

	    import hxdoom.Engine;
	    
	    var myDoomGame:Engine;
	    
	    function someFunction() {
	    	myDoomGame = new Engine();
	    }
* Please note that certain cores will not be initialized when this is called. This is due to them being useless when ran as the developer is expected to provide that code.
3) **Using HxDoom**
- Typically a Doom program expects a wad to be added:

		//If your target reads files as haxe.io.bytes;
		myDoomGame.addWadBytes(wadbytes, "Filename"); 
		//If your target reads files as a String;
		myDoomGame.addWadString(wadstring, "Filename");

- The name of wad is recommended being the respective file name as to avoid unintended naming conflicts. HxDoom organizes [wad lumps](https://doomwiki.org/wiki/Lump) based on this string provided. Currently, only a single [IWAD](https://doomwiki.org/wiki/IWAD) is allowed to be loaded into HxDoom at a time, and [PWAD](https://doomwiki.org/wiki/PWAD)s should be loaded into HxDoom after the first IWAD. If you do not posses a legal IWAD, you can download the Doom shareware wad here: http://distro.ibiblio.org/pub/linux/distributions/slitaz/sources/packages/d/doom1.wad
- **Note**: The Shareware versions of IWADS (DOOM1.WAD/HERETIC1.WAD/STRIFE1.WAD) is **not allowed to be used for modding** as part of the [original license regarding the shareware versions](https://pastebin.com/Fb1GdqiK). Any developers planning on making their own source port must not ship their executables without this prevention.
- To load a map:

	    myDoomGame.loadMap(map_marker_name);

- Map markers need to be referred to by their internal string names. To load the first level of The Ultimate Doom, you would use ``myDoomGame.loadMap("E1M1");``, or to load the first level of Doom II, you would use ``myDoomGame.loadMap("MAP01");``
- Once loaded, you can access the static map variable in ``Engine.ACTIVEMAP``, which will access the assembled ``hxdoom.core.BSPMap`` created when ``loadMap()`` was called.

***

More info can be found by reading the API docs: https://kevansevans.github.io/HxDoom/api/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Confirmed targets HxDoom has been compiled to and ran on (Please help with this list!)
////////////////////////////////////////////////////////////////////////////////////////////////////
```
* With Lime https://lime.software/
  * C++ (Widows, Manjaro)
  * Hashlink https://hashlink.haxe.org/
  * HTML5 w/WebGL
* With Heaps
  * Targeting Hashlink
  * Targeting Hashlink C
* Other
  * LOVR (Lua) https://lovr.org/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Haxe code by kevansevans
////////////////////////////////////////////////////////////////////////////////////////////////////
//
//                         ...,,,,,,,,..                     
//                  ./&&%(/**,,,,,,,,,**/%&*               
//              .//,,,,,,,,,,,,,,,,,,,,,,,,/&&/            
//           ./&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*&&,         
//         .#%*,*#/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#&,       
//        ,@#,,(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/&(      
//      .%@*,/#,,,,,,,,,,,,,,,,*((/,,,,,,,,,,,,,,,,,,,##     
//     .&&/,*/,,,,,,,,,,,,,/#/,,,,,,,,,,,,,,,,,,,,,,,,,#&.   
//     %##,*%,,,,,,,,,,,,#(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%#   
//    ,%(/,#*,,,,,,,,,*#(,,,,,,,,,,,,,,,,,,,*/#%#%,,,,,,*&.  
//    (/#*,#,,,,,,,,,*%,,,,,,,,,,,,,,*/#%#*.    (*,,,,,,,((  
//    &*%**(,,,,,,,,/#,,,,,,,,,,*(&%(%.       /#,,,,,,,,,*%. 
//    &/%**(,,,,,,,/#,,,,,,,*/&%/%(  ,*     ,#/(#,,,,,,,,,&. 
//    ((##*%*******%*******#&&/*(@&**#,    *. (#,,,,,,,,,,&, 
//    .%/&/%/******%*****(&*.%**(@&*/&      *&/,,,,,,,,,,,&. 
//     /%/&/%******%****(#.  ,#****#(     /%**(*,,,,,,,,,*%. 
//      .%(&/%/****%/**/&(/    /%%/      .,#%*%*,,,,,,,,,#*  
//        ,%####***/%**#/   ....      /%/*****%*,,,,,,,,/&.  
//          .(%%/*/%*#*         .(#*.%/*****%,,,,,,,,*&*   
//              #%&@@%#%%#/*/%...#*    *%****(/,,,,,,,*&,    
//             /#*****/(%***#*...#,    (%***/%,,,,,,,(&.     
//          .%%*,,,,*#%&%%%,......*.,&/**/(,,,,,,/%,       
//       (&(((((##(/%%,,,,*%,....../##&/*(#*,,,,*&(.         
//         /%(/***/&/,,,,,,/(......*(#/,,,*(&(,            
//             .,(&,,,,,,,,*%    .*/(*,.                 
//              (#,,,,,**,,,/*    ..,#(#&&&/                 
//             *(,,,,*&/*,,,,%.  #*,,,,***&/                 
//           .#(,,,*%#(%******%(.%*******(&.                 
//           %/,,,/@(//##*******##*******&%#   
////////////////////////////////////////////////////////////////////////////////////////////////////
```