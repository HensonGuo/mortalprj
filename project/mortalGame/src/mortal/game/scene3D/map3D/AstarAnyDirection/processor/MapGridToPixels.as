/**
 * 2013-12-12
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.Vector2f;
	import mortal.game.scene3D.map3D.util.GameMapUtil;

	public class MapGridToPixels
	{
		public function MapGridToPixels()
		{
		}
		
		private static const SERVERDISTANCE:Number = 60;
		private static const SERVERMAXDISTANCE:Number = 80;
		
		public static function work(arr:Array):Array
		{
			var res:Array = [];
			var len:int = arr.length;
			var cur:AstarTurnPoint;
			var next:AstarTurnPoint;
			var distance:Number;
			var real:AstarTurnPoint;
			var realX:int;
			var realY:int;
			var value:int;
			
			for(var i:int = 0; i < len; i++)
			{
				cur = arr[i];
				cur._x = (cur._x + 0.5) * GameMapUtil.tileWidth;
				cur._y = (cur._y + 0.5) * GameMapUtil.tileHeight;
			}
			
			for(i = 0; i < len; i++)
			{
				cur = arr[i];
				if(i != len - 1)
				{
					next = arr[i + 1];
				}
				else
				{
					real = new AstarTurnPoint();
					real._x = cur._x;
					real._y = cur._y;
					real.distance = cur.distance;
					res.push(real);
					
					continue;
				}
				distance = GeomUtil.calcDistance(cur._x, cur._y, next._x, next._y);
				
				// 先加入本点
				real = new AstarTurnPoint();
				real._x = cur._x;
				real._y = cur._y;
				real.distance = cur.distance;
				
				res.push(real);
				if(distance < SERVERMAXDISTANCE)
				{
					
					continue;
				}
				
				var dy:Number = next._y - cur._y;
				var dx:Number = next._x - cur._x;
				var rate:Number;
				var num:int = int((distance -SERVERMAXDISTANCE)/SERVERDISTANCE) + 1;
				
				// 加入中间点
				for(var j:int = 1; j <= num; j++)
				{
					rate = j*SERVERDISTANCE/distance;
					real = new AstarTurnPoint();
					real._x = rate * dx + cur._x;
					real._y = rate * dy + cur._y;
					real.distance = cur.distance + distance*rate;
					
					res.push(real);
				}
			}
			
			
			// 检查角色所在的位置、第二个点组成的直线经过的格子都可走, 假如不可走，
			//那么取这条直线上、并且在第一个点所在的格子的一个点， 作为第一个点 
			if(!lineWalkable(res[0] as AstarTurnPoint, res[1] as AstarTurnPoint))
			{
				fixFirstPoint(res); // 纠正第一个格子点
			}
			else
			{
				res.shift(); // 删除第一个点（走路实现，会先走到当前坐标点的以代替这里的第一个格子点）
			}
			
			return res;
		}
		
		/**
		 * p1->p2 组成的线段，经过的格子是否全部可走
		 * @param arr
		 * 
		 */		
		private static function lineWalkable(p1:AstarTurnPoint, p2:AstarTurnPoint):Boolean
		{
			var grids:Vector.<int> = GeomUtil.calcLinePassGridesFastMidle(p1._x, p1._y, p2._x, p2._y);
			for(var i:int = 0; i < grids.length; i += 2)
			{
				var xx:int = int(grids[i])/GameMapUtil.tileWidth;
				var yy:int = int(grids[i+1])/GameMapUtil.tileHeight;
				var value:int = AstarAnyDirection.mapData[xx][yy];
				if(!MapGridCutter.walkable(value))
				{
					return false;
				}
			}
			return true;
		}
		
		private static function fixFirstPoint(res:Array):void
		{
			// 第一个点重新取值为第一、第二个点的中心点，且仍然在第一个点所在的格子
			var p1:AstarTurnPoint = res[0];
			var p2:AstarTurnPoint = res[1];
			var dy:Number = p2._y - p1._y;
			var dx:Number = p2._x - p1._x;
			
			if(dx == 0)
			{
				if(dy != 0)
				{
					p1._y = (int(p1._y / GameMapUtil.tileHeight)) * GameMapUtil.tileHeight 
						+ ((dy)/Math.abs(dy)) * (GameMapUtil.tileHeight - 2);
				}
			}
			else
			{
				var rate:Number = Math.abs(dy/dx);
				if(rate > (GameMapUtil.tileHeight/GameMapUtil.tileWidth))
				{
					rate = Math.abs(0.4*GameMapUtil.tileHeight/dy);
				}
				else
				{
					rate = Math.abs(0.4*GameMapUtil.tileWidth/dx);
				}
				p1._x += dx * rate;
				p1._y += dy * rate;
			}
		}
	}
}