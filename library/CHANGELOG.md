### Alpha 0.0.5
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