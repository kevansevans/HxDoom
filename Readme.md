# HxDoom readme

# What is HxDoom?
Haxe Doom is a Haxe library adaption of id Software's Doom, or more specifically, "id Tech 1". While currently being used as the back end of a game engine (To play Doom of course), it's primary function is to serve as a library/haxelib that Doom related tools and engines can be built on top of. Development of HxDoom must adhere to the singular core rule:

* **Wherever Haxe can deploy, HxDoom must do the same!**

The point of Haxe is to be able to maintain a singular source that can be bridged between many languages and platforms. This means that at all times, conditional compilation based on target, system, and any haxelibs must be avoided. The purpose of this system is to avoid having to write code for every edge situation, as not every target Haxe supports can be utilized the same way. Flash and JavaScript do not have file system access, native platforms can't use rendering backends like Canvas, some Haxe frameworks have limited deployment range and as a result, have limitations on what parts of Haxe it can use. Users of HxDoom are expected to make up for the parts HxDoom can not or will not meet.

The only time this should be allowed is if it's to maintain the above rule, IE JavaScript doesn't allow for array access with [haxe.io.BytesData](https://api.haxe.org/haxe/io/BytesData.html), so an integer array is used instead, allowing for identical behavior (see [hxdoom.core.WadCore.hx](https://github.com/kevansevans/HxDoom/blob/0.0.5-alpha/src/hxdoom/core/WadCore.hx)). This isn't an explicit conditional compilation, but if the issue were to arise, it would be used and listed on this readme.

# Features and goals

* Act as a unifying library for anything Doom related.
* Easy integration and use within any project.
* Dependency injection, change behaviors without changing the library!

# How do I use HxDoom?
HxDoom is a haxelib and is meant to be used as a library, it provides tools needed to make building your engine or tools easier.

1) **Installing Haxe and HxDoom**
 - Download and install the latest version of Haxe from https://haxe.org/download/
 - The earliest version supported is 4.1.2, as HxDoom uses the newly featured ``contains`` function for arrays. Some time in the future, I might work on a Haxe 3 compatible version.
 - After install, open your systems terminal and run the command ``haxelib setup``. Unix users may need to use ``sudo``.
 - Run the command ``haxelib install hxdoom``. This will download and extract the latest version of HxDoom for you. Alternatively if you need a specific version, you can use ``haxelib install hxdoom`` and add the version number to the end of the command, IE ``haxelib install hxdoom 0.0.4``. Haxelib also can install the latest git version with ``haxelib git hxdoom [git URL here]``
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
- To add a wad:

	    myDoomGame.addWad(wadbytes, "Filename");

- ``wadbytes`` being the data (as ``haxe.io.bytes``) through your targets method of loading files. The name of wad is recommended being the respective file name as to avoid unintended naming conflicts. HxDoom organizes [wad lumps](https://doomwiki.org/wiki/Lump) based on this string provided. Only a single [IWAD](https://doomwiki.org/wiki/IWAD) is allowed to be loaded into HxDoom at a time, and [PWAD](https://doomwiki.org/wiki/PWAD)s should be loaded into HxDoom after the first IWAD. If you do not posses a legal IWAD, you can download the Doom shareware wad here: http://distro.ibiblio.org/pub/linux/distributions/slitaz/sources/packages/d/doom1.wad
- As a side note: The Shareware version of Doom (DOOM1.wad) is not allowed to be used for modding as part of the [original license regarding the shareware](https://pastebin.com/Fb1GdqiK). Any developers planning on making their own source port must not ship their executables without this prevention.
- To load a map:

	    myDoomGame.loadMap(map_marker_name);

- Maps are indexed by their marker name, which is a string. To load the first level of The Ultimate Doom, you would use ``myDoomGame.loadMap("E1M1");``, or to load the first level of Doom II, you would use ``myDoomGame.loadMap("MAP01");``
- Once loaded, you can access the static map variable in ``Engine.ACTIVEMAP``, which will access the assembled ``hxdoom.core.BSPMap`` created when ``loadMap()`` was called.

***

More info can be found by reading the API docs: https://kevansevans.github.io/HxDoom/api/

```
////////////////////////////////////////////////////////////////////////////////////////////////////
//Confirmed specific targets HxDoom has been compiled to and ran on
////////////////////////////////////////////////////////////////////////////////////////////////////
```
* C++ (Widows, Manjaro)
* Hashlink JIT
* HTML5

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
