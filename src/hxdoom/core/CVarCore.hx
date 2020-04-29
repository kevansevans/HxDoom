package hxdoom.core;

/**
 * ...
 * @author Kaelan
 */
typedef CVar = {
	var name : String;
	var type : CVarType;
	var value : Any;
	@:optional var onSet : Void -> Void;
}

enum CVarType {
	CInt;
	CFloat;
	CString;
	CBool;
}
 
class CVarCore
{
	static var CVarMap:Map<String, CVar> = new Map();
	
	public function new() 
	{
		
	}
	
	public static inline function setNewCVar(_name:String, _type:CVarType, _value:Any, ?_onSet:Void -> Void) {
		CVarMap[_name] = {
			name : _name,
			type : _type,
			value : _value,
			onSet : _onSet
		}
	}
	public static function setCVar(_name:String, _value:Any) {
		if (CVarMap[_name] == null) Engine.log('Set error: CVar Namespace "$_name" does not exist');
		else {
			switch (CVarMap[_name].type) {
				case CInt :
					if (Std.is(_value, Int)) CVarMap[_name].value = _value;
					else if (Std.is(_value, Float)) CVarMap[_name].value = Std.int(_value);
					else if (Std.is(_value, String)) {
						if (Std.parseInt(_value) == null) Engine.log('Set error: CVar Namespace "$_name" expects an Integer');
						else CVarMap[_name].value = Std.parseInt(_value);
					}
					else if (Std.is(_value, Bool)) Engine.log('Set error: CVar Namespace "$_name" expects an Integer');
				case CFloat :
					if (Std.is(_value, Int) || Std.is(_value, Float)) CVarMap[_name].value = _value;
					else if (Std.is(_value, String)) {
						if (Math.isNaN(Std.parseFloat(_value))) Engine.log('Set error: CVar Namespace "$_name" expects a Float');
						else CVarMap[_name].value = Std.parseFloat(_value);
					}
					else if (Std.is(_value, Bool)) Engine.log('Set error: CVar Namespace "$_name" expects a Float');
				case CBool :
					if (!Std.is(_value, Bool)) Engine.log('Set error: CVar Namespace "$_name" expects a Boolean');
					else CVarMap[_name].value = _value;
				case CString :
					CVarMap[_name].value = "" + _value;
			}
			if (CVarMap[_name].onSet != null) CVarMap[_name].onSet();
		}
	}
	public static function getCvar(_name:String):Dynamic {
		if (CVarMap[_name] == null) {
			Engine.log('Get error: CVar Namespace "$_name" does not exist');
			return null;
		} else {
			switch (CVarMap[_name].type) {
				case CInt :
					if (!Std.is(CVarMap[_name].value, Int)) {
						return 0;
					} else {
						return CVarMap[_name].value;
					}
				case CFloat :
					if (!Std.is(CVarMap[_name].value, Float)) {
						return 0;
					} else {
						return CVarMap[_name].value;
					}
				case CString :
					if (!Std.is(CVarMap[_name].value, String)) {
						return "";
					} else {
						return CVarMap[_name].value;
					}
				case CBool :
					if (!Std.is(CVarMap[_name].value, Bool)) {
						return false;
					} else {
						return CVarMap[_name].value;
					}
				default :
					return null;
			}
		}
	}
}