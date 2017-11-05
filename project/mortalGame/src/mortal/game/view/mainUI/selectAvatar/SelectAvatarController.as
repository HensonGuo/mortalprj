/**
 * @heartspeak
 * 2014-2-13 
 */   	

package mortal.game.view.mainUI.selectAvatar
{
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class SelectAvatarController extends Controller
	{
		private var _avatarView:SelectAvatarView;
		
		public function SelectAvatarController()
		{
			super();
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.Player_Selected,onPlayerSelected);
		}
		
		override protected function initView():IView
		{
			if(!_avatarView)
			{
				_avatarView = new SelectAvatarView();
			}
			return _avatarView;
		}
		
		/**
		 * 选择或者取消选择对象 
		 * @param e
		 * 
		 */
		private function onPlayerSelected(e:DataEvent):void
		{
			var entity:IEntity = e.data as IEntity;
			var entityInfo:EntityInfo = entity.entityInfo;
			
			if( entity.selected )
			{
				if( entity.type == EntityType.NPC)
				{
					_avatarView.showBaseAvatar(entityInfo);
				}
				else if(entity.type == EntityType.Pet)
				{
					_avatarView.showPetAvatar(entityInfo);
				}
				else if(entity.type == EntityType.Player)
				{
					_avatarView.showUseAvatar(entityInfo);
				}
				else if(entity.type == EntityType.Boss)
				{
					_avatarView.showBossAvatar(entityInfo);
				}
				entity.addEventListener(PlayerEvent.UPDATEINFO,onPlayerInfoUpdate);
			}
			else
			{
				_avatarView.removeLastAvatar();
				entity.removeEventListener(PlayerEvent.UPDATEINFO,onPlayerInfoUpdate);
			}
		}
		
		/**
		 * 更新选择对象的数据
		 * 
		 */
		private function onPlayerInfoUpdate(e:PlayerEvent):void
		{
			_avatarView.updateEntity((e.target as IEntity).entityInfo);
		}
	}
}