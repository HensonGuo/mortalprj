package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import flash.geom.Point;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIILink;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;

	public class MapGridTurnPointMaker
	{
		public function MapGridTurnPointMaker()
		{
		}
		
		private static var count:int = 0;
		public static function work2(lines:Array, startRect:Point, endRect:Point):Array
		{
			// 从初始点生成边
			var P:AstarTurnPoint = new AstarTurnPoint();
			
			P._x = startRect.x;
			P._y = startRect.y;
			
			// 从结束点生成结束边 
			var link:AstarIILink = new AstarIILink();
			link.minCol = endRect.x;
			link.minRow = endRect.y;
			link.maxCol = endRect.x;
			link.maxRow = endRect.y;
			lines.push(link);
			
			link = lines[0];
			var A:AstarTurnPoint = new AstarTurnPoint();
			A.setValue(link.minCol, link.minRow);
			var B:AstarTurnPoint = new AstarTurnPoint();
			B.setValue(link.maxCol, link.maxRow);
			
			var C:AstarTurnPoint = new AstarTurnPoint();
			var D:AstarTurnPoint = new AstarTurnPoint();
			
			
			var obj:Object = {};
			
			for(var i:int = 1; i < lines.length; i++)
			{
				link = lines[i];
				C.setValue(link.minCol, link.minRow);
				D.setValue(link.maxCol, link.maxRow);
				// 更新本link
				addNewLink(P, A, B, C, D, obj);
				P = obj.P; A = obj.A; B = obj.B;
			}
			// 添加终结点
			var endPoint:AstarTurnPoint = new AstarTurnPoint();
			endPoint.x = endRect.x;
			endPoint.y = endRect.y;
			endPoint.parent = P;
			
			buildPath(endPoint);
			
			return _path;
		}
		
		// PA直线跟CD的交点为test1
		private static var testP1:AstarTurnPoint = new AstarTurnPoint();
		// PB直线跟CD的交点为test2
		private static var testP2:AstarTurnPoint = new AstarTurnPoint();
		private static function addNewLink(P:AstarTurnPoint, A:AstarTurnPoint, B:AstarTurnPoint, C:AstarTurnPoint, D:AstarTurnPoint,
										   res:Object):void
		{
			if(A._x == B._x && A._y == B._y)//GeomUtil.calcDistance2(A, B) <= 4)
			{
				A.parent = P;
				P = A;
				A = new AstarTurnPoint();
				A.setValue(C._x, C._y);
				B.setValue(D._x, D._y);
				res.P = P; res.A = A; res.B = B;
				return ;
			}
			/// P = lastTurnPoint, A=left, B=Right, C=C, D=D;
			var isPC_AB:Boolean = GeomUtil.isLimitLineCross(C, P, A, B);
			var isPD_AB:Boolean = GeomUtil.isLimitLineCross(D, P, A, B);
			
			if(isPC_AB && isPD_AB)
			{
				A.setValue(C._x, C._y);
				B.setValue(D._x, D._y);
				res.P = P; res.A = A; res.B = B;
				return;
			}
			else if(!isPC_AB && !isPD_AB)
			{
				// CD是否在PA的两边
				var isPALineCrossCDSegment:Boolean = GeomUtil.isLineP3P4CrossSegmentsP1P2(C, D, P, A);
				// CD是否在PB的两边
				var isPBLineCrossCDSegment:Boolean = GeomUtil.isLineP3P4CrossSegmentsP1P2(C, D, P, B);
				// PA直线穿越CD， 且PB直线穿越CD
				if(isPALineCrossCDSegment && isPBLineCrossCDSegment)
				{
					GeomUtil.calcLineCrossPoint(P, A, C, D, testP1);
					GeomUtil.calcLineCrossPoint(P, B, C, D, testP2);
					A.setValue(testP1._x, testP1._y);
					B.setValue(testP2._x, testP2._y);
					res.P = P; res.A = A; res.B = B;
					return;
				}
				else
				{
					// 拿C做测试点
					var dPA_C:Number = GeomUtil.calcDistance2(P, A) + GeomUtil.calcDistance2(A, C);
					var dPB_C:Number = GeomUtil.calcDistance2(P, B) + GeomUtil.calcDistance2(B, C);
					if(dPA_C < dPB_C)// 在PA一边
					{
						A.parent = P;
						P = A;
						A = new AstarTurnPoint();
						A.setValue(C._x ,C._y);
						B.setValue(D._x, D._y);
					}
					else if(dPA_C > dPB_C)// 在PB一边
					{
						B.parent = P;
						P = B;
						B = new AstarTurnPoint();
						B.setValue(D._x, D._y);
						A.setValue(C._x, C._y);
					}
				}
			}
			else
			{
				
				if(GeomUtil.isLineP3P4CrossSegmentsP1P2(C, D, P, A))
				{
					GeomUtil.calcLineCrossPoint(P, A, C, D, testP1);
					B.setValue(testP1._x, testP1._y);
				}
				else if(GeomUtil.isLineP3P4CrossSegmentsP1P2(C, D, P, B))
				{
					GeomUtil.calcLineCrossPoint(P, B, C, D, testP2);
					B.setValue(testP2._x, testP2._y);
				}
				
				if(isPC_AB) // C在夹角之内， 成为新的夹角点
				{
					A.setValue(C._x, C._y);
				}
				else if(isPD_AB)
				{
					A.setValue(D._x, D._y);
				}
				
			}
			res.P = P; res.A = A; res.B = B;
		}
		
		private static var _path:Array;
		private static function buildPath(p:AstarTurnPoint):void
		{
			_path = [];
			while(p)
			{
				_path.unshift(p);
				p = p.parent;
			}
			
		}
		
		private static var test:AstarTurnPoint = new AstarTurnPoint();
		private static function addNewPoint(p:AstarTurnPoint, arr:Array, sIndex:int, eIndex:int):int
		{
			var i:int;
			var index:int = eIndex;
			var minDistance:Number = 100000000;
			
			test.from(p);
			for(i = sIndex; i <= eIndex; i++)
			{
				var parent:AstarTurnPoint = arr[i];
				if(isLineVisible(parent, p, arr, i*0.5 + 1, eIndex*0.5))
				{
					var tmp:Number = parent.distance + GeomUtil.calcDistance2(test, parent);//test.distance;
					if(tmp < minDistance)
					{
						minDistance = tmp;
						index = i;
						p.parent = parent;
					}
				}
			}
			if(p.parent == null)
			{
				p.distance = 0;
			}
			else
			{
				//				p.updateDistance();
				p.distance = p.parent.distance + GeomUtil.calcDistance2(p, p.parent);//test.distance;
			}
			return index;
		}
		
		private static function isLineVisible(parent:AstarTurnPoint, testPoint:AstarTurnPoint, arr:Array, starIndex:int, endIndex:int):Boolean
		{
			var i:int;
			for(i = starIndex; i <= endIndex; i += 1)
			{
				var p1:AstarTurnPoint = arr[i*2];
				var p2:AstarTurnPoint = arr[i*2 + 1];
				count++;
				if(!GeomUtil.isLineP3P4CrossSegmentsP1P2(p1, p2, parent, testPoint))//isLimitLineCross(parent, testPoint, p1, p2))
				{
					return false;
				}
			}
			return true;
		}
		
		public static function work(lines:Array, startRect:Point, endRect:Point):Array
		{
			
			// 从初始点生成边
			var link:AstarIILink = new AstarIILink();
			link.minCol = startRect.x;
			link.minRow = startRect.y;
			link.maxCol = startRect.x;
			link.maxRow = startRect.y;
			lines.unshift(link);
			// 从结束点生成结束边 
			link = new AstarIILink();
			link.minCol = endRect.x;
			link.minRow = endRect.y;
			link.maxCol = endRect.x;
			link.maxRow = endRect.y;
			lines.push(link);
			
			var closeList:Array = [];
			var i:int;
			var j:int;
			var leftMin:int = -1;;
			var rightMin:int = -2;
			// 上一个拐点的索引
			var lastTurnPointIndex:int = 0;
			var curPoint:AstarTurnPoint;
			
			count = 0;
			
			for(i = 0; i < lines.length; i++)
			{
				link = lines[i];
				//				if(i*2 - lastTurnPointIndex > 30)
				//				{
				//					lastTurnPointIndex = i*2 - 2;
				//				}
				curPoint = new AstarTurnPoint();
				curPoint.setValue(link.minCol, link.minRow);
				closeList.push(curPoint);
				leftMin = -1;
				rightMin = -2;
				leftMin = addNewPoint(curPoint, closeList, lastTurnPointIndex, i*2-1);
				
				curPoint = new AstarTurnPoint();
				curPoint.setValue(link.maxCol, link.maxRow);
				closeList.push(curPoint);
				rightMin = addNewPoint(curPoint, closeList, lastTurnPointIndex, i*2-1);
				
				if(leftMin == rightMin && leftMin >= 0)
				{
					lastTurnPointIndex = leftMin;
					//					trace("lastTurnPointIndex === "+ lastTurnPointIndex.toString());
				}
					
				else if(GeomUtil.calcDistance(link.minCol, link.minRow, link.maxCol, link.maxRow) <= 5)
				{
					lastTurnPointIndex = Math.max(i*2 - 2, 0);
				}
			}
			buildPath(closeList[closeList.length - 2]);
			
			return _path;
		}
	}
}