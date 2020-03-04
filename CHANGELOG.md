### 03MAR2020 Alpha 0.0.3
* CheatHandler.hx should be fixed
* Added ``toString()`` funtions to classes found in hxdoom/lumps/map/ for debug purposes.
* Added cardinal direction enums, CardInt for integer values 90, 180, 225, etcetera, CardString for "NORTH", "WEST", etcetera
* Moved render behavior from ``hxdoom.core.BSPMap`` to ``hxdoom.core.Render``. Name subject to change.
* Added engine loop to ``hxdoom.Engine``.  Calling ``Engine.start()`` will set up default behavior, alternatively a user can attach a function to ``Engine.gamelogic`` for custom behavior.