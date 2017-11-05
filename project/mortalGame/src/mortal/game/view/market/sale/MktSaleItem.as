package mortal.game.view.market.sale
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GNumericStepper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.TodayNotTipUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.TodayNoTipsConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.alert.MktTodayNoTipAlert;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 市场寄售道具
	 * @author lizhaoning
	 */
	public class MktSaleItem extends MktSaleBase
	{
		
		private var _numStepper:GNumericStepper;
//		private var _maxNumBtn:GLoadedButton;
		private var _comboMType:GComboBox;
		
		private var itemData:ItemData;
		public function MktSaleItem()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			itemData = null;
			
			_numStepper.dispose(isReuse);
//			_maxNumBtn.dispose(isReuse);
			_comboMType.dispose(isReuse);
			
			
			_numStepper = null;
//			_maxNumBtn = null;
			_comboMType = null;
		}
		
		override protected function resetUI():void
		{
			// TODO Auto Generated method stub
			super.resetUI();
			
			var _tfBai:GTextFormat = GlobalStyle.textFormatBai;
			_tfBai.align = TextFormatAlign.RIGHT;
			
			_numStepper = UIFactory.gNumericStepper(115,144,49,20,this,999,1,"NumericStepper",_tfBai);
			_numStepper.minimum  = 1;
			_numStepper.value = _numStepper.minimum;
			
//			_maxNumBtn = UIFactory.gLoadedButton(ImagesConst.numMax_upSkin,_numStepper.x+_numStepper.width,_numStepper.y,20,20,this);
//			_maxNumBtn.drawNow();
			
			_comboMType = UIFactory.gComboBox(218,this._txtPrice.y,55,22,null,this);
			_comboMType.dataProvider = MktModConfig.dpMoneyType.clone();
			
			
			_item.configEventListener(MouseEvent.CLICK,clickHandler);
//			_maxNumBtn.configEventListener(MouseEvent.CLICK,clickHandler);
			_numStepper.configEventListener(Event.CHANGE,changeNum);
			_comboMType.configEventListener(Event.CHANGE,onComboMTypeChange);
		
			//其他面板事件监听
			Dispatcher.addEventListener(EventName.MarketPushSaleItem,pushItem);
			
			reset(true);
		}
		
		private function pushItem(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			reset(true);
			
			itemData = (e.data as ItemData);
			this._item.itemCode = itemData.itemCode;
			this._numStepper.maximum = itemData.itemAmount;
			this._numStepper.value = this._numStepper.maximum;
		}
		
		private function onComboMTypeChange(e:Event):void
		{
			_txtPrice.unit = _comboMType.selectedItem.moneyType;
			updateTax();
		}
		
		private function changeNum(e:Event):void
		{	
			
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
//			if(e.currentTarget == _maxNumBtn)
//			{
//				_numStepper.value = _numStepper.maximum;
//			}
			if(e.currentTarget == _btnReset)
			{
				reset();
			}
			else if(e.currentTarget == _btnSale)
			{
				sale();
			}
			else if(e.currentTarget == _item)
			{
				reset(true);
			}
		}
		
		override protected function reset(clearItem:Boolean = false):void
		{
			super.reset(clearItem);
			if(clearItem)
			{
				itemData = null;
				this._item.itemData = null;
				this._numStepper.maximum = 999;
				Dispatcher.dispatchEvent(new DataEvent(EventName.MarketRemoveSaleItem));
			}
			
			_numStepper.value = _numStepper.minimum;
			this._txtPrice.textInput.text = "";
			this._comboMType.selectedIndex = 0;
			onComboMTypeChange(null);
			this._timeBox.selectedIndex = 0;
		}
		
		private function sale():void
		{
			if(this._item.itemData == null)
			{
				MsgManager.showRollTipsMsg("请选择要寄售的物品");
				return;
			}
			
			if(this._txtPrice.value <=0)
			{
				MsgManager.showRollTipsMsg("请输入正确的价格");
				return;
			}
			
			//手续费判断
			var totalTax:int = this._btnBroadcast.selected ? MktModConfig.BroadcastCost:0;
			totalTax += _txtTax.value;
			if(!Cache.instance.role.enoughMoney(EPrictUnit._EPriceUnitCoin,totalTax))
			{
				MsgManager.showRollTipsMsg("铜钱不足");
				return;
			}
			
			
//			/你将以5元宝的价格寄售2个汉堡包
			var str:String = "你将以"+
				HTMLUtil.addColor(this._txtPrice.value.toString(),GlobalStyle.colorHuang)+
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtPrice.unit,GlobalStyle.colorHuang)+"的价格寄售" +
				HTMLUtil.addColor(this._numStepper.value.toString(),GlobalStyle.colorHuang) + "个" +
				ItemsUtil.getItemName(itemData) + "，寄售时间"+
				HTMLUtil.addColor(this._timeBox.selectedItem.timeType,GlobalStyle.colorHuang)+
				HTMLUtil.addColor("小时",GlobalStyle.colorHuang);
			//Alert.show(str,null,Alert.OK|Alert.CANCEL,null,onSelect);
		
			var todayTipsType:String = "";
			if(this._txtPrice.unit == EPrictUnit._EPriceUnitCoin)
			{
				todayTipsType = TodayNoTipsConst.MarketSaleByCoin;
			}
			else if(this._txtPrice.unit == EPrictUnit._EPriceUnitGold)
			{
				todayTipsType = TodayNoTipsConst.MarketSaleByGold;
			}
			
			var obj:Object = {};
			obj.unit = this._txtPrice.unit;
			obj.str = "寄售";
			Alert.extendObj = obj;
			TodayNotTipUtil.toDayNotTip(todayTipsType,onSelect,str,null,Alert.OK|Alert.CANCEL,null,null,null,0x4,MktTodayNoTipAlert);
			//Alert.show(str,null,Alert.OK|Alert.CANCEL,null,onBuySelect);
		}
		
		private function onSelect():void
		{
			var obj:Object = {};
			obj.code = itemData.itemCode;
			obj.itemUid = itemData.uid;
			obj.amount = this._numStepper.value;
			obj.price = this._txtPrice.value;
			obj.unit = this._txtPrice.unit;
			obj.time = this._timeBox.selectedItem.timeType;
			obj.broadcast = this._btnBroadcast.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketSale,obj));
		}
	}
}