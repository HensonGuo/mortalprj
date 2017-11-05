package mortal.game.view.common.display
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.view.common.UIFactory;
	
	public class TextBox extends GSprite
	{
		//显示对象
		public var _text:GTextFiled;
		
		private var _bg:ScaleBitmap;
		
		//数据
		private var _label:String;
		
		private var _htmlText:String;
		
		private var _bgWidth:Number = 23;
		
		private var _bgHeight:Number = 117;
		
		private var _textFieldWidth:Number = 100;
		
		private var _textFieldHeight:Number;
		
		public function TextBox()
		{
			super();
		}
		
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.bg(0,0,_bgWidth,_bgHeight,this,"DisabledBg");
//			_bg = ResouceConst.getScaleBitmap("DisabledBg");
			_bg.width = _bgWidth;
			_bg.height = _bgHeight;
			
			_text = UIFactory.gTextField("",0,0,_textFieldWidth,_textFieldHeight,this,null,true);
			
			if(_label)
			{
				_text.text = _label;
			}
			if(_htmlText)
			{
				_text.htmlText = _htmlText;
			}
			if(_textFieldWidth)
			{
				_text.width = _textFieldWidth;
			}
			if(_bgWidth)
			{
				_bg.width = _bgWidth;
				_text.width = _bgWidth;
			}
			if(_bgHeight)
			{
				_bg.height = _bgHeight;
				_text.height = _bgHeight;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_bg.dispose();
			_text.dispose();
			
			_bg = null;
			_text = null;
			
			super.disposeImpl(isReuse);
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			_label = "";
			_htmlText = "";
			_bgWidth = 0;
			_bgHeight = 0;
			_textFieldWidth = 100;
			_textFieldHeight = 20;
			super.dispose(isReuse);
		}
		
		public function get textField():TextField
		{
			return _text;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			_text.text = value;
		}
		public function get label():String
		{
			return _label;
		}
		
		public function set htmlText(value:String):void
		{
			_htmlText = value;
			_text.htmlText = value;
		}
		public function get htmlText():String
		{
			return _htmlText;
		}
		
		public function set textFieldWidth(value:Number):void
		{
			_textFieldWidth = value;
			_text.width = value;
		}
		
		public function set textFieldHeight(value:Number):void
		{
			_textFieldHeight = value;
			_text.height = value;
		}
		
		public function set bgWidth(value:Number):void
		{
			_bgWidth = value;
			_bg.width = value;
			_text.width = value;
		}
		
		public function get bgWidth():Number
		{
			return _bg.width;
		}
		
		public function set bgHeight(value:Number):void
		{
			_bgHeight = value;
			_bg.height = value;
			_text.height = value;
		}
		
		public function get bgHeight():Number
		{
			return _bg.height;
			
		}
		
		public function set defaultTextFormat( $value:TextFormat ):void
		{
			_text.defaultTextFormat = $value;
		}
		
		public function setbgStlye(url:String,formate:GTextFormat):void
		{
			_bg.dispose(true);
			_bg = UIFactory.bg(0,0,_bgWidth,_bgHeight,this,url);
			setChildIndex(_bg,0);
			
			_text.defaultTextFormat = formate;
			_text.setTextFormat(formate);
		}
		
		
	}
}