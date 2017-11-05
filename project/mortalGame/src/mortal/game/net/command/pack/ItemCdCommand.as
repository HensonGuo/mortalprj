package mortal.game.net.command.pack
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SDrugCanUseDtMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class ItemCdCommand extends BroadCastCall
	{
		public function ItemCdCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have recieve ItemCdCommand");
			super.call(mb);
			var sDrugCanUseDtMsg:SDrugCanUseDtMsg = mb.messageBase as SDrugCanUseDtMsg;
			
			NetDispatcher.dispatchCmd(ServerCommand.UpdateItemCdData,sDrugCanUseDtMsg);
		}
	}
}