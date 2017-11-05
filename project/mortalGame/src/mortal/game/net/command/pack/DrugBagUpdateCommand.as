package mortal.game.net.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SDrugBagInfo;
	import Message.Public.EDrug;
	
	import com.gengine.debug.Log;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class DrugBagUpdateCommand extends BroadCastCall
	{
		public function DrugBagUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have recieve DrugBagUpdateCommand");
			super.call(mb);
			var drugBagInfo:SDrugBagInfo = mb.messageBase as SDrugBagInfo;
			if(drugBagInfo)
			{
				if(drugBagInfo.type == EDrug._EDrugLifeBag)
				{
					_cache.role.lifeDrugBagInfo = drugBagInfo;
				}
				else if(drugBagInfo.type == EDrug._EDrugManaBag)
				{
					_cache.role.manaDrugBagInfo = drugBagInfo;
				}
			}
			NetDispatcher.dispatchCmd(ServerCommand.DrugBagInfoUpdate,drugBagInfo);
			Dispatcher.dispatchEvent(new DataEvent(EventName.RoleAutoResume,null));
		}
	}
}