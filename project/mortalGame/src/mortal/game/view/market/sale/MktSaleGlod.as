package mortal.game.view.market.sale
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.controls.GSprite;
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
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.MoneyInput;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.alert.MktTodayNoTipAlert;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 市场寄售元宝
	 * @author lizhaoning
	 */
	public class MktSaleGlod extends MktSaleBase
	{
		protected var _txtCount:MoneyInput;
		
		public function MktSaleGlod()
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
			
			_title.visible = false;
			_txtCount.minValue = 1;
			_txtCount.value = _txtCount.minValue;
			_txtCount.unit = EPrictUnit._EPriceUnitGold;
			_txtPrice.unit = EPrictUnit._EPriceUnitCoin;
			
			_item.source = GlobalClass.getBitmapData(ImagesConst.YuanbaoBig);
			
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
			if(this._txtPrice.value <=0)
			{
				MsgManager.showRollTipsMsg("请输入正确的价格");
				return;
			}
			if(!Cache.instance.role.enoughMoney(EPrictUnit._EPriceUnitGold,this._txtCount.value))
			{
				MsgManager.showRollTipsMsg("元宝不足");
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
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtPrice.unit,GlobalStyle.colorHuang)+"的价格寄售" +
				HTMLUtil.addColor(this._txtCount.value.toString(),GlobalStyle.colorHuang) +
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtCount.unit,GlobalStyle.colorHuang) + "，寄售时间"+
				HTMLUtil.addColor(this._timeBox.selectedItem.timeType,GlobalStyle.colorHuang)+
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
			var obj:Object = {};
			obj.code = EPrictUnit._EPriceUnitGold;
			obj.itemUid = "";
			obj.amount = this._txtCount.value;
			obj.price = this._txtPrice.value;
			obj.unit = this._txtPrice.unit;
			obj.time = this._timeBox.selectedItem.timeType;
			obj.broadcast = this._btnBroadcast.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketSale,obj));
		}
	}
}