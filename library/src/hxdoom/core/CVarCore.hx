package hxdoom.core;

import hxdoom.enums.data.CVarType;

/**
 * Main handler for controlling CVar behavior.
 * @author Kaelan
 */

typedef CVar = {
	var name : String;
	/**
	 * Controls the return behavior when accessing this CVar.
	 */
	var type : hxdoom.enums.data.CVarType;
	var value : Any;
	/**
	 * Function to call if this CVar is changed.
	 */
	@:optional var onSet : Void -> Void;
}

class CVarCore
{
	static var CVarMap:Map<String, CVar> = new Map();
	
	public function new() 
	{
		
	}
	
	/**
	 * Call to set a new CVar. Will not allow replacement of existing CVars.
	 * @param	_name Namespace of CVar
	 * @param	_type What type of data will it be storing, dictates reading and writing behavior
	 * @param	_value Value to set this CVar to
	 * @param	_onSet Function to call when changing the value
	 * @param	_callAfterSet Call this function immedaitely after creating this CVar
	 */
	public static inline function setNewCVar(_name:String, _type:hxdoom.enums.data.CVarType, _value:Any, ?_onSet:Void -> Void, ?_callAfterSet:Bool = false) {
		if (CVarMap[_name] != null) {
			Engine.log('Cvar $_name is already set, use replaceCvar() instead if this is intentional');
			return;
		}
		CVarMap[_name] = {
			name : _name,
			type : _type,
			value : _value,
			onSet : _onSet == null ? doNothingOnSet : _onSet
		}
		if (_onSet != null && _callAfterSet) _onSet();
	}
	/**
	 * To call to replace an existing CVar
	 * @param	_name Namespace of CVar
	 * @param	_type What type of data will it be storing, dictates reading and writing behavior
	 * @param	_value Value to set this CVar to
	 * @param	_onSet Function to call when changing the value
	 * @param	_callAfterSet Call this function immedaitely after creating this CVar
	 */
	public static inline function replaceCvar(_name:String, _type:hxdoom.enums.data.CVarType, _value:Any, ?_onSet:Void -> Void, ?_callAfterSet:Bool = false) {
		CVarMap[_name] = {
			name : _name,
			type : _type,
			value : _value,
			onSet : _onSet == null ? doNothingOnSet : _onSet
		}
		if (_onSet != null && _callAfterSet) _onSet();
	}
	public static function doNothingOnSet() {}
	/**
	 * Change the value of an existing CVar
	 * @param	_name Name of CVar to set
	 * @param	_value Value to set CVar to
	 * @param	_doNotCallFunction When set to true, the CVar's attached funtion will not be called
	 */
	public static function setCVar(_name:String, _value:Any, ?_doNotCallFunction:Bool = false) {
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
			if (CVarMap[_name].onSet != null && !_doNotCallFunction) CVarMap[_name].onSet();
		}
	}
	/**
	 * Gets value of CVar. Type of value returned depends on type of CVar set.
	 * @param	_name Name of CVar needed
	 * @return Int, Float, String, or Bool
	 */
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