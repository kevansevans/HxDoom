package citrus.render.limeGL;

import hxdoom.core.RenderCore;
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLProgram;
import lime.math.Matrix4;
import lime.math.Vector4;
import lime.ui.Window;
import lime.utils.Float32Array;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLShader;
import citrus.render.limeGL.programs.GLMapGeometry;

import citrus.render.limeGL.programs.GLAutoMap;

import hxdoom.Engine;
import hxdoom.common.Environment;

/**
 * ...
 * @author Kaelan
 * 
 */
class GLHandler extends RenderCore
{
	var gl:WebGLRenderContext;
	var context:RenderContext;
	var window:Window;
	
	var programAutoMap:GLAutoMap;
	public var programMapGeometry:GLMapGeometry;
	
	public function new(_context:RenderContext, _window:Window) 
	{
		super();
		
		gl = _context.webgl;
		window = _window;
		context = _context;
		
		programAutoMap = new GLAutoMap(gl);
		programMapGeometry = new GLMapGeometry(gl);
		
		resize(window.width, window.height);
	}
	
	override public function resize(_width:Int, _height:Int) {
		gl.viewport(0, 0, _width, _height);
		screen_width = window.width;
	}
	
	override public function initScene() 
	{
		super.initScene();
		
		programMapGeometry.buildMapGeometry();
	}
	
	override public function render_scene() {
		
		
		//remove color buffer bit to allow HOM effect.
		gl.clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
		
		#if js
		resize(window.width, window.height);
		#end
		
		if (CVarCore.getCvar(EnvName.AUTOMAP_MODE)) {
			
			gl.clearColor (0x6c / 255, 0x54 / 255, 0x40 / 255, 1);
			programAutoMap.render(window.width, window.height);
			
		} else {
			
			gl.clearColor (0, 0, 0, 1);
			
			//depth buffer
			gl.enable(gl.DEPTH_TEST);
			gl.depthFunc(gl.LESS);
			
			//enable translucency
			gl.enable(gl.BLEND);
			gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
			
			//backface culling
			gl.enable(gl.CULL_FACE);
			gl.cullFace(gl.BACK);
			
			programMapGeometry.render(window.width, window.height);
			
			//disable for stability (?)
			gl.disable(gl.CULL_FACE);
			gl.disable(gl.BLEND);
			gl.disable(gl.DEPTH_TEST);
			
		}
	}
}