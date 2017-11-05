/**
 * 2010-1-22
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;

	public class MapGridTurnPointFixer
	{
		public function MapGridTurnPointFixer()
		{
		}
		
		public static function fix(data:Array, v:Array, walkableMinValue:int, insertDistance:int=10, maxVisibleDistance:int=80):Array
		{
			//			trace("..........................................................................................:" + v.length.toString());
			// 先预处理， 两点的距离超过insertDistance的插入新的点
			v = preFix(v, insertDistance);
			//			return v;
			//			trace("..........................................................................................:" + v.length.toString());
			// d[i]代表到第i点的最短距离
			var len:int = v.length;
			var i:int;
			var j:int;
			var cur:AstarTurnPoint;
			var parent:AstarTurnPoint;
			
			// 初始化距离
			for(i = 1; i < len; i++)
			{
				cur = v[i];
				cur.distance = Number.MAX_VALUE;
			}
			cur = v[0];
			cur.distance = 0;
			
			var sRow:int;
			var sCol:int;
			var eRow:int;
			var eCol:int;
			var dx:int;
			var dy:int;
			var distance:Number;
			
			for(i = 0; i < len - 1; i++)
			{
				parent = v[i]
				sRow = parent._y;
				sCol = parent._x;
				for(j = i + 1; j < len; j++)
				{
					cur = v[j];
					eRow = cur._y;
					eCol = cur._x;
					if(Math.abs(eRow - sRow) + Math.abs(eCol - sCol) > maxVisibleDistance)// 超过可见距离
					{
						break;
					}
					
					var grides:Vector.<int> = GeomUtil.calcLinePassGridesFastMidle(sRow, sCol, eRow, eCol);
					var k:int = 0;
					var lenx:int = grides.length;
					var value:int;
					var isVisible:Boolean = true;
					
					if(j != i + 1)
					{
						for(k = 0; k < lenx-1; k += 2)
						{
							var x:int = grides[k];
							var y:int = grides[k + 1];
							if(data[x] == null)
							{
								isVisible = false;
								break;
							}
							value = data[x][y];
							if(value >= 0)
							{
								if(value < walkableMinValue)
								{
									isVisible = false;
									break;
								}
							}
						}
					}
					
					if(isVisible)//isLineVisible(sRow, sCol, eRow, eCol, data, walkableMinValue))
					{
						dx = eCol - sCol;
						dy = eRow - sRow;
						distance = Math.sqrt(dx*dx + dy*dy);
						if(parent.distance + distance < cur.distance)
						{
							cur.distance = parent.distance + distance;
							cur.parent = parent;
						}
					}
				}
			}
			
			// guild path
			var res:Array = [];
			cur = v[len-1];
			while(cur!= null)
			{
				res.unshift(cur);
				cur = cur.parent;
			}
			return res;
		}
		
		private static function preFix(v:Array, splitDistance:int=20):Array
		{
			var res:Array = [];
			var len:int = v.length;
			var i:int;
			var j:int;
			var dx:Number;
			var dy:Number;
			var cur:AstarTurnPoint;
			var next:AstarTurnPoint;
			var d:Number;
			var num:int;
			for(i = 0; i < v.length - 1; i++)
			{
				cur = v[i];
				res.push(cur);
				next = v[i+1];
				d = GeomUtil.calcDistance2(cur, next);
				num = int(d/splitDistance);
				if(num < 1)
				{
					continue;
				}
				num++;
				// 平均分num份
				dx = (next._x - cur._x)/num;
				dy = (next._y - cur._y)/num;
				for(j = 1; j < num; j++)
				{
					var p:AstarTurnPoint = new AstarTurnPoint();
					p._x = int(cur._x + dx*j);
					p._y = int(cur._y + dy*j);
					res.push(p);
				}
			}
			if(next != null)
			{
				res.push(next);
			}
			return res;
		}
		
		public static function isLineVisible(sRow:int, sCol:int, eRow:int, eCol:int, data:Array, walkableMinValue:int):Boolean
		{
			var grides:Vector.<int> = GeomUtil.calcLinePassGridesFastMidle(sRow, sCol, eRow, eCol);
			var i:int = 0;
			var len:int = grides.length;
			var value:int;
			for(i = 0; i < len; i += 2)
			{
				var x:int = grides[i];
				var y:int = grides[i + 1];
				value = data[x][y];
				if(value >= 0)
				{
					if(value < walkableMinValue)
					{
						return false;
					}
				}
			}
			return  true;
		}
	}
}