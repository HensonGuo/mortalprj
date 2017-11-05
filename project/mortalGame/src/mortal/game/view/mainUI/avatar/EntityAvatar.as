/**
 * @heartspeak
 * 2014-2-13 
 */   	

package mortal.game.view.mainUI.avatar
{
	import Message.Public.ECareer;
	import Message.Public.SFightAttribute;
	
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.game.view.mainUI.roleAvatar.BuffPanel;

	public class EntityAvatar extends BaseAvater
	{
		
		protected var _buffPanel:BuffPanel;//Buff
		
		public function EntityAvatar()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			this.mouseEnabled = true;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			addBuff();
		}
		
//		/**
//		 * 添加头像 
//		 * 
//		 */		
//		override protected function addAvatar():void
//		{
//			_avatar = UIFactory.gBitmap(null,0,-15,this);
//		}
		
		/**
		 * 添加buff 
		 * 
		 */		
		protected function addBuff():void
		{
			_buffPanel = UICompomentPool.getUICompoment(BuffPanel);
			_buffPanel.createDisposedChildren();
			_buffPanel.x = 75;
			_buffPanel.y = 30;
			this.addChild(_buffPanel);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_buffPanel.dispose(isReuse);
			_buffPanel = null;
		}
		
		
		/**
		 * 更新头像 
		 * 
		 */		
		override public function updateAvatar():void
		{
			_avatar.bitmapData = GlobalClass.getBitmapData(ImagesConst.AvatarMonsterHead);
		}
		
		/**
		 *根据传入的BuffInfo数组更新Buffer。用于更新玩家自身的BUFF。
		 * @param buffInfoArray 包含的是BuffInfo
		 * 
		 */		
		public function updateBufferByBuffInfoArray(buffInfoArray:Array):void
		{
			_buffPanel.updateBufferByBuffInfoArray(buffInfoArray);
		}
		
		/**
		 *根据传入的tStateId(BUFF的id)更新Buffer。用于更新所查看的实体的BUFF。
		 * @param stateIdArray 包含的是BUFF的id,即stateId
		 * 
		 */		
		public function updateEntityBuffer(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_buffPanel.updateBufferByTSateIdArray(_entityInfo.entityInfo.buffs);
		}
		
		/**
		* 更新显示 
		* @param entityInfo
		* 
		*/
		override public function updateEntity(entityInfo:EntityInfo):void
		{
			super.updateEntity(entityInfo);
			updateEntityBuffer();
			PlayerMenuRegister.Register(_bgSprite,entityInfo,PlayerMenuConst.NearbyPlayerOpMenu);
		}
		
		override protected function addEntityEvent():void
		{
			super.addEntityEvent();
			
			if(_entityInfo)
			{
				_entityInfo.addEventListener(EntityInfoEventName.UpdateBuffs,updateEntityBuffer);
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
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateBuffs,updateEntityBuffer);
			}
		}
	}
}