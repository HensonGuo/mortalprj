/**
 * 2010-1-20
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;

	public class MapGrideRoundPointChecker
	{
		public function MapGrideRoundPointChecker()
		{
		}
		
		public static function searchFixedByDirectionNum(turnPoints:Array, startIndex:int):int
		{
			// 上，下，左，右
			var arr:Array = [0,0,0,0];
			var p:AstarTurnPoint = turnPoints[startIndex];
			var len:int = turnPoints.length;
			var cur:AstarTurnPoint;
			
			for(var i:int = startIndex + 1; i < len; i++)
			{
				cur = turnPoints[i];
				if(cur._y < p._y)
				{
					arr[0] = 1;
				}
				if(cur._y >= p._y)
				{
					arr[1] = 1;
				}
				if(cur._x < p._x)
				{
					arr[2] = 1;
				}
				if(cur._x >= p._x)
				{
					arr[3] = 1;
				}
				if(arr[0] + arr[1] + arr[2] + arr[3] == 4)
				{
					//					return i-1;
					if(i + 1 < len)
					{
						var next:AstarTurnPoint = turnPoints[i+1];
						if(cur._y < p._y)
						{
							if(cur._y < next._y)
							{
								return i - 1;
							}
						}
						if(cur._y >= p._y)
						{
							if(cur._y > next._y)
							{
								return i - 1;
							}
						}
						if(cur._x < p._x)
						{
							if(cur._x < next._x)
							{
								return i - 1;
							}
						}
						if(cur._x >= p._x)
						{
							if(cur._x > next._x)
							{
								return i - 1;
							}
						}
					}
					//					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 搜索下一个回环点， 回环点就是：走到这一点的这条线路占据了四个方向的任意三个方向，那么这个点就是回环点 
		 * @param turnPoints 
		 * @param startIndex 
		 * @return 返回回环点所在的索引
		 * 
		 */			
		public static function searchFixedByChangeDirection(turnPoints:Array, startIndex:int, maxChangDirectionTimes:int=2, pointsMinDistance:Number = 20):int
		{
			// 上，下，左，右
			var last:AstarTurnPoint = turnPoints[startIndex];
			var len:int = turnPoints.length;
			
			// 上一次方向改变的点
			var lastDirectionTurnPointIndex:int;
			var lastDirection:int = -1; // 1↗，2↙， 3↘，4↖
			var curDirection:int=-1;
			var turnTimes:int = -1;
			
			for(var i:int = startIndex + 1; i < len; i++)
			{
				var cur:AstarTurnPoint = turnPoints[i];
				if(cur._x >= last._x && cur._y <= last._y)
				{
					curDirection = 1;
				}
				else if(cur._x <= last._x && cur._y >= last._y)
				{
					curDirection = 2;
				}
				else if(cur._x > last._x && cur._y > last._y)
				{
					curDirection = 3;
				}
				else 
				{
					curDirection = 4;
				}
				
				if(curDirection != lastDirection)
				{
					if(turnTimes == -1)
					{
						turnTimes++;
						lastDirection = curDirection;
					}
					else if(turnTimes >= maxChangDirectionTimes)
					{
						return lastDirectionTurnPointIndex;
					}
						// 判断距离
					else if(GeomUtil.calcDistance(cur._x, cur._y, last._x, last._y) >= pointsMinDistance)
					{
						turnTimes++;
						lastDirection = curDirection;
						lastDirectionTurnPointIndex = i;
					}
					else
					{
						
					}
				}
				last = cur;
			}
			return -1;
		}
	}
}