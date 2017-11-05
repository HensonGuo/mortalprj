package mortal.game.control
{
	import modules.AvatarModule;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class AvatarController extends Controller
	{
		private var _avatarModule:AvatarModule;
		
		public function AvatarController()
		{
			super();
			
		}
		
		override protected function initView():IView
		{
			if(!_avatarModule)
			{
				_avatarModule = new AvatarModule();
			}
			return _avatarModule;
		}
		
		override protected function initServer():void
		{
//			NetDispatcher.addCmdListener(ServerCommand.RoleFightAttributeChange, upDateLife);
//			NetDispatcher.addCmdListener(ServerCommand.RoleFightAttributeChange, upDateMana);
//			NetDispatcher.addCmdListener(ServerCommand.RoleFightAttributeChange, updateAllInfo);
//			NetDispatcher.addCmdListener(ServerCommand.RoleLevelUpdate,updateLevel);
//			NetDispatcher.addCmdListener(ServerCommand.LifeUpdate,upDateLife);
//			NetDispatcher.addCmdListener(ServerCommand.ManaUpdate,upDateMana);
			NetDispatcher.addCmdListener(ServerCommand.BufferUpdate,upDateBuff);
			NetDispatcher.addCmdListener(ServerCommand.CaptainChange,captainChange);
			NetDispatcher.addCmdListener( ServerCommand.FightSetModeSuccess,setModeSuccess);
			
			Dispatcher.addEventListener( EventName.LoginGameSuccess,onLoginGame);
			Dispatcher.addEventListener( EventName.FightSetMode,setFightMode);
		}
		
		private function setFightMode(e:DataEvent):void
		{
			if(Cache.instance.role.entityInfo.level < 30)
			{
				MsgManager.showRollTipsMsg("等级不足30,无法切换战斗模式");
				return
			}
			
			GameProxy.sceneProxy.changeFightMode(e.data as int);
		}
		
		private function onLoginGame(e:DataEvent):void
		{
			_avatarModule.updateEntity();
		}
		
//		/**
//		 * 更新人物属性 
//		 * @param data
//		 * 
//		 */		
//		private function updateAllInfo(data:Object = null):void
//		{
//			if(Cache.instance.role.fightAttribute)
//			{
//				_avatarModule.upDateAllInfo();
//			}
//		}
//		
		private function setModeSuccess(data:Object):void
		{
			_avatarModule.setModeStyle(data as int);
		}
		
		private function upDateBuff(data:Object = null):void
		{
			_avatarModule.updateBufferByBuffInfoArray(data as Array);
		}
//		
		private function captainChange(data:Object = null):void
		{
			_avatarModule.captainChange();
		}
		
//		private function updateLevel(data:Object = null):void
//		{
//			_avatarModule.updateLevel(int(data));
//		}
//		
////		private function upDateName():void
////		{
////			_avatarModule.upDateName();
////		}
//		
//		private function upDateMana(data:Object = null):void
//		{
//			_avatarModule.upDateMana(cache.role.entityInfo.mana,cache.role.entityInfo.maxMana);
//		}
//		
//		private function upDateLife(data:Object = null):void
//		{
//			_avatarModule.upDateLife();
//		}
		
		
	}
}