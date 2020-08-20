package hxdoom.lumps.map;
import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Node extends LumpBase
{
	public static var CONSTRUCTOR:(Array<Any>) -> Node = Node.new;
	
	public static inline var BYTE_SIZE:Int = 28;
	public static var SUBSECTORIDENTIFIER:Int = 0x8000;
	
	public var xPartition:Int;
	public var yPartition:Int;
	public var changeXPartition:Int;
	public var changeYPartition:Int;
	
	public var frontBoxTop:Int;
	public var frontBoxBottom:Int;
	public var frontBoxLeft:Int;
	public var frontBoxRight:Int;
	
	public var backBoxTop:Int;
	public var backBoxBottom:Int;
	public var backBoxLeft:Int;
	public var backBoxRight:Int;
	
	public var frontChildID:Int;
	public var backChildID:Int;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		xPartition = 			_args[0];
		yPartition = 			_args[1];
		changeXPartition = 		_args[2];
		changeYPartition = 		_args[3];
		
		frontBoxTop = 			_args[4];
		frontBoxBottom = 		_args[5];
		frontBoxLeft = 			_args[6];
		frontBoxRight = 		_args[7];
		
		backBoxTop = 			_args[8]; 		//Sam, be careful with your order. You'll be travelling through the heart of BT territory
		backBoxBottom = 		_args[9];		//Sam, your BB is nothing more than a tool. Don't get attached to it.
		backBoxLeft = 			_args[10];		//I was so naive when I made this comment, go play Death Stranding
		backBoxRight = 			_args[11];
		
		frontChildID = 			_args[12];
		backChildID = 			_args[13];
	}
	
	public function toString():String
	{
		return(
			['XY Partition: {' + xPartition + ", " + yPartition + '}, ',
			'Change Partition: {' + changeXPartition + ", " + changeYPartition + '}, ',
			'Front Box: { Top: ' + frontBoxTop + ', Bottom: ' + frontBoxBottom + ', Left: ' + frontBoxLeft + ', Right: ' + frontBoxRight + '}, ',
			'Back Box: { Top: ' + backBoxTop + ', Bottom: ' + backBoxBottom + ', Left: ' + backBoxLeft + ', Right: ' + backBoxRight + '}, ',
			'Children IDs: { Front: ' + frontChildID + ', Back: ' + backChildID + '}'
			].join("")
		);
	}
}