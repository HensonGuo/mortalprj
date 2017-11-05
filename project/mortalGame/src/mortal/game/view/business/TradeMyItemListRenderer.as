package mortal.game.view.business
{
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 
	 * @author lizhaoning
	 */
	public class TradeMyItemListRenderer extends TradeListRenderer
	{
		public function TradeMyItemListRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			_item.configEventListener(MouseEvent.CLICK,onClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			Dispatcher.dispatchEvent(new DataEvent(EventName.TradeClickItem,this.data.itemData));
		}
		
	}
}