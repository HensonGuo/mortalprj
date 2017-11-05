package mortal.game.view.market.qiugou
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
	import mortal.game.view.market.myQiugou.MarketMyQiugouPanel;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 求购基础界面
	 * @author lizhaoning
	 */
	public class MktQiugouBase extends GSprite
	{
		protected var _bg:ScaleBitmap;
		protected var _titleBg:ScaleBitmap;
		protected var _title:GBitmap;
		protected var _itemBg:GBitmap;
		protected var _item:BaseItem;
		protected var _txtUintPrice:MoneyInput;
		protected var _txtTotalPrice:MoneyItem;
	//	protected var _bgTotalPrice:ScaleBitmap;
		protected var _timeBox:GComboBox;
		protected var _txtTax:MoneyItem;
		protected var _btnQiugou:GButton;
		protected var _btnReset:GButton;
		protected var _btnBroadcast:GCheckBox;
		protected var _txtBoradCastCost:MoneyItem;
		
		protected var _txtMySales:GTextFiled;
		
		
		protected var _tfBai:GTextFormat;
		protected var _tfAnjin:GTextFormat;
		public function MktQiugouBase()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_tfBai = GlobalStyle.textFormatBai;
			_tfBai.align = TextFormatAlign.RIGHT;
			_tfAnjin = GlobalStyle.textFormatAnjin;
			
			
			_bg = UIFactory.bg(0,0,350,414,this);
			_titleBg = UIFactory.bg(1,0,350,25,this,"RegionTitleBg");
			_title = UIFactory.bitmap(ImagesConst.market5,0,0,this);
			_title.x = (_titleBg.width-_title.width)/2;
			_title.y = (_titleBg.y + _titleBg.height-_title.height)/2;
			
			_itemBg = UIFactory.bitmap(ImagesConst.marketItemBg,0,45,this);
			_itemBg.x = (_bg.width - _itemBg.width)/2;
			_item = UIFactory.getUICompoment(BaseItem,145,55,this);
			_item.setItemStyle(ItemStyleConst.Big,null,0,0);
			
			_txtUintPrice = UIFactory.getUICompoment(MoneyInput,115,172,this);
		//	_txtUintPrice.textInput.textField.setTextFormat(_tfBai);
			//_txtUintPrice.textInput.text = "0";
			_txtUintPrice.unit = EPrictUnit._EPriceUnitGold;
			
			
		//	_bgTotalPrice = UIFactory.bg(115,202,105,22,this,ImagesConst.InputDisablBg);
			_txtTotalPrice = UIFactory.getUICompoment(MoneyItem,199,203,this); 
			_txtTotalPrice.tfNum.setTextFormat(_tfBai);
			_txtTotalPrice.unit = EPrictUnit._EPriceUnitCoin;
			_txtTotalPrice.value = 0;
			_timeBox = UIFactory.gComboBox(115,234,70,22,null,this);
			_timeBox.dataProvider = MktModConfig.dpTimeType.clone();
			
			var txt1:GTextFiled = UIFactory.textField("保存费",_timeBox.x + _timeBox.width,_timeBox.y,41,20,this);
			pushUIToDisposeVec(txt1);
			_txtTax = UIFactory.getUICompoment(MoneyItem, txt1.x + txt1.width+40,txt1.y,this);
			_txtTax.unit = EPrictUnit._EPriceUnitCoin;
			_txtTax.value = 0;
			
			
			pushUIToDisposeVec(UIFactory.textField("求购数量：",50,144,68,22,this,_tfAnjin));
			pushUIToDisposeVec(UIFactory.textField("求购单价：",50,172,68,22,this,_tfAnjin));
			pushUIToDisposeVec(UIFactory.textField("求购总价：",50,202,68,22,this,_tfAnjin));
			pushUIToDisposeVec(UIFactory.textField("求购时长：",50,234,68,22,this,_tfAnjin));
			
			
			_btnQiugou = UIFactory.gButton("求购",112,267,55,22,this);
			_btnReset = UIFactory.gButton("重置",188,267,55,22,this);
			
			_btnBroadcast = UIFactory.checkBox("世界频道宣传，花费",86,312,128,20,this);
			_txtBoradCastCost = UIFactory.getUICompoment(MoneyItem,_btnBroadcast.x+_btnBroadcast.width+35,_btnBroadcast.y,this);
			_txtBoradCastCost.unit = EPrictUnit._EPriceUnitCoin;
			_txtBoradCastCost.value = MktModConfig.BroadcastCost;
			
			_txtMySales = UIFactory.textField("",230,360,110,28,this);
			_txtMySales.htmlText = HTMLUtil.addColor("<u><a href='event:1'>查看我的求购物品</a></u>",GlobalStyle.green);
			_txtMySales.configEventListener(TextEvent.LINK,onTextLink);
			
			_txtUintPrice.configEventListener(Event.CHANGE, onTxtUintPriceChange);
			_timeBox.configEventListener(Event.CHANGE,timeSelectChange);
			_btnBroadcast.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnQiugou.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnReset.configEventListener(MouseEvent.CLICK,clickHandler);
			
			NetDispatcher.addCmdListener(ServerCommand.MarketResultSeekBuy,qiugouItemBack);
			
			resetUI();
		}
		
		private function qiugouItemBack(e:Object):void
		{
			// TODO Auto Generated method stub
			reset(true);
		}
		
		/** 提供复写 */
		protected function resetUI():void
		{
			
		}
		
		protected function setMoneyBmpPos(_bmp:GBitmap, head:DisplayObject, paret:DisplayObjectContainer):void
		{
			_bmp.x = head.x + head.width;
			_bmp.y = head.y+ (head.height-_bmp.height)/2;
			paret.addChild(_bmp);
		}
		
		protected function onTextLink(e:TextEvent):void
		{
			MarketMyQiugouPanel.instance.show();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			NetDispatcher.removeCmdListener(ServerCommand.MarketResultSeekBuy,qiugouItemBack);
			
			_bg.dispose(isReuse);
			_titleBg.dispose(isReuse);
			_title.dispose(isReuse);
			_itemBg.dispose(isReuse);
			_item.dispose(isReuse);
			_txtUintPrice.dispose(isReuse);
			_txtTotalPrice.dispose(isReuse);
			//_bgTotalPrice.dispose(isReuse);
			_timeBox.dispose(isReuse);
			_txtTax.dispose(isReuse);
			_btnQiugou.dispose(isReuse);
			_btnReset.dispose(isReuse);
			_btnBroadcast.dispose(isReuse);
			_txtBoradCastCost.dispose(isReuse);
			_txtMySales.dispose(isReuse);
			
			
			_bg = null;
			_titleBg = null;
			_title = null;
			_itemBg = null;
			_item = null;
			_txtUintPrice = null;
			_txtTotalPrice = null;
			//_bgTotalPrice = null;
			_timeBox = null;
			_txtTax = null;
			_btnQiugou = null;
			_btnReset = null;
			_btnBroadcast = null;
			_txtBoradCastCost = null;
			_txtMySales = null;
			
			_tfBai = null;
			_tfAnjin = null;
		}
		
		private function timeSelectChange(e:Event):void
		{
			// TODO Auto Generated method stub
			updateTax();
		}
		
		protected function onTxtUintPriceChange(e:Event):void
		{
			// TODO Auto Generated method stub
			changeTotolPrice();
		}
		
		//计算总价
		protected function changeTotolPrice():void
		{
			updateTax();
		}
		
		
		/** 更新手续费   */
		protected function updateTax():void
		{
			var num:int = MktModConfig.getTax(this._timeBox.selectedItem.timeType,this._txtTotalPrice.unit,this._txtTotalPrice.value);
			this._txtTax.value = num;
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(e.currentTarget == _btnBroadcast)
			{
				
			}
			else if(e.currentTarget == _btnQiugou)
			{
				
			}
			else if(e.currentTarget == _btnReset)
			{
				
			}
		}
		
		protected function reset(clearItem:Boolean = false):void
		{
			this._txtUintPrice.value = 0;
			this._timeBox.selectedIndex = 0;
			this._btnBroadcast.selected = false;
		}
	}
}