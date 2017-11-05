package mortal.game.model
{
	import flash.geom.Point;
	
	import mortal.game.scene3D.map3D.AStarPoint;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.map3D.SceneRange;

	public class GuidePathInfo
	{
		public var dir:int;
		private var _point:AStarPoint;
		private var _goemPoint:Point;
		private var _pixPoint:Point;
		private var _id:String = "";
		private var _inScene:Boolean;
		
		public function GuidePathInfo()
		{
			_goemPoint = new Point();
			_pixPoint = new Point();
		}
		
		public function set point(p:AStarPoint):void
		{
			_point = p;
			_goemPoint.x = _point.x;
			_goemPoint.y = _point.y;
			_pixPoint = GameMapUtil.getPixelPoint(_point.x,point.y);
			_id = MapFileUtil.mapID + "_" + pixx + "_" + pixy;
		}
		
		public function get point():AStarPoint
		{
			return _point;
		}
		
		public function get goemPoint():Point
		{
			return _goemPoint;
		}
		
		public function get x():int
		{
			if(point)
			{
				return point.x;
			}
			return 0;
		}
		
		public function get y():int
		{
			if(point)
			{
				return point.y;
			}
			return 0;
		}
		
		public function get pixx():int
		{
			return _pixPoint.x;
		}
		
		public function get pixy():int
		{
			return _pixPoint.y;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function checkInScene():Boolean
		{
			_inScene = SceneRange.isInScene(pixx,pixy);
			return _inScene;
		}
		
		public function get inScene():Boolean
		{
			return _inScene;
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			_inScene = false;
		}
	}
}