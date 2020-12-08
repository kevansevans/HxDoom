package hxdoom.lumps.map;
import hxdoom.lumps.map.LineDef;

/**
 * ...
 * @author Kaelan
 */
class LineDefHexen extends LineDef 
{
	public static inline var BYTE_SIZE:Int = 16;
	
	public static var CONSTRUCTOR:(Array<Any>) -> LineDefHexen = LineDefHexen.new;
	
	public var arg_1:Int;
	public var arg_2:Int;
	public var arg_3:Int;
	public var arg_4:Int;
	public var arg_5:Int;
	
	public function new(_args:Array<Any>) 
	{
		super([_args[0], _args[1], _args[2], _args[3], 0, _args[9], _args[10]]);
		
		if (override_new) return;
		
		arg_1 = _args[4];
		arg_2 = _args[5];
		arg_3 = _args[6];
		arg_4 = _args[7];
		arg_5 = _args[8];
		
	}
	
	override public function copy():LineDefHexen
	{
		var lineDefHexen = LineDefHexen.CONSTRUCTOR([
			startVertexID,
			endVertexID,
			flags,
			lineType,
			0,
			frontSideDefID,
			backSideDefID
		]);
		return lineDefHexen;
	}
	
}