package hxdoom.typedefs.internal;

/**
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