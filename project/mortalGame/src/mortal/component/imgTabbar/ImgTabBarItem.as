/**
 * @date 2011-6-7 下午04:32:11
 * @author  宋立坤
 * 
 */  
package mortal.component.imgTabbar
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.resource.ImagesConst;
	
	public class ImgTabBarItem extends Sprite
	{
		protected var _upBg:Bitmap;
		protected var _overBg:Bitmap;
		protected var _titleText:TextField;
		protected var _info:Object;
		protected var _selected:Boolean;
		
		protected var _upColor:uint = 0xB1efff;
		protected var _overColor:uint = 0xffff00;
		
		public function ImgTabBarItem()
		{
			super();
			mouseChildren = false;
			buttonMode = true;
			initUI();
		}
		
		/**
		 * 初始化界面 
		 * 
		 */
		protected function initUI():void
		{
//			_upBg = GlobalClass.getBitmap(ImagesConst.imgBtn_up);
//			_overBg = GlobalClass.getBitmap(ImagesConst.imgBtn_over);
			
			_titleText = new TextField();
			_titleText.filters = [FilterConst.nameGlowFilter];
			_titleText.autoSize = TextFieldAutoSize.CENTER;
			_titleText.defaultTextFormat = new GTextFormat(FontUtil.songtiName,14,0xffff00,true,null,null,null,null,TextFormatAlign.CENTER);
			_titleText.selectable = false;
			_titleText.width = 90;
			_titleText.y = 15;
			addChild(_titleText);
			
			selected(false);
		}
		
		public function set upColor(value:uint):void
		{
			_upColor = value;
		}
		
		public function set overColor(value:uint):void
		{
			_overColor = value;
		}
		
		public function set index(value:int):void
		{
			
		}
		
		public function get info():Object
		{
			return _info;
		}
		
		/**
		 * 更新数据 
		 * @param info
		 * 
		 */
		public function updateData(info:Object):void
		{
			_info = info;
			_titleText.text = info.name;
		}
		
		/**
		 * 选择或放弃选择 
		 * @param value
		 * 
		 */
		public function selected(value:Boolean):void
		{
			_selected = value;
			if(value)//选择
			{
				if(this.contains(_upBg))
				{
					this.removeChild(_upBg);
				}
				this.addChildAt(_overBg,0);
				_titleText.textColor = _overColor;
			}
			else//取消选择
			{
				if(this.contains(_overBg))
				{
					this.removeChild(_overBg);
				}
				this.addChildAt(_upBg,0);
				_titleText.textColor = _upColor;
			}
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			_info = null;
			_selected = false;
		}
	}
}