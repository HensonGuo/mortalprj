package mortal.game.scene3D.layer3D
{
	import flash.geom.Rectangle;
	
	import baseEngine.basic.RenderList;
	
	import frEngine.primitives.FrQuad;
	
	public class BottomQuad extends FrQuad
	{
		public function BottomQuad(_arg1:String="quad", $x:Number=0, $y:Number=0, $width:Number=100, $height:Number=100, isFullScreenMode:Boolean=false, material:*=null, $renderList:RenderList=null)
		{
			super(_arg1, $x, $y, $width, $height, isFullScreenMode, material, $renderList);
			_sceneRect=new Rectangle(0,0,1024,1024);

		}
		public override function set sceneRect(value:Rectangle):void
		{
			
		}
	}
}