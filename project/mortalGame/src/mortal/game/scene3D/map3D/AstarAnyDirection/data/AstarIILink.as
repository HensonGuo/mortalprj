/**
 * 2010-1-14
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.data
{
	import flash.geom.Point;
	
	public class AstarIILink
	{
		/**
		 * 连接边 
		 */		
		public var otherNode:AstarIIPoint;
		/**
		 *  与parentLink的公共边
		 */		
		public var minCol:Number;
		public var minRow:Number;
		public var maxCol:Number;
		public var maxRow:Number;
		
		public function AstarIILink()
		{
		}
		
		/**
		 * 设置公共边 
		 * @param v1
		 * @param v2
		 * @param v3
		 * @param v4
		 * 
		 */		
		public function setCommon(v1:Number, v2:Number, v3:Number, v4:Number):void
		{
			if(v4 <= v2)
			{
				minRow = minCol = Math.max(v1, v3);
				maxRow = maxCol = v4;
			}
			else if(v3 <= v2)
			{
				minRow = minCol = Math.max(v1, v3);
				maxRow = maxCol = v2;
			}
		}
		
		public function getLinksDistance(other:AstarIILink):Number
		{
			var dx:int;
			var dy:int;
			var res:Number;
			
			dx = minCol - other.minCol;
			dy = minRow - other.minRow;
			res = dx*dx + dy*dy;
			
			dx = minCol - other.maxCol;
			dy = minRow - other.maxRow;
			res = Math.min(res, dx*dx+dy*dy);
			
			dx = maxCol - other.minCol;
			dy = maxRow - other.minRow;
			res = Math.min(res, dx*dx+dy*dy);
			
			dx = maxCol - other.maxCol;
			dy = maxRow - other.maxRow;
			res += Math.min(res, dx*dx+dy*dy);
			
			return Math.sqrt(res/2);
		}
		
		public function calcDistance(sourceP:Point, endPoint:Point, p1:Point, p2:Point, linkPoint:Point):Number
		{
			p1.x = minCol;p1.y = minRow;
			p2.x = maxCol;p2.y = maxRow;
			if(GeomUtil.calcSegmentsCrossPoint(sourceP, endPoint, p1, p2, linkPoint, false))
			{
				return GeomUtil.calcDistance(sourceP.x, sourceP.y, linkPoint.x, linkPoint.y);
			}
			// p1、p2、中心点分别测试
			var tt1:Number = GeomUtil.calcDistance(sourceP.x, sourceP.y, p1.x, p1.y);
			var tt2:Number = GeomUtil.calcDistance(sourceP.x, sourceP.y, p2.x, p2.y);
			var t1:Number = tt1 + GeomUtil.calcDistance(p1.x, p1.y, endPoint.x, endPoint.y);
			var t2:Number = tt2 + GeomUtil.calcDistance(p2.x, p2.y, endPoint.x, endPoint.y);
			if(t1 < t2)
			{
				linkPoint.x = p1.x;linkPoint.y = p1.y;
				return tt1;
			}
			linkPoint.x = p2.x;
			linkPoint.y = p2.y;
			return tt2;
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			linkPoint.x = (minCol + maxCol)*0.5;
			linkPoint.y = (minRow + maxRow)*0.5;
			var dx:Number = linkPoint.x - sourceP.x;
			var dy:Number = linkPoint.y - sourceP.y;
			return Math.sqrt(dx*dx + dy*dy);
			//
			if(sourceP.x >= minCol && sourceP.x < maxCol)
			{
				linkPoint.x = sourceP.x;
				linkPoint.y = (minRow + maxRow)/2;
				return Math.abs(linkPoint.y - sourceP.y);
			}
			else if(sourceP.y >= minRow && sourceP.y < maxRow)
			{
				linkPoint.x = (minCol + maxCol)/2;
				linkPoint.y = sourceP.y;
				return Math.abs(linkPoint.x - sourceP.x);
			}
			else
			{
				var d1:Number = GeomUtil.calcDistance(sourceP.x, sourceP.y, minCol, minRow);
				var d2:Number = GeomUtil.calcDistance(sourceP.x, sourceP.y, maxCol, maxRow);
				if(d1 < d2)
				{
					linkPoint.x = minCol;
					linkPoint.y = minRow;
					return d1;
				}
				linkPoint.x = maxCol;
				linkPoint.y = maxRow;
				return d2;
			}
			return 0;
		}
	}
}