/**
 * @heartspeak
 * 2014-2-13 
 */   	

package mortal.game.view.mainUI.avatar
{
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.roleAvatar.BuffPanel;

	public class PlayerAvatar extends EntityAvatar
	{
		protected var _mofaBar:BaseProgressBar;    //魔法条
		
		protected var _carrer:GBitmap;  //职业
		
		public function PlayerAvatar()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			addMana();
			addCarrer();
		}
		
		/**
		 * 添加背景 
		 * 
		 */
		override protected function addBg():void
		{
			//血条背景
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.AvatarEntityBg,0,0,this)); 
		}
		
		/**
		 * 添加职业 
		 * 
		 */		
		protected function addCarrer():void
		{
			_carrer = UIFactory.gBitmap(null,-10,-2,this);
		}
		
		/**
		 * 添加等级 
		 * 
		 */		
		override protected function addLevel():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatHui;
			textFormat.size = 12;
			textFormat.color = GlobalStyle.yellowUint;
			_level = UIFactory.gTextField("",60,28,50,20,this,textFormat,false);
		}
		/**
		 * 添加魔法 
		 * 
		 */
		protected function addMana():void
		{
			_mofaBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_mofaBar.createDisposedChildren();
			_mofaBar.setProgress(ImagesConst.AvatarEntityMana,true,3,1,86,8);
			_mofaBar.setLabel(BaseProgressBar.ProgressBarTextNone);
			_mofaBar.x = 54;
			_mofaBar.y = 20;
			this.addChild(_mofaBar);
		}
		
		override protected function addBuff():void
		{
			_buffPanel = UICompomentPool.getUICompoment(BuffPanel);
			_buffPanel.createDisposedChildren();
			_buffPanel.x = 100;
			_buffPanel.y = 30;
			this.addChild(_buffPanel);
		}
		
		/**
		 * 添加头像 
		 * 
		 */		
		override protected function addAvatar():void
		{
			_avatar = UIFactory.gBitmap(null,5,-8,_bgSprite);
		}
		
		/**
		 * 添加名字
		 * 
		 */
		override protected function addName():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 12;
			_name = UIFactory.gTextField("",60,-10,100,20,this,textFormat,false);
		}
		
		/**
		 * 添加生命条
		 * 
		 */		
		override protected function addLifeBar():void
		{
			_shengmingBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_shengmingBar.createDisposedChildren();
			_shengmingBar.setProgress(ImagesConst.AvatarEntityLife,false,3,1,89,8);
			_shengmingBar.setLabel(BaseProgressBar.ProgressBarTextNone);
			_shengmingBar.x = 54;
			_shengmingBar.y = 11;
			this.addChild(_shengmingBar);
		}
		
		/**
		 * 更新魔法 
		 * @param 传数值则更新剩余魔法,传SFightAttribute则更新最大魔法
		 * 
		 */		
		public function updateMana(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_mofaBar.setValue(_entityInfo.entityInfo.mana,_entityInfo.entityInfo.maxMana);
		}
		
		/**
		 * 更新职业 
		 * @param value
		 * 
		 */		
		public function updateCarrer():void
		{
			if(!_entityInfo)
			{
				return;
			}
			var value:int = _entityInfo.entityInfo.career;
			if(value)
			{
				_carrer.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getECarrerSmallPic(value));
			}
			else
			{
				_carrer.bitmapData = null;
			}
		}
		
		override public function updateLevel(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_level.text = "Lv. " + _entityInfo.entityInfo.level;
		}
		
		/**
		 * 更新头像 
		 * 
		 */		
		override public function updateAvatar():void
		{
			_avatar.bitmapData = GlobalClass.getBitmapData(AvatarUtil.getPlayerAvatar(_entityInfo.entityInfo.career,_entityInfo.entityInfo.sex,3));
		}
		
		/**
		 * 更新显示 
		 * @param entityInfo
		 * 
		 */
		override public function updateEntity(entityInfo:EntityInfo):void
		{
			super.updateEntity(entityInfo);
			updateCarrer();
			updateMana();
		}
		
		override protected function addEntityEvent():void
		{
			super.addEntityEvent();
			
			if(_entityInfo)
			{
				_entityInfo.addEventListener(EntityInfoEventName.UpdateMana,updateMana);
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
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateMana,updateMana);
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_mofaBar.dispose(isReuse);
			_mofaBar = null;
			_carrer.dispose(isReuse);
			_carrer = null;
		}
	}
}