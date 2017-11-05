/**
 * 2010-1-13
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection
{
	import flash.geom.Point;
	
	import mortal.game.Game;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIILink;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIIPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.Vector2f;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridCutter;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridLinker;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridTurnPointFixer;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridTurnPointMaker;
	import mortal.game.scene3D.map3D.MapNodeType;
	
	public class AstarAnyDirection
	{
		public function AstarAnyDirection()
		{
		}
		
		private static var nowversion:int = 0;
		private static var _start:AstarIIPoint;
		public static var _end:AstarIIPoint;
		private static var _RectEnd:Point = new Point();
		private static var _rectStart:Point = new Point();
		private static var _mapData:Array;
		private static var _isMapDirty:Boolean = false;
		private static var _v:Vector.<AstarIIPoint>;
		
		public static function set mapData(value:Array):void
		{
			_mapData = value;
			_isMapDirty = true;
		}
		
		public static function get mapData():Array
		{
			return _mapData;
		}
		
		public static function findPath(sRow:int, sCol:int, eRow:int, eCol:int, isWalk:Boolean, isSubCheck:Boolean=false):Array
		{
			if(_mapData == null)
			{
				return [];
			}
			resetLink(isWalk);
			
			var len:int;
			var i:int;
			
			nowversion++;
			var childLink:AstarIILink;
			var parentLink:AstarIILink;
			var parentNode:AstarIIPoint
			var curNode:AstarIIPoint;
			var childNode:AstarIIPoint;
			var tmpP1:Point = new Point();
			var tmpP2:Point = new Point();
			
			var _open:BinaryHeap = new BinaryHeap(justMin);
			_start = calcNearestPoint(sRow, sCol, _v);
			
			_rectStart = _RectEnd;
			_RectEnd = new Point();
			
			_end = calcNearestPoint(eRow, eCol, _v);
			
			curNode = _start;
			curNode.version=nowversion;
			var inPoint:Point = new Point(_rectStart.x, _rectStart.y);
			curNode.inX = inPoint.x;
			curNode.inY = inPoint.y;
			var outPoint:Point = new Point();
			
			while (curNode != _end)
			{
				// 木有链接边的格子，是不可走的格子， 角色站在不可走的格子是动不了的
				if(curNode.links == null)
				{
					return [];
				}
				len=curNode.links.length;
				parentNode = curNode.parent;
				inPoint.x = curNode.inX;
				inPoint.y = curNode.inY;
				
				if(curNode.linkTM >= 0 && parentNode != null)
				{
					parentLink = parentNode.links[curNode.linkTM];
				}
				for (i = 0; i < len; i++)
				{
					childLink = curNode.links[i];
					childNode = childLink.otherNode;
					if(childNode == parentNode)
					{
						continue;
					}
					var cost:Number = 0;
					
					cost = childLink.calcDistance(inPoint, _RectEnd, tmpP1, tmpP2, outPoint);// 计算穿入点到本链接边的最短距离，并保存穿出边
					
					var g:Number=curNode.g + cost ;// getCornerCost(test,curNode); //  转弯+5
					var h:Number=heuristic(outPoint, _RectEnd);
					var f:Number=g + h;
					if (childNode.version == nowversion)
					{
						if (childNode.f > f + 0.00001)
						{
							childNode.f=f;
							childNode.g=g;
							childNode.h=h;
							childNode.linkTM = i;
							childNode.parent = curNode;
							childNode.inX = outPoint.x;
							childNode.inY = outPoint.y;
							//							outPoint = new Point();
						}
					}
					else
					{
						childNode.f=f;
						childNode.g=g;
						childNode.h=h;
						childNode.parent = curNode;
						childNode.linkTM = i;
						_open.ins(childNode);
						childNode.version = nowversion;
						childNode.inX = outPoint.x;
						childNode.inY = outPoint.y;
						//						outPoint = new Point();
					}
					
				}
				if (_open.a.length == 1)
				{
					return null;
				}
				curNode=_open.pop() as AstarIIPoint;
			}
			
			//			trace("生成aStar使用时间:" + int(time - getTimer()).toString());
			//			time = getTimer();
			var arrCommonLines:Array = buildCommonLines();
			//			trace("arrCommonLines使用时间:" + int(time - getTimer()).toString());
			//			time = getTimer();
			var turnPoints:Array = MapGridTurnPointMaker.work(arrCommonLines, _rectStart, _RectEnd);
			//			trace("MapGridTurnPointMaker:" + int(time - getTimer()).toString());
			//			time = getTimer();
			turnPoints = MapGridTurnPointFixer.fix(_mapData, turnPoints, 5);
			//			return t;
			//			trace(".................MapGridTurnPointFixer:" + int(  getTimer() - time).toString());
			return turnPoints;
		}
		
		
		public static function findNearestWalkablePoint(row:int, col:int, isWalk:Boolean=true):Point
		{
			if(_mapData == null)
			{
				return new Point(0, 0);
			}
			resetLink(isWalk);
			calcNearestPoint(row, col, _v);
			return _RectEnd.clone();
		}
		
		private static function resetLink(isWalk:Boolean):void
		{
			var min_Value:int;
			if(isWalk){
				min_Value = MapNodeType.WALK_MIN_VALUE;
			}else{
				min_Value = MapNodeType.FLY_MIN_VALUE;
			}
			// 设置link
			AstarCache.instance.setLink(Game.mapInfo.mapId, _mapData, min_Value);
			_v = AstarCache.instance.getLink(Game.mapInfo.mapId, min_Value);
		}
		
		
		public static function buildCommonLines():Array
		{
			var _path:Array = [];
			var node:AstarIIPoint = _end;
			var parent:AstarIIPoint;
			var link:AstarIILink;
			var tmp2:AstarIILink;
			var tmp:AstarIILink;
			var last:AstarIILink;
			
			while (node != _start && node.parent != null)
			{
				parent = node.parent;
				link = node.parent.links[node.linkTM];
				tmp = new AstarIILink();
				tmp2 = new AstarIILink();
				
				if(link.minCol == link.maxCol)
				{
					tmp.minRow = tmp2.minRow = link.minRow + 0.5;
					tmp.maxRow = tmp2.maxRow = link.maxRow - 0.5;
					
					// 母向左到子
					if(parent.col == link.maxCol + 0.5) 
					{
						tmp.minCol = tmp.maxCol = link.minCol + 0.5;
						tmp2.minCol = tmp2.maxCol = link.minCol - 0.5;
					}
					else// 母向右到子 
					{
						tmp.minCol = tmp.maxCol = link.minCol - 0.5;
						tmp2.minCol = tmp2.maxCol = link.minCol + 0.5;
					}
				}
				else
				{
					tmp.minCol = tmp2.minCol = link.minCol + 0.5;
					tmp.maxCol = tmp2.maxCol = link.maxCol - 0.5;
					//母向上到子 
					if(parent.row == link.maxRow + 0.5) 
					{
						tmp.minRow = tmp.maxRow = link.minRow + 0.5;
						tmp2.minRow = tmp2.maxRow = link.maxRow - 0.5;
					}
					else // 母向下到子
					{
						tmp.minRow = tmp.maxRow = link.minRow - 0.5;
						tmp2.minRow = tmp2.maxRow = link.maxRow + 0.5;
					}
				}
				
				
				
				
				// 先检查tmp2可否忽略掉（先后两条链接边的任意连线都穿越tmp2）
				if(!isLinkCanDelete(tmp2, last, tmp))
				{
					_path.unshift(tmp2);
					last = tmp2;
				}
				else
				{
					last = tmp;
				}
				
				_path.unshift(tmp);
				
				node=node.parent;
			}
			return _path;
		}
		
		private static var v1:Vector2f = new Vector2f();
		private static var v2:Vector2f = new Vector2f();
		private static var v3:Vector2f = new Vector2f();
		private static var v4:Vector2f = new Vector2f();
		private static function isLinkCanDelete(link:AstarIILink, left:AstarIILink, right:AstarIILink):Boolean
		{
			return false;
			if(left == null)
			{
				return true;
			}
			v1.x = left.minCol;
			v1.y = left.minRow;
			v2.x = right.minCol;
			v2.y = right.minRow;
			v3.x = link.minCol;
			v3.y = link.minRow;
			v4.x = link.maxCol;
			v4.y = link.maxRow;
			if(!GeomUtil.isLimitLineCross(v1, v2, v3, v4))
			{
				return false;
			}
			
			v1.x = left.maxCol;
			v1.y = left.maxRow;
			if(!GeomUtil.isLimitLineCross(v1, v2, v3, v4))
			{
				return false;
			}
			
			v2.x = right.maxCol;
			v2.y = right.maxRow;
			if(!GeomUtil.isLimitLineCross(v1, v2, v3, v4))
			{
				return false;
			}
			
			v1.x = left.minCol;
			v1.y = left.minRow;
			if(!GeomUtil.isLimitLineCross(v1, v2, v3, v4))
			{
				return false;
			}
			
			return true;
		}
		
		private static var _diagCost:Number = 1.0;
		private static var _straightCost:Number = 1.414;
		public static function heuristic(p:Point, end:Point):Number
		{
			return GeomUtil.calcDistance(p.x, p.y, end.x, end.y);
		}
		
		// 计算出最近的多边形或者所在的多边形
		private static function calcNearestPoint(row:int, col:int, v:Vector.<AstarIIPoint>):AstarIIPoint
		{
			var res:AstarIIPoint;
			var minDistance:Number = 100000000;
			var dRow:int;
			var dCol:int;
			var dEndRow:int;
			var dEndCol:int;
			var tmpDistance:Number;
			var p:AstarIIPoint;
			var i:int;
			var len:int = v.length;
			for(i = 0; i < len; i++)
			{
				p = v[i];
				// 在p的区域内
				if(row >= p.row)
				{
					if(row < p.endRow)
					{
						if(col >= p.col)
						{
							if(col < p.endCol)
							{
								_RectEnd.x = col;
								_RectEnd.y = row;
								return p;
							}
						}
					}
				}
			}
			// 找最近的
			for(i = 0; i < len; i++)
			{
				p = v[i];
				// 定义此点到当前四边形的距离为到四个顶点的最小距离
				dRow = row - p.row;
				dCol = col - p.col;
				dEndRow = row - p.endRow + 1;
				dEndCol = col - p.endCol + 1;
				
				// 点在四边形的上方3个方向
				if(row < p.row)
				{
					if(col < p.col)
					{
						tmpDistance = dRow * dRow + dCol*dCol;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = p.row;
							_RectEnd.x = p.col;
							res = p;
						}
					}
					else if(col > p.endCol - 1)
					{
						tmpDistance = dEndCol*dEndCol + dRow * dRow;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = p.row;
							_RectEnd.x = p.endCol - 1;
							res = p;
						}
					}
					else
					{
						tmpDistance = dRow*dRow;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = p.row;
							_RectEnd.x = col;
							res = p;
						}
					}
				}
					
					// 点在四边形的下方3个方向
				else if(row > p.endRow - 1)
				{
					if(col < p.col)
					{
						tmpDistance = dEndRow * dEndRow + dCol*dCol;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = p.endRow - 1;
							_RectEnd.x = p.col;
							res = p;
						}
					}
					else if(col > p.endCol - 1)
					{
						tmpDistance = dEndRow * dEndRow + dEndCol*dEndCol;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = p.endRow - 1;
							_RectEnd.x = p.endCol - 1;
							res = p;
						}
					}
					else
					{
						tmpDistance = dRow*dRow;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = p.endRow - 1;
							_RectEnd.x = col;
							res = p;
						}
					}
				}
					
					// 左边方向
				else
				{
					if(col <= p.col)
					{
						tmpDistance = dCol*dCol;
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = row;
							_RectEnd.x = p.col;
							res = p;
						}
					}
					else
					{
						tmpDistance = dEndCol*dEndCol
						if(tmpDistance < minDistance)
						{
							minDistance = tmpDistance;
							_RectEnd.y = row;
							_RectEnd.x = p.endCol - 1;
							res = p;
						}
					}
				}
				
			}
			return res;
		}
		
		private static function justMin(x:Object, y:Object):Boolean
		{
			return x.f < y.f;
		}
	}
}

class BinaryHeap
{
	public var a:Array=[];
	public var justMinFun:Function=function(x:Object, y:Object):Boolean
	{
		return x < y;
	};
	
	public function BinaryHeap(justMinFun:Function=null)
	{
		a.push(-1);
		if (justMinFun != null)
			this.justMinFun=justMinFun;
	}
	
	public function ins(value:Object):void
	{
		var p:int=a.length;
		a[p]=value;
		var pp:int=p >> 1;
		while (p > 1 && justMinFun(a[p], a[pp]))
		{
			var temp:Object=a[p];
			a[p]=a[pp];
			a[pp]=temp;
			p=pp;
			pp=p >> 1;
		}
	}
	
	public function pop():Object
	{
		var min:Object=a[1];
		a[1]=a[a.length - 1];
		a.pop();
		var p:int=1;
		var l:int=a.length;
		var sp1:int=p << 1;
		var sp2:int=sp1 + 1;
		while (sp1 < l)
		{
			if (sp2 < l)
			{
				var minp:int=justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
			}
			else
			{
				minp=sp1;
			}
			if (justMinFun(a[minp], a[p]))
			{
				var temp:Object=a[p];
				a[p]=a[minp];
				a[minp]=temp;
				p=minp;
				sp1=p << 1;
				sp2=sp1 + 1;
			}
			else
			{
				break;
			}
		}
		return min;
	}
}