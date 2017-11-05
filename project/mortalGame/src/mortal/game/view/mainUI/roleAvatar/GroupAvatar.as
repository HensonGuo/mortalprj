package mortal.game.view.mainUI.roleAvatar
{
	import Message.Public.SPublicPlayer;
	
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.manager.ToolTipSprite;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.game.view.mainUI.avatar.PlayerAvatar;

	public class GroupAvatar extends PlayerAvatar
	{
		protected var _publicPlayer:SPublicPlayer;
		
		protected var _captainIcon:GBitmap;
		
		protected var _stateIcon:GBitmap;
		
		protected var _toolTipData:*;
		
		public function GroupAvatar()
		{
			super();
		}
		
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			addCaptain();
			addStateIcon();
//			this.configEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
//			this.configEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_captainIcon.dispose(isReuse);
			_stateIcon.dispose(isReuse);
			
			
			_captainIcon = null;
			_stateIcon = null;
			
			super.disposeImpl(isReuse);
			
		}
		
		private function setTarget(e:MouseEvent):void
		{
			if(e.target != _name)
			{
				if(_entityInfo)
				{
					ThingUtil.selectEntity = ThingUtil.entityUtil.getEntity(_entityInfo.entityInfo.entityId);
				}
			}
		}
		
		protected function addStateIcon():void
		{
			_stateIcon = UIFactory.gBitmap(null,12,7,this);
		}
		
		/**
		 * 添加队长标志 
		 * 
		 */		
		protected function addCaptain():void
		{
			_captainIcon = UIFactory.gBitmap(ImagesConst.SmallCatain,-10,20,this);
		}
		
		override protected function addBg():void
		{
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.AvatarEntityBg,0,0,this)); 
		}
		
		/**
		 * 添加名字
		 * 
		 */		
		override protected function addName():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 12;
			textFormat.underline = true;
			_name = UIFactory.gTextField("",60,-10,85,20,this,textFormat,false);
		}
		
		/**
		 * 添加生命条
		 * 
		 */		
		override protected function addLifeBar():void
		{
			var tm:GTextFormat = new GTextFormat();
			tm.size = 8;
			tm.align = AlignMode.CENTER;
			_shengmingBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_shengmingBar.createDisposedChildren();
			_shengmingBar.setLabel(BaseProgressBar.ProgressBarTextPercent,5,-2,80,10,tm);
			_shengmingBar.setProgress(ImagesConst.AvatarEntityLife,false,3,1,89,8);
			_shengmingBar.x = 54;
			_shengmingBar.y = 11;
			this.addChild(_shengmingBar);
		}
		
		override protected function addMana():void
		{
//			super.addMana();
			var tm:GTextFormat = new GTextFormat();
			tm.size = 8;
			tm.align = AlignMode.CENTER;
			_mofaBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_mofaBar.createDisposedChildren();
			_mofaBar.setLabel(BaseProgressBar.ProgressBarTextPercent,5,-2,80,10,tm);
			_mofaBar.setProgress(ImagesConst.AvatarEntityMana,false,3,1,86,8);
			_mofaBar.x = 54;
			_mofaBar.y = 20;
			this.addChild(_mofaBar);
		}
		
		/**
		 * 添加头像 
		 * 
		 */		
		override protected function addAvatar():void
		{
			_avatar = UIFactory.gBitmap(null,5,-9,_bgSprite);
		}
		
		override public function updateLevel(e:Event = null):void
		{
			if(_entityInfo)
			{
				_level.text = "Lv. " + _entityInfo.entityInfo.level;
				return;
			}
			else if(_publicPlayer)
			{
				_level.text = "Lv. " + _publicPlayer.level;
			}
			
		}
		
		override public function updateName():void
		{
			if(_entityInfo)
			{
				_name.htmlText = "<a href='event:#'>" + _entityInfo.entityInfo.name + "</a>";
				return;
			}
			else if(_publicPlayer)
			{
				_name.htmlText = "<a href='event:#'>" + _publicPlayer.name + "</a>";
			}
	
		}
		
		/**
		 * 更新职业 
		 * @param value
		 * 
		 */		
		override public function updateCarrer():void
		{
			if(!_publicPlayer)
			{
				return;
			}
			var value:int = _publicPlayer.career;
			_carrer.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getECarrerSmallPic(value));
		}
		
		/**
		 * 更新队长标志 
		 * 
		 */		
		protected function updateCaptain():void
		{
			if(!_publicPlayer)
			{
				return;
			}
			
			if(_publicPlayer.entityId.id == Cache.instance.group.captain.id)
			{
//				this.addChild(_captainIcon);
				_captainIcon.visible = true;
			}
			else
			{
				if(_captainIcon.parent)
				{
//					this.removeChild(_captainIcon);
					
				}
				_captainIcon.visible = false;
			}
		}
		
		/**
		 * 更新离线标志 
		 * 
		 */		
		public function updateOnline():void
		{
			if(_publicPlayer.online == 0)
			{
				_stateIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.Offline);
//				ToolTipsManager.unregister(this);
				_shengmingBar.setValue(0,100);
				_mofaBar.setValue(0,100);
			}
			else
			{
//				ToolTipsManager.register(this);
			}
		}
		
		/**
		 * 更新远离标志 
		 * 
		 */		
		public function updateLeave():void
		{
			if(_publicPlayer.online == 1)
			{
				_stateIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.leave);
			}
		}
		
		/**
		 * 更新死亡
		 * 
		 */		
		protected function updateDead(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			
			if(_entityInfo.entityInfo.life <= 0)
			{
				_stateIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.dead);
			}
			else
			{
				_stateIcon.bitmapData = null;
			}
		}
		
		/**
		 * 更新人物基本属性 
		 * @param publicPlayer
		 * 
		 */		
		public function updatePlayer(publicPlayer:SPublicPlayer):void
		{
			_publicPlayer = publicPlayer;
			
			if(_entityInfo == null)
			{
				updateCarrer();
				updateName();
				updateLevel();
				updateLeave();
			}
			
			updateCaptain();
			updateOnline();
			updateAvatar();
	
			_bgSprite.toolTipData = GameMapConfig.instance.getMapInfo(_publicPlayer.mapId).name;
			
			PlayerMenuRegister.UnRegister(_name);
			PlayerMenuRegister.Register(_name,_publicPlayer,PlayerMenuConst.GroupMemberOpMenu);
			
		}
		
		/**
		 * 更新显示 
		 * @param entityInfo
		 * 
		 */
		override public function updateEntity(entityInfo:EntityInfo):void
		{
			super.updateEntity(entityInfo);
			this.configEventListener(MouseEvent.CLICK,setTarget);
			PlayerMenuRegister.UnRegister(_bgSprite);
			if(entityInfo == null)
			{
				_avatar.filters = [FilterConst.colorFilter2];
			}
			else
			{
				_avatar.filters = [];
				_stateIcon.bitmapData = null;
			}
			updateDead();
		}
		
	    //远离的时候停止更新
		override public function stopUpdateEntity():void
		{
			super.stopUpdateEntity();
			_avatar.filters = [FilterConst.colorFilter2];
			PlayerMenuRegister.UnRegister(_name);
			PlayerMenuRegister.Register(_name,_publicPlayer,PlayerMenuConst.GroupMemberOpMenu);
			if(_publicPlayer.online == 1)
			{
				_stateIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.leave);
			}
		}
		
		//移除的时候停止更新
		public function removeAndStopUpdate():void
		{
			stopUpdateEntity();
			PlayerMenuRegister.UnRegister(_name);
		}
		
		
		/**
		 * 添加Entity的事件监听 
		 * 
		 */		
		override protected function addEntityEvent():void
		{
			super.addEntityEvent();
			if(_entityInfo)
			{
				_entityInfo.addEventListener(EntityInfoEventName.UpdateLife,updateDead);
			}
		}
		
		/**
		 * 移除Entity的事件监听 
		 * 
		 */		
		override protected function removeEntityEvent():void
		{
			super.removeEntityEvent();
			if(_entityInfo)
			{
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateLife,updateDead);
			}
		}
		
		/**
		 * 更新头像 
		 * 
		 */		
		override public function updateAvatar():void
		{
			if(_publicPlayer)
			{
				_avatar.bitmapData = GlobalClass.getBitmapData(AvatarUtil.getPlayerAvatar(_publicPlayer.career,_publicPlayer.sex,3));
			}
		}
		
		public function updateMapId(id:int):void
		{
			_publicPlayer.mapId = id;
			_bgSprite.toolTipData = GameMapConfig.instance.getMapInfo(_publicPlayer.mapId).name;
		}
		
//		protected function judgeToolTip(e:Event = null):void
//		{
//			if(e && e.type == Event.ADDED_TO_STAGE && toolTipData 
//				|| !e && toolTipData && Global.stage.contains(this))
//			{
//				ToolTipsManager.register(this);
//			}
//			else
//			{
//				ToolTipsManager.unregister(this);
//			}
//		}
//		
//		/**
//		 * 获取toolTipData 
//		 * @return 
//		 * 
//		 */		
//		public function get toolTipData():*
//		{
//			if(_publicPlayer)
//			{ 
//				return GameMapConfig.instance.getMapInfo(_publicPlayer.mapId).name;
//			}
//			else
//			{
//				return "";
//			}
//		
//		}
//		
//		/**
//		 * 设置toolTipData 
//		 * @param value
//		 * 
//		 */		
//		public function set toolTipData( value:* ):void
//		{
//			_toolTipData = value;
//			judgeToolTip();
//		}
		
		
		public function get publicPlayer():SPublicPlayer
		{
			return _publicPlayer;
		}
	}
}