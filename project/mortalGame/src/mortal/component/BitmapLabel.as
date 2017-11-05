/**
 * @date	2012-5-28 下午03:38:26
 *  @author  wyang
 * 用位图显示的label
 */
package mortal.component
{
	import com.mui.manager.ToolTipsManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	import mortal.common.net.CallLater;
	
	public class BitmapLabel extends Bitmap
	{
		private var _textField:TextField;
		private var _toolTipData:*;
		private var _htmlText:String;
		private var _bitmapData:BitmapData;

		public function BitmapLabel(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			createChildren();
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function set textField(value:TextField):void
		{
			_textField = value;
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set text(str:String):void
		{
			if(_textField.text != str)
			{
				_textField.text = str;
				_htmlText = str;
				CallLater.addCallBack(updateDisplay);
			}
			
		}
		
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		public function set htmlText(str:String):void
		{
			_htmlText = str;
			_textField.htmlText = _htmlText;
			CallLater.addCallBack(updateDisplay);
		}
		
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
		}
		
		public function get enabled():Boolean
		{
			return _textField.mouseEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_textField.mouseEnabled = value;
		}
		
		public function get autoSize():String
		{
			return _textField.autoSize;
		}
		
		public function set autoSize(value:String):void
		{
			_textField.autoSize = value;
		}
		
		public function get selectable():Boolean
		{
			return _textField.selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_textField.selectable = value;
		}
		
		public function get toolTipData():*
		{
			return _toolTipData;
		}
		
		public function set toolTipData( value:* ):void
		{
			if(value == null || value==""){
				ToolTipsManager.unregister(this);
			}else{
				ToolTipsManager.register(this);
			}
			_toolTipData = value;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * 创建组件的子对象 
		 * 
		 */
		protected function createChildren():void
		{
			_textField = new TextField();
			_textField.selectable = false;
		}
		
		
		private var _styleName:String;
		
		public function get styleName():String
		{
			return _styleName;
		}
		
		private var _isStyleChange:Boolean = false;
		public function set styleName( value:String ):void
		{
			if( _styleName != value )
			{
				_styleName = value;
				_isStyleChange = true;
			}
		}
		override public function set filters(value:Array):void
		{
			_textField.filters = value;
			CallLater.addCallBack(updateDisplay);
		}
		public function get defaultTextFormat():TextFormat
		{
			return _textField.defaultTextFormat;
		}
		
		public function set defaultTextFormat(value:TextFormat):void
		{
			_textField.defaultTextFormat = value;
		}
		
		public function get textWidth():int
		{
			return _textField.textWidth;
		}
		
		public function get textHeight():int
		{
			return _textField.textHeight;
		}
		
		public function setStyle(styleName:String,style:*):void
		{
			if(styleName == "textFormat")
			{
				_textField.defaultTextFormat = style as TextFormat;
			}
		}
		
		public function getStyle(styleName:String):*
		{
			if(styleName == "textFormat")
			{
				return _textField.defaultTextFormat;
			}
			return null;
		}
		
		public function setSize(arg0:Number, arg1:Number):void
		{
			width = arg0;
			height = arg1;
		}
		
		override public function get width():Number
		{
			return _textField.width;
		}
		
		override public function set width(arg0:Number):void
		{
			if(textField){
				textField.width = arg0;
				CallLater.addCallBack(updateDisplay);
			}
		}
		
		override public function  get height():Number
		{
			return _textField.height;
		}
		
		override public function set height(arg0:Number):void
		{
			if(textField){
				textField.height = arg0;
				CallLater.addCallBack(updateDisplay);
			}
		}
		
		private function updateDisplay():void
		{
			if(_bitmapData)
			{
				_bitmapData.dispose();
			}
			_bitmapData = new BitmapData(_textField.width,_textField.height,true,0x00000000);
			_bitmapData.draw(_textField);
			this.bitmapData = _bitmapData;
		}
		
		
	}
}