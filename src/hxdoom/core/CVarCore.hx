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
		if (CVarMap[_name] == null) Engine.log('Set: CVar Namespace "$_name" does not exist');
		else {
			CVarMap[_name].value = _value;
			if (CVarMap[_name].onSet != null) CVarMap[_name].onSet();
		}
	}
	public static function getCvar(_name:String):Dynamic {
		if (CVarMap[_name] == null) {
			Engine.log('Get: CVar Namespace "$_name" does not exist');
			return null;
		} else {
			switch (CVarMap[_name].type) {
				case CInt :
					if (Type.typeof(CVarMap[_name].value) != Type.ValueType.TInt) {
						return 0;
					} else {
						return CVarMap[_name].value;
					}
				case CFloat :
					if (Type.typeof(CVarMap[_name].value) != Type.ValueType.TFloat) {
						return 0;
					} else {
						return CVarMap[_name].value;
					}
				case CString :
					trace(Type.typeof(CVarMap[_name].value));
					return "";
				case CBool :
					if (Type.typeof(CVarMap[_name].value) != Type.ValueType.TBool) {
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