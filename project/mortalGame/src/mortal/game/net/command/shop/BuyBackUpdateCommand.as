package mortal.game.net.command.shop
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SBuyBackItemMsg;
	import Message.Public.EUpdateType;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class BuyBackUpdateCommand extends BroadCastCall
	{
		public function BuyBackUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive BuyBackUpdateCommand");
			var msg:SBuyBackItemMsg = mb.messageBase as SBuyBackItemMsg;
			
			switch(msg.type)
			{
				case EUpdateType._EUpdateTypeAdd:
					_cache.shop.buyBackList.unshift(msg.item);
					break;
				case EUpdateType._EUpdateTypeDel:
					_cache.shop.removeBuyBackItemByUid(msg.item.uid);
					break;
			}
			NetDispatcher.dispatchCmd(ServerCommand.updateBuyBackList,null);
		}
		
	}
}