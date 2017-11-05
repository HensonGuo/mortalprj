package frEngine.render
{
	import baseEngine.core.Mesh3D;
	
	import frEngine.shader.ShaderBase;

	public interface IRender
	{
		function draw(mesh:Mesh3D, material:ShaderBase=null):void;
		function drawDepth(mesh:Mesh3D,objectColor:Number=0, $alpha:Number=1):void;
		function drawEdge(mesh:Mesh3D,edgeColor:Number=0xffffff):void;
		function completeDraw(mesh:Mesh3D):void;
	}
}