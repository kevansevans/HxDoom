package hxdoom.core;

import haxe.ds.Vector;
import hxdoom.core.Reader;
import hxdoom.lumps.Directory;
import hxdoom.lumps.graphic.Flat;
import hxdoom.lumps.graphic.Playpal;
import hxdoom.lumps.graphic.Patch;
import hxdoom.component.Texture;
import hxdoom.typedefs.graphics.TextureData;
import hxdoom.typedefs.graphics.PatchLayout;

/**
 * ...
 * @author Kaelan
 */
class TextureCore 
{
	public var playpal:Playpal;
	public var patches:Array<String>;
	public var textureData:Map<String, TextureData>;
	public var textures:Map<String, Texture>;
	
	public function new() 
	{
		
	}
	public function loadPlaypal() {
		
		playpal = Playpal.CONSTRUCTOR([]);
		
		var directory = Engine.WADDATA.getDirectory("PLAYPAL");
		var bytes = Engine.WADDATA.getWadByteArray(directory.wad);
		
		var numPals:Int = Std.int(directory.size / 768);
		var offset:Int = 0;
		
		for (pal in 0...numPals) {
			for (sw in 0...256) {
				
				var red:Int = Reader.getOneByte(bytes, directory.dataOffset + offset);
				var green:Int = Reader.getOneByte(bytes, directory.dataOffset + (offset += 1));
				var blue:Int = Reader.getOneByte(bytes, directory.dataOffset + (offset += 1));
				
				var _color:Int = (red << 16) | (green << 8) | blue;
				
				playpal.addSwatch(pal, _color);
				
				offset += 1;
			}
		}
	}
	public function parsePatchNames() {
		
		var pname_dir:Directory = Engine.WADDATA.getDirectory("PNAMES");
		var data = Engine.WADDATA.getWadByteArray(pname_dir.wad);
		
		patches = Reader.readPatchNames(data, pname_dir.dataOffset).names;
		
	}
	
	public function parseTextures() {
		
		textureData = new Map();
		textures = new Map();
		
		var textureLumpCount:Int = 1;
		
		while (Engine.WADDATA.wadContains(["TEXTURE" + textureLumpCount])) {
			
			var directory = Engine.WADDATA.getDirectory("TEXTURE" + textureLumpCount);
			var wad_bytes = Engine.WADDATA.getWadByteArray(directory.wad);
			
			var t_data = Reader.readTextureInfo(wad_bytes, directory.dataOffset);
			
			for (tex in t_data.textures) {
				textureData[tex.textureName] = tex;
			}
			
			++textureLumpCount;
		}
	}
	
	public function buildTextures() {
		for (tex in textureData) {
			textures[tex.textureName] = Texture.CONSTRUCTOR([tex]);
		}
	}
	
	public function getTexture(_name:String):Texture {
		if (textures[_name.toUpperCase()] != null) return textures[_name.toUpperCase()];
		else {
			var text = Texture.CONSTRUCTOR([textureData[_name.toUpperCase()]]);
			textures[_name.toUpperCase()] = text;
			return text;
		}
	}
	
	public function getPatch(_patchName:String):Patch {
		
		if (Engine.WADDATA.wadContains([_patchName]) == true) {
			
			var directory = Engine.WADDATA.getDirectory(_patchName);
			var wad_data = Engine.WADDATA.getWadByteArray(directory.wad);
			
			return Reader.readPatch(wad_data, directory.dataOffset);
		}
		var patch = Patch.CONSTRUCTOR([16, 16, 16, 16]);
		for (a in 0...16) {
			patch.pixels[a] = new Vector(16);
			for (b in 0...16) {
				patch.pixels[a][b] = Std.int(Math.min(a * b, 255));
			}
		}
		return patch;
	}
	public function getFlat(_flatName:String):Flat {
		var directory = Engine.WADDATA.getDirectory(_flatName);
		var wad_data = Engine.WADDATA.getWadByteArray(directory.wad);
		
		return Reader.readFlat(wad_data, directory.dataOffset);
	}
}