package mortal.game.view.msgbroad
{
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	
	import mortal.component.BitmapLabel;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.model.RollRadioInfo;
	import mortal.game.resource.ImagesConst;
	
	public class RollRadioItem extends Sprite
	{
		private var _textField:TextField;
		private var _info:RollRadioInfo;
		private var _skin:Bitmap;
		
		private var _width:int;
		private var _height:int = 30;
		
		private var _bmpLabel:BitmapLabel;
		
		public function RollRadioItem(width:int = 750)
		{
			super();
			_width = width;
			initUI();
		}
		
		/**
		 * 初始化UI 
		 * 
		 */
		private function initUI():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			
			this.scrollRect = new Rectangle(0,0,_width,_height);
			
			_skin = GlobalClass.getScaleBitmap(ImagesConst.rollmsgbg,new Rectangle(130,10,5,5));
			_skin.width = _width;
			_skin.height = _height;
			addChild(_skin);
			
			_textField = new TextField();
			_textField.selectable = false;
			_textField.height = 24;
			_textField.filters = [FilterConst.nameGlowFilter];
			var tf:TextFormat = new GTextFormat(FontUtil.songtiName,14,0xffff00,false,null,null,null,null,TextFormatAlign.LEFT);
			tf.letterSpacing = 2;
			_textField.defaultTextFormat = tf;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			
			_bmpLabel = new BitmapLabel();
			_bmpLabel.textField = _textField;
			_bmpLabel.x = 0;
			_bmpLabel.y = 7;
			addChild(_bmpLabel);
			
			this.cacheAsBitmap = true;
		}
		
		/**
		 * 更新 
		 * @param info
		 * 
		 */
		public function updateData(info:RollRadioInfo):void
		{
			_info = info;
			_bmpLabel.htmlText = HTMLUtil.addColor(info.str,"#ffffff");
			_bmpLabel.x = _width;
			_info.count++;
		}
		
		/**
		 * 帧频 
		 * 
		 */
		public function frameScript():void
		{
			_bmpLabel.x -= _info.speed;
		}
		
		/**
		 * 销毁 
		 * 
		 */
		public function dispose():void
		{
			if(_info)
			{
				ObjectPool.disposeObject(_info);
			}
			_info = null;
			_bmpLabel.x = _width;
		}
		
		
		/**
		 * 是否正在运行 
		 * @return 
		 * 
		 */
		public function get running():Boolean
		{
			return _info && _bmpLabel.x >= -_bmpLabel.textWidth;
		}
		
		/**
		 * 次数是否飘完 
		 * @return 
		 * 
		 */
		public function get hasEnd():Boolean
		{
			return _info && _info.count >= _info.totalCount;
		}
		
		public function get info():RollRadioInfo
		{
			return _info;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function get width():Number
		{
			return _width;
		}
	}
}