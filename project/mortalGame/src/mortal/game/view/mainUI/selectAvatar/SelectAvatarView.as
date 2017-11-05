/**
 * @heartspeak
 * 2014-2-14 
 */   	

package mortal.game.view.mainUI.selectAvatar
{
	import mortal.game.manager.LayerManager;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.mainUI.avatar.BaseAvater;
	import mortal.game.view.mainUI.avatar.BossAvatar;
	import mortal.game.view.mainUI.avatar.EntityAvatar;
	import mortal.game.view.mainUI.avatar.PlayerAvatar;
	import mortal.mvc.core.View;
	
	public class SelectAvatarView extends View
	{
		private var _baseAvatar:BaseAvater;
		
		private var _bossAvatar:BossAvatar;
		
		private var _petAvatar:EntityAvatar;
		
		private var _userAvatar:PlayerAvatar;
		
		//最后一个选择的头像
		private var _lastAvatar:BaseAvater;
		
		public function SelectAvatarView()
		{
			super();
			isHideDispose = false;
			this.layer = LayerManager.uiLayer;
		}
		
		/**
		 * 显示基本头像，用于NPC 和小怪物 
		 * @param entity
		 * 
		 */		
		public function showBaseAvatar(entityInfo:EntityInfo):void
		{
			removeLastAvatar();
			if(!_baseAvatar)
			{
				_baseAvatar = new BaseAvater();
			}
			this.addChild(_baseAvatar);
			_lastAvatar = _baseAvatar;
			updateEntity(entityInfo);
		}
		
		/**
		 * 显示宠物头像 
		 * @param entity
		 * 
		 */
		public function showPetAvatar(entityInfo:EntityInfo):void
		{
			removeLastAvatar();
			if(!_petAvatar)
			{
				_petAvatar = new EntityAvatar();
			}
			this.addChild(_petAvatar);
			_lastAvatar = _petAvatar;
			updateEntity(entityInfo);
		}
		
		public function showBossAvatar(entityInfo:EntityInfo):void
		{
			removeLastAvatar();
			if(!_bossAvatar)
			{
				_bossAvatar = new BossAvatar();
			}
			this.addChild(_bossAvatar);
			_lastAvatar = _bossAvatar;
			updateEntity(entityInfo);
		}
		
		/**
		 * 显示人物头像 
		 * @param entity
		 * 
		 */		
		public function showUseAvatar(entityInfo:EntityInfo):void
		{
			removeLastAvatar();
			if(!_userAvatar)
			{
				_userAvatar = new PlayerAvatar();
			}
			this.addChild(_userAvatar);
			_lastAvatar = _userAvatar;
			updateEntity(entityInfo);
		}
		
		/**
		 * 移除之前显示的头像 
		 * 
		 */
		public function removeLastAvatar():void
		{
			if(_lastAvatar && _lastAvatar.parent)
			{
				this.removeChild(_lastAvatar);
			}
		}
		
		/**
		 * 更新实体显示 
		 * 
		 */		
		public function updateEntity(entityInfo:EntityInfo):void
		{
			_lastAvatar.updateEntity(entityInfo);
		}
		
		/**
		 * 重设屏幕位置 
		 * 
		 */
		override public function stageResize():void
		{
			this.x = 400;
			this.y = 50
		}
	}
}