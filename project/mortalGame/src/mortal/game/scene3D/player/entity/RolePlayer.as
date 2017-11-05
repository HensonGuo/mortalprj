package mortal.game.scene3D.player.entity
{
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.utils.MathUitl;
	import com.mui.controls.Alert;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.game.Game;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.view.systemSetting.SystemSetting;


	/**
	 * 玩家唯一角色
	 * @author jianglang
	 *
	 */
	[Eevent(name = "walk_Start", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "walk_end", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "on_walk", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "gird_walk_end", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "player_fire", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "doubleRest", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "ServerPoint", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "UpdateEquip", type = "com.gengine.game.events.PlayerEvent")]
	[Eevent(name = "FlyChange", type = "com.gengine.game.events.PlayerEvent")]
	public class RolePlayer extends UserPlayer
	{
		private static var _instance:RolePlayer;

		public var isCanControlWalk:Boolean = true; //是否可以控制 移动
		public var isCanControlAttack:Boolean = true; //是否可以攻击
		public var isCanControlReleaseMagic:Boolean = true; //是否可以释放魔法

		private var _scrollRect:Rectangle;

		public function RolePlayer()
		{
			if (_instance)
			{
				throw new Error("RolePlayer 唯一性");
			}
			_scrollRect = SceneRange.display;
		}

		protected override function initPlayers():void
		{
			super.initPlayers();
			_bodyPlayer.selectEnabled = false;
			_weaponPlayer && (_weaponPlayer.selectEnabled = false);
		}

		
		/*public override function set x2d(value:Number):void
		{
			_x2d = value;
			this.x = int(Scene3DUtil.change2Dto3DX(value));
		}
		
		public override function set y2d(value:Number):void
		{
			_y2d = value;
			this.z = int(Scene3DUtil.change2Dto3DY(value));
		}*/
		
		
		override public function dispose(isReuse:Boolean = true):void
		{
			isCanControlWalk = true;
			isCanControlAttack = true;
			isCanControlReleaseMagic = true;
		}

		public static function get instance():RolePlayer
		{
			if (!_instance)
			{
				_instance = new RolePlayer();
			}
			return _instance;
		}

		private var _isSetPoint:Boolean = false;

		//		override public function setTitlePoint(x:int, y:int, isStop:Boolean=true):void
		//		{
		//			super.setTitlePoint(x,y,isStop);
		//			setCurrentPointImpl();
		//		}

		override public function setPixlePoint(x:int, y:int, isDelay:Boolean = true, isStop:Boolean = true):void
		{
			super.setPixlePoint(x, y, isDelay, isStop);
			//			if (!isDelay)
			//			{
			setCurrentPointImpl();
			stopMove();
			return;
			//			}
			//			if (_isSetPoint == false)
			//			{
			//				_isSetPoint=true;
			//				setTimeout(setCurrentPointImpl, 50);
			//			}
		}

		/**
		 * 设置当前场景位置
		 *
		 */
		public function setCurrentPointImpl(isX:Boolean = true, isY:Boolean = true):void
		{
			//trace( "人物位置：",this.x,this.y );
			_isSetPoint = false;
			//更新当前的位置

			var xx:int = SceneRange.moveMap.x;
			var yy:int = SceneRange.moveMap.y;

			if (SceneRange.map.contains(this.x2d, this.y2d))
			{
				if (isX)
				{
					_scrollRect.x = int(this.x2d - _scrollRect.width / 2);
					if (_scrollRect.left < SceneRange.map.left)
					{
						_scrollRect.x = 0;
					}

					if (_scrollRect.right > SceneRange.map.right)
					{
						_scrollRect.x = int(SceneRange.map.right - _scrollRect.width);
					}
				}
				if (isY)
				{
					_scrollRect.y = int(this.y2d - _scrollRect.height / 2);
					if (_scrollRect.top < SceneRange.map.top)
					{
						_scrollRect.y = 0;
					}

					if (_scrollRect.bottom > SceneRange.map.bottom)
					{
						_scrollRect.y = int(SceneRange.map.bottom - _scrollRect.height);
					}
				}

				Game.scene.scrollRect = _scrollRect;
			}
			else
			{
				if (Global.isDebugModle)
				{
					Alert.show("不在地图范围内");
				}
			}
			//			updateDoubleRestPos();
		}

		private var _serverPoints:Array = [];
		private const SERVERDISTANCE:Number = 60;
		private const SERVERMAXDISTANCE:Number = 80;

		public function get serverPoints():Array
		{
			return _serverPoints;
		}

		/**
		 * 是否有下一个节点
		 * @return
		 *
		 */
		override protected function hasNextPoint():Boolean
		{
			if (_nextTwoPoint)
			{
				_nextPoint = _nextTwoPoint;
				_nextTwoPoint = cutPoint(_nextPoint._x, _nextPoint._y);
				return true;
			}
			else
			{
				if (_nextPoint)
				{
					return true;
				}
				else
				{
					_nextPoint = cutPoint(this.x2d, this.y2d);
					if (_nextPoint)
					{
						return true;
					}
					return false;
				}
			}
		}

		/**
		 * 从路线中截取一个点
		 * @return
		 *
		 */
		public function cutPoint(baseX:Number, baseY:Number):AstarTurnPoint
		{
			var p:AstarTurnPoint;
			var pCut:AstarTurnPoint;
			if (_pathArray.length > 0)
			{
				p = _pathArray[0] as AstarTurnPoint;
			}
			else
			{
				return null;
			}
			var targetPoint:Point = new Point(p._x, p._y);
			if (targetPoint)
			{
				pCut = new AstarTurnPoint();
				if (0) //GameMapUtil.getDistance(baseX, baseY, targetPoint.x, targetPoint.y) > SERVERMAXDISTANCE)
				{
					var radians:Number = MathUitl.getRadiansByXY(baseX, baseY, targetPoint.x, targetPoint.y);
					pCut._x = baseX + Math.cos(radians) * SERVERDISTANCE;
					pCut._y = baseY + Math.sin(radians) * SERVERDISTANCE;

				}
				else
				{
					pCut._x = targetPoint.x;
					pCut._y = targetPoint.y;

					//删除列表节点
					if (_pathArray.length > 0)
					{
						_pathArray.shift();
					}
				}
				var point:Point = GameMapUtil.getTilePoint(pCut._x, pCut._y);
				pCut.value = GameMapUtil.getPointValue(point.x, point.y);
				return pCut;
			}
			return null;
		}

		override protected function isArrive():Boolean
		{
			return speed.distance < speed.speed * 1.4;
		}
		
		override protected function walkGridStart(nextPoint:AstarTurnPoint):void
		{
			_serverPoints.length = 0;
			if (_nextTwoPoint)
			{
				var sp:SPoint = new SPoint();
				sp.x = _nextTwoPoint._x;
				sp.y = _nextTwoPoint._y;
				_serverPoints.push(sp);
//				Log.debug("中间发送给服务器：", sp.x, sp.y);
				if(!_isInServerMove)
				{
					dispatchEvent(new PlayerEvent(PlayerEvent.GIRD_WALK_START, this));
				}
			}
		}

		/**
		 * 把人物当前坐标和下两个目标点发给服务器
		 * @param nextPoint
		 *
		 */
		protected function walkStartSendServer():void
		{
			_serverPoints.length = 0;
			var sp:SPoint = new SPoint();
			sp.x = this.x2d;
			sp.y = this.y2d;
			_serverPoints.push(sp);
//			Log.debug("开始发送给服务器：", sp.x, sp.y,getTimer());

			sp = new SPoint();
			sp.x = _nextPoint._x;
			sp.y = _nextPoint._y;
			_serverPoints.push(sp);
//			Log.debug("开始发送给服务器：", sp.x, sp.y);

			if (_nextTwoPoint)
			{
				sp = new SPoint();
				sp.x = _nextTwoPoint._x;
				sp.y = _nextTwoPoint._y;
				_serverPoints.push(sp);
//				Log.debug("开始发送给服务器：", sp.x, sp.y);
			}
			if(!_isInServerMove)
			{
				dispatchEvent(new PlayerEvent(PlayerEvent.ServerPoint, this));
			}
			super.walkStart(_nextPoint);
			dispatchEvent(new PlayerEvent(PlayerEvent.WALK_START, this));
		}

		private function checkIsCanWalk(col:int, row:int):int
		{
			var value:int = AstarAnyDirection.mapData[col][row];
			if (value > 0 && value < 5)
			{

				return 1;
			}
			return 0;
		}

		protected var _isInServerMove:Boolean = false;
		public function set inServerMove(value:Boolean):void
		{
			_isInServerMove = value;
		}
		
		override public function walking(pointAry:Array):void
		{
			if (isInitInfo == false || this.isDead)
			{
				return;
			}
			if (pointAry.length == 0)
			{
				return;
			}
			_pathArray = pointAry.concat();
			_nextTwoPoint = null;
			_nextPoint = null;
			if (_isMove == false)
			{
				startMove();
				nextPathPoint(true);
				_nextTwoPoint = cutPoint(_nextPoint._x, _nextPoint._y);
				this.direction = _speed.direction;
			}
			else
			{
				nextPathPoint(false);
				_nextTwoPoint = cutPoint(_nextPoint._x, _nextPoint._y);
				this.direction = _speed.direction;
			}
			walkStartSendServer();
		}

		/**
		 * 停止移动 
		 * 
		 */		
		override public function stopWalking():void
		{
			super.stopWalking();
		}
		
		public function stopWalkSendPoint():void
		{
			_serverPoints.length = 0;
			var sp:SPoint = new SPoint();
			sp.x = this.x2d;
			sp.y = this.y2d;
			_serverPoints.push(sp);
			_serverPoints.push(sp);
			if(!_isInServerMove)
			{
				dispatchEvent(new PlayerEvent(PlayerEvent.ServerPoint, this));
			}	
		}
		
		override protected function get speedCorrectPer():Number
		{
			return 1;
		}

		override protected function walkGridEnd():void
		{
			super.walkGridEnd();
			if(_nextPoint)
			{
				updateSceneXY();
			}
			dispatchEvent(new PlayerEvent(PlayerEvent.GIRD_WALK_END, this));
		}

		/**
		 * 是否在安全区域更新显示 
		 * 
		 */
		override protected function updateIsInSafeArea():void
		{
			ThingUtil.isNameChange = true;
		}
		
		override protected function walkEnd():void
		{
			super.walkEnd();
			dispatchEvent(new PlayerEvent(PlayerEvent.WALK_END, this));
			SceneRange.randomBgSpeed();
		}

		override protected function onMove():void
		{
			super.onMove();
			ThingUtil.isMoveChange = true;
			updateSceneXY();
//			Log.debug(SceneRange.display,this.x2d,this.y2d);
		}

		private function updateSceneXY():void
		{
			if(Game.scene.isInLockScene)
			{
				return;
			}
//			Log.debug("updateSceneXY",SceneRange.display,this.x2d,this.y2d);
			//不在地图缓冲区，需要移动地图
			if (SceneRange.noMoveMap.contains(this.x2d, this.y2d) == false)
			{
				//trace(SceneRange.moveMap);
				// 在可移动范围内 自由滚动
				if (SceneRange.moveMap.contains(this.x2d, this.y2d))
				{
					_scrollRect.x += _speed.xSpeed;
					_scrollRect.y += _speed.ySpeed;
					//					if(!Global.isActivate)
					//					{
					//						trace("场景移动",_speed.xSpeed,_speed.ySpeed);
					//					}
					Game.scene.scrollRect = _scrollRect;
					return;
				}
				else
				{
					var isUpdate:Boolean = false;
					_scrollRect.x += _speed.xSpeed;
					_scrollRect.y += _speed.ySpeed;
					// 在边角不需要移动地图
					if (_scrollRect.right < SceneRange.map.right && _scrollRect.left > SceneRange.map.left)
					{
						var left1Pos:Number, left2Pos:Number, left3Pos:Number;

						left1Pos = (_scrollRect.width - SceneRange.noMoveMap.width) * 0.5;
						//left2Pos = _scrollRect.width *0.5;
						left3Pos = (_scrollRect.width + SceneRange.noMoveMap.width) * 0.5

						if (this.x2d < left1Pos)
						{
							_scrollRect.x -= _speed.xSpeed;
						}
						else if (this.x2d < left3Pos)
						{
							//向右跑
							if (_speed.xSpeed > 0)
							{
								_scrollRect.x -= _speed.xSpeed;
							}
							else
							{
								isUpdate = true;
							}
						}
						else
						{
							if (this.x2d > SceneRange.map.right - left3Pos)
							{
								//向左跑
								if (_speed.xSpeed < 0)
								{
									_scrollRect.x -= _speed.xSpeed;
								}
								else
								{
									isUpdate = true;
								}
							}
							else if (this.x2d >= SceneRange.map.right - left1Pos)
							{
								_scrollRect.x -= _speed.xSpeed;
							}
							else
							{
								isUpdate = true;
							}
						}
					}
					else
					{
						_scrollRect.x -= _speed.xSpeed;
					}

					if (_scrollRect.bottom < SceneRange.map.bottom && _scrollRect.top > SceneRange.map.top)
					{
						var top1Pos:Number, top3Pos:Number;

						top1Pos = (_scrollRect.height - SceneRange.noMoveMap.height) * 0.5;
						top3Pos = (_scrollRect.height + SceneRange.noMoveMap.height) * 0.5

						if (this.y2d < top1Pos)
						{
							_scrollRect.y -= _speed.ySpeed;
						}
						else if (this.y2d < top3Pos)
						{
							//向下跑
							if (_speed.ySpeed > 0)
							{
								_scrollRect.y -= _speed.ySpeed;
							}
							else
							{
								isUpdate = true;
							}
						}
						else
						{
							if (this.y2d > SceneRange.map.bottom - top3Pos)
							{
								//向上跑
								if (_speed.ySpeed < 0)
								{
									_scrollRect.y -= _speed.ySpeed;
								}
								else
								{
									isUpdate = true;
								}
							}
							else if (this.y2d >= SceneRange.map.bottom - top1Pos)
							{
								_scrollRect.y -= _speed.ySpeed;
							}
							else
							{
								isUpdate = true;
							}
						}
					}
					else
					{
						_scrollRect.y -= _speed.ySpeed;
					}
					//					if (isUpdate)
					//					{
					if (_scrollRect.left < SceneRange.map.left)
					{
						_scrollRect.x = int(SceneRange.map.left + this.x2d - this.x2d);
					}
					else if (_scrollRect.right > SceneRange.map.right)
					{
						_scrollRect.x = int(SceneRange.map.right - _scrollRect.width + this.x2d - this.x2d - 1);
					}

					if (_scrollRect.top < SceneRange.map.top)
					{
						_scrollRect.y = int(SceneRange.map.top + this.y2d - this.y2d);
					}
					else if (_scrollRect.bottom > SceneRange.map.bottom)
					{
						_scrollRect.y = int(SceneRange.map.bottom - _scrollRect.height  + this.y2d - this.y2d - 1);
					}
					Game.scene.scrollRect = _scrollRect;
						//					}
				}
			}
		}
		override public function set isDead(value:Boolean):void
		{
			if (value != _isDead)
			{
				super.isDead = value;
				if (value == false)
				{
					Log.error("人物复活");
					isCanControlWalk = true;
					isCanControlReleaseMagic = true;
					isCanControlAttack = true;
					stopMove();
					dispatchEvent(new PlayerEvent(PlayerEvent.ENTITY_Relived, this));
				}
				else
				{
					Log.error("人物躺下");
					dispatchEvent(new PlayerEvent(PlayerEvent.ENTITY_DEAD, this));
				}
			}
		}

		override public function hoverTest(disPlayX:Number,disPlayY:Number,mouseX:Number,mouseY:Number):Boolean
		{
			return false;
		}
		
		/**
		 * 更新头顶部分显示与隐藏
		 * 
		 */
		override public function updateHeadContainer():void
		{
			//一些显示与隐藏的判断条件
			var isInLayer:Boolean = this.parent != null;
			var isHideTitle:Boolean = SystemSetting.instance.isHideTitle.bValue;
			var isHideGuildName:Boolean = SystemSetting.instance.isHideGuildName.bValue;
			
			//显示隐藏
			_headContainner.updateBloodVisible(isInLayer);
			_headContainner.updateGuildVisible(isInLayer && !isHideGuildName);
		}
		
		public function addToLayer():void
		{
			if (Game.scene.playerLayer.contains(this) == false)
			{
				Game.scene.playerLayer.addChild(this);
				/*var t:Stext3DBox=SText3DFactory.instance.createtext3D("碾压-230(吸收5392)",ENumberTextColor.red);
				this.addChild(t);
				t.y=250;*/
			}
		}
	}
}
