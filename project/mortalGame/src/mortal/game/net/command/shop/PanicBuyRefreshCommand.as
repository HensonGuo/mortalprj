package mortal.game.net.command.shop
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SPanicBuyMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.mvc.core.NetDispatcher;
	
	public class PanicBuyRefreshCommand extends BroadCastCall
	{
		public function PanicBuyRefreshCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive BuyRefreshCommand");
			var msg:SPanicBuyMsg = mb.messageBase as SPanicBuyMsg;
			
			
			if(msg.type == 0)  //普通抢购
			{
				_cache.shop.panicInfo = msg.panicBuyShop;
				_cache.shop.updatePanicList( msg.panicBuyItems );
			}
			
			var cdData:CDData = Cache.instance.cd.registerCDData(CDDataType.backPackLock, "PanicCd", cdData) as CDData;
			cdData.totalTime = msg.panicBuyShop.leftSeconds*1000;
			cdData.startCoolDown();
			
			NetDispatcher.dispatchCmd(ServerCommand.PanicUndate,null);   //更新团购信息
		}
	}
}