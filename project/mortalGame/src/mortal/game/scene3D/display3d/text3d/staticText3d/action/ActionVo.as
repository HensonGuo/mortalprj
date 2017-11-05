package mortal.game.scene3D.display3d.text3d.staticText3d.action
{
	public class ActionVo
	{
		public var type:int=0;
		public var start2d_x:Number;
		public var start2d_y:Number;
		public var end2d_x:Number;
		public var end2d_y:Number;

		private static const R:int=50;
		public function reInit($type:int,$start2d_x:Number,$start2d_y:Number,$end2d_x:Number,$end2d_y:Number):void
		{
			type=$type;
			start2d_x=$start2d_x;
			start2d_y=$start2d_y;
			end2d_x=$end2d_x+(Math.random()-0.5)*R;
			end2d_y=$end2d_y+(Math.random()-0.5)*R;
		}
	}
}