package mortal.game.scene3D.map3D
{
	import flash.utils.getTimer;

	public class AStar
	{
		private var _open:BinaryHeap;
		private var _grid:Grid;
		private var _endAStarPoint:AStarPoint;
		private var _startAStarPoint:AStarPoint;
		private var _path:Array;
		public var heuristic:Function;
		private var _straightCost:Number=1.0;
		private var _diagCost:Number=Math.SQRT2;
		private var nowversion:int=1;
		
		private function justMin(x:Object, y:Object):Boolean
		{
			return x.f < y.f;
		}
		
		public function isCanfindPath():Boolean
		{
			_endAStarPoint=_grid.endAStarPoint;
			nowversion++;
			_startAStarPoint=_grid.startAStarPoint;
			//_open = [];
			_open=new BinaryHeap(justMin);
			_startAStarPoint.g=0;
			return search();
		}
		
		public function getCornerCost(node:AStarPoint,parentNode:AStarPoint):int
		{
			var grandfather:AStarPoint = parentNode.parent;
			if(!grandfather)
			{
				return 0;
			}
			if(grandfather.x - parentNode.x == parentNode.x - node.x && grandfather.y - parentNode.y == parentNode.y - node.y)
			{
				return 0;
			}else
			{
				return 5;
			}
		}
		
		public function search():Boolean
		{
			var count:int = 0;
			var node:AStarPoint=_startAStarPoint;
			node.version=nowversion;
			while (node != _endAStarPoint)
			{
				count++;
//				if(count > _checkMaxCount)
//				{
//					return false;
//				}
				if(!_grid.hasCreatedAStarPointLink(node))
				{
					_grid.initAStarPointLink(node);
				}
				var len:int=node.links.length;
				for (var i:int=0; i < len; i++)
				{
					var test:AStarPoint=node.links[i].node;
					var cost:Number=node.links[i].cost;
					var g:Number=node.g + cost + getCornerCost(test,node);
					var h:Number=heuristic(test);
					var f:Number=g + h;
					if (test.version == nowversion)
					{
						if (test.f > f)
						{
							test.f=f;
							test.g=g;
							test.h=h;
							test.parent=node;
						}
					}
					else
					{
						test.f=f;
						test.g=g;
						test.h=h;
						test.parent=node;
						_open.ins(test);
						test.version=nowversion;
					}
					
				}
				if (_open.a.length == 1)
				{
					return false;
				}
				node=_open.pop() as AStarPoint;
			}
			buildPath();
			return true;
		}
		
		private function buildPath():void
		{
			_path=[];
			var node:AStarPoint=_endAStarPoint;
			_path.push(node);
			while (node != _startAStarPoint)
			{
				node=node.parent;
				_path.unshift(node);
			}
		}
		
		public function get path():Array
		{
			return _path;
		}
		
		public function manhattan(node:AStarPoint):Number
		{
			return Math.abs(node.x - _endAStarPoint.x) + Math.abs(node.y - _endAStarPoint.y);
		}
		
		public function manhattan2(node:AStarPoint):Number
		{
			var dx:Number=Math.abs(node.x - _endAStarPoint.x);
			var dy:Number=Math.abs(node.y - _endAStarPoint.y);
			return dx + dy + Math.abs(dx - dy) / 1000;
		}
		
		public function euclidian(node:AStarPoint):Number
		{
			var dx:Number=node.x - _endAStarPoint.x;
			var dy:Number=node.y - _endAStarPoint.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private var TwoOneTwoZero:Number=2 * Math.cos(Math.PI / 3);
		
		public function chineseCheckersEuclidian2(node:AStarPoint):Number
		{
			var y:int=node.y / TwoOneTwoZero;
			var x:int=node.x + node.y / 2;
			var dx:Number=x - _endAStarPoint.x - _endAStarPoint.y / 2;
			var dy:Number=y - _endAStarPoint.y / TwoOneTwoZero;
			return sqrt(dx * dx + dy * dy);
		}
		
		private function sqrt(x:Number):Number
		{
			return Math.sqrt(x);
		}
		
		public function euclidian2(node:AStarPoint):Number
		{
			var dx:Number=node.x - _endAStarPoint.x;
			var dy:Number=node.y - _endAStarPoint.y;
			return dx * dx + dy * dy;
		}
		
		public function diagonal(node:AStarPoint):Number
		{
			var dx:Number=Math.abs(node.x - _endAStarPoint.x);
			var dy:Number=Math.abs(node.y - _endAStarPoint.y);
			var diag:Number=Math.min(dx, dy);
			var straight:Number=dx + dy;
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
		
		public function add(node:AStarPoint):Number
		{
			var dx:Number=node.x - _endAStarPoint.x;
			var dy:Number=node.y - _endAStarPoint.y;
			return (dx>0?dx:-dx) + (dy>0?dy:-dy);
		}
		
		/**
		 * 寻路不可走的最小值
		 */		
		public static var MIN_VALUE:int = 1;
		
		/**
		 * 当前状态（飞行、行走），是否可通过
		 * @param type
		 * @return 
		 * 
		 */		
		public static function walkable(type:int):Boolean
		{
			return type < 0 || type >= MIN_VALUE;
		}
		
		/**
		 * 地形数据
		 */
		private var _mapData:Array;
		
		public function AStar()
		{
			heuristic = diagonal;
		}
		
		public function set mapData(arr:Array):void
		{
//			_mapData = arr;
			var time:int = getTimer();
			if(!_grid)
			{
				var grid:Grid = new Grid();
				this._grid=grid;
			}
			_grid.mapData = arr;
		}
		
		public function resetMapData():void
		{
			if(_grid)
			{
				_grid.resetMapData();
			}
		}
		
		public function resetMapPoint(x:int,y:int,value:int):void
		{
			_grid.resetMapPoint(x,y,value);
		}
		
		public function stop():void
		{
			
		}
		
		private var _checkMaxCount:int = int.MAX_VALUE;
		private var _notCheck:Boolean = false;
		
		private var _lastIsWalk:Boolean = true;
		
		/**
		 * 寻路
		 * @param sx 开始x
		 * @param sy 开始y
		 * @param ex 结束x
		 * @param ey 结束y
		 * @param isWalk 是否行走寻路，如果是飞行寻路，则为false
		 * @return
		 *
		 */
		public function findpath(sx:int, sy:int, ex:int, ey:int, checkMaxCount:int,isWalk:Boolean):Array
		{
			if(_lastIsWalk != isWalk)
			{
				resetMapData();
			}
			_lastIsWalk = isWalk;
			_checkMaxCount = checkMaxCount;
			var time:int= getTimer();
			if(!_grid || !_grid.mapData)
			{
				return null;
			}
			if(_notCheck)
			{
				MIN_VALUE = 0;
			}
			else
			{
//				if(RolePlayer.instance.isInVideo)
//				{
//					MIN_VALUE = MapNodeType.FLY_MIN_VALUE;
//				}
				if(isWalk){
					MIN_VALUE = MapNodeType.WALK_MIN_VALUE;
				}else{
					MIN_VALUE = MapNodeType.FLY_MIN_VALUE;
				}
			}
			
			if(ex >= _grid.mapData.length || ey > _grid.mapData[ex].length || sx > _grid.mapData.length || sy > _grid.mapData[sx].length)
			{
				return [];
			}
			
			var tempD:int = _grid.mapData[ex][ey];
			if(!walkable(tempD)){
				//点击的点不可走
				//寻找最近的可走的点
				while(!walkable(tempD)){
					if(ex>sx){
						ex--;
					}else if(ex<sx){ 
						ex++;
					}
					if(ey>sy){
						ey--;
					}else if(ey<sy){ 
						ey++;
					}
					if(sx == ex && sy == ey){
						return null;
					}
					tempD = _grid.mapData[ex][ey];
				}
			}
			
			_grid.setStartAStarPoint(sx,sy);
			_grid.setEndAStarPoint(ex,ey);
			
			if(isCanfindPath())
			{
				return path;
			}
			else
			{
				return [];
			}
		}
	}
}

import com.gengine.debug.Log;

import flash.utils.getTimer;

import mortal.game.scene3D.map3D.AStarPoint;


class Grid
{
	private var _mapData:Array;
	private var _startAStarPoint:AStarPoint;
	private var _endAStarPoint:AStarPoint;
	private var _nodes:Array;
	private var _numCols:int;
	private var _numRows:int;
	
	private var type:int;
	
	private var _straightCost:Number=1.0;
	private var _diagCost:Number=Math.SQRT2;
	
	public function Grid()
	{
//		calculateLinks();
	}
	
	/**
	 *
	 * @param	type	0四方向 1八方向 2跳棋
	 */
	public function calculateLinks(type:int=0):void
	{
		this.type=type;
		for (var i:int=0; i < _numCols; i++)
		{
			for (var j:int=0; j < _numRows; j++)
			{
				initAStarPointLink(_nodes[i][j], type);
			}
		}
	}
	
	public function getType():int
	{
		return type;
	}
	
	/**
	 * 判断某个节点是否已经创建了链接表 
	 * @param node
	 * 
	 */	
	public function hasCreatedAStarPointLink(node:AStarPoint):Boolean
	{
		return !(node.links == null);
	}
	
	/**
	 *
	 * @param	node
	 * @param	type	0八方向 1四方向 2跳棋
	 */
	public function initAStarPointLink(node:AStarPoint, type:int = 0):void
	{
		var startX:int=Math.max(0, node.x - 1);
		var endX:int=Math.min(numCols - 1, node.x + 1);
		var startY:int=Math.max(0, node.y - 1);
		var endY:int=Math.min(numRows - 1, node.y + 1);
		node.links=[];
		for (var i:int=startX; i <= endX; i++)
		{
			for (var j:int=startY; j <= endY; j++)
			{
				var test:AStarPoint=getAStarPoint(i, j);
				if (test == node || !test.walkable)
				{
					continue;
				}
				if (type != 2 && i != node.x && j != node.y)
				{
					var test2:AStarPoint=getAStarPoint(node.x, j);
					if (!test2.walkable)
					{
						continue;
					}
					test2=getAStarPoint(i, node.y);
					if (!test2.walkable)
					{
						continue;
					}
				}
				var cost:Number=_straightCost;
				if (!((node.x == test.x) || (node.y == test.y)))
				{
					if (type == 1)
					{
						continue;
					}
					if (type == 2 && (node.x - test.x) * (node.y - test.y) == 1)
					{
						continue;
					}
					if (type == 2)
					{
						cost=_straightCost;
					}
					else
					{
						cost=_diagCost;
					}
				}
				node.links[node.links.length] = new Link(test, cost);
//				node.links.push(new Link(test, cost));
			}
		}
	}
	
	public function getAStarPoint(x:int, y:int):AStarPoint
	{
		if(!_nodes)
		{
			_nodes = new Array();
		}
		if(!_nodes[x])
		{
			_nodes[x] = new Array();
		}
		var point:AStarPoint = _nodes[x][y];
		if(!point)
		{
			point = new AStarPoint(x, y,_mapData[x][y]);
			_nodes[x][y] = point;
		}
		return point;
	}
	
	public function resetMapPoint(x:int,y:int,value:int):void
	{
		for(var i:int = -1;i<=1;i++)
		{
			for(var j:int = -1;j<=1;j++)
			{
				if(x + i >= 0 && x + i < _numCols && y + j >= 0 && y + j < _numRows)
				{
					clearPointLinks(x + i,y + j);
				}
			}
		}
		clearPointData(x,y);
		_mapData[x][y] = value;	
	}
	
	public function clearPointData(x:int,y:int):void
	{
		clearPointLinks(x,y);
		_nodes[x][y] = null;
	}
	
	public function clearPointLinks(x:int,y:int):void
	{
		var point:AStarPoint = _nodes[x][y];
		if(point)
		{
			point.dispose();
		}
	}
	
	public function setEndAStarPoint(x:int, y:int):void
	{
		_endAStarPoint=getAStarPoint(x,y);
	}
	
	public function setStartAStarPoint(x:int, y:int):void
	{
		_startAStarPoint=getAStarPoint(x,y);
	}
	
	//	public function setWalkable(x:int, y:int, value:Boolean):void
	//	{
	//		_nodes[x][y].walkable=value;
	//	}
	
	public function get endAStarPoint():AStarPoint
	{
		return _endAStarPoint;
	}
	
	public function get numCols():int
	{
		return _numCols;
	}
	
	public function get numRows():int
	{
		return _numRows;
	}
	
	public function get startAStarPoint():AStarPoint
	{
		return _startAStarPoint;
	}

	public function get mapData():Array
	{
		return _mapData;
	}

	public function set mapData(value:Array):void
	{
		dispose();
		_mapData = value;
		_numCols=_mapData.length;
		_numRows=(_mapData[0] as Array).length;
		_nodes=new Array();
		
		var time:int = getTimer();
		
		for (var i:int=0; i < _numCols; i++)
		{
			_nodes[i]=new Array();
//			for (var j:int=0; j < _numRows; j++)
//			{
////				_nodes[i][j]=new AStarPoint(i, j,_mapData[i][j]);
//				var point:AStarPoint = ObjectPool.getObject(AStarPoint);
//				point.x = i;
//				point.y = j;
//				point.value = _mapData[i][j];
//				_nodes[i][j] = point;
//			}
		}
		
		Log.debug("初始化地图节点耗时：" + (getTimer() - time));
	}
	
	/**
	 * 重设地图数据 
	 * 
	 */	
	public function resetMapData():void
	{
		if(_mapData)
		{
			mapData = _mapData;
		}
	}
	
	/**
	 * 清除原有数据 
	 * 
	 */	
	private function dispose():void
	{
		var point:AStarPoint;
		if(_mapData)
		{
			for (var i:int=0; i < _numCols; i++)
			{
				for (var j:int=0; j < _numRows; j++)
				{
					point = _nodes[i][j] as AStarPoint;
					if(point)
					{
						point.dispose();
					}
				}
			}
		}
		_nodes = null;
	}
}

class Link
{
	public var node:AStarPoint;
	public var cost:Number;
	
	public function Link(node:AStarPoint, cost:Number)
	{
		this.node=node;
		this.cost=cost;
	}
	
	public function dispose():void
	{
		node = null;
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
