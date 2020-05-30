# HxDoom readme

# What is HxDoom?
Haxe Doom is a Haxe library adaption of id Software's Doom, or more specifically, "id Tech 1". While primarily being used as the back end of a game engine (To play Doom of course), it's primary function is to serve as a library/haxelib that Doom related tools and engines can be built on top of. Development of HxDoom must adhere to the singular core rule:

* **Wherever Haxe can deploy, HxDoom must do the same!**

The point of Haxe is to be able to maintain a singular source that can be bridged between many languages and platforms. This means that at all times, conditional compilation based on target, system, and any haxelibs must be avoided. The purpose of this system is to avoid having to write code for every edge situation, as not every target Haxe supports can be utilized the same way. Flash and JavaScript do not have file system access, native platforms can't use rendering backends like Canvas, some Haxe frameworks have limited deployment range and as a result, have limitations on what parts of Haxe it can use. Users of HxDoom are expected to make up for the parts HxDoom can not or will not meet.

The only time this should be allowed is if it's to maintain the above rule, IE JavaScript doesn't allow for array access with [haxe.io.BytesData](https://api.haxe.org/haxe/io/BytesData.html), so an integer array is used instead, allowing for identical behavior (see [hxdoom.core.WadCore.hx](https://github.com/kevansevans/HxDoom/blob/0.0.5-alpha/src/hxdoom/core/WadCore.hx)). This isn't an explicit conditional compilation, but if the issue were to arise, it would be used and listed on this readme.

# How do I use HxDoom?
HxDoom is a haxelib and is meant to be used as a library, not an engine. If you are looking to make your own Doom engine or Doom tools, and Haxe seems to be a pretty cool thing, you've come to the right place.

1) **Installing Haxe and HxDoom**
 - Download and install the latest version of Haxe from https://haxe.org/download/
 - The earliest version supported is 4.0.0 as HxDoom utilizes ``enum abstract`` for some of it's enums. For Haxe 3 and lower, (currently) all instances of these enums must be replaced with ``@:enum abstract`` and the individual values must be added, as the Haxe 3 compiler does not support being able to use implicit declaration.
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

# Extrapolating and using data
One of the key things developers need to remember when using HxDoom is that it does not provide any tools for "using" the data, but only acts as a back end for any parts of the engine that aren't platform dependent. This means that HxDoom **will not come bundled** with the following abilities:

* Rendering
* Sound output
* Player Input
* Filesystem access

What developers are encouraged to do however is inherit from the provided cores and  are expected to override functions that are provided in each core. This system should allow for near parity behaviors across implementations of HxDoom, and to prevent the need of splitting HxDoom development, causing different ports to constantly play a game of catch up.
***
### Input
* Currently, HxDoom  only supports keyboard input and should not require much effort from the developer to change it's behavior.
* Developer must send inputs to ``IOCore.hx``. ``Engine.hx`` will declare a new IOCore when initilized, so it can be accessed via ``Engine.IO``
* Send 'key down' events to ``Engine.IO.keyPress()`` and 'key release' events to ``Engine.IO.keyRelease()``.
* HxDoom expects [standard ASCII codes](http://www.asciitable.com/) integers for input. It provides it's own ASCII enum (``hxdoom.utils.enums.HXDKeyCode``) in case the developer is unable to send in correct inputs.

### Rendering
When a map is loaded, all loaded walls can be found through either the static ACTIVEMAP variable ``Engine.ACTIVEMAP.linedefs`` or ``Engine.ACTIVEMAP.segments``, however it's more encouraged to rely on ``RenderCore.hx`` to solve which walls are visible.
* RenderCore.hx has to be manually declared as new. HxDoom does not come with the ability to create a window and draw a scene, as many platforms have different ways to go about this, and we're avoiding any target/library dependent code.
* Instead, the developer is recommended to create a class that inherits from ``RenderCore.hx`` so they can add their own rendering code. As an example for an OpenGL approach, see [GLHandler.hx for the Citrus Doom](https://github.com/kevansevans/HxDoom/blob/0.0.5-alpha/src/citrus/render/limeGL/GLHandler.hx) adaption of HxDoom.
* ``initScene()`` This is the first function in RenderCore to get called when a map is loaded into memory. If the developer requires to perform some pre-calculations with the map geometry, IE triangulation of walls, floors, ceilings, sprites for a GL based library, the developer must override this function. Otherwise, the function does nothing and can be ignored.
* ``setVisibleSegments()`` This function determines the visible geometry and items within the player's FOV. It will call a private function ``subsectorVisibilityCheck()`` and will populate the public array ``vis_segments`` with every visible wall. Developers can derive visible floors/ceilings and actors from this array. These functions do not need to be overriden unless non-vanilla behavior is desired.
* ``render_scene()`` This function is meant to be called during the developers render loop. Minimum framerate desired should be 35FPS. On it's own, it will do nothing and must be overriden. Developers can access ``vis_segments`` and pass those values to however they're drawn on screen.

# TO DO
so much time so little to do...

# Credits

* HxDoom is loosely based on id Software's Doom: https://github.com/id-Software/DOOM
* HxDoom had it's start thanks to the DIY Doom Project: https://github.com/amroibrahim/DIYDoom
* DIY Doom is led by Amro Ibrahim https://twitter.com/AngryCPPCoder and Marl https://twitter.com/DOOMReboot
* Chocolate Doom, which is the source port DIY Doom is based on: https://www.chocolate-doom.org/wiki/index.php/Chocolate_Doom
* The Haxe Discord server https://discordapp.com/invite/0uEuWH3spjck73Lo
* The OpenFL Discord server: https://discordapp.com/invite/SnJBC53
* The ZDoom community for being very open and welcoming to this approach for a Doom source port: https://forum.zdoom.org/index.php

