package mortal.game.net.command.shop
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SBuyBackItem;
	import Message.Game.SeqBuyBackItemMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class BuyBackCommand extends BroadCastCall
	{
		public function BuyBackCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive BuyBackCommand");
			var msg:SeqBuyBackItemMsg = mb.messageBase as SeqBuyBackItemMsg;
			var arr:Array = msg.buyBackItems;
			arr.sortOn("sellTime",sortArr);
			
			
			_cache.shop.buyBackList = arr;
//			NetDispatcher.dispatchCmd(ServerCommand.updateBuyBackList);
			
		}
		
		private function sortArr(a1:Date , a2:Date):int
		{
			if(a1.time > a2.time)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
			
	}
}