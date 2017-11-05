package mortal.game.scene3D.player.entity
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TBuff;
	import Message.Public.SPoint;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.utils.ArrayUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ModelAttackFrameConfig;
	import mortal.game.resource.info.ModelAttackFrameInfo;
	import mortal.game.resource.tableConfig.BuffConfig;
	import mortal.game.scene3D.display3d.text3d.staticText3d.SText3DFactory;
	import mortal.game.scene3D.display3d.text3d.staticText3d.Stext3DBox;
	import mortal.game.scene3D.display3d.text3d.staticText3d.action.ActionVo;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.fight.FightUpdateAttribtue;
	import mortal.game.scene3D.fight.SkillEffectUtil;
	import mortal.game.scene3D.layer3D.SLayer3D;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.MapNodeType;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.Speed;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.model.SceneGlobalPlayer;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.player.head.HeadContainer;
	import mortal.game.scene3D.player.head.TalkSprite;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.ResjsInfo;
	import mortal.game.view.chat.data.FaceAuthority;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.Dispatcher;

	public class SpritePlayer extends Game2DPlayer implements IUser
	{
		protected var _isInitInfo:Boolean = false;

		private var _selected:Boolean;

		//当前动作具体名字
		protected var _actionName:String = "stand";
		//当前动作类型
		protected var _actionType:String = "stand";
		
		protected var _speed:Speed;

		protected var _entityInfo:EntityInfo;

		protected var sentityInfo:SEntityInfo;

		protected var _reserveJs:ResjsInfo;

		protected var _inMount:Boolean = false;
		
		public var camp:int; //阵营
		public var career:int; //职业
		public var sex:int; //性别

		private var _entityStatus:EntityStatus;

		public var pointChangeHandler:Function;

		protected var _bodyPlayer:ActionPlayer;

		protected var _targetDirection:Number;

		protected var _entityID:String = "";
		
		protected var _playerList:Vector.<Mesh3D> = new Vector.<Mesh3D>();

		protected var _headContainner:HeadContainer;
		
		protected var _timer:FrameTimer;
		
		private static const actionVoParams:ActionVo=new ActionVo();
		
		public function SpritePlayer()
		{
			super();
			_entityStatus = new EntityStatus();
			_speed = new Speed();
			this.timerContorler=TimeControler.createTimerInstance();
			initHeadContainer();
			initPlayers();
			//飘字
			_timer = new FrameTimer(3);
			_timer.addListener(TimerType.ENTERFRAME,onFightEnterFrame);
			scaleValue = 1;
		}

		public function get entityID():String
		{
			return _entityID;
		}

		protected function updateID():void
		{
			_entityID = EntityUtil.toString(_entityInfo.entityInfo.entityId);
		}

		public function get type():int
		{
			return 0;
		}

		override public function set y(value:Number):void
		{
			super.y = value;
		}

		override public function hoverTest(disPlayX:Number,disPlayY:Number,mouseX:Number,mouseY:Number):Boolean
		{
			var recWidth:Number = 60;
			var recHeight:Number = 110;
			if(_bodyPlayer)
			{
				recWidth *= _bodyPlayer.scaleX;
				recHeight *= _bodyPlayer.scaleY;
			}
			_displayRec.x = this.x2d - disPlayX - recWidth/2;
			_displayRec.y = this.y2d - disPlayY - recHeight;
			_displayRec.width = recWidth;
			_displayRec.height = recHeight;
			return _displayRec.contains(mouseX,mouseY);
		}

		public function set selected(value:Boolean):void
		{
			if(_selected == value)
			{
				return;
			}
			var selectPlayer:EffectPlayer = SceneGlobalPlayer.selectPlayerMask;
			_selected = value;
			if(value)
			{
				if(this.contains(selectPlayer) == false)
				{
					this.addChild(selectPlayer);
					selectPlayer.play(true);
				}
			}
			else
			{
				if(this.contains(selectPlayer))
				{
					selectPlayer.stop();
					this.removeChild(selectPlayer);
				}
			}
			Dispatcher.dispatchEvent(new DataEvent(EventName.Player_Selected, this));
			updateHeadContainer();
		}

		public function get selected():Boolean
		{
			return _selected;
		}

//		public function show():void
//		{
//			var len:int = this.children.length;
//			for(var i:int = 0;i < len;i++)
//			{
//				this.children[i].isHide = false;
//			}
//		}
//		
//		public function hide():void
//		{
//			var len:int = this.children.length;
//			for(var i:int = 0;i < len;i++)
//			{
//				this.children[i].isHide = true;
//			}
//		}
		
		public function addToStage( layer:SLayer3D ):Boolean
		{
			if( !layer.contains(this) )
			{
				layer.addChild(this);
				updateHeadContainer();
				return true;
			}
			return false;
		}
		
		public function removeFromStage( layer:SLayer3D ):Boolean
		{
			if( this.parent == layer )
			{
				layer.removeChild(this);
				updateHeadContainer();
				return true;
			}
			return false;
		}
		
		override public function onMouseOut():void
		{
			var i:int;
			for(i = 0;i < _playerList.length;i++)
			{
				Device3D.scene.removeSelectObject(_playerList[i],false);
			}
		}
		
		override public function onMouseOver():void
		{
			var i:int;
			for(i = 0;i < _playerList.length;i++)
			{
				Device3D.scene.addSelectObject(_playerList[i],false);
			}
		}

		public function attack(value:String):void
		{
			var startAttackFrame:int = 0;
			var modelAttackFrame:ModelAttackFrameInfo = ModelAttackFrameConfig.instance.getAttackFrameInfo(this.career,this.sex,_actionName);
			var modelAttackFrameNew:ModelAttackFrameInfo = ModelAttackFrameConfig.instance.getAttackFrameInfo(this.career,this.sex,value);
			//原来也是攻击动作,判断连击操作
			if(modelAttackFrame && GameDefConfig.instance.isAttackBatter(_actionName,value))
			{
				if(modelAttackFrameNew && _bodyPlayer.currentFrame > modelAttackFrame.handsEndFrame && _bodyPlayer.currentFrame <= modelAttackFrame.waitEndFrame)
				{
					startAttackFrame = modelAttackFrameNew.handsEndFrame + 1;
				}
			}
			var fireFrame:int = _bodyPlayer.getAttackFrame(value);
			if(fireFrame != 0)
			{
				_bodyPlayer.addFrameScript(value,fireFrame,onFightHandler);
			}
			else
			{
				onFightHandler();
			}
			setAction(ActionType.attack,value);
			_bodyPlayer.gotoFrame(startAttackFrame);
		}
		
		private function onFightHandler():void
		{
			this.dispatchEvent( new PlayerEvent(PlayerEvent.PLAYER_FIRE,this) );
		}
		
		/**
		 * 获取当前动作名字 
		 * @return 
		 * 
		 */
		public function get actionName():String
		{
			return _actionName;
		}
		
		/**
		 * 获取当前动作类型 
		 * @return 
		 * 
		 */		
		public function get actionType():String
		{
			return _actionType;
		}
		
		/**
		 * 切换动作类型和名字(外部调用设置切换动作)  isForce目前只用于针对旋风斩动作
		 * @param actionType
		 * @param actionName
		 * 
		 */		
		public function setAction(actionType:String,actionName:String,isForce:Boolean = false):void
		{
			if(_actionName == actionName)
			{
				return;
			}
			
			if( actionType == ActionType.Death )  //死亡
			{
				refreshActionType( ActionType.Death);
				refreshActionName( ActionName.Death);
			}
			else if(!this.isDead)
			{
				if(actionType == ActionType.Injury ) //受伤
				{
					//只有站立的时候才播放受伤动作
					if( !_inMount && _actionType == ActionType.Stand)
					{
						refreshActionType( ActionType.Injury );
						refreshActionName( ActionName.Injury );
					}
				}
				else if(actionType == ActionType.leading)
				{
					//旋风斩不需要引导动作
					if(ActionType.isLeadStartAction(_actionName) || actionName == ActionName.Tornado)
					{
						refreshActionType( ActionType.leading );
						refreshActionName(actionName );
					}
				}
				//旋风斩 是只能强制切换
				else if( actionType == ActionType.Stand) //站立
				{
					if(_actionName != ActionName.Tornado || isForce)
					{
						refreshActionType(ActionType.Stand);
						updateActionName();
					}
				}
				else if( actionType == ActionType.Walking ) //走动
				{
					if(_actionName != ActionName.Tornado || isForce)
					{
						refreshActionType(ActionType.Walking);
						updateActionName();
					}
				}
				else
				{
					refreshActionType(actionType);
					refreshActionName(actionName);
				}
			}
		}
		
		/**
		 * 更新状态名字（最终确认更新）
		 * 
		 */
		protected function refreshActionName(value:String):void
		{
			if(_actionName == value)
			{
				return;
			}
			var lastActionName:String = _actionName;
			var lastFrame:int = _bodyPlayer.currentFrame;
			
			_actionName = value;
			_bodyPlayer.changeAction(_actionName);
			_bodyPlayer.play();
			//吟唱动作开始播放
			if(ActionType.isLeadingAction(_actionName))
			{
				this.dispatchEvent( new PlayerEvent(PlayerEvent.PLAYER_LEADING,this) );
			}
			if(ActionType.isLeadingAction(lastActionName))
			{
				this.dispatchEvent( new PlayerEvent(PlayerEvent.PLAYER_LEADING_END,this) );
			}
			
			if( ActionType.isAttackAction(lastActionName) )
			{
				var fireFrame:int = _bodyPlayer.getAttackFrame(lastActionName);
				if(fireFrame != 0 && lastFrame <= fireFrame)
				{
					onFightHandler();
				}
			}
			updateNamePosition();
		}
		
		/**
		 * 更新名字位置 
		 * 
		 */		
		protected function updateNamePosition():void
		{
			if(_bodyPlayer.hasBone(_headContainner.hangBoneName))
			{
				_headContainner.y = _bodyPlayer.targetMd5Controler.skeletoAnimator.getBoneGlobleJointByName(_headContainner.hangBoneName).translation.y;
			}
			else
			{
				_headContainner.y = 150;
			}
		}
		
		/**
		 * 更新状态类型 （最终确认更新）
		 * 
		 */		
		protected function refreshActionType(value:String):void
		{
			if(_actionType == value)
			{
				return;
			}
			_actionType = value;
		}
		
		/**
		 * 刷新动作 由上下坐骑，进入结束战斗、游泳等一些操作触发 
		 * 
		 */
		protected function updateActionName():void
		{
			if(_actionType == ActionType.Walking)
			{
				refreshActionName(ActionName.Walking);
			}
			if(_actionType == ActionType.Stand)
			{
				refreshActionName(ActionName.Stand);
			}
		}

		private var _insertTime:int;
		private var _insertAngle:Number;
		protected var _direction:Number = 0;

		override public function update():void
		{
			if(_insertTime > 0)
			{
				if(_insertTime > 1)
				{
					updateDirection(_direction + _insertAngle);
					_insertTime--;
				}
				else
				{
					updateDirection(_targetDirection);
					_insertTime = 0;
				}
			}
			
			super.update();
		}

		public function updateDirection(value:Number):void
		{
			if(value > 180)
			{
				value -= 360;
			}
			else if(value < -180)
			{
				value += 360;
			}
			_direction = value;
			updateBodyDirection();
		}

		protected function updateBodyDirection():void
		{
			if(_bodyPlayer)
			{
				_bodyPlayer.direction = _direction;
			}
		}
		
		override public function set direction(value:Number):void
		{
			var difAngle:Number;
			_targetDirection = value;
			difAngle = _targetDirection - _direction;
			if(difAngle > 180)
			{
				difAngle -= 360;
			}
			else if(difAngle < -180)
			{
				difAngle += 360;
			}
			_insertTime = Math.abs(Math.floor((difAngle) / 12));
			_insertTime = _insertTime < 6?6:_insertTime;
			_insertTime = _insertTime > 12?12:_insertTime;
			_insertAngle = difAngle / _insertTime;
			if(_insertTime == 0)
			{
				updateDirection(_targetDirection);
			}
		}

		override public function get direction():Number
		{
			return _direction;
		}

		public function hurt(value:int):void
		{
			if( _isDead || life <= 0 )
			{
				_isDead = true;
				delayLifeDeath();
			}
			if( value == 0  ) return;
		}

		//用于怪物播放死亡特效
		protected function delayLifeDeath():void
		{
			
		}
		
		
		public function cutHurtImpl(fightUpdateAttribute:FightUpdateAttribtue):void
		{
			addToTweenCache(fightUpdateAttribute);
		}
		
		//处理不叠加
		private var vcFightUpdateAttribtue:Vector.<FightUpdateAttribtue>=new Vector.<FightUpdateAttribtue>();
		
		private function addToTweenCache(fightUpdateAttribute:FightUpdateAttribtue):void
		{
			//缓存池不为空或者 最后一次播放时间距离现在很近
			if(_timer.running)
			{
				//最多堆积20条记录
				if(vcFightUpdateAttribtue.length <= 20)
				{
					vcFightUpdateAttribtue.push(fightUpdateAttribute);
				}
			}
			else
			{
				tween(fightUpdateAttribute);
				_timer.start();
			}
		}
		
		private function onFightEnterFrame(timer:FrameTimer):void
		{
			tweenNext();
		}
		
		/**
		 * 缓动一个飘字 
		 * @param text
		 * 
		 */		
		private function tween(fightUpdateAttribute:FightUpdateAttribtue):void
		{
			//处理飘字
			actionVoParams.reInit(fightUpdateAttribute.textDirection,fightUpdateAttribute.fromX,fightUpdateAttribute.fromY - 80,fightUpdateAttribute.toX,fightUpdateAttribute.toY - 80);
			var text3DBox:Stext3DBox = SText3DFactory.instance.createtext3D(fightUpdateAttribute.getText(),fightUpdateAttribute.getColor(),this,actionVoParams);
			text3DBox.y = 100;
			text3DBox.x =  -int(text3DBox.textWidth/2);
		}
		
		/**
		 *  
		 * 飘下一个
		 */		
		private function tweenNext():void
		{
			if (vcFightUpdateAttribtue.length > 0)
			{
				var FightUpdateAttribtueNext:FightUpdateAttribtue = vcFightUpdateAttribtue.shift();
				tween(FightUpdateAttribtueNext);
			}
			else
			{
				_timer.stop();
			}
		}
		
		public function updateInfo(info:Object, isAllUpdate:Boolean = true):void
		{
			_entityInfo = info as EntityInfo;
//			Log.debug(_entityInfo.entityInfo.code);
			sentityInfo = _entityInfo.entityInfo;
			initPlayers();
			_isDead = sentityInfo.life <= 0;
			if(sentityInfo == null)
				return;

			if(sentityInfo.reserveJs != null && sentityInfo.reserveJs != "" && sentityInfo.reserveJs != "null\n")
			{
				reserveJs.putObject(JSON.parse(sentityInfo.reserveJs));
			}

			_isInitInfo = true;

			updateID();
			var sp:SPoint = sentityInfo.points[0] as SPoint;
			setPixlePoint(sp.x, sp.y);
			
			//更新显示相关
			updateOther(sentityInfo);
			updateCCS(sentityInfo, false);
			updateBuffers(sentityInfo.buffs);
//			updateFightMode(sentityInfo.fightMode);
			updateLevel(sentityInfo.level, false);
			updateLife(sentityInfo.life, sentityInfo.maxLife);
			updateMana(sentityInfo.mana, sentityInfo.maxMana);
//			updateTitleMain( sentityInfo.titles );
			updateRoleActionName();//比如跑商

			updateSpeed(sentityInfo.speed);
//			updateGroupStatus(sentityInfo.groupStatus);
			if(sentityInfo.direction > 0)
			{
				direction = sentityInfo.direction;
			}
			updateStatus(sentityInfo.status);//比如采集
			updateFighting(false);
			updateName(sentityInfo.name);
			updateGuildName();
			updateMount(sentityInfo.mountCode);
			updateClothes(_entityInfo.clothes);
			updateWeapons(_entityInfo.weapon);
			updateDisappear();
			updateHeadContainer();
			
			_entityInfo.resetUpdateState();
			this.dispatchEvent(new PlayerEvent(PlayerEvent.UPDATEINFO, this));
		}

		/**
		 * 更新显示 
		 * 
		 */
		public function updateDisplay():void
		{
			if(_isInitInfo && _entityInfo.isUpdate)
			{
				if(_entityInfo.isUpdateName)
				{
					updateName(sentityInfo.name);
				}
				if(_entityInfo.isUpdateGuildName)
				{
					updateGuildName();
				}
				if(_entityInfo.isUpdateLife)
				{
					updateLife(sentityInfo.life, sentityInfo.maxLife);
				}
				if(_entityInfo.isUpdateSpeed)
				{
					updateSpeed(sentityInfo.speed);
				}
				if(_entityInfo.isUpdateFighting)
				{
					updateFighting(false);
				}
				if(_entityInfo.isUpdateBuffer)
				{
					updateBuffers(sentityInfo.buffs);
				}
				if(_entityInfo.isUpdateMount)
				{
					updateMount(sentityInfo.mountCode);
				}
				if(_entityInfo.isUpdateDirection)
				{
					this.direction = _entityInfo.entityInfo.direction;
				}
				if(_entityInfo.isUpdateDisappear)
				{
					updateDisappear();
				}
				if(_entityInfo.isUpdateClothes)
				{
					updateClothes(_entityInfo.clothes);
				}
				if(_entityInfo.isUpdateWeapon)
				{
					updateWeapons(_entityInfo.weapon);
				}
				if(_entityInfo.isUpdateCCS)
				{
					updateCCS(_entityInfo.entityInfo);
				}
				_entityInfo.resetUpdateState();
			}
		}
		
		public function get reserveJs():ResjsInfo
		{
			if(_reserveJs == null)
			{
				_reserveJs = new ResjsInfo();
			}
			return _reserveJs;
		}

		protected function initPlayers():void
		{
			if(!_bodyPlayer)
			{
				_bodyPlayer = ObjectPool.getObject(ActionPlayer);
				_bodyPlayer.changeAction(ActionName.Stand);
				_actionName = ActionName.Stand;
				_actionType = ActionType.Stand;
				_bodyPlayer.hangBoneName = "guazai001";
				_bodyPlayer.selectEnabled = true;
				_bodyPlayer.timerContorler=this.timerContorler;
				_bodyPlayer.play();
				_bodyPlayer.addEventListener(Engine3dEventName.InitComplete,onInitBodyPlayer);
				_playerList.push(_bodyPlayer);
			}
			this.timerContorler.active();
			this.addChild(_bodyPlayer);
		}
		
		protected function initHeadContainer():void
		{
			_headContainner = new HeadContainer();
			_headContainner.y = 150;
			this.addChild(_headContainner);
		}

		/*protected function initShadow():void
		{
			shadow = ShadowFactory.createshadow3D();
			this.addChild(shadow);
		}*/
		
		protected function onInitBodyPlayer(e:Event):void
		{
			if(_bodyPlayer)
			{
				if(_isDead)
				{
					actionType == ActionType.Death;
					this.refreshActionName(ActionName.Death);
//					_bodyPlayer.currentFrame = _bodyPlayer.getActionFrameLen(ActionName.Death) - 1;
					_bodyPlayer.gotoFrame(_bodyPlayer.getActionFrameLen(ActionName.Death) - 1);
					_bodyPlayer.stop();
				}
				addFrameComplete();
				updateNamePosition();
			}
		}
		
		protected function addFrameComplete():void
		{
			var i:int;
			var length:int = ActionName.attackActionList.length;
			//添加攻击动作执行完毕事件
			for(i = 0;i < length;i++)
			{
				_bodyPlayer.addFrameComplete(ActionName.attackActionList[i],onFrameComplete);
			}
			//添加吟唱起始执行完毕事件
			for(var key:String in ActionName.leadActionDic)
			{
				_bodyPlayer.addFrameComplete(key,onFrameComplete);
			}
			_bodyPlayer.addFrameComplete(ActionName.Injury,onFrameComplete);
			_bodyPlayer.addFrameComplete(ActionName.Jump,onFrameComplete);
			_bodyPlayer.addFrameComplete(ActionName.Somersault,onFrameComplete);
			_bodyPlayer.addFrameComplete(ActionName.Death,onFrameComplete);
		}
		
		protected function onFrameComplete():void
		{
			if(!_bodyPlayer)
			{
				return;
			}
			if(_actionType == ActionType.attack || _actionType == ActionType.Injury || _actionType == ActionType.Jump)
			{
				setAction(ActionType.Stand,ActionName.Stand);
			}
			else if(ActionType.isLeadStartAction(_bodyPlayer.actionName))
			{
				setAction(ActionType.leading,ActionName.leadActionDic[_bodyPlayer.actionName]);
			}
		}
		
		/**
		 * 播放一个动作后执行第二个动作，用于吟唱开始 
		 * @param action1
		 * @param action2
		 * 
		 */		
		protected function addFrameNextAction(actionName1:String,actionType2:String,actionName2:String):void
		{
			_bodyPlayer.addFrameComplete(actionName1,onFrameActionComplete);
			
			function onFrameActionComplete():void
			{
				setAction(actionType2,actionName2);
				_bodyPlayer.removeFrameComplete(actionName1,onFrameActionComplete);
			}
		}
		
		protected function set scaleValue(value:Number):void
		{
			_bodyPlayer.scaleX = value;
			_bodyPlayer.scaleY = value;
			_bodyPlayer.scaleZ = value;
		}

		public function get entityInfo():EntityInfo
		{
			return _entityInfo;
		}

		/**
		 * 玩家状态信息
		 * @return
		 *
		 */
		public function get entityStatus():EntityStatus
		{
			return _entityStatus;
		}

		/**
		 * 当前所处的点的数据
		 * @param x
		 * @param y
		 * @return
		 *
		 */
		protected function getPointValue(x:int, y:int):int
		{
			return GameMapUtil.getPointValue(x, y);
		}

		protected function updateAlpha(type:int):void
		{
			this.isAlpha = MapNodeType.isAlpha(type);
		}

		/**
		 * 透明度设置
		 */
		private var _isAlpha:Boolean = false;

		/**
		 * 设置是否透明
		 * @param value
		 */
		public function set isAlpha(value:Boolean):void
		{
			if(_isAlpha != value)
			{
				_isAlpha = value;
			}
			updateAlphaImpl();
		}

		public function get isAlpha():Boolean
		{
			return _isAlpha;
		}
		
		/**
		 * 更新alpha 
		 * 
		 */		
		protected function updateAlphaImpl():void
		{
			var obj:*;
			var alpha:Number = 1;
			if( _entityInfo.isDisappear)
			{
				alpha = 0.2;
			}
			else if( _isAlpha )
			{
				alpha = 0.5;
			}
			else
			{
				alpha = 1;
			}
			for each(obj in _playerList)
			{
				obj.alpha = alpha;
			}
		}

		public function get isInitInfo():Boolean
		{
			return _isInitInfo;
		}

		protected function move():void
		{
			//播放移动动作
			setAction(ActionType.Walking,ActionName.Walking);
		}

//		/**
//		 * 设置格子坐标 
//		 * @param x
//		 * @param y
//		 * 
//		 */		
//		public function setTitlePoint( x:int,y:int,isStop:Boolean = true):void
//		{
//			var p:Point = GameMapUtil.getPixelPoint(x,y);
//			this.x2d = p.x;
//			this.y2d = p.y;
//			var type:int = getPointValue(x,y);
//			updateAlpha(type);
//		}

		/**
		 * 更新其他
		 * @param info
		 * @param isAllUpdate
		 * 
		 */		
		protected function updateOther( info:SEntityInfo,isAllUpdate:Boolean = true ):void
		{
			
		}
		
		/**
		 * 设置像素坐标
		 * @param x
		 * @param y
		 * @param isDelay
		 *
		 */
		public function setPixlePoint(x:int, y:int, isDelay:Boolean = true, isStop:Boolean = true):void
		{
//			var p:Point=GameMapUtil.getTilePoint(x, y);
//			setTitlePoint( p.x ,p.y,isStop );
			this.x2d = x;
			this.y2d = y;
			if(pointChangeHandler is Function)
			{
				pointChangeHandler();
			}
		}

		protected var _isDead:Boolean = false;

		/**
		 * 是否死亡了
		 * @return
		 *
		 */
		public function get isDead():Boolean
		{
			return _isDead;
		}

		public function set isDead(value:Boolean):void
		{
			if(_isDead != value)
			{
				_isDead = value;
			}
		}

		/**
		 * 移动
		 *
		 */
		public function walking(pointAry:Array):void
		{
			move();
		}

		/**
		 * 转向
		 * @param pointAry
		 *
		 */
		public function diversion(pointAry:Array):void
		{
			move();
		}

		private var _talkClearDate:Date;
		private var _talkText:TalkSprite;
		
		public function talk(value:String,time:Number = 5000):void
		{
			if(value!= null && value != "" )
			{
				if( _talkText == null )
				{
					_talkText = UICompomentPool.getUICompoment(TalkSprite);
				}
				
				if(_talkClearDate)
				{
					ClockManager.instance.removeDateCall(_talkClearDate);
				}
				_talkClearDate = ClockManager.instance.getDelayDate(time);
				ClockManager.instance.addDateCall(_talkClearDate,timeoutClearTalk);
				
				LayerManager.entityTalkLayer.addPopUp(_talkText);
				
				_talkText.faceAuthortiy = faceAuthority;
				_talkText.text = value;
				updateTalkXY();
			}
			else
			{
				clearTalk();
			}
		}

		protected function timeoutClearTalk():void
		{
			LayerManager.entityTalkLayer.removeTalk(this);
		}
		
		public function clearTalk():void
		{
			if(_talkText)
			{
				LayerManager.entityTalkLayer.removePopup(_talkText);
				_talkText.dispose();
				_talkText = null;
				if(_talkClearDate)
				{
					ClockManager.instance.removeDateCall(_talkClearDate);
					_talkClearDate = null;
				}
			}
		}
		
		/**
		 * 更新talk的位置 
		 * 
		 */		
		public function updateTalkXY():void
		{
			if(_talkText)
			{
				var x1:int = this.x2d - SceneRange.display.x;
				var y1:int = this.y2d - SceneRange.display.y - 180;
				_talkText.x = x1;
				_talkText.y = y1;
			}
		}
		
		public function get toRoleDistance():Number
		{
			var xx:Number = this.x2d - RolePlayer.instance.x2d;
			var yy:Number = this.y2d - RolePlayer.instance.y2d;
			return xx*xx+yy*yy;
		}

		public function updateWeapons(value:int):void
		{

		}

		public function updateClothes(value:int):void
		{

		}

		public function updateStatus(value:int, isInit:Boolean = true):void
		{

		}

		protected function updateFighting(isTip:Boolean = true):void
		{
			if(entityInfo.fighting == false)
			{
				entityStatus.isAttackRole = false;
			}
			updateActionName();
		}

		protected function updateRoleActionName():void
		{

		}

		public function updateSpeed(value:int):void
		{
			_speed.timeSpeed = value;
		}

		protected function updateGroupStatus(state:int):void
		{

		}

		public function updateFightMode(value:int):void
		{
//			_entityInfo.entityInfo.fightMode  = value;
//			typeUpdate.isUpdateName = true;
		}

		public function updateLevel(value:int, update:Boolean):void
		{

		}

		public function updateCCS(info:SEntityInfo, isUpdate:Boolean = false):void
		{
			camp = info.camp;
			career = info.career;
			sex = info.sex;
		}

		/**
		 * 更新状态 
		 * @param value
		 * 
		 */
		protected function updateBuffers(value:Array):void // 更新buffer 
		{
			var currentUrlAry:Array = [];
			for each(var iBufferId:int in value)
			{
				var buff:TBuff = BuffConfig.instance.getInfoById(iBufferId);
				if(buff && buff.specialEffectId)
				{
					if(currentUrlAry.indexOf(buff.specialEffectId) == -1)
					{
						currentUrlAry.push(buff.specialEffectId);
					}
				}
			}
			
			var addAry:Array = ArrayUtil.cut(currentUrlAry,_oldBuffUrlAry);
			var removeAry:Array = ArrayUtil.cut(_oldBuffUrlAry,currentUrlAry);
			var i:int;
			for(i = 0;i < addAry.length;i++)
			{
				addStateModel(addAry[i]);
			}
			for(i = 0;i < removeAry.length;i++)
			{
				removeStateModel(addAry[i]);
			}
			_oldBuffUrlAry = currentUrlAry;
		}
		
		/**
		 * 更新坐骑 
		 * @param value
		 * 
		 */		
		public function updateMount(value:int):void
		{
			
		}

		/**
		 * 更新是否隐身状态 
		 * 
		 */		
		public function updateDisappear():void
		{
			updateAlphaImpl();
		}
		
		private function clearStateModel():void
		{
			var buffPlayer:EffectPlayer;
			for each(buffPlayer in _stateMap)
			{
				buffPlayer.dispose();
			}
			_stateMap = new Dictionary();
			_oldBuffUrlAry = [];
		}
		
		/**
		 * 添加状态 
		 * @param stateModelId
		 * 
		 */
		private var _oldBuffUrlAry:Array = [];
		private var _stateMap:Dictionary = new Dictionary();
		public function addStateModel( url:String ):void
		{
			if(SystemSetting.instance.isHideAllEffect.bValue)
			{
				return;
			}
			var buffPlayer:EffectPlayer = _stateMap[url] as EffectPlayer;
			if(!buffPlayer)
			{
				buffPlayer = EffectPlayerPool.instance.getEffectPlayer(url);
				_stateMap[url] = buffPlayer;
				SkillEffectUtil.addPlayerEffect(this,url,null,true);
			}
		}
		
		
		/**
		 * 删除状态 
		 * @param stateModelId
		 * 
		 */		
		public function removeStateModel( url:String ):void
		{
			var buffPlayer:EffectPlayer = _stateMap[url] as EffectPlayer;
			if( buffPlayer )
			{
				delete _stateMap[ url ];
				buffPlayer.dispose();
			}
		}
		
		/**
		 * 更新头顶部分显示与隐藏
		 * 
		 */
		public function updateHeadContainer():void
		{
			//一些显示与隐藏的判断条件
			var isInLayer:Boolean = this.parent != null;
			var isSelected:Boolean = this.selected;
			var isHideLife:Boolean = SystemSetting.instance.isHideLife.bValue;
			var isHideName:Boolean = SystemSetting.instance.isHideOterPlayerName.bValue;
			var isHideTitle:Boolean = SystemSetting.instance.isHideTitle.bValue;
			var isHideGuildName:Boolean = SystemSetting.instance.isHideGuildName.bValue;
			
			//显示隐藏
			_headContainner.updateBloodVisible(isInLayer && (!isHideLife || isSelected));
			_headContainner.updateNameVisible(isInLayer && (!((this is UserPlayer || this is PetPlayer) && isHideName && !isSelected)));
			_headContainner.updateGuildVisible(isInLayer && (!isHideGuildName && !(isHideName && !isSelected)));
		}
		
		/**
		 * 更新血条显示 
		 * @param life
		 * @param maxLife
		 * 
		 */
		public function updateLife(life:int, maxLife:int):void
		{
			_headContainner.updateLife(life,maxLife);
		}
		
		public function updateMana(mana:int, maxMana:int):void
		{
			
		}
		
		/**
		 * 更新名字显示 
		 * @param value
		 * @param isUpdate
		 * 
		 */		
		public function updateName(value:String = null, isUpdate:Boolean = true):void
		{
			_headContainner.updateName(value);
		}

		/**
		 * 更新公会名字显示
		 * 
		 */
		protected function updateGuildName():void
		{
			
		}
		
		/**
		 * 更新称号显示 
		 * @param titles
		 * 
		 */		
		protected function updateTitleMain(titles:Dictionary):void
		{
			
		}
		
		public function death(isEffect:Boolean = false):void
		{
			dispatchEvent(new PlayerEvent(PlayerEvent.ENTITY_DEAD, this));
			isDead = true;
			dispose();
		}

		public function get life():int
		{
			if( _entityInfo.entityInfo )
			{
				return _entityInfo.entityInfo.life;
			}
			return 0;
		}
		
		public function get stagePointX():Number
		{
			return x2d - SceneRange.display.x;
		}
		
		public function get stagePointY():Number
		{
			return y2d - SceneRange.display.y;
		}

		public function get faceAuthority():int	
		{
			return FaceAuthority.getFullAuthority();
//			return entityInfo.entityInfo.VIP > 0?FaceAuthority.getFullAuthority():FaceAuthority.NORMAL;
		}
		
		/**
		 * 播放动作 
		 * @param actionName
		 * 时间：毫秒
		 * 
		 */		
		public function playAction(actionName:String,isRepeat:Boolean,time:int = 0,callBack:Function = null):void
		{
			if(_bodyPlayer)
			{
				_bodyPlayer.changeAction(actionName);
				if(!isRepeat)
				{
					_bodyPlayer.addFrameComplete(actionName,onActionComplete);
				}
			}
			if(time > 0)
			{
				var date:Date = ClockManager.instance.getDelayDate(time);
				ClockManager.instance.addDateCall(date,onComplete);
			}
			
			function onComplete():void
			{
				onActionComplete();
			}
			
			function onActionComplete():void
			{
				setAction(ActionType.Stand,ActionName.Stand);
				
				if(callBack != null)
				{
					callBack.call();
				}
			}
		}
		
		/**
		 *
		 * @param isReuse  是否重用
		 *
		 */
		override public function dispose(isReuse:Boolean = true):void
		{
			setAction(ActionType.Stand,ActionName.Stand);
			pointChangeHandler = null;
			sentityInfo = null;
			_entityInfo = null;
//			entityInfo.entityInfo.msgEx = null;
			this.scaleValue = 1;
			
			this.timerContorler.unActive();
			
			if(ThingUtil.selectEntity == this)
			{
				ThingUtil.selectEntity = null;
			}
			_isDead = true;
			_entityStatus.clear();
			if(!isReuse)
			{
				TimeControler.disposeTimer(this.timerContorler);
			}
			_reserveJs = null;
			_bodyPlayer.removeEventListener(Engine3dEventName.InitComplete,onInitBodyPlayer);
			_bodyPlayer.dispose();
			_bodyPlayer = null;
			
			_headContainner.clear();
			_isAlpha = false;
			_speed.timeSpeed = 0;
			_targetDirection = 0;
			_actionName = "stand";
			_actionType = "stand";
			_entityID = "";
			_playerList = new Vector.<Mesh3D>();
			_direction = 0;
			clearStateModel();
			_inMount = false;
			LayerManager.entityTalkLayer.removeTalk(this);
			_timer.stop();
			super.dispose(isReuse);
		}

		public function get bodyPlayer():ActionPlayer
		{
			return _bodyPlayer;
		}

	}
}
