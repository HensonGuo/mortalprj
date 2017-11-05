package mortal.game.scene3D.player.entity
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.geom.Point;
	
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.MapNodeType;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.Speed;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;

	/**
	 * 角色播放器
	 * @author jianglang
	 *
	 */
	public class MovePlayer extends SpritePlayer
	{
		/**
		 * 寻路结果，行走的路径
		 */
		protected var _pathArray:Array = new Array();
		/**
		 *是否跟随寻路
		 */
		protected var _needFollowFindPath:Boolean=true;

		protected var _nextPoint:AstarTurnPoint = new AstarTurnPoint();
		
		protected var _nextTwoPoint:AstarTurnPoint;

		protected var _isMove:Boolean=false; //是否移动
		
		protected var _isInSafeArea:Boolean = false;
		
		/**
		 * 跟随列表
		 */
		private var _followList:Array;

		public function MovePlayer()
		{
			super();
			_needFollowFindPath=true;
			_followList=[];
		}
		 
		override public function updateInfo( info:Object,isAllUpdate:Boolean = true):void
		{
			super.updateInfo(info,isAllUpdate);
			_isInSafeArea = isInSafeArea();
		}
		
		public function get isMove():Boolean
		{
			return _isMove;
		}

		public function get speed():Speed	{	return _speed;	}
		
		private function traceUser( value:String ):void
		{
			if( this is UserPlayer && this is RolePlayer == false )
			{
				Log.debug(entityInfo.entityInfo.name+":"+ value );
			}
		}
		
		/**
		 * 格子坐标
		 * @return
		 *
		 */
		public function getTilePoint():Point
		{
			return GameMapUtil.getTilePoint(this.x2d, this.y2d);
		}
		
		public function updatePos():void
		{
			if(_isMove)
			{
				if(isArrive())
				{
					if(_pathArray.length > 0 || _nextTwoPoint != null)
					{
						walkGridEnd();
						nextPathPoint();
					}
					else
					{
						walkEnd();
					}
				}
				else
				{
					onWalk();
					onMove();
					_speed.update(this.x2d, this.y2d);
//					Log.debug(_speed.xSpeed,_speed.ySpeed);
				}
			}
		}
		
		/**
		 * 是否有下一个节点 
		 * @return 
		 * 
		 */		
		protected function hasNextPoint():Boolean
		{
			if( _pathArray.length > 0 )
			{
				_nextPoint = _pathArray.shift() as AstarTurnPoint;
				return true;
			}
			return false;
		}
		
		protected function nextPathPoint( isStart:Boolean = false ):void
		{
			if (hasNextPoint())
			{	
				if(_nextPoint == null)
				{
					walkEnd();
					return;
				}
				var p:Point=GameMapUtil.getTilePoint(_nextPoint._x, _nextPoint._y);
				_speed.setPoint(this.x2d, this.y2d, _nextPoint._x, _nextPoint._y);
				
				//取地形值
				_nextPoint.value = getPointValue(p.x, p.y);
				//透明度控制
				updateAlpha(_nextPoint.value);
				
				this.direction = _speed.direction;
				
				//traceUser( "userPlayer:"+[_nextPoint._x,_nextPoint._y] );
				
				if( isStart )
				{
					walkStart(_nextPoint);
				}
				else
				{
					walkGridStart(_nextPoint);
				}
			}
			else
			{
				walkEnd();
			}
		}
		
		public function updateCurrentAlpha():void
		{
			//透明度控制
			var p:Point=GameMapUtil.getTilePoint(this.x2d, this.y2d);
			updateAlpha(getPointValue(p.x,p.y));
		}
		
		protected function isArrive():Boolean
		{
			return speed.distance < speed.speed;
		}

		protected function get speedCorrectPer():Number
		{
			if(_pathArray.length > 2)
			{
				return 1.1;
			}
			else if(_pathArray.length > 1)
			{
				return 1.02;
			}
			else
			{
				return 1;
			}
		}
		
		protected function onMove():void
		{
//			//缓动中不能移动
//			if(!isTweening)
//			{
//				if(!Global.isActivate)
//				{
//					trace("人物移动",_speed.xSpeed * speedCorrectPer,_speed.ySpeed * speedCorrectPer)	
//				}
				this.x2d += _speed.xSpeed * speedCorrectPer;
				this.y2d += _speed.ySpeed * speedCorrectPer;
				updateTalkXY();
				if (SceneRange.map.contains(this.x2d, this.y2d) == false)
				{
					stopMove();
				}
//				ThingUtil.isEntitySort=true;
//			}
		}

		override public function walking(pointAry:Array):void
		{
			if (isInitInfo == false || this.isDead)
			{
				stopMove();
				return;
			}
			if(pointAry.length == 0)
			{
				return;
			}
			if( _isMove == false )
			{
				_pathArray = pointAry.concat();
				startMove();
				nextPathPoint(true);
			}
			else
			{
				_pathArray = _pathArray.concat(pointAry);
			}
		}
		
		/**
		 * 转向 
		 * @param pointAry
		 * 
		 */	
		override public function diversion(pointAry:Array):void
		{
			if (isInitInfo == false || this.isDead)
			{
				stopMove();
				return;
			}
			if( _isMove == false )
			{
				_pathArray = pointAry.concat();
				startMove();
				nextPathPoint(true);
			}
			else
			{
				
				if(_pathArray.length)
				{
					_pathArray.pop();
					if(_pathArray.length)
					{
						_pathArray.pop();
						_pathArray = _pathArray.concat(pointAry);
					}
					else
					{
						_pathArray = _pathArray.concat(pointAry);
						nextPathPoint();
					}
				}
				else
				{
					_pathArray = _pathArray.concat(pointAry);
					nextPathPoint();
				}
			}
		}
		
		public function stopWalking():void
		{
			stopMove();
		}

		protected function startMove():void
		{
			_isMove=true;
			move();
		}
		
		public function stopMove():void
		{
			if(_isMove)
			{
				_isMove = false;
				Global.instance.callLater(setActionStand);
			}
			_pathArray.length=0;
			_nextPoint = null;
			_nextTwoPoint = null;
		}
		
		public function setActionStand():void
		{
			if (!_isMove && this.isDead == false && ActionType.isWalkAction(this._actionName))
			{
				this.setAction(ActionType.Stand,ActionName.Stand);
			}
		}
		
		
		/**
		 * 开始走路
		 *
		 */
		protected function walkStart( nextPoint:AstarTurnPoint ):void{}

		/**
		 * 走路中
		 *
		 */
		protected function onWalk():void
		{ 
//			ThingUtil.isEntitySort=true; 
		}

		/**
		 * 格子开始 
		 * 
		 */		
		protected function walkGridStart( nextPoint:AstarTurnPoint ):void
		{
		}
		
		/**
		 * 格子结束 
		 * 
		 */		
		protected function walkGridEnd():void
		{
			if( _nextPoint )
			{
				_speed.setSpeedXY(_nextPoint._x - this.x2d,_nextPoint._y - this.y2d);
				this.x2d = _nextPoint._x;
				this.y2d = _nextPoint._y;
				updateTalkXY();
//				Log.debug(_speed.xSpeed,_speed.ySpeed);
			}
			
			checkSafeArea();
			
			if( pointChangeHandler is Function )
			{
				pointChangeHandler();
			}
		}
		
		protected function updateDif(xDif:int,yDif:int):void
		{
			
		}
		
		/**
		 * 判定是否在安全区域 
		 * 
		 */		
		protected function checkSafeArea():void
		{
			var inSafeArea:Boolean = isInSafeArea();
			if(inSafeArea != _isInSafeArea)
			{
				_isInSafeArea = inSafeArea;
				updateIsInSafeArea();
			}
		}
		
		/**
		 * 是否在安全区域 
		 * @return 
		 * 
		 */
		protected function isInSafeArea():Boolean
		{
			var tilePoint:Point = GameMapUtil.getTilePoint(this.x2d,this.y2d);
			var mapValue:int = getPointValue(tilePoint.x,tilePoint.y);
			var isInSafeArea:Boolean = MapNodeType.isSameServerSafe(mapValue);
			return isInSafeArea;
		}
		
		/**
		 * 是否在安全区域更新显示 
		 * 
		 */
		protected function updateIsInSafeArea():void
		{
			if(entityInfo &&　entityInfo.entityInfo)
			{
				entityInfo.isUpdateName = true;
			}
		}
		
		/**
		 * 行走结束
		 * @param isEnd==true 是行路结束   == false 节点行路完成
		 */
		protected function walkEnd():void
		{
			walkGridEnd();
			stopMove();
		}
		
//		/**
//		 * 设置格子坐标 
//		 * @param x
//		 * @param y
//		 * 
//		 */		
//		override public function setTitlePoint(x:int, y:int, isStop:Boolean=true):void
//		{
//			super.setTitlePoint(x,y,isStop);
//			_nextPointAry.length = 0;
//			if( isStop && _isMove )
//			{
//				stopMove();
//			}
//			checkSafeArea();
//		}
		
		/**
		 * 剩余的格子数组
		 * @return
		 *
		 */
		public function get pathArray():Array
		{
			return _pathArray;
		}
		
		////////////////////////////////////////////////////////////////////////////
		//  跟随
		////////////////////////////////////////////////////////////////////////////
		/**
		 * 获取更随列表
		 * @return
		 *
		 */
		public function get followList():Object
		{
			return _followList;
		}
		
		/**
		 * 移除跟随者
		 * @param player
		 *
		 */
		public function removeFollow(player:MovePlayer):void
		{
			var len:uint=_followList.length;
			for (var i:uint=0; i < len; i++)
			{
				var followItem:MovePlayer=_followList[i] as MovePlayer;
				if (followItem == player)
				{
					_followList.splice(i, 1);
				}
			}
		}
		
		
		public function addFollow(player:MovePlayer):void
		{
			_followList.push(player);
		}
		
		public function follow(player:MovePlayer):void
		{
//			var roleTilePoint:Point=GameMapUtil.getTilePoint(this.x, this.y);
//			var pathAry:Array;
//			//根据目标点与当前点之间的距离确定使用的最大检测次数
//			var d:Number=Math.sqrt(Math.pow((roleTilePoint.x - player.currentPoint.x), 2) + Math.pow((roleTilePoint.y - player.currentPoint.y), 2));
//			if (d > 50)
//			{
//				//格子间距离大于50
//				pathAry=Game.scene.findPath(roleTilePoint.x, roleTilePoint.y, player.currentPoint.x, player.currentPoint.y, 50000, RolePlayer.instance.isFlying == false);
//			}
//			else
//			{
//				pathAry=Game.scene.findPath(roleTilePoint.x, roleTilePoint.y, player.currentPoint.x, player.currentPoint.y, 5000, RolePlayer.instance.isFlying == false);
//			}
//			
//			//根据当前人物在跟随列表中的位置计算应该跟随到哪一格为止。
//			var index:int=player.getFollowIndex(this);
//			//第N个人，只需要移动到寻路结果的len-n格上
//			pathAry.splice(pathAry.length - (index + 1), (index + 1));
//			if (pathAry.length > 0)
//			{
//				//只有寻路的长度大于0的才需要行走
//				walking(pathAry);
//			}
		}
		
		public function get hasMount():Boolean
		{
			return false;
		}
		
		/**
		 * 跟随的目标
		 */
		protected var _currentFollowTarget:MovePlayer;
		
		public function set currentFollowTarget(target:MovePlayer):void
		{
			// TODO Auto-generated method stub
			if (_currentFollowTarget && _currentFollowTarget != target)
			{
				_currentFollowTarget.removeFollow(this);
			}
			_currentFollowTarget=target;
		}
		
		public function get currentFollowTarget():MovePlayer
		{
			// TODO Auto-generated method stub
			return _currentFollowTarget;
		}
		
		public function getFollowIndex(player:MovePlayer):int
		{
			// TODO Auto-generated method stub
			var index:int=-1;
			var len:int=_followList.length;
			for (var i:int=0; i < len; i++)
			{
				if ((_followList[i] as MovePlayer) == player)
				{
					index=i;
					return index;
				}
			}
			return index;
		}
		

		override public function set isDead(value:Boolean):void
		{
			super.isDead=value;
			if (value)
			{
				stopMove();
			}
		}

//		override protected function disposeObject():void
//		{
//			super.disposeObject();
////			EntityClass.disposeInstance(this, MovePlayer);
//		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			stopMove();
			_isInSafeArea = false;
			collecting = false;
		}
		
		//------------------------------ 采集状态 ------------------------------
		
		/**
		 * 采集状态 
		 */
		private var _collecting:Boolean;
		
		public function get collecting():Boolean
		{
			return _collecting;
		}
		
		public function set collecting(value:Boolean):void
		{
			_collecting = value;
		}
		
		//------------------------------翻滚状态-----------------------------
		private var _isJumping:Boolean = false;
		
		public function get isJumping():Boolean
		{
			return _isJumping;
		}
		
		public function set isJumping(value:Boolean):void
		{
			_isJumping = value;
		}
	}
}
