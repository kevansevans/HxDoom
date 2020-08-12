package hxdoom.lumps.graphic;

/**
 * ...
 * @author Kaelan
 */
class PatchNames 
{
	public static var CONSTRUCTOR:(Array<Any>) -> PatchNames = PatchNames.new;
	
	public var names:Array<String>;
	
	public function new(_args:Array<Any>) 
	{
		names = new Array();
	}
	public function addPatchName(_name:String) {
		names.push(_name);
	}
	public function checkPatch(_name:String) {
		if (names.contains(_name)) return true;
		return false;
	}
	public function getPatchName(_index:Int):String {
		return names[_index];
	}
	public function toString():String {
		var str:String = "";
		for (name in names) {
			str += name + "\n";
		}
		return str;
	}
}