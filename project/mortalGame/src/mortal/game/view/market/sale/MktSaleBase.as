package mortal.game.view.market.sale
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.MoneyInput;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.common.item.MoneyItem;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.myQiugou.MarketMySalePanel;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 市场寄售基础面板
	 * @author lizhaoning
	 */
	public class MktSaleBase extends GSprite
	{
		protected var _bg:ScaleBitmap;
		protected var _titleBg:ScaleBitmap;
		protected var _title:GBitmap;
		protected var _itemBg:GBitmap;
		protected var _item:BaseItem;
		protected var _txtPrice:MoneyInput;
		protected var _timeBox:GComboBox;
		protected var _txtTax:MoneyItem;
		protected var _btnSale:GButton;
		protected var _btnReset:GButton;
		protected var _btnBroadcast:GCheckBox;
		protected var _txtBoradCastCost:MoneyItem;
		
		protected var _txtMySales:GTextFiled;
		
		public function MktSaleBase()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			
			var _tfBai:GTextFormat = GlobalStyle.textFormatBai;
			_tfBai.align = TextFormatAlign.RIGHT;
			
			_bg = UIFactory.bg(0,0,350,414,this);
			_titleBg = UIFactory.bg(1,0,350,25,this,"RegionTitleBg");
			_title = UIFactory.bitmap(ImagesConst.market2,0,0,this);
			_title.x = (_titleBg.width-_title.width)/2;
			_title.y = (_titleBg.y + _titleBg.height-_title.height)/2;
			
			
			_itemBg = UIFactory.bitmap(ImagesConst.marketItemBg,0,45,this);
			_itemBg.x = (_bg.width - _itemBg.width)/2;
			_item = UIFactory.getUICompoment(BaseItem,145,55,this);
			_item.setItemStyle(ItemStyleConst.Big,null,0,0);
			
			
			_txtPrice = UIFactory.getUICompoment(MoneyInput,115,180,this);
			_txtPrice.unit = EPrictUnit._EPriceUnitCoinBind;
			
			_timeBox = UIFactory.gComboBox(115,216,70,22,null,this);
			_timeBox.dataProvider = MktModConfig.dpTimeType.clone();
			_timeBox.selectedIndex = 0;
			
			var txt1:GTextFiled = UIFactory.textField("保存费",_timeBox.x + _timeBox.width,_timeBox.y,41,20,this);
			pushUIToDisposeVec(txt1);
			_txtTax = UIFactory.getUICompoment(MoneyItem, txt1.x + txt1.width+40,txt1.y,this);
			_txtTax.unit = EPrictUnit._EPriceUnitCoin;
			
			var textFormat:GTextFormat = GlobalStyle.textFormatAnjin;
			pushUIToDisposeVec(UIFactory.textField("寄售数量：",50,144,68,22,this,textFormat));
			pushUIToDisposeVec(UIFactory.textField("寄售总价：",50,180,68,22,this,textFormat));
			pushUIToDisposeVec(UIFactory.textField("寄售时长：",50,216,68,22,this,textFormat));
			
			
			_btnSale = UIFactory.gButton("寄售",112,267,55,22,this);
			_btnReset = UIFactory.gButton("重置",188,267,55,22,this);
			
			_btnBroadcast = UIFactory.checkBox("世界频道宣传，花费",86,312,128,20,this);
			_txtBoradCastCost = UIFactory.getUICompoment(MoneyItem,_btnBroadcast.x+_btnBroadcast.width+35,_btnBroadcast.y,this);
			_txtBoradCastCost.unit = EPrictUnit._EPriceUnitCoin;
			_txtBoradCastCost.value = MktModConfig.BroadcastCost;;
			
			_txtMySales = UIFactory.textField("",230,360,110,28,this);
			_txtMySales.htmlText = HTMLUtil.addColor("<u><a href='event:1'>查看我的寄售物品</a></u>",GlobalStyle.green);
			_txtMySales.configEventListener(TextEvent.LINK,onTextLink);
		
			_timeBox.configEventListener(Event.CHANGE, onTimeBoxChange);
			_txtPrice.configEventListener(Event.CHANGE, onTxtPriceChangeHandler);
			_btnBroadcast.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnReset.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnSale.configEventListener(MouseEvent.CLICK,clickHandler);
			
			NetDispatcher.addCmdListener(ServerCommand.MarketResultSellItem,sellItemBack);
			
			resetUI();
		}
		
		
		/** 提供复写 */
		protected function resetUI():void
		{
		}
		
		protected function reset(clearItem:Boolean = false):void
		{
			_timeBox.selectedIndex = 0;
			_btnBroadcast.selected = false;
			updateTax();
		}
		
		private function sellItemBack(obj:Object):void
		{
			// TODO Auto Generated method stub
			this.reset(true);
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(e.currentTarget == _btnBroadcast)
			{
				
			}
			else if(e.currentTarget == _btnReset)
			{
				
			}
			else if(e.currentTarget == _btnSale)
			{
				
			}
		}
		
		private function onTimeBoxChange(e:Event):void
		{
			// TODO Auto Generated method stub
			updateTax();
		}	
		
		protected function onTxtPriceChangeHandler(e:Event):void
		{
			// TODO Auto Generated method stub
			updateTax();
		}
		
		/** 更新手续费   */
		protected function updateTax():void
		{
			var num:int = MktModConfig.getTax(this._timeBox.selectedItem.timeType,this._txtPrice.unit,this._txtPrice.value);
			this._txtTax.value = num;
		}
		
		private function setMoneyBmpPos(_bmp:GBitmap, head:DisplayObject, paret:DisplayObjectContainer):void
		{
			_bmp.x = head.x + head.width;
			_bmp.y = head.y+ (head.height-_bmp.height)/2;
			paret.addChild(_bmp);
		}
		
		private function onTextLink(e:TextEvent):void
		{
			MarketMySalePanel.instance.show();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			NetDispatcher.removeCmdListener(ServerCommand.MarketResultSellItem,sellItemBack);
			
			_bg.dispose(isReuse);
			_titleBg.dispose(isReuse);
			_title.dispose(isReuse);
			_itemBg.dispose(isReuse);
			_item.dispose(isReuse);
			_txtPrice.dispose(isReuse);
			_timeBox.dispose(isReuse);
			_txtTax.dispose(isReuse);
			_btnSale.dispose(isReuse);
			_btnReset.dispose(isReuse);
			_btnBroadcast.dispose(isReuse);
			_txtBoradCastCost.dispose(isReuse);
			_txtMySales.dispose(isReuse);
			
			_bg = null;
			_titleBg = null;
			_title = null;
			_itemBg = null;
			_item = null;
			_txtPrice = null;
			_timeBox = null;
			_txtTax = null;
			_btnSale = null;
			_btnReset = null;
			_btnBroadcast = null;
			_txtBoradCastCost = null;
			_txtMySales = null;
		}
	}
}