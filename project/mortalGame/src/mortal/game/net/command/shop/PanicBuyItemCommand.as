package mortal.game.net.command.shop
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SPanicBuyItemMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class PanicBuyItemCommand extends BroadCastCall
	{
		public function PanicBuyItemCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive PanicBuyItemCommand");
			var msg:SPanicBuyItemMsg = mb.messageBase as SPanicBuyItemMsg;
			
			_cache.shop.changePanicItemLeftNum(msg.itemCode, msg.leftAmount);
			NetDispatcher.dispatchCmd(ServerCommand.PanicUndate,null);   //更新团购信息
		}
	}
}