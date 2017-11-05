package mortal.game.view.market.myQiugou
{
	import Message.Game.EMarketRecordType;
	import Message.Game.SMarketItem;
	import Message.Public.EPrictUnit;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.tools.DateUtil;
	import mortal.component.skin.Label.GLabelStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.MsgManager;
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
	 * 
	 * @author lizhaoning
	 */
	public class MktMyCellRenderner extends GCellRenderer
	{
		private var _item:BaseItem;
		private var _txtItemName:GTextFiled;
		private var _txtTime:GTextFiled;
		private var _bmpTotalPrice:GBitmap;
		private var _txtTotalPrice:GTextFiled;
		private var _bgTotalPrice:ScaleBitmap;
		private var _btnBroadcast:GButton;
		private var _btnSoldOut:GButton;
		private var _line:ScaleBitmap;
		public function MktMyCellRenderner()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			_item = UIFactory.getUICompoment(BaseItem,0,3,this);
			_item.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,2,3);
			
			_txtItemName = UIFactory.textField("mingzi",45,8,100,20,this);
			_txtTime = UIFactory.textField("[剩余时间]",45,26,100,20,this);
			
			_bgTotalPrice = UIFactory.bg(163,13,70,22,this,ImagesConst.InputDisablBg);
			var _tf:GTextFormat = GlobalStyle.textFormatHuang;
			_tf.align = TextFormatAlign.CENTER;
			_txtTotalPrice = UIFactory.textField("",_bgTotalPrice.x,_bgTotalPrice.y,_bgTotalPrice.width,_bgTotalPrice.height,this,_tf);
			_bmpTotalPrice = UIFactory.bitmap("",0,0,this);
			
			_btnBroadcast = UIFactory.gButton("广播",261,13,38,22,this);
			_btnSoldOut = UIFactory.gButton("下架",301,13,38,22,this);
			
			
			_btnBroadcast.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnSoldOut.configEventListener(MouseEvent.CLICK,clickHandler);
			
			_line = UIFactory.bg(0,47,320,1,this,ImagesConst.SplitLine);
			
			unit = 1;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			var obj:Object = {};
			var marketItem:SMarketItem = this.data as SMarketItem;
			if(e.currentTarget == _btnBroadcast)
			{
				//是否花费2000铜钱宣传该条寄售信息
				var str:String = "是否花费"+
					HTMLUtil.addColor(MktModConfig.BroadcastCost.toString(),GlobalStyle.colorHuang) +
					GameDefConfig.instance.getEPrictNameAddColoer(EPrictUnit._EPriceUnitCoin) +
					"宣传该条";
				str += marketItem.recordType == EMarketRecordType._EMarketRecordSell ? "寄售":"求购";
				str += "信息";
				Alert.show(str,null,Alert.OK|Alert.CANCEL,null,onSelect);
				
				function onSelect(type:int):void
				{
					if(type == Alert.OK)
					{
						if(!Cache.instance.role.enoughMoney(EPrictUnit._EPriceUnitCoin,MktModConfig.BroadcastCost))
						{
							MsgManager.showRollTipsMsg("铜钱不足");
							return;
						}
						obj = {};
						obj.recordId = marketItem.recordId;
						Dispatcher.dispatchEvent(new DataEvent(EventName.MarketBroadcast,obj));
					}
				}
			}
			else if(e.currentTarget == _btnSoldOut)
			{
				if(this.data is SMarketItem)
				{
					obj = {};
					obj.recordId = marketItem.recordId;
					if(marketItem.recordType == EMarketRecordType._EMarketRecordSell)
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.MarketCancelSell,obj));
					}
					else if(marketItem.recordType == EMarketRecordType._EMarketRecordSeekBuy)
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.MarketCancelSeekBuy,obj));
					}
				}
			}
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
					_item.amount = 0;  //钱 这里不显示数量
				}
				else
				{
					_item.itemCode = marketItem.code;
					_item.amount = marketItem.amount;
					_txtItemName.htmlText = ItemsUtil.getItemName(_item.itemData);
				}
				unit = marketItem.sellUnit;
				_txtTotalPrice.text = MktModConfig.getTotalPrice(marketItem);
				
				var minutes:int = DateUtil.getSecondsDis(ClockManager.instance.nowDate,marketItem.timeoutDt) / 60;
				if(minutes < 0) {
					_txtTime.text = "已过期";
				}
				else if(minutes>60) {
					_txtTime.text = "剩余" + Math.ceil(minutes/60) + "小时";
				}
				else {
					_txtTime.text = "剩余" + minutes + "分钟";
				}
			}
		}
		
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_item.dispose(isReuse);
			_txtItemName.dispose(isReuse);
			_txtTime.dispose(isReuse);
			_bgTotalPrice.dispose(isReuse);
			_txtTotalPrice.dispose(isReuse);
			_bmpTotalPrice.dispose(isReuse);
			_btnBroadcast.dispose(isReuse);
			_btnSoldOut.dispose(isReuse);
			
			
			_item = null;
			_txtItemName = null;
			_txtTime = null;
			_bgTotalPrice = null;
			_txtTotalPrice = null;
			_bmpTotalPrice = null;
			_btnBroadcast = null;
			_btnSoldOut = null;
		}
		
		
		/**
		 * 设置货币单位 
		 * @param type
		 */		
		private var _unit:int;
		public function set unit(type:int):void
		{
			_unit = type;
			_bmpTotalPrice.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getEPrictUnitImg(type));
			_bmpTotalPrice.x = _bgTotalPrice.x -22;
			_bmpTotalPrice.y = _bgTotalPrice.y+ (_bgTotalPrice.height-_bmpTotalPrice.height)/2;
		}
	}
}