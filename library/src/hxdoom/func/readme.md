This part of the source will contain the more 1:1 port of Doom's source that need to be "haxe-ified". More or less, this is for code that hasn't been adapted into HxDoom's goal of making it a building block one could use, although this is probably the next best approach.

The code here will still abide to HxDoom's goal of dependency injection, all functions will be declared as ``var func:Void -> void = function() {}`` or similar, allowing their behaviors to be replaced and modified.

Other parts of the source need to adapt to this style as well.