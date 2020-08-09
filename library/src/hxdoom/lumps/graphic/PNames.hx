package hxdoom.lumps.graphic;

/**
 * ...
 * @author Kaelan
 */
class PNames 
{
	public var names:Array<String>;
	public function new() 
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
	public function toString():String {
		var str:String = "";
		for (name in names) {
			str += name + "\n";
		}
		return str;
	}
}