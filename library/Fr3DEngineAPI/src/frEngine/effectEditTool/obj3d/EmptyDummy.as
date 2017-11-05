package frEngine.effectEditTool.obj3d
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	
	import frEngine.shader.ShaderBase;
	
	public class EmptyDummy extends Mesh3D
	{
		public function EmptyDummy(meshName:String, useColorAnimate:Boolean, $renderList:RenderList)
		{
			super(meshName, useColorAnimate, $renderList);
		}
		public override function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
		{
			
		}
	}
}