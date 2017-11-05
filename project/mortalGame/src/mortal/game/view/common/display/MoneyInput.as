package mortal.game.view.common.display
{
	import Message.Game.SMoney;
	import Message.Public.EPrictUnit;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;

	/**
	 * 金钱输入框
	 * @author lizhaoning
	 */
	public class MoneyInput extends GSprite
	{
		/** 输入文本 */
		private var _textInput:GTextInput;
		/** 货币图标 */
		private var _bmp:GBitmap;
		/** 背景 */
		private var _bg:ScaleBitmap;
		
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _unit:int;//货币单位 
		private var _textInputWidth:int;
		
		private var _defultText:String;
		
		/** 输入的时候是否检查自己的金钱足够 */
		public var checkSelfMoeny:Boolean;
		public function MoneyInput()
		{
			super();
		}

		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_minValue = 0;
			_maxValue = Number.MAX_VALUE;
			_defultText = "";
			checkSelfMoeny = false;
			
			var _tfBai:GTextFormat = GlobalStyle.textFormatBai;
			_tfBai.align = TextFormatAlign.RIGHT;
			
			_bg = UIFactory.bg(0,0,105,22,this,ImagesConst.InputBg);
			
			_textInput = UIFactory.gTextInput(0,0,85,22,this,"NoSkinInput");
			_textInput.setStyle("textFormat" , _tfBai );
			_textInput.restrict  = "0-9";
			_textInput.text = _minValue.toString();
			//_textInput.drawNow();
			_bmp = UIFactory.bitmap("",0,0,this);
			updateMoneyBmpPos();
			
			_textInput.configEventListener(Event.CHANGE, onTextInputChangeHandler);
			_textInput.configEventListener(FocusEvent.FOCUS_IN,onTextInputFocusInHandler);
			_textInput.configEventListener(FocusEvent.FOCUS_OUT,onTextInputFocusOutHandler);
			
			onTextInputFocusOutHandler(null);
		}
		
		/**
		 * 设置货币单位 
		 * @param type
		 * 
		 */		
		public function set unit(type:int):void
		{
			_unit = type;
			_bmp.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getEPrictUnitImg(type));
			updateMoneyBmpPos();
		}
		public function get unit():int
		{
			return _unit;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			checkSelfMoeny = false;
			_minValue = 0;
			_maxValue = Number.MAX_VALUE;
			
			_textInput.removeEventListener(Event.CHANGE, onTextInputChangeHandler);
			_textInput.removeEventListener(FocusEvent.FOCUS_IN,onTextInputFocusInHandler);
			_textInput.removeEventListener(FocusEvent.FOCUS_OUT,onTextInputFocusOutHandler);
			
			_defultText = "";
			_textInput.text = "";
			_textInput.restrict  = null;
			_textInput.width = 85;
			_textInput.dispose(isReuse);
			_bg.dispose(isReuse);
			_bmp.dispose(isReuse);
			
			_textInput = null;
			_bg = null;
			_bmp = null;
		}
		
		/**
		 * 刷新货币图标位置 
		 * 如果重设了文本框大小宽高可以调用此方法
		 */
		public function updateMoneyBmpPos():void
		{
			_bmp.x = _bg.x  + _bg.width - _bmp.width - 3;
			_bmp.y = _bg.y + (_bg.height-_bmp.height)/2;
		}
		
		protected function onTextInputChangeHandler(e:Event):void
		{
			checkValue();
			trace(this.name)
		}
		
		protected function onTextInputFocusInHandler(e:FocusEvent):void
		{
			// TODO Auto Generated method stub
			if(_defultText != "" && _textInput.text == _defultText)
			{
				_textInput.text = "";
			}
		}
		
		protected function onTextInputFocusOutHandler(e:FocusEvent):void
		{
			checkValue();
			
			if(_textInput && int(_textInput.text) <= 0)
			{
				_textInput.text = defultText;
			}
		}
		
		
		
		private function checkValue():void
		{
			if(_textInput == null)
			{
				return;
			}
			
			if(int(_textInput.text) > _maxValue)
			{
				_textInput.text = _maxValue.toString();
			}
			else if(int(_textInput.text) < _minValue)
			{
				_textInput.text = _minValue.toString();
			}
			
			if(checkSelfMoeny)
			{
				var moneys:SMoney = Cache.instance.role.money;
				if(this.unit == EPrictUnit._EPriceUnitCoin && this.value > moneys.coin)
				{
					_textInput.text = moneys.coin.toString();
				}
				else if(this.unit == EPrictUnit._EPriceUnitGold && this.value > moneys.gold)
				{
					_textInput.text = moneys.gold.toString();
				}
				else if(this.unit == EPrictUnit._EPriceUnitCoinBind && this.value > moneys.coinBind)
				{
					_textInput.text = moneys.coinBind.toString();
				}
				else if(this.unit == EPrictUnit._EPriceUnitGoldBind && this.value > moneys.goldBind)
				{
					_textInput.text = moneys.goldBind.toString();
				}
			}
			
			_textInput.text = (int(_textInput.text)).toString();
		}
		
		/** 货币图标 */
		public function get bmp():GBitmap
		{
			return _bmp;
		}
		
		
		/** 输入文本 */
		public function get textInput():GTextInput
		{
			return _textInput;
		}
		public function set textInput(value:GTextInput):void
		{
			_textInput = value;
		}
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		/** 最大值  */
		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			checkValue();
		}
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		/** 最小值  */
		public function set minValue(value:Number):void
		{
			_minValue = value;
			checkValue();
		}
		
		
		
		public function get value():Number
		{
			return Number(_textInput.text);
		}
		
		public function set value(i:Number):void
		{
			_textInput.text = i.toString();
			checkValue();
		}
		
		public function get textInputWidth():int
		{
			return _textInputWidth;
		}
		
		public function set textInputWidth(value:int):void
		{
			_textInputWidth = value;
			_textInput.width = _textInputWidth;
		}
		
		/** 默认显示 */
		public function get defultText():String
		{
			return _defultText;
		}
		
		/**
		 * @private
		 */
		public function set defultText(value:String):void
		{
			_defultText = value;
			onTextInputFocusOutHandler(null);
		}
	}
}