
package mortal.component.window
{
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.ResManager;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.interfaces.ILayer;
 	
	[Event(name="close",type="mortal.component.window.WindowEvent")]
	public class BaseWindow extends Window
	{		
		protected var _winTitleName:String;
		
		protected var _titleIconName:String;
		
		protected var _titleBmp:Bitmap;
		
		protected var _title:DisplayObject;
		
		protected var _windowBg:ScaleBitmap;
		
		protected var _windowBgName:String;
		
		protected var _windowCenter:ScaleBitmap;
		
		protected var _windowCenter2:ScaleBitmap;
		
		protected var _windowLine:ScaleBitmap;
		
		//padding
		protected var paddingBottom:int=11;
		protected var paddingLeft:int=9;
		protected var paddingRight:int=7;
		//边缘模糊
		protected var blurTop:int = 2;
		protected var blurBottom:int = 2;
		protected var blurLeft:int = 2;
		protected var blurRight:int = 4;
		
		public function BaseWindow($layer:ILayer = null)
		{
			super($layer);
		}
		
		override protected function configParams():void
		{
			_contentX = blurLeft;
			_contentY = blurTop;
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width + blurLeft + blurRight,height + blurTop + blurBottom);
		}
		
		override protected function updateSize():void
		{
			super.updateSize();
			
			if( _windowBg )
			{
				_windowBg.setSize(this.width,this.height);
				_windowBg.x = 0;
				_windowBg.y = 0;
			}
			updateWindowCenterSize();			
		}
		
		protected function updateWindowCenterSize(  ):void
		{
			if( _windowCenter )
			{
				var w:Number = this.width - paddingLeft - paddingRight - blurLeft - blurRight;
				var h:Number = this.height - _titleHeight - paddingBottom - blurTop - blurBottom;
				_windowCenter.setSize(w,h);
				_windowCenter.x = paddingLeft + blurLeft;
				_windowCenter.y = _titleHeight + blurTop;
			}	
			
			if (_windowCenter2)
			{
				_windowCenter2.x = _windowCenter.x + 5;
				_windowCenter2.y = _windowCenter.y + 5;
				_windowCenter2.width = _windowCenter.width - 10;
				_windowCenter2.height = _windowCenter.height - 10;
			}
			
			if(_windowLine)
			{
				var k:Number = this.width - paddingLeft - paddingRight - blurLeft - blurRight;
				_windowLine.setSize(k,7);
				_windowLine.x = paddingLeft + blurLeft;
				_windowLine.y = _titleHeight + blurTop - 7;
			}
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			setWindowBgName();
			_windowBg = UIFactory.bg(0,0,-1,-1,null,_windowBgName);
			addChildAt( _windowBg,0 );
			addWindowLine();
			setWindowCenter();
			if( _windowCenter )
			{
				addChildAt(_windowCenter,1);
			}
		}
		
		protected function setWindowBgName():void
		{
			_windowBgName = ImagesConst.WindowBg;
		}
		
		private var _titleLabel:TextField;
		
		private function resetTitle():void
		{
			if(_titleLabel)
			{
				_titleLabel.setTextFormat(GlobalStyle.windowTitle);
				_titleLabel.autoSize = TextFieldAutoSize.CENTER;
				_titleLabel.htmlText = _titleLabel.htmlText;
			}
		}
		
		public function get title():*
		{
			return _title;
		}
		
		protected var _titleChange:Boolean = false;
		public function set title(value:*):void
		{
			if(_title && _title.parent)
			{
				_title.parent.removeChild( _title );
				_title = null;
			}
			if(value is DisplayObject)
			{
				_winTitleName = DisplayObject(value).name;
				_title = value;
				
				_titleSprite.addChild( _title );
			}
			else if(value is String)
			{
				_winTitleName = value;
				_titleLabel = new TextField();
				_titleLabel.mouseEnabled = false;
				_titleLabel.embedFonts = true;
				_titleLabel.defaultTextFormat = GlobalStyle.windowTitle;
				_titleLabel.selectable = false;
				_titleLabel.filters = [FilterConst.titleFilter,FilterConst.titleShadowFilter];
				_titleLabel.autoSize = TextFieldAutoSize.LEFT;
				_titleLabel.htmlText = value;
				_title = _titleLabel;
				_titleSprite.addChild( _titleLabel );
				
				ResManager.instance.registerTitle(resetTitle);
			}
			
			_titleChange = true; 
			updateDisplayList();
		}
		
		/**
		 * 获取窗口标题名字 
		 * @return 
		 * 
		 */		
		public function get winTitleName():String
		{
			return _winTitleName;
		}
		
		public function set titleIcon(value:String):void
		{
			_titleIconName = value;
			if(!_titleBmp)
			{
				_titleBmp = UIFactory.bitmap();
			}
			_titleSprite.addChild( _titleBmp );
			LoaderHelp.addResCallBack(ResFileConst.windowIcon,titleIconHander);
		}
		
		protected function titleIconHander():void
		{
			_titleBmp.bitmapData = GlobalClass.getBitmapData(_titleIconName);
			_titleChange = true;
			updateDisplayList();
		}
		
		protected function setWindowCenter():void
		{
			_windowCenter = ResourceConst.getScaleBitmap("WindowCenterA");
		}
		
		protected function addWindowCenter2():void
		{
			_windowCenter2 = UIFactory.bg();
			this.addChild(_windowCenter2);
		}
		
		protected function addWindowLine():void
		{
			_windowLine = UIFactory.bg(0,0,-1,-1,this,ImagesConst.WindowBgLine);
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			if(_titleChange)
			{
				_titleChange = false;
				var titleX:Number = 68;
				if(_titleBmp && _titleBmp.bitmapData)
				{
					_titleBmp.x = 17;
					_titleBmp.y = 35 - _titleBmp.height;
					titleX = _titleBmp.width + 17 + 5;
				}
				if( _title )
				{
					_title.y = 5;
					_title.x = titleX;
				}
			}
		}
		
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			paddingBottom = 11;
			paddingLeft = 9;
			paddingRight = 7;
			//边缘模糊
			blurTop = 2;
			blurBottom = 2;
			blurLeft = 2;
			blurRight = 4;
			
			if(_windowBg)
			{
				_windowBg.dispose(isReuse);
			}
			if(_windowCenter)
			{
				_windowCenter.dispose(isReuse);
			}
			if(_windowCenter2)
			{
				_windowCenter2.dispose(isReuse);
			}
			if(_windowLine)
			{
				_windowLine.dispose(isReuse);
			}
			super.disposeImpl(isReuse);
		}
		
		/**
		 * 实现 IView 接口 
		 * 
		 */
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose();
			
			_windowBg = null;
			_windowCenter = null;
			_windowLine = null;
			
			_title = null;
		}
	}
}