package mortal.game.view.market.sale
{
	import com.mui.controls.GRadioButton;
	import com.mui.controls.GSprite;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.RadioButtonGroup;
	
	import flash.events.Event;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 市场寄售主界面
	 * @author lizhaoning
	 */
	public class MarketSalePanel extends GSprite
	{
		private var _boxItem:GRadioButton;
		private var _boxCoin:GRadioButton;
		private var _boxGold:GRadioButton;
		
		private var _saleYuBao:MktSaleGlod;
		private var _saleJinbi:MktSaleCoin;
		private var _saleItem:MktSaleItem;
		private var _bag:MktBag;
		
		public function MarketSalePanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_boxItem = UIFactory.radioButton("寄售物品",25,63,85,28,this);
			_boxCoin = UIFactory.radioButton("寄售铜钱",115,63,85,28,this);
			_boxGold = UIFactory.radioButton("寄售元宝",205,63,85,28,this);
			_boxItem.groupName = "MarketSaleRadioGroup";
			_boxCoin.groupName = "MarketSaleRadioGroup";
			_boxGold.groupName = "MarketSaleRadioGroup";
			
			
			_saleYuBao = UIFactory.getUICompoment(MktSaleGlod,15,92,this);
			_saleYuBao.visible = false;
			_saleItem = UIFactory.getUICompoment(MktSaleItem,15,92,this);
			_saleItem.visible = false;
			_saleJinbi = UIFactory.getUICompoment(MktSaleCoin,15,92,this);
			_saleJinbi.visible = false;
			
			_bag = UIFactory.getUICompoment(MktBag,367,92,this);
			
			_boxItem.configEventListener(Event.CHANGE,radioBtnChange);
			_boxCoin.configEventListener(Event.CHANGE,radioBtnChange);
			_boxGold.configEventListener(Event.CHANGE,radioBtnChange);
			
			//其他面板事件监听
			Dispatcher.addEventListener(EventName.MarketPushSaleItem,onPushItem);
			
			//默认显示寄售物品
			onPushItem(null);
		}
		
		private function onPushItem(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_boxItem.selected = true;
			radioBtnChange(null);
		}
		
		private function radioBtnChange(e:Event):void
		{
			// TODO Auto Generated method stub
			if(_saleYuBao){
				_saleYuBao.visible = false;
			}
			if(_saleItem){
				_saleItem.visible = false;
			}
			if(_saleJinbi){
				_saleJinbi.visible = false;
			}
			
			if(_boxItem.selected){
				_saleItem.visible = true;
			}
			if(_boxCoin.selected){
				_saleJinbi.visible = true;
			}
			if(_boxGold.selected){
				_saleYuBao.visible = true;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_boxItem.dispose(isReuse);
			_boxCoin.dispose(isReuse);
			_boxGold.dispose(isReuse);
			_bag.dispose(isReuse);
			
			_boxItem = null;
			_boxCoin = null;
			_boxGold = null;
			_bag = null;
			
			if(_saleYuBao)
			{
				_saleYuBao.dispose(isReuse);
				_saleYuBao = null;
			}
			if(_saleJinbi)
			{
				_saleJinbi.dispose(isReuse);
				_saleJinbi = null;
			}
			if(_saleItem)
			{
				_saleItem.dispose(isReuse);
				_saleItem = null;
			}
		}
		
	}
}