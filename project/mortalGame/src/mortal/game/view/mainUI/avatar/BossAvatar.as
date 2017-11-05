/**
 * @heartspeak
 * 2014-2-13 
 */   	

package mortal.game.view.mainUI.avatar
{
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.roleAvatar.BuffPanel;

	public class BossAvatar extends EntityAvatar
	{
		protected var _mofaBar:BaseProgressBar;    //魔法条
		
		public function BossAvatar()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			addMana();
			addChild(_avatar);
			
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			_mofaBar.dispose(isReuse);
			_mofaBar = null;
		}
		
		/**
		 * 添加背景 
		 * 
		 */
		override protected function addBg():void
		{
			//血条背景
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.AvatarBossBg,0,0,this)); 
		}
		
		/**
		 * 添加头像 
		 * 
		 */		
		override protected function addAvatar():void
		{
			_avatar = UIFactory.gBitmap(null,5,0,this);
		}
		
		/**
		 * 添加生命条
		 * 
		 */		
		override protected function addLifeBar():void
		{
			_shengmingBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_shengmingBar.createDisposedChildren();
			_shengmingBar.setProgress(ImagesConst.AvatarBossLife,false,3,1,283,18);
			_shengmingBar.setLabel(BaseProgressBar.ProgressBarTextNumber);
			_shengmingBar.x = 70;
			_shengmingBar.y = 30;
			this.addChild(_shengmingBar);
		}
		
		/**
		 * 添加名字
		 * 
		 */
		override protected function addName():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 12;
			_name = UIFactory.gTextField("",84,8,100,20,this,textFormat,false);
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
			_level = UIFactory.gTextField("",55,44,50,20,this,textFormat,false);
		}
		
		/**
		 * 添加魔法 
		 * 
		 */
		protected function addMana():void
		{
			_mofaBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_mofaBar.createDisposedChildren();
			_mofaBar.setProgress(ImagesConst.AvatarBossLifeMana,false,3,1,283,18);
			_mofaBar.setLabel(BaseProgressBar.ProgressBarTextNumber);
			_mofaBar.x = 74;
			_mofaBar.y = 45;
			this.addChild(_mofaBar);
		}
		
		/**
		 * 添加buff 
		 * 
		 */
		override protected function addBuff():void
		{
			_buffPanel = UICompomentPool.getUICompoment(BuffPanel);
			_buffPanel.createDisposedChildren();
			_buffPanel.x = 79;
			_buffPanel.y = 58;
			this.addChild(_buffPanel);
		}
		
		override public function updateLevel(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_level.text = _entityInfo.entityInfo.level.toString();
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
		 * 更新头像 
		 * 
		 */		
		override public function updateAvatar():void
		{
			_avatar.bitmapData = GlobalClass.getBitmapData(ImagesConst.AvatarBossHead);
		}
		
		/**
		 * 更新显示 
		 * @param entityInfo
		 * 
		 */
		override public function updateEntity(entityInfo:EntityInfo):void
		{
			super.updateEntity(entityInfo);
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
		
	}
}