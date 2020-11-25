### 24NOV2020

* The Haxelib is now MIT!
  * A sizeable chunk of the previous in-dev work had to be removed due to it being borrowed from GPL2 sources. This is counter to the goals of HxDoom. A substitute source has been found and will be used from now on.
* Flat textures reading added.
* Blockmap reading added.
* Dependency injection for functions added to Reader.hx.
* Vanilla maps can read out of order lumps.
* Further fixes to wall visibly calculations.
* Sector.hx
  * Added 'lines' array that stores all linedefs that make up sector.
  * Added 'getSortedVertices' static method that returns a correctly sorted array of vertices, meant for aiding with converting map geometry into GL-Esque friendly data.
* General code cleanup

### 16AUG2020 0.0.6

* Significant organization of classes with clearer intent with their names and package paths
* Significant improvements to documentation, friendly to Dox generation.
* Significant overhaul to wad reading and core utilization. Way too much to list!
* Per class dependency injection system utilizing var class:() -> Class = Class.new; Allows for easy behavior replacement of the library without having to rewrite the whole library.
* String parsing for addWad via WadCore.addWadFromString. This is for Haxe targets that do not natively support "bytes" or their filesystem handlers returns strings when reading files.
* Texture reading. Can now read TEXTUREX and PNAME lumps and assemble defined patches.
* Addition of LevelCore.hx which more directly handles loaded maps

### 29MAY2020 Alpha 0.0.5
* Improved Core overriding system
* Cleaner map lumps
* Reduced memory useage
* Cleaner implementation of assembling data for supplied renderer
* Dedicated Camera class
* Implemented CVar system
* ZPos getter for all actors, no longer limited to players
* "Closed" Geometry now occludes walls
* "Patch" Reading added hxdoom.lumps.graphic.Patch.hx
* Started samples folder. Requires OpenFL. First Sample is how to read a Patch.

### 03APR2020 Alpha 0.0.4
* Various improvements to null handling safety
* Occlusion algorithm works more closely to vanilla behavior
* Dedicated ASCII table to maintain lib agnosticism
* More dedicated core classes that can be overriden by user
* Reduced asynchronus rendering. RenderCore has dedicated function render_scene() to call
* Maps are now loaded/built when calling loadMap() instead of stored in memory
* Added more toString functions to lumps

### 03MAR2020 Alpha 0.0.3
* CheatHandler.hx should be fixed
* Added ``toString()`` funtions to classes found in hxdoom/lumps/map/ for debug purposes.
* Added cardinal direction enums, CardInt for integer values 90, 180, 225, etcetera, CardString for "NORTH", "WEST", etcetera
* Moved render behavior from ``hxdoom.core.BSPMap`` to ``hxdoom.core.Render``. Name subject to change.
* Added engine loop to ``hxdoom.Engine``.  Calling ``Engine.start()`` will set up default behavior, alternatively a user can attach a function to ``Engine.gamelogic`` for custom behavior.
