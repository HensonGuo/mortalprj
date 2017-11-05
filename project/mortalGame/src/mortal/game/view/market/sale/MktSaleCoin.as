package mortal.game.view.market.sale
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
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
	import mortal.game.view.common.display.MoneyInput;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.alert.MktTodayNoTipAlert;
	import mortal.mvc.core.Dispatcher;
	
	
	/**
	 * 市场寄售铜钱
	 * @author lizhaoning
	 */
	public class MktSaleCoin extends MktSaleBase
	{
		protected var _txtCount:MoneyInput;
		private var _txt:GTextFiled;
		public function MktSaleCoin()
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
			
			_txtCount.dispose(isReuse);
			
			_txtCount = null;
		}
		
		override protected function resetUI():void
		{
			// TODO Auto Generated method stub
			super.resetUI();
			
			_txtCount = UIFactory.getUICompoment(MoneyInput,115,144,this);
			_txtCount.unit = EPrictUnit._EPriceUnitGold;
			_txtCount.textInputWidth = 67;
			
			_txt = UIFactory.textField("万",183,144,20,20,this);
			
			_title.visible = false;
			_txtCount.minValue = 1;
			_item.source = GlobalClass.getBitmapData(ImagesConst.JinbiBig);
			
			_txtCount.unit = EPrictUnit._EPriceUnitCoin;
			_txtPrice.unit = EPrictUnit._EPriceUnitGold;
			
			reset(true);
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			if(e.currentTarget == _btnReset)
			{
				reset();
			}
			else if(e.currentTarget == _btnSale)
			{
				sale();
			}
		}
		
		override protected function reset(clearItem:Boolean = false):void
		{
			super.reset(clearItem);
			
			this._txtCount.value = _txtCount.minValue;
			this._txtPrice.textInput.text = "";
		}
		
		private function sale():void
		{
			var count:int = this._txtCount.value * 10000;
			if(count <=0)
			{
				MsgManager.showRollTipsMsg("请输入正确的价格");
				return;
			}
			if(!Cache.instance.role.enoughMoney(EPrictUnit._EPriceUnitCoin,count))
			{
				MsgManager.showRollTipsMsg("铜钱不足");
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
			
			//你将以5元宝的价格寄售2个汉堡包
			var str:String = "你将以"+
				HTMLUtil.addColor(this._txtPrice.value.toString(),GlobalStyle.colorHuang)+
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtPrice.unit)+"的价格寄售" +
				HTMLUtil.addColor(this._txtCount.value.toString()+ "万",GlobalStyle.colorHuang)  +
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtCount.unit) + "，寄售时间"+
				HTMLUtil.addColor(this._timeBox.selectedItem.timeType,GlobalStyle.colorHuang) +
				HTMLUtil.addColor("小时",GlobalStyle.colorHuang);
			
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
			var count:int = this._txtCount.value * 10000;
			
			var obj:Object = {};
			obj.code = EPrictUnit._EPriceUnitCoin;
			obj.itemUid = "";
			obj.amount = count;
			obj.price = _txtPrice.value;
			obj.unit = this._txtPrice.unit;
			obj.time = this._timeBox.selectedItem.timeType;
			obj.broadcast = this._btnBroadcast.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketSale,obj));
		}
	}
}