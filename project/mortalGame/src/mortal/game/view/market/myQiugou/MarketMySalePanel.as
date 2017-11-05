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
	 * 我的寄售
	 * @author lizhaoning
	 */
	public class MarketMySalePanel extends MarketMyMktBase
	{
		private static var _instance:MarketMySalePanel;
		
		public function MarketMySalePanel()
		{
			super();
			
			if(_instance)
			{
				throw new Error("MarketMySalePanel单例");
			}
		}
		
		public static function get instance():MarketMySalePanel
		{
			if(_instance == null)
			{
				_instance  = new MarketMySalePanel();
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
			
			NetDispatcher.removeCmdListener(ServerCommand.MarketGetMySellsBack,mySellUpdate);
			NetDispatcher.removeCmdListener(ServerCommand.MarketSearchCancelSell,cancelBack);
		}
		
		override protected function resetUI():void
		{
			// TODO Auto Generated method stub
			this._title1.text = "我寄售的物品";
			
			_pageSelect.configEventListener(Event.CHANGE,onPageChange);
			
			
			NetDispatcher.addCmdListener(ServerCommand.MarketSearchCancelSell,cancelBack);
			NetDispatcher.addCmdListener(ServerCommand.MarketGetMySellsBack,mySellUpdate);
			
			getDataFromServer();
			mySellUpdate();
		}
		
		
		private function onPageChange(e:Event):void  //翻页
		{
			this.updatePanel(Cache.instance.market.mySaleMarketItemObj);
		}
		
		/** 向服务器请求数据 */
		public function getDataFromServer():void
		{
			var obj:Object = {};
			obj.recordType = EMarketRecordType._EMarketRecordSell;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketGetMyRecords,obj));
		}
		
		private function mySellUpdate(e:Object = null):void
		{
			this.updatePanel(Cache.instance.market.mySaleMarketItemObj);
		}
		
		/** 下架返回 */
		private function cancelBack(e:Object):void 
		{
			// TODO Auto Generated method stub
			getDataFromServer();
		}	
		
	}
}