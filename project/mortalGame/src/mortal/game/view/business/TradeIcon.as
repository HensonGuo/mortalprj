package mortal.game.view.business
{
	import Message.Public.SBusiness;
	import Message.Public.SBusinessInfo;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.skin.Label.GLabelStyle;
	import mortal.game.cache.Cache;
	import mortal.game.cache.TradeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	/**
	 * 交易小图标
	 * @author lizhaoning
	 */
	public class TradeIcon extends View
	{
		private static var _instance:TradeIcon;
		
		/** 显示图标 */
		private var _icon:GBitmap;
		/** 申请人数文本 */
		private var _numLabel:GTextFiled;
		
		private var _tradeCache:TradeCache;
		public function TradeIcon()
		{
			super();
			
			if(_instance)
			{
				throw new Error("TradeIcon单例");
			}
			
			_tradeCache = Cache.instance.trade;
			
			this.layer = LayerManager.smallIconLayer;
			this.mouseChildren = false;
			this.buttonMode = true;
			this.mouseEnabled = true;
		}
		public static function get instance():TradeIcon
		{
			if(!_instance)
			{
				_instance = new TradeIcon();
			}
			return _instance;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_icon = UIFactory.gBitmap(ImagesConst.trade_hintIcon,0,0,this);
			
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			_numLabel = UIFactory.gTextField("",14,11,20,20,this,textFormat);
			
			this.configEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_icon.dispose(isReuse);
			_numLabel.dispose(isReuse);
			
			_icon = null;
			_numLabel = null;
		}
		
		
		private function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(Cache.instance.trade.isTrading)
			{
				MsgManager.showRollTipsMsg("已经在交易中");
			}
			else
			{
				_tradeCache.currentSbusiness = _tradeCache.requestList.shift() as SBusiness;
				showLabel();
				if(_tradeCache.requestList.length == 0)
				{
					this.hide();
				}
				var tradeInfo:SBusinessInfo = _tradeCache.getTargetSBusinessInfo();
				Alert.show(tradeInfo.name+"向你发出交易申请",null,Alert.YES|Alert.NO,null,onAcceptTradeRequest);
			}
		}
		
		/**
		 * 是否接受交易申请 
		 * @param buttonType
		 * 
		 */		
		private function onAcceptTradeRequest(buttonType:int):void
		{
			if(buttonType == Alert.YES)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.TradeAcceptTrade,_tradeCache.currentBusinessId));
			}
			else
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.TradeRejectTrade,_tradeCache.currentBusinessId));
			}
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			// TODO Auto Generated method stub
			super.show(x, y);
			showLabel();
		}
		
		private function showLabel():void
		{
			this._numLabel.text = String(_tradeCache.requestList.length);
		}
		
		
	}
}