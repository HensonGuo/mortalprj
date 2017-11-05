package mortal.game.view.palyer
{
	import Message.Public.SFightAttribute;
	
	import flash.events.Event;
	
	import modules.interfaces.IPlayerModule;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.view.forging.ForgingModule;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class PlayerController extends Controller
	{
        private var _playerModule:IPlayerModule
		
		public function PlayerController()
		{
			super();
		}
		
		
		override protected function initView():IView
		{
			if (_playerModule == null)
			{
				_playerModule=new PlayerModule();
				_playerModule.addEventListener(WindowEvent.SHOW, onPlayerShow);
				_playerModule.addEventListener(WindowEvent.CLOSE, onPlayerClose);
			}
			return _playerModule;
		}
		
		override protected function initServer():void
		{
		
		}
		
		private function onPlayerShow(e:Event):void
		{
			updateAttributes(Cache.instance.role.fightAttribute);
			
			Cache.instance.role.roleEntityInfo.addEventListener(EntityInfoEventName.UpdateComBat,updateComBat);
			
			NetDispatcher.addCmdListener(ServerCommand.RoleFightAttributeChange, updateAttributes);
			NetDispatcher.addCmdListener(ServerCommand.LifeUpdate,updateLife);
			NetDispatcher.addCmdListener(ServerCommand.ManaUpdate,updateMana);
			NetDispatcher.addCmdListener(ServerCommand.ExpUpdate,updateExp);
			NetDispatcher.addCmdListener(ServerCommand.updateEquipMent,updateEquipByType);
			NetDispatcher.addCmdListener( ServerCommand.RoleLevelUpdate,updateLevel);
			
			Dispatcher.addEventListener(EventName.GetOffEquip,equipHandler);
		}
		
		private function onPlayerClose(e:Event):void
		{
			Cache.instance.role.roleEntityInfo.removeEventListener(EntityInfoEventName.UpdateComBat,updateComBat);
			
			NetDispatcher.removeCmdListener(ServerCommand.RoleFightAttributeChange, updateAttributes);
			NetDispatcher.removeCmdListener(ServerCommand.LifeUpdate,updateLife);
			NetDispatcher.removeCmdListener(ServerCommand.ManaUpdate,updateMana);
			NetDispatcher.removeCmdListener(ServerCommand.ExpUpdate,updateExp);
			NetDispatcher.removeCmdListener(ServerCommand.updateEquipMent,updateEquipByType);
			NetDispatcher.removeCmdListener( ServerCommand.RoleLevelUpdate,updateLevel);
			
			Dispatcher.removeEventListener(EventName.GetOffEquip,equipHandler);
		}
		
		/**
		 * 更新人物最终战斗属性 
		 * @param data
		 * 
		 */		
		private function updateAttributes(data:Object = null):void
		{
			if( _playerModule == null || _playerModule.isHide)
			{
				return;
			}
			
			if(Cache.instance.role.fightAttribute)
			{
				_playerModule.upDateAllInfo(data as SFightAttribute);
			}
		}
		
		/**
		 * 更新人物血量 
		 * 
		 */		
		private function updateLife(data:Object = null):void
		{
			_playerModule.upDateLife(int(data));
		}
		
		/**
		 * 更新人物魔法 
		 * 
		 */		
		private function updateMana(data:Object = null):void
		{
			_playerModule.upDateMana(int(data));
		}
		
		private function updateExp(data:Object = null):void
		{
			_playerModule.upDateExp(int(data));
		}
		
		private function updateEquipByType(data:int):void
		{
			_playerModule.updateEquipByType(data);
		}
		
		private function updateAllEquip():void
		{
			_playerModule.updateAllEquip();
		}
		
		private function updateLevel(data:Object = null):void
		{
			_playerModule.updateLevel(int(data));
		}
		
		private function equipHandler(e:DataEvent):void
		{
			var itemData:ItemData = e.data as ItemData;
			GameProxy.equip.dress(null,itemData.serverData.uid);
		}
		
		private function updateComBat(e:Event):void
		{
			_playerModule.updateComBat();
			GameController.forging.updateCombat();
		}
		
	}
}