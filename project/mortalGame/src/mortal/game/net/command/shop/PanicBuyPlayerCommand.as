package mortal.game.net.command.shop
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SPanicBuyPlayerMsg;
	
	import com.gengine.debug.Log;
	
	import flash.utils.Dictionary;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class PanicBuyPlayerCommand extends BroadCastCall
	{
		public function PanicBuyPlayerCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive PanicBuyPlayerCommand");
			var msg:SPanicBuyPlayerMsg = mb.messageBase as SPanicBuyPlayerMsg;
			
			_cache.shop.panicBuyDict[msg.code + "_" + msg.item1Index] = msg.item1BuyAmount;
			_cache.shop.panicBuyDict[msg.code + "_" + msg.item2Index] = msg.item2BuyAmount;
			_cache.shop.panicBuyDict[msg.code + "_" + msg.item3Index] = msg.item3BuyAmount;
			
			NetDispatcher.dispatchCmd(ServerCommand.PanicUndate,null);   //更新团购信息
		}
	}
}