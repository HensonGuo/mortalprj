package mortal.game.view.common.item
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class MoneyItem extends GSprite
	{
		public function MoneyItem()
		{
			super();
		}
		
		protected var _tfNum:GTextFiled;
		protected var _bmpType:Bitmap;
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var textFormat:TextFormat = new GTextFormat(FontUtil.defaultName,12,0xF1FFB1);
			textFormat.align = TextFormatAlign.RIGHT;
			_tfNum = UIFactory.textField("100",-80,0,80,22,this,textFormat);
			_bmpType = UIFactory.bitmap(ImagesConst.Jinbi,0,6,this);
			updateMoneyBmpPos();
		}
		
		/**
		 * 设置货币单位 
		 * @param type
		 * 
		 */		
		private var _unit:int;
		public function set unit(type:int):void
		{
			_unit = type;
			_bmpType.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getEPrictUnitImg(type));
			updateMoneyBmpPos();
		}
		public function get unit():int
		{
			return _unit;
		}
		
		/**
		 * 设置货币数量 
		 * 
		 */		
		private var _value:int;
		public function set value(value:int):void
		{
			_value = value;
			_tfNum.htmlText = value.toString();
		}
		public function get value():int
		{
			return _value;
		}
		
		/**
		 * 更新数据和类型 
		 * @param num
		 * @param type
		 * 
		 */
		public function update(num:int,type:int):void
		{
			_tfNum.text = num.toString();
			_bmpType.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getEPrictUnitImg(type));
			updateMoneyBmpPos();
		}
		
		public function updateMoneyBmpPos():void
		{
			var head:TextField = _tfNum;
			
			_bmpType.x = head.x + head.width + 3;
			_bmpType.y = head.y + (head.height-_bmpType.height)/2;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_tfNum.dispose(isReuse);
			UIFactory.disposeBitmap(_bmpType,isReuse);
			
			_tfNum = null;
			_bmpType = null;
			super.disposeImpl(isReuse);
		}
		
		public function get bmpType():Bitmap
		{
			return _bmpType;
		}
		
		public function get tfNum():GTextFiled
		{
			return _tfNum;
		}

	}
}