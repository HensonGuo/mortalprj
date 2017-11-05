package mortal.game.view.common
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.GTextFormat;
	import mortal.component.gconst.ResourceConst;
	
	//进度条
	public class BaseProgressBar extends GSprite
	{
		public static var ProgressBarTextNone:int = 0;
		public static var ProgressBarTextNumber:int = 1;
		public static var ProgressBarTextPercent:int = 2;
		
		//背景bitmap类名
		protected var _bgClass:String;
		protected var _progressBarBg:Bitmap;
		
		// 进度bitmap类名
		protected var _progressBarClass:String;
		protected var _progcessScaleBmp:ScaleBitmap;
		public var _progressBar:Bitmap;
		
		protected var _label:GTextFiled;
		
		protected var _value:Number = 0;
		protected var _totalValue:Number = 0;
		protected var _lastWidth:int = 0;//血管长度
		
		protected var _progressWidth:Number;
		protected var _progressHeight:Number;
		protected var _labelType:int;
		protected var _replaceTxt:String;
		
		public function BaseProgressBar()
		{
			super();
			mouseEnabled = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			//进度条主体
			_progressBar = UIFactory.bitmap("");
			this.addChild(_progressBar);
			//文本
			_label = UIFactory.textField("", 0, 0, 200, 20, this);
			_label.autoSize = TextFieldAutoSize.CENTER;
		}
		
		override protected function disposeImpl(isReuse:Boolean = true):void
		{
			UIFactory.disposeBitmap(_progressBarBg);
			_label.dispose(isReuse);
			UIFactory.disposeBitmap(_progressBar,isReuse);
			_value = 0;
			_totalValue = 0;
			_progressWidth = 0;
			_progressHeight = 0;
			_lastWidth = 0;
			_labelType = 1;
			_replaceTxt = "";
			_bgClass = null;
			_progressBarBg = null;
			_progcessScaleBmp = null;
			_progressBarClass = null;
			_progressBar = null;
			_label = null;
			super.disposeImpl(isReuse);
		}
		
		/**
		 * 设置进度条背景 
		 * @param bgName 	图片名字
		 * @param isScale 	是否是拉伸图
		 * @param width		如果是拉伸图需要设置长度和宽度
		 * @param height
		 * 
		 */
		public function setBg(bgName:String,isScale:Boolean,width:int = 0,height:int = 0,isAtBgPosition:Boolean = true):void
		{
			if(_progressBarBg)
			{
				UIFactory.disposeBitmap(_progressBarBg);
				_progressBarBg = null;
			}
			if(isScale)
			{
				_progressBarBg = ResourceConst.getScaleBitmap(bgName);
				_progressBarBg.width = width;
				_progressBarBg.height = height;
			}
			else
			{
				_progressBarBg = UIFactory.bitmap(bgName);
			}
			if(isAtBgPosition)
			{
				this.addChildAt(_progressBarBg,0);
			}
		}
		
		/**
		 * 设置进度条 
		 * @param barName
		 * @param isScale
		 * @param width
		 * @param height
		 * 
		 */
		public function setProgress(barName:String,isScale:Boolean = true,x:Number = 0,y:Number = 0,width:int = 0,height:int = 0):void
		{
			_progressBarClass = barName;
			if(_progcessScaleBmp)
			{
				_progcessScaleBmp.dispose();
				_progcessScaleBmp = null;
			}
			if(isScale)
			{
				_progcessScaleBmp = ResourceConst.getScaleBitmap(barName);
			}
			_progressBar.x = x;
			_progressBar.y = y;
			_progressWidth = width;
			_progressHeight = height;
		}
		
		/**
		 * 设置文本显示格式  
		 * @param type 文本显示格式（下划线格式、百分比格式、无文本格式）BaseProgressBar.ProgressBarTextNone为不显示文本
		 * @param replaceTxt 文本替换，如果设置为空则显示固定格式，如果需要替换比如"血量：{0}"如果type是1  则显示：血量：10/100
		 * 
		 */
		public function setLabel(type:int = 1,x:Number = 0,y:Number = 0,width:Number = 200,height:Number = 20,textFormat:GTextFormat = null,replaceTxt:String = ""):void
		{
			_labelType = type;
			_replaceTxt = replaceTxt;
			_label.x = x;
			_label.y = y;
			_label.width = width;
			_label.height = height;
			if(textFormat)
			{
				_label.defaultTextFormat = textFormat;
			}
		}
		
		/**
		 * 设置进度
		 * @param value
		 * @param totalValue
		 *
		 */
		public function setValue(value:Number, totalValue:Number):void
		{
			//return;
			if(value == _value && _totalValue == totalValue)
			{
				return;
			}
			
			_value = value;
			_totalValue = totalValue;
			
			drawBar();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function drawBar():void
		{
			var text:String = "";
			
			if(value > totalValue)   //如果当前值大于最大值,则当前值等于最大值(addByTangkaixin)
			{
				_value = totalValue;
			}
			
			switch(_labelType)
			{
				case BaseProgressBar.ProgressBarTextNone:
					text = "";
					_label.visible = false;
					break;
				case BaseProgressBar.ProgressBarTextNumber:
					text = _value + "/" + _totalValue;
					_label.visible = true;
					break;
				case BaseProgressBar.ProgressBarTextPercent:
					text = int(_value * 100/_totalValue) + "%";
					_label.visible = true;
					break;
			}
			if(_replaceTxt)
			{
				text = _replaceTxt.replace("{0}",text);
			}
			_label.text = text;
			
			var per:Number = _value/_totalValue;
			var width:int = per * _progressWidth;
			if(_lastWidth == width)
			{
				return;	
			}
			_lastWidth = width;
			
			if(_progressBar && _progressBar.bitmapData)
			{
				_progressBar.bitmapData.dispose();
				_progressBar.bitmapData = null;
			}
			
			//绘制图片
			if(width > 0 && _progressBarClass)
			{
				var bitmap:BitmapData = GlobalClass.getBitmapData(_progressBarClass);
				if(_progcessScaleBmp && bitmap.width - _progcessScaleBmp.scale9Grid.width < width)
				{
					_progcessScaleBmp.setSize(width,bitmap.height);
					_progressBar.bitmapData = _progcessScaleBmp.bitmapData;
				}
				else
				{
					var perBitmapData:BitmapData = new BitmapData(width,_progressHeight,true,0x00FFFFFF);
					perBitmapData.draw(bitmap,new Matrix(),null,null,new Rectangle(0,0,width,_progressHeight));
					_progressBar.bitmapData = perBitmapData;
				}
			}
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(num:Number):void
		{
			_value = num;
			drawBar();
		}
		
		public function set totalValue(num:Number):void
		{
			_totalValue = num;
			drawBar();
		}
		
		public function get totalValue():Number
		{
			return _totalValue;
		}
		
		public function get lastWidth():int
		{
			return _lastWidth;
		}
	}
}
