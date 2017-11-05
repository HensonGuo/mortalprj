package mortal.game.net.command.mount
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SMountUpdate;
	import Message.Public.EUpdateType;
	import Message.Public.SPublicMount;
	
	import com.gengine.debug.Log;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.mount.data.MountData;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class MountInfoUpdateCommand extends BroadCastCall
	{
		public function MountInfoUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive MountInfoUpdateCommand");
			
			var msg:SMountUpdate = mb.messageBase as SMountUpdate;
			
			if(msg.updateType == EUpdateType._EUpdateTypeAdd)
			{
				_cache.mount.addMount(msg.mounts[0] as SPublicMount);
				_cache.mount.newMountData = _cache.mount.getMountDataByUid(msg.uid);
				_cache.mount.sortList();
				
				if(!GameController.mount.isViewShow)
				{
					GameManager.instance.popupWindow(ModuleType.Mounts);
				}
			}
			else if(msg.updateType == EUpdateType._EUpdateTypeDel)
			{
				if(_cache.mount.currentMount && _cache.mount.currentMount.isOwnMount )  //先把幻化的坐骑删掉
				{
					var uid:String = _cache.mount.currentMount.sPublicMount.uid;
					if(uid == msg.uid)
					{
						_cache.mount.currentMount = null;
					}
				}
			
				_cache.mount.delMount(msg.uid);
				
				_cache.mount.newMountData  = null;
				
				_cache.mount.sortList();
				
				
				
//				if(uid == msg.uid && _cache.mount.isHasMount)  //如果被删掉的马已经被幻化,则幻化第一匹马
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.ChangeRideMount,_cache.mount.mountList[0].sPublicMount.uid));
//				}
//				
			}
			
			if( _cache.mount.currentMount == null &&  _cache.mount.isHasMount)  //如果是第一只坐骑,默认骑上
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChangeRideMount,_cache.mount.mountList[0].sPublicMount.uid));
			}
			
			NetDispatcher.dispatchCmd(ServerCommand.MountUpdateList,null);
			
		}
	}
}