package mortal.game.view.market.qiugou
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GNumericStepper;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.TodayNotTipUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.TodayNoTipsConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.alert.MktTodayNoTipAlert;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 求购物品
	 * @author lizhaoning
	 */
	public class MktQiugouItem extends MktQiugouBase
	{
		private var _numStepper:GNumericStepper;
//		private var _maxNumBtn:GLoadedButton;
		private var _comboMType:GComboBox;
		
		public function MktQiugouItem()
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
			
			_numStepper = UIFactory.gNumericStepper(115,144,49,20,this,999,1,"NumericStepper",_tfBai);
			_numStepper.minimum  = 1;
			_numStepper.value = _numStepper.minimum;
			
//			_maxNumBtn = UIFactory.gLoadedButton(ImagesConst.numMax_upSkin,_numStepper.x+_numStepper.width,_numStepper.y,20,20,this);
//			_maxNumBtn.drawNow();
//			_maxNumBtn.configEventListener(MouseEvent.CLICK,clickHandler);
			
			_comboMType = UIFactory.gComboBox(218,this._txtUintPrice.y,55,22,null,this);
			_comboMType.dataProvider = MktModConfig.dpMoneyType.clone();
			
			_numStepper.configEventListener(Event.CHANGE,changeNum);
			_comboMType.configEventListener(Event.CHANGE,onComboMTypeChange);
			
			_item.configEventListener(MouseEvent.CLICK,clickHandler);
			//其他面板事件监听
			Dispatcher.addEventListener(EventName.MarketPushSeekItem,pushItem);
		
			reset(true);
		}
		
		private function pushItem(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			this._item.itemCode = (e.data.code);
		}
		
		private function onComboMTypeChange(e:Event):void
		{
			_txtTotalPrice.unit = _comboMType.selectedItem.moneyType;
			_txtUintPrice.unit = _comboMType.selectedItem.moneyType;
			
			updateTax();
		}
		
		private function changeNum(e:Event):void  //数量改变
		{	
			changeTotolPrice();
		}
		
		override protected function changeTotolPrice():void  //计算总价
		{
			_txtTotalPrice.value = _txtUintPrice.value * _numStepper.value;
			super.changeTotolPrice();
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
			else if(e.currentTarget == _btnQiugou)
			{
				qiugou();
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
				this._item.itemData = null;
				this._numStepper.maximum = 999;
				Dispatcher.dispatchEvent(new DataEvent(EventName.MarketRemoveSeekItem));
			}
			
			_numStepper.value = _numStepper.minimum;
			//this._txtPrice.textInput.text = "";
			this._comboMType.selectedIndex = 0;
			onComboMTypeChange(null);
			this._timeBox.selectedIndex = 0;
			changeTotolPrice();
		}
		
		private function qiugou():void
		{
			if(this._item.itemData == null)
			{
				return;
			}
			
			
			if(this._txtUintPrice.value <=0)
			{
				MsgManager.showRollTipsMsg("请输入正确的价格");
				return;
			}
			
			
			//钱判断
			var goldNeed:int = 0;
			var coinNeed:int = this._btnBroadcast.selected ? MktModConfig.BroadcastCost:0;
			coinNeed += _txtTax.value;
			if(_txtTotalPrice.unit == EPrictUnit._EPriceUnitGold)
			{
				goldNeed += _txtTotalPrice.value;
			}
			else if(_txtTotalPrice.unit == EPrictUnit._EPriceUnitCoin)
			{
				coinNeed += _txtTotalPrice.value;
			}
			if(!Cache.instance.role.enoughMoney(EPrictUnit._EPriceUnitCoin,coinNeed))
			{
				MsgManager.showRollTipsMsg("铜钱不足");
				return;
			}
			if(!Cache.instance.role.enoughMoney(EPrictUnit._EPriceUnitCoin,goldNeed))
			{
				MsgManager.showRollTipsMsg("元宝不足");
				return;
			}
			
			//【你将以1YB的单价收购10个汉堡包，求购时间8小时，确定/取消】
			var str:String = "你将以"+
				HTMLUtil.addColor(this._txtUintPrice.value.toString(),GlobalStyle.colorHuang)+
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtUintPrice.unit)+"的单价收购" +
				HTMLUtil.addColor(this._numStepper.value.toString(),GlobalStyle.colorHuang) + "个"+
				ItemsUtil.getItemName(this._item.itemData) + "，求购时间"+
				HTMLUtil.addColor(this._timeBox.selectedItem.timeType,GlobalStyle.colorHuang) + 
				HTMLUtil.addColor("小时",GlobalStyle.colorHuang);
			
			var todayTipsType:String = "";
			if(this._txtUintPrice.unit == EPrictUnit._EPriceUnitCoin)
			{
				todayTipsType = TodayNoTipsConst.MarketQiugouByCoin;
			}
			else if(this._txtUintPrice.unit == EPrictUnit._EPriceUnitGold)
			{
				todayTipsType = TodayNoTipsConst.MarketQiugouByGold;
			}
			
			var obj:Object = {};
			obj.unit = this._txtUintPrice.unit;
			obj.str = "求购";
			Alert.extendObj = obj;
			TodayNotTipUtil.toDayNotTip(todayTipsType,onSelect,str,null,Alert.OK|Alert.CANCEL,null,null,null,0x4,MktTodayNoTipAlert);
			//Alert.show(str,null,Alert.OK|Alert.CANCEL,null,onBuySelect);
		}
		
		private function onSelect():void
		{
			var obj:Object = {};
			obj.code = this._item.itemData.itemCode;
			obj.amount = this._numStepper.value;
			obj.price = this._txtUintPrice.value;
			obj.unit = this._txtTotalPrice.unit;
			obj.time = this._timeBox.selectedItem.timeType;
			obj.broadcast = this._btnBroadcast.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketQiugou,obj));
		}
	}
}