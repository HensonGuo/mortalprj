package mortal.game.view.shop
{
	import Message.DB.Tables.TShop;
	
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.manager.CursorManager;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.game.view.shopMall.view.ShopSellItem;
	
	
	public class ShopCellRenderer extends GCellRenderer
	{
		private var _npcId:int;
		
		private var _shopItem:ShopSellItem;
		
		private var _itemName:GTextFiled;
		
		private var _price:GTextFiled;
		
		private var _moneyIcon:GBitmap;
		
		public function ShopCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.doubleClickEnabled = true;
			this.configEventListener(MouseEvent.DOUBLE_CLICK,doubClickHandler);
			this.configEventListener(MouseEvent.CLICK,	clickHandler);
			
			this.pushUIToDisposeVec(UIFactory.bg(0,0,145,50,this,ImagesConst.InputDisablBg));
//			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.PackItemBg,4,4,this));
			
			_shopItem = UICompomentPool.getUICompoment(ShopSellItem);
			_shopItem.x = 5;
			_shopItem.y = 4;
			_shopItem.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,3,3);
			this.addChild(_shopItem);
			_shopItem.mouseChildren = false;
			_shopItem.doubleClickEnabled = true;
			_shopItem.configEventListener(MouseEvent.DOUBLE_CLICK,doubClickHandler);
			_shopItem.configEventListener(MouseEvent.CLICK,	clickHandler);
			
			_itemName = UIFactory.gTextField("",55,5,120,20,this,null,true);
			_itemName.mouseEnabled = false;
			
			_moneyIcon = UIFactory.gBitmap("",55,27,this);
			
			var tm:GTextFormat = GlobalStyle.textFormatPutong;
			tm.align = AlignMode.CENTER;
			_price = UIFactory.gTextField("",70,25,60,20,this);
			_price.mouseEnabled = false;
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_shopItem.dispose(isReuse);
			_itemName.dispose(isReuse);
			_moneyIcon.dispose(isReuse);
			_price.dispose(isReuse);
			
			_shopItem = null;
			_itemName = null;
			_moneyIcon = null;
			_price = null;
			super.disposeImpl(isReuse);
		}
		
		
		private function setMoneyIcon(type:int):void
		{
			_moneyIcon.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getMoneyIcon(type));
		}
		
		override public function set data(arg0:Object):void
		{
			_shopItem.shopPropData = arg0.data as ShopItemData;
			_npcId = arg0.npcId as int;
			var tshop:TShop = ShopConfig.instance.getShopById(_shopItem.shopPropData.tShopSell.shopCode);
			
			setMoneyIcon(tshop.unit);
			
			_itemName.htmlText = ItemsUtil.getItemName(_shopItem.itemData);
			
			if(_shopItem.shopPropData.tShopSell.activeOffer != 0)   //有活动价的时候显示特价
			{
				_price.text = _shopItem.shopPropData.tShopSell.activeOffer.toString();
			}
			else
			{
				_price.text = _shopItem.shopPropData.tShopSell.offer.toString();
			}
			
		}
		
		private function doubClickHandler(e:MouseEvent):void
		{
			BuyItemWin.showWin(_shopItem.shopPropData,_npcId);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if(CursorManager.currentCurSorType == CursorManager.BUY)
			{
				BuyItemWin.showWin(_shopItem.shopPropData,_npcId);
			}
			else if(CursorManager.currentCurSorType == CursorManager.NO_CURSOR)
			{
				
			}
		}
	}
}