package mortal.game.view.market.qiugou
{
	import com.mui.controls.GRadioButton;
	import com.mui.controls.GSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 我要求购主面板
	 * @author lizhaoning
	 */
	public class MarketQiugouPanel extends GSprite
	{
		private var _boxItem:GRadioButton;
		private var _boxCoin:GRadioButton;
		private var _boxGold:GRadioButton;
		
		private var _qiugouItem:MktQiugouItem;
		private var _qiugouCoin:MktQiugouCoin;
		private var _qiugouGold:MktQiugouGold;
		private var _searchPanel:MktQiugouRtPanel;
		public function MarketQiugouPanel()
		{
			super();
		}

		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_boxItem = UIFactory.radioButton("求购物品",25,63,85,28,this);
			_boxCoin = UIFactory.radioButton("求购铜钱",115,63,85,28,this);
			_boxGold = UIFactory.radioButton("求购元宝",205,63,85,28,this);
			_boxItem.groupName = "MarketQiugouRadioGroup";
			_boxCoin.groupName = "MarketQiugouRadioGroup";
			_boxGold.groupName = "MarketQiugouRadioGroup";
			
			
			_searchPanel = UICompomentPool.getUICompoment(MktQiugouRtPanel);
			_searchPanel.createDisposedChildren();
			_searchPanel.x = 367;
			_searchPanel.y = 92;
			addChild(_searchPanel);
			
			_boxItem.configEventListener(Event.CHANGE,radioBtnChange);
			_boxCoin.configEventListener(Event.CHANGE,radioBtnChange);
			_boxGold.configEventListener(Event.CHANGE,radioBtnChange);
			
			//其他面板事件监听
			Dispatcher.addEventListener(EventName.MarketPushSeekItem,onPushItem);
			
			//默认显示求购物品
			onPushItem(null);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_boxItem.dispose(isReuse);
			_boxCoin.dispose(isReuse);
			_boxGold.dispose(isReuse);
			_searchPanel.dispose(isReuse);
			if(_qiugouItem)
			{
				_qiugouItem.dispose(isReuse);
				_qiugouItem = null;
			}
			if(_qiugouCoin)
			{
				_qiugouCoin.dispose(isReuse);
				_qiugouCoin = null;
			}
			if(_qiugouGold)
			{
				_qiugouGold.dispose(isReuse);
				_qiugouGold = null;
			}
			
			
			_boxItem = null;
			_boxCoin = null;
			_boxGold = null;
			_searchPanel = null;
		}
		
		private function onPushItem(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_boxItem.selected = true;
			radioBtnChange(null);
		}
		
		private function radioBtnChange(e:Event):void
		{
			if(qiugouItem){
				qiugouItem.visible = false;
			}
			if(qiugouCoin){
				qiugouCoin.visible = false;
			}
			if(qiugouGold){
				qiugouGold.visible = false;
			}
			
			
			if(_boxItem.selected){
				qiugouItem.visible = true;
			}
			if(_boxCoin.selected){
				qiugouCoin.visible = true;
			}
			if(_boxGold.selected){
				qiugouGold.visible = true;
			}
		}
		
		public function get qiugouCoin():MktQiugouCoin
		{
			if(_qiugouCoin == null)
			{
				_qiugouCoin = UIFactory.getUICompoment(MktQiugouCoin,15,92,this)  as MktQiugouCoin;
			}
			return _qiugouCoin;
		}
		
		public function get qiugouItem():MktQiugouItem
		{
			if(_qiugouItem == null)
			{
				_qiugouItem = UIFactory.getUICompoment(MktQiugouItem,15,92,this)  as MktQiugouItem;
			}
			return _qiugouItem;
		}
		
		
		public function get qiugouGold():MktQiugouGold
		{
			if(_qiugouGold == null)
			{
				_qiugouGold = UIFactory.getUICompoment(MktQiugouGold,15,92,this)  as MktQiugouGold;
			}
			return _qiugouGold;
		}
	}
}