package mortal.game.view.market.buyAndQiugou
{
	import Message.Game.SMarketItem;
	import Message.Public.EPrictUnit;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.market.MktModConfig;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 市场购买界面物品列表单个ListItem
	 * @author lizhaoning
	 */
	public class MktQiugouListItem extends GCellRenderer
	{
		private var _item:BaseItem;
		private var _itemBg:GBitmap;
		private var _txtItemName:GTextFiled;
		private var _txtLevel:GTextFiled;
		private var _bmpUintPrice:GBitmap;
		private var _txtUintPrice:GTextFiled;
		private var _bgUintPrice:ScaleBitmap;
		private var _btnBuy:GButton;
		private var _line:ScaleBitmap;
		
		public function MktQiugouListItem()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_item = UIFactory.getUICompoment(BaseItem,15,5,this);
			_item.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,2,3);
			
//			_item = UICompomentPool.getUICompoment(BaseItem);
//			_item.createDisposedChildren();
//			_item.x=15;
//			_item.y=5;
//			this.addChild(_item);
//			
//			_itemBg = GlobalClass.getBitmap(ImagesConst.PackItemBg);
//			_item.addChildAt(_itemBg,0);
			
			_txtItemName = UIFactory.gTextField("恶魔之刃",57,18,100,20,this);
			_txtLevel = UIFactory.gTextField("50",195,18,20,20,this);
			_bmpUintPrice = UIFactory.bitmap("",265,18,this);
			_bgUintPrice = UIFactory.bg(290,18,60,20,this,ImagesConst.InputDisablBg);
			_txtUintPrice = UIFactory.gTextField("50",290,18,60,20,this);
			_txtUintPrice.autoSize = TextFieldAutoSize.CENTER;
			
			_btnBuy = UIFactory.gButton("出售",415,20,45,22,this);
			
			_line = UIFactory.bg(0,49,474,1,this,ImagesConst.SplitLine);
			
			_btnBuy.configEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
//			_itemBg.dispose(isReuse);
			_item.dispose(isReuse);
			_txtItemName.dispose(isReuse);
			_txtLevel.dispose(isReuse);
			_bmpUintPrice.dispose(isReuse);
			_bgUintPrice.dispose(isReuse);
			_txtUintPrice.dispose(isReuse);
			_btnBuy.dispose(isReuse);
			_line.dispose(isReuse);
			
//			_itemBg = null;
			_item = null;
			_txtItemName = null;
			_txtLevel = null;
			_bmpUintPrice = null;
			_bgUintPrice = null;
			_txtUintPrice = null;
			_btnBuy = null;
			_line = null;
		}
		
		override public function set data(arg0:Object):void
		{
			// TODO Auto Generated method stub
			super.data = arg0;
			
			if(arg0 is SMarketItem)
			{
				var marketItem:SMarketItem = arg0 as SMarketItem;
				
				if(marketItem.code == EPrictUnit._EPriceUnitCoin ||
					marketItem.code == EPrictUnit._EPriceUnitGold)
				{
					_item.source = GlobalClass.getBitmapData( GameDefConfig.instance.getMoneyBigIcon(marketItem.code));
					_txtItemName.htmlText = marketItem.amount + GameDefConfig.instance.getEPrictUnitName(marketItem.code);
					_txtLevel.text = "1";
				}
				else
				{
					_item.itemCode = marketItem.code;
					_item.amount = marketItem.amount;
					_txtItemName.htmlText = ItemsUtil.getItemName(_item.itemData);
					_txtLevel.text = _item.itemData.itemInfo.level.toString();
				}
				
				unit = marketItem.sellUnit;
				_txtUintPrice.text = MktModConfig.getUnitPrice(marketItem);
			}
			
			_txtItemName.htmlText = "<a href='event:1'>"+_txtItemName.htmlText + "</a>";
			_txtItemName.configEventListener(TextEvent.LINK,onNameLink);
		}
		
		override public function get data():Object
		{
			// TODO Auto Generated method stub
			return super.data;
		}
		
		private function onNameLink(e:TextEvent):void
		{
			// TODO Auto Generated method stub
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketSearchClickName,data));
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketSellItem2SeekBuy,data));
		}
		
		/**
		 * 设置货币单位 
		 * @param type
		 */		
		private var _unit:int;
		public function set unit(type:int):void
		{
			_unit = type;
			
			_bmpUintPrice.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getEPrictUnitImg(type));
			_bmpUintPrice.x = _bgUintPrice.x -22;
			_bmpUintPrice.y = _bgUintPrice.y+ (_bgUintPrice.height-_bmpUintPrice.height)/2;
		}
	}
}