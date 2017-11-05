package mortal.game.scene3D
{

	import flash.display3D.Context3DProgramType;
	import flash.geom.Rectangle;
	
	import baseEngine.system.Device3D;
	
	import frEngine.core.OrthographicCamera3D;
	import frEngine.shader.registType.base.ConstParamBase;
	
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	
	public class GameCamera extends OrthographicCamera3D
	{
		public var y2d:Number=0;//相机左上角x
		public var x2d:Number=0;//相机左上角y
		private var offset2dy:Number=0;
		private var yHeight:int=1000;
		public var center2dx:int=0;
		public var center2dy:int=0;
		public function GameCamera(_arg1:String="", _arg2:Number=75)
		{
			super(_arg1, _arg2);
			this.zoom=1;
			this.x = 0
			this.y = yHeight;
			this.z= 0;
			this.rotationX = Scene3DUtil.cameraAngle;
		}
		
		public override function set y(value:Number):void
		{
			super.y=value;
			offset2dy=value*Scene3DUtil.cameraAngleCos;
		}
		
		public function setScreenPos(value:Rectangle):void
		{
			x2d = value.x;
			y2d = value.y;
			
			center2dx=value.x+value.width/2;
			center2dy=value.y+value.height/2;
			
			x = Scene3DUtil.change2Dto3DX(center2dx);
			z = Scene3DUtil.change2Dto3DY(center2dy+offset2dy);
			
			var viewPortWH:Vector.<Number>=Device3D.viewPortWH;
			viewPortWH[2]=center2dx;
			viewPortWH[3]=center2dy;
			
			if(scene.context)
			{
				var param:ConstParamBase=Device3D.VcConst1Register2;
				scene.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, param.index, param.value,1);
			}
			
		}
	}
}