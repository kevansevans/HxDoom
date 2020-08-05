Requires Lovr https://lovr.org/
	
When compiled, place your Doom wad within /bin/lua, then drag the Lua folder on top of the Lovr executable. VR headset is not required.

As of Haxe 4.1.3, the -D lua_vanilla flag is not working correctly and will still generate required libs when compiling this project. Once compiled, go into Main.lua and comment out whever "luv" is defined as a required lib. (typically around line 240 - 250 with this code)