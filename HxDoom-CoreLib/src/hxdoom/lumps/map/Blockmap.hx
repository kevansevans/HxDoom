package hxdoom.lumps.map;

import haxe.ds.Vector;

import hxdoom.lumps.LumpBase;

/**
 * ...
 * @author Kaelan
 */
class Blockmap extends LumpBase 
{
	public static var CONSTRUCTOR:(Array<Any>) -> Blockmap = Blockmap.new;
	
	public var originX:Int;
	public var originY:Int;
	
	public var numColumns:Int;
	public var numRows:Int;
	
	public var indexedBlocks:Vector<Array<Int>>;
	
	public var blocks:Vector<Array<LineDef>>;
	
	public function new(_args:Array<Any>) 
	{
		super();
		
		originX = _args[0];
		originY = _args[1];
		numColumns = _args[2];
		numRows = _args[3];
		indexedBlocks = _args[4];
		
	}
	
	public function linkLines() {
		
		blocks = new Vector(indexedBlocks.length);
		
		for (block in 0...indexedBlocks.length) {
			if (blocks[block] == null) blocks[block] = new Array();
			
			for (index in indexedBlocks[block]) {
				blocks[block].push(Engine.LEVELS.currentMap.linedefs[index]);
			}
		}
	}
	
}