/**
 * 样式全局类
 */
package mortal.component.gconst
{
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;

	public class StyleConst
	{
		private static var _defaultTextFormat:TextFormat
		public static function get defaultTextFormat():TextFormat
		{
			return _defaultTextFormat || (_defaultTextFormat=new GTextFormat(FontUtil.songtiName,12,0xB1efff))
		}
		
		
		private static var _textFormatA:TextFormat
		public static function get textFormatA():TextFormat
		{
			return _textFormatA || (_textFormatA=new GTextFormat(FontUtil.songtiName,12,0xFFFFFF))
		}
		/**
		 * GTextInput格式，5像素缩进，颜色 0xb2efff
		 */		
		private static var _gTextInputFormatA:TextFormat
		public static function get gTextInputFormatA():TextFormat
		{
			return _gTextInputFormatA || (_gTextInputFormatA=new GTextFormat(FontUtil.songtiName,16,0xb2efff,null,null,null,null,null,null,null,null,5,null))
		}
		/**
		 * GTextInput格式，5像素缩进，颜色 0xfefecc
		 */	
		private static var _gTextInputFormatB:TextFormat
		public static function get gTextInputFormatB():TextFormat
		{
			return _gTextInputFormatB || (_gTextInputFormatB=new GTextFormat(FontUtil.songtiName,12,0xfefecc,null,null,null,null,null,null,null,null,5,null))
		}
		/**
		 * GLabel样式 
		 */		
		private static var _gLabelFormat:TextFormat
		public static function get gLabelFormat():TextFormat
		{
			return _gLabelFormat || (_gLabelFormat=new GTextFormat(FontUtil.songtiName,12,null,null,null,null,null,null,TextFormatAlign.CENTER))
		}
		/**
		 * 双休颜色字体 
		 */		
		private static var _CircleFormat:TextFormat
		public static function get CircleFormat():TextFormat
		{
			return _CircleFormat || (_CircleFormat=new GTextFormat(FontUtil.songtiName,12,0xFEFFB1,null,null,null,null,null,null))
		}
		
		public function StyleConst()
		{
			
		}
	}
}