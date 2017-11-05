package mortal.game.view.market.qiugou
{
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.core.GlobalClass;
	
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
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.MoneyInput;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.alert.MktTodayNoTipAlert;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 求购元宝
	 * @author lizhaoning
	 */
	public class MktQiugouGold extends MktQiugouBase
	{
		private var _txtCount:MoneyInput;
		public function MktQiugouGold()
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
			
			_title.visible = false;
			
			_item.source = GlobalClass.getBitmapData(ImagesConst.YuanbaoBig);
			
			_txtCount = UIFactory.getUICompoment(MoneyInput,115,144,this);
			//	_txtCount.textInput.textField.setTextFormat(_tfBai);
			_txtCount.unit = EPrictUnit._EPriceUnitGold;
			
			_txtUintPrice.unit = EPrictUnit._EPriceUnitCoin;
			_txtTotalPrice.unit = EPrictUnit._EPriceUnitCoin;
			
			_txtCount.configEventListener(Event.CHANGE, onTxtCountChange);
			
			reset(true);
		}
		
		private function onTxtCountChange(e:Event):void
		{
			// TODO Auto Generated method stub
			changeTotolPrice();
		}
		
		override protected function changeTotolPrice():void  //计算总价
		{
			_txtTotalPrice.value = _txtUintPrice.value * _txtCount.value;
			super.changeTotolPrice();
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			if(e.currentTarget == _btnReset)
			{
				reset();
			}
			else if(e.currentTarget == _btnQiugou)
			{
				qiugou();
			}
		}
		
		override protected function reset(clearItem:Boolean=false):void
		{
			// TODO Auto Generated method stub
			super.reset(clearItem);
			
			_txtCount.value = 0;
			changeTotolPrice();
		}
		
		private function qiugou():void
		{
			if( _txtCount.value <=0)
			{
				MsgManager.showRollTipsMsg("请输入正确的数量");
				return;
			}
			if( _txtUintPrice.value <=0)
			{
				MsgManager.showRollTipsMsg("请输入正确的价格");
				return;
			}
			
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
				HTMLUtil.addColor(this._txtCount.value.toString(),GlobalStyle.colorHuang) +
				GameDefConfig.instance.getEPrictNameAddColoer(this._txtCount.unit) + "，求购时间"+
				HTMLUtil.addColor(this._timeBox.selectedItem.timeType,GlobalStyle.colorHuang)+
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
		}
		
		private function onSelect():void
		{
			var obj:Object = {};
			obj.code = EPrictUnit._EPriceUnitGold;
			obj.amount = this._txtCount.value;
			obj.price = this._txtUintPrice.value;
			obj.unit = this._txtTotalPrice.unit;
			obj.time = this._timeBox.selectedItem.timeType;
			obj.broadcast = this._btnBroadcast.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketQiugou,obj));
		}
	}
}