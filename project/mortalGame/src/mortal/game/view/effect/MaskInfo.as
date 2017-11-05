package mortal.game.view.effect
{
	import flash.geom.Point;

	public class MaskInfo
	{
		public static const Shape_Rect:int = 1;//矩形
		public static const Shape_Cycle:int = 2;//圆形
		
		public var shape:int = 1;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		
		public function MaskInfo()
		{
		}
		
		public function set globalPoint(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
	}
}