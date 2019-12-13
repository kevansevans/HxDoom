package;

import haxe.PosInfos;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GL;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.graphics.opengl.GLProgram;
import lime.utils.Float32Array;


class Main extends Application {
	
	public function new () {
		
		super ();
	}
	
	var vertShader:String = [
	'precision mediump float;',
	'attribute vec2 vertPosition;',
	'attribute vec3 vertColor;',
	'varying vec3 fragColor;',
	'',
	'void main()',
	'{',
	'	fragColor = vertColor;',
	'	gl_Position = vec4(vertPosition, 0.0, 1.0);',
	'}'
	].join('\n');
	
	var fragShader:String = [
	'precision mediump float;',
	'varying vec3 fragColor;',
	'',
	'void main()',
	'{',
	' 	gl_FragColor = vec4(fragColor, 1.0);',
	'}'
	].join('\n');
	var gl:WebGLRenderContext;
	var program:GLProgram;
	public override function render (context:RenderContext):Void {
		switch (context.type) {
			
			case OPENGL, OPENGLES, WEBGL:
				
				if (gl == null) {
					gl = context.webgl;
				
					var vShader = gl.createShader(gl.VERTEX_SHADER);
					var fShader = gl.createShader(gl.FRAGMENT_SHADER);
				
					gl.shaderSource(vShader, vertShader);
					gl.shaderSource(fShader, fragShader);
				
					gl.compileShader(vShader);
					gl.compileShader(fShader);
				
					program = gl.createProgram();
					gl.attachShader(program, vShader);
					gl.attachShader(program, fShader);
					gl.linkProgram(program);
				}
				
				gl.clearColor (0, 0, 0, 1);
				gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
					
					var triVerts =
					[
						0.0, 0.5,		1, 0, 0,
						-0.5, -0.5,		0, 1, 0,
						0.5, -0.5,		0, 0, 1,
					];
				
					var triVertBuffer = gl.createBuffer();
					gl.bindBuffer(gl.ARRAY_BUFFER, triVertBuffer);
					gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(triVerts), gl.STATIC_DRAW);
				
					var posAttributeLocation = gl.getAttribLocation(program, 'vertPosition');
					var colorAttributeLocation = gl.getAttribLocation(program, 'vertColor');
					gl.vertexAttribPointer(
						posAttributeLocation,
						2,
						gl.FLOAT,
						false,
						5 * Float32Array.BYTES_PER_ELEMENT,
						0
					);
					gl.vertexAttribPointer(
						colorAttributeLocation,
						3,
						gl.FLOAT,
						false,
						5 * Float32Array.BYTES_PER_ELEMENT,
						2 * Float32Array.BYTES_PER_ELEMENT
					);
					gl.enableVertexAttribArray(posAttributeLocation);
					gl.enableVertexAttribArray(colorAttributeLocation);
				
				gl.useProgram(program);
				gl.drawArrays(gl.TRIANGLES, 0, 3);
			default:
				
				throw "Render context not supported by choice";
			
		}
		
	}
	
	public static function main () {
		
		var app = new Main ();
		return app.exec ();
		
	}
	
	
}