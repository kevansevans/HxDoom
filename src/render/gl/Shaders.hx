package render.gl;

import render.gl.enums.Automap;

/**
 * ...
 * @author Kaelan
 */

//We'll use implicit string casts to make this easier outside of this class.
class Shaders 
{
	public static var automapVertext:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'attribute vec3 V3_POSITION;',
	'attribute vec3 V3_COLOR;',
	'varying vec3 F_COLOR;',
	'uniform mat4 M4_POSITION;',
	'',
	'void main()',
	'{',
	'	F_COLOR = V3_COLOR;',
	'	gl_Position = M4_POSITION * vec4(V3_POSITION, 1.0);',
	'}'
	].join('\n');
	
	public static var automapFragment:String = [
	#if !desktop
	'precision mediump float;',
	#end
	'varying vec3 F_COLOR;',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = vec4(F_COLOR, 1.0);',
	'}'
	].join('\n');
}