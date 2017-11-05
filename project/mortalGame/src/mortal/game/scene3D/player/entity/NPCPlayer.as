package mortal.game.scene3D.player.entity
{
	import baseEngine.system.Device3D;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.model.NPCInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.layer3D.SLayer3D;
	import mortal.game.scene3D.layer3D.utils.NPCUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.MapNodeType;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.model.SceneGlobalPlayer;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.player.head.HeadContainer;
	import mortal.game.scene3D.player.head.TalkSprite;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.chat.data.FaceAuthority;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * NPC
	 */
	public class NPCPlayer extends Game2DPlayer implements IEntity
	{
		private var _direction:int;
		
		private var _npcInfo:NPCInfo;
		
		private var _selected:Boolean;
		
		private var _entityInfo:EntityInfo;
		
		private var _taskStatus:int = -1;
		
		private var _bodyPlayer:ActionPlayer;
		
		private var _isHasSpecialStandBy:Boolean = false;
		
		private var _nextSecialDate:Date;
		
		private var _headContainner:HeadContainer;
		
		public function NPCPlayer()
		{		
			super();
			initHeadContainner();
			_entityInfo = ObjectPool.getObject(EntityInfo);
			overPriority = Game2DOverPriority.NPC;
			this.timerContorler=TimeControler.createTimerInstance();
		}
		
		public function get type():int
		{
			return EntityType.NPC;
		}
		
		private var _isAlpha:Boolean = false;
		public function set isAlpha( value:Boolean ):void
		{
			if(_isAlpha != value)
			{
				_isAlpha = value;
				if( _isAlpha )
				{
					_bodyPlayer.alpha = 0.5;
				}
				else
				{
					_bodyPlayer.alpha = 1;
				}
			}
		}
		
		public function updateInfo( info:NPCInfo,isAllUpdate:Boolean = true):void
		{
			_npcInfo = info;
			if(!_entityInfo)
			{
				_entityInfo = ObjectPool.getObject(EntityInfo);
			}
			_entityInfo.entityInfo.name = _npcInfo.tnpc.name;
			_entityInfo.entityInfo.code = _npcInfo.tnpc.code;
			_entityInfo.entityInfo.level = int(_npcInfo.tnpc.level);
			initPlayer();
			_bodyPlayer.name = NPCUtil.getNPCPlayerName(npcInfo.snpc.npcId);
			if( _npcInfo.snpc )
			{
				this.x2d = _npcInfo.snpc.point.x;
				this.y2d = _npcInfo.snpc.point.y;
				var type:int = GameMapUtil.getPixelPointValue(_npcInfo.snpc.point.x,_npcInfo.snpc.point.y);
				this.isAlpha = MapNodeType.isAlpha(type);
			}
			if( _npcInfo.tnpc )
			{
				updateName();
				//加载NPC
				_bodyPlayer.load(_npcInfo.tnpc.mesh,_npcInfo.tnpc.bone,_npcInfo.tnpc.texture);
				_bodyPlayer.direction = _npcInfo.tnpc.direction;
				if(_npcInfo.tnpc.modelScale)
				{
					_bodyPlayer.scaleValue = _npcInfo.tnpc.modelScale * 1.0/100;
				}
			}
			
			updateStatus( _npcInfo );
		}
		
		
		public function updateHeadContainer():void
		{
			
		}
		
		protected function initHeadContainner():void
		{
			_headContainner = new HeadContainer();
			this.addChild(_headContainner);
		}
		
		/**
		 * 
		 * 定时更新
		 */
		override public function update():void
		{
			super.update();
		}
		
		/**
		 * 播放特殊待机动作 
		 * 
		 */		
		public function specialStandBy():void
		{
			if(_bodyPlayer)
			{
				setActionName(ActionName.Standing);
				nextSpecialTime();
			}
		}
		
		/**
		 * 下一次特殊待机动作10s - 20s 
		 * @return 
		 * 
		 */		
		protected function nextSpecialTime():void
		{
			var nextSecialTime:Number = ClockManager.instance.nowDate.time + Math.random() * 10000 + 10000;
			_nextSecialDate = new Date(nextSecialTime);
			ClockManager.instance.addDateCall(_nextSecialDate,specialStandBy);
		}

		protected function initPlayer():void
		{
			if(!_bodyPlayer)
			{
				_bodyPlayer = ObjectPool.getObject(ActionPlayer);
				setActionName(ActionName.Stand);
				_bodyPlayer.selectEnabled = true;
				_bodyPlayer.timerContorler = this.timerContorler;
				_bodyPlayer.addEventListener(Engine3dEventName.InitComplete,onInitBodyPlayer);
				_bodyPlayer.play();
			}
			this.timerContorler.active();
			this.addChild(_bodyPlayer);
		}
		
		protected function onInitBodyPlayer(e:Event):void
		{
			if(_bodyPlayer)
			{
				_isHasSpecialStandBy = _bodyPlayer.hasAction(ActionName.Standing);
				if(_isHasSpecialStandBy)
				{
					nextSpecialTime();
					_bodyPlayer.addFrameComplete(ActionName.Standing,onFrameComplete);
				}
				
				updateNamePosition();
			}
		}
		
		
		protected function onFrameComplete():void
		{
			if(!_bodyPlayer)
			{
				return;
			}
			setActionName(ActionName.Stand);
		}
		
		/**
		 * 切换动作 
		 * @param action
		 * 
		 */		
		public function setActionName(action:String):void
		{
			_bodyPlayer.changeAction(action);
			updateNamePosition();
		}
		
		/**
		 * 更新头顶名字位置 
		 * 
		 */		
		protected function updateNamePosition():void
		{
			if(_bodyPlayer.hasBone(_headContainner.hangBoneName))
			{
				_headContainner.y = _bodyPlayer.targetMd5Controler.skeletoAnimator.getBoneGlobleJointByName(_headContainner.hangBoneName).translation.y;
			}else
			{
				_headContainner.y = 150;
			}
		}
		
		public function addToStage( layer:SLayer3D ):Boolean
		{
			if( !layer.contains(this) )
			{
				layer.addChild(this);
				_headContainner.show();
				return true;
			}
			return false;
		}
		
		public function removeFromStage( layer:SLayer3D ):Boolean
		{
			if( this.parent == layer )
			{
				layer.removeChild(this);
				_headContainner.hide();
				return true;
			}
			return false;
		}
		
		/**
		 * 更新任务状态 
		 * @param info
		 * 
		 */
		public function updateStatus( info:NPCInfo ):void
		{
			if(_taskStatus == info.taskStatus)
			{
				return;
			}
			_npcInfo = info;
			_taskStatus = _npcInfo.taskStatus;
			if( _npcInfo.taskStatus == -1 )
			{
				
			}
			else
			{
				
			}
		}
		
		public function updateName():void
		{
			_headContainner.updateName(_npcInfo.tnpc.name);
		}
		
		public function set selected( value:Boolean ):void
		{
			if( _selected == value ) return;
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
			Dispatcher.dispatchEvent(new DataEvent( EventName.Player_Selected,this ));
		}
		
		/**
		 * 距离的平方 
		 * @return 
		 * 
		 */		
		public function get toRoleDistance():Number
		{
			var xx:Number = this.x2d - RolePlayer.instance.x2d;
			var yy:Number = this.y2d - RolePlayer.instance.y2d;
			return xx*xx+yy*yy;
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
		
		override public function onMouseOut():void
		{
			Device3D.scene.removeSelectObject(_bodyPlayer,false);
		}
		
		override public function onMouseOver():void
		{
			Device3D.scene.addSelectObject(_bodyPlayer,false);
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			if(ThingUtil.selectEntity == this)
			{
				ThingUtil.selectEntity = null;
			}
			_taskStatus = -1;
			_direction = 0;
			_npcInfo = null;
			_entityInfo.dispose();
			_entityInfo = null;
			_taskStatus = -1;
			_bodyPlayer.dispose();
			_bodyPlayer = null;
			this.timerContorler.unActive();
			_headContainner.clear();
			_isHasSpecialStandBy = false;
			if(_nextSecialDate)
			{
				ClockManager.instance.removeDateCall(_nextSecialDate);
				_nextSecialDate = null;
			}
			LayerManager.entityTalkLayer.removeTalk(this);
			if(!isReuse)
			{
				TimeControler.disposeTimer(this.timerContorler);
			}
			super.dispose(isReuse);
		}
		
		override protected function disposeObject():void
		{
			ObjectPool.disposeObject(this,NPCPlayer);
		}
		
		public function get npcInfo():NPCInfo
		{ 
			return _npcInfo;
		}		
		
		public function get entityID():String{return "";}
		
		public function get selected():Boolean{ return _selected;  }
		
		public function get entityInfo():EntityInfo
		{
			if( _entityInfo == null )
			{
				_entityInfo = new EntityInfo();
			}
			return _entityInfo;
		}
		
		public function setAction(actionType:String,actionName:String,isForce:Boolean = false):void{}  //设置动作
		public function get actionName():String{ return ActionName.Stand; }  //设置动作
		
		public function walking(pointAry:Array):void{}
		public function attack():void{}
		
		public function set actionEffect( value:String ):void{} //动作效果
		
		public function hurt( value:int ):void{}
			
		public 	function get isDead():Boolean{ return false; }
		public function set isDead(value:Boolean):void{ }
		public function showName( value:Boolean ):void{};
		public function showLife( value:Boolean ):void{};
		public function showTitleMain():void{};
		
		public function set mouseOver(value:Boolean):void{};
		
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
				
				_talkText.faceAuthortiy = FaceAuthority.getFullAuthority();
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
				var y1:int = this.y2d - SceneRange.display.y - 160;
				_talkText.x = x1;
				_talkText.y = y1;
			}
		}
	}
}