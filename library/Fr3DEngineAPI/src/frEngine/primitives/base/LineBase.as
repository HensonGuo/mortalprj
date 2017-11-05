package frEngine.primitives.base
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;
	
	import frEngine.animateControler.DrawShapeControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.shader.ShaderBase;
	
	public class LineBase extends Mesh3D
	{
		protected var drawInstance:DrawShapeControler;
		public function LineBase(meshName:String, useColorAnimate:Boolean, $renderList:RenderList)
		{
			super(meshName, useColorAnimate, $renderList);
			drawInstance = this.getAnimateControlerInstance(AnimateControlerType.DrawShapeControler) as DrawShapeControler;
		}
		public override function dispose(isReuse:Boolean=true):void
		{
			drawInstance=null;
			super.dispose(isReuse);
		}
		public override function draw(_arg1:Boolean=true, _arg2:ShaderBase=null):void
		{
			if(this.visible)
			{
				Device3D.worldView.copyFrom(this.world);
				Device3D.worldView.append(Device3D.view);
			}
			
			super.draw(_arg1,_arg2);
		}
	}
}