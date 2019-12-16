package render.gl;

import render.gl.enums.Automap;

/**
 * ...
 * @author Kaelan
 */

//We'll use implicit string casts to make this easier outside of this class.
enum abstract Automap(String) from String {
	var V3_POSITION:String;
	var V3_COLOR:String;
	var F_COLOR:String;
}
class Shaders 
{
	public static var automapVertext:String = [
	'precision mediump float;',
	'attribute vec2 ' + Automap.V3_POSITION + ';',
	'attribute vec3 ' + Automap.V3_COLOR + ';',
	'varying vec3 ' + Automap.F_COLOR + ';',
	'',
	'void main()',
	'{',
	'	' + Automap.F_COLOR + ' = ' + Automap.V3_COLOR + ';',
	'	gl_Position = vec4(' + Automap.V3_POSITION + ', 0.0, 1.0);',
	'}'
	].join('\n');
	
	public static var automapFragment:String = [
	'precision mediump float;',
	'varying vec3 ' + Automap.F_COLOR + ';',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = vec4(' + Automap.F_COLOR + ', 1.0);',
	'}'
	].join('\n');
}