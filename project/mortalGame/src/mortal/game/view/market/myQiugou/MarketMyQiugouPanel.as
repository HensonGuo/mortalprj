package mortal.game.view.market.myQiugou
{
	import Message.Game.EMarketRecordType;
	
	import flash.events.Event;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 我的求购
	 * @author lizhaoning
	 */
	public class MarketMyQiugouPanel extends MarketMyMktBase
	{
		private static var _instance:MarketMyQiugouPanel;
		
		public function MarketMyQiugouPanel()
		{
			super();
			
			if(_instance)
			{
				throw new Error("MarketMyQiugouPanel单例");
			}
		}
		
		public static function get instance():MarketMyQiugouPanel
		{
			if(_instance == null)
			{
				_instance  = new MarketMyQiugouPanel();
			}
			return _instance;
		}

		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			resetUI();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			NetDispatcher.removeCmdListener(ServerCommand.MarketCancelSeekBuy,cancelBack);
			NetDispatcher.removeCmdListener(ServerCommand.MarketGetMySeekBuysBack,mySeekBuysUpdate);
		}
		
		override protected function resetUI():void
		{
			// TODO Auto Generated method stub
			this._title1.text = "我求购的物品";
		
			_pageSelect.configEventListener(Event.CHANGE,onPageChange);
			
			NetDispatcher.addCmdListener(ServerCommand.MarketCancelSeekBuy,cancelBack);
			NetDispatcher.addCmdListener(ServerCommand.MarketGetMySeekBuysBack,mySeekBuysUpdate);
			
			getDataFromServer();
			mySeekBuysUpdate();
		}
		
		private function onPageChange(e:Event):void  //翻页
		{
			this.updatePanel(Cache.instance.market.mySeekBuyMarketItemObj);
		}
		
		/** 向服务器请求数据 */
		public function getDataFromServer():void
		{
			var obj:Object = {};
			obj.recordType = EMarketRecordType._EMarketRecordSeekBuy;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketGetMyRecords,obj));
		}
		
		private function mySeekBuysUpdate(e:Object = null):void
		{
			this.updatePanel(Cache.instance.market.mySeekBuyMarketItemObj);
		}
		
		/** 下架返回 */
		private function cancelBack(e:Object):void 
		{
			// TODO Auto Generated method stub
			getDataFromServer();
		}	
	}
}