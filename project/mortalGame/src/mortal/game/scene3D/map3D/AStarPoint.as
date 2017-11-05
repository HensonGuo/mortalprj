package mortal.game.scene3D.map3D
{
	import Message.Public.SPoint;
	
	import com.gengine.utils.pools.ObjectPool;

	/**
	 * A*寻路结果的点
	 * @author huangliang
	 */
	public class AStarPoint extends SPoint
	{
//		public var x:int;
//		public var y:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
//		public var walkable:Boolean=true;
		public var parent:AStarPoint;
		public var value:int;
		//public var costMultiplier:Number = 1.0;
		public var version:int=1;
		public var links:Array;
		
		//public var index:int;
		public function AStarPoint(x:int = 0, y:int = 0,value:int = -1)
		{
			this.x=x;
			this.y=y;
			this.value = value;
		}
		
		public function get walkable():Boolean
		{
			return AStar.walkable(value);
		}
		
//		/**
//		 * 地形数据 
//		 */		
//		public var value:int;
//		/**
//		 * 
//		 * @param x
//		 * @param y
//		 */
//		public function AStarPoint(x:Number=0, y:Number=0)
//		{
//			this.x = x;
//			this.y = y;
//		}
		
		public function toString():String
		{
			return this.x+":"+this.y;
		}
		
		public function dispose():void
		{
			parent = null;
			if(links &&　links.length)
			{
				for(var i:int = 0;i<links.length;i++)
				{
					(links[i] as Object).dispose();
				}
			}
			links = null;
//			value = -1;
//			version = 1;
//			f = 0;
//			g = 0;
//			h = 0;
//			ObjectPool.disposeObject(this);
		}
	}
}