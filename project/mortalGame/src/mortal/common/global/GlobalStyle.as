/**
 * @date 2011-3-23 下午05:13:44
 * @author  hexiaoming
 *
 */
package mortal.common.global
{
	import extend.language.Language;
	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontName;
	import mortal.common.font.FontUtil;

	public class GlobalStyle
	{
		/**
		 * 通用普通淡蓝色
		 */
		public static const colorPutong:String="#Bee8fe";
		public static const colorPutongUint:int=0xBee8fe;

		/**
		 * 通用暗金色
		 */
		public static const colorAnjin:String="#ffc293";
		public static const colorAnjinUint:int=0xffc293;

		/**
		 * 通用灰色
		 */
		public static const colorHui:String="#989795";
		public static const colorHuiUint:int=0x989795;

		/**
		 * 通用蓝色
		 */
		public static const colorLan:String="#21A8FF";
		public static const colorLanUint:int=0x21A8FF;

		/**
		 * 通用绿色
		 */
		public static const colorLv:String="#42e554";
		public static const colorLvUint:int=0x42e554;

		/**
		 * 通用黄色
		 */
		public static const colorHuang:String="#f2de47";
		public static const colorHuangUint:int=0xf2de47;

		/**
		 * 通用红色
		 */
		public static const colorHong:String="#df2121";
		public static const colorHongUint:int=0xdf2121;

		/**
		 * 通用紫色
		 */
		public static const colorZi:String="#f72ef0";
		public static const colorZiUint:int=0xf72ef0;

		/**
		 * 通用橙色
		 */
		public static const colorChen:String="#CF700A";
		public static const colorChenUint:int=0xCF700A;


		/**
		 * 通用白色
		 */
		public static const colorBai:String="#ffffff";
		public static const colorBaiUint:int=0xffffff;
		
		public static const colorYin:String = "#F1DE42";
		public static const colorYinUint:uint = 0xF1DE42;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/**
		 * 通用淡蓝色
		 */
		public static const dBlue:String="#B1efff";
		public static const dBlueUint:int=0xB1efff;

		/**
		 * 通用淡黄色
		 */
		public static const dYellow:String="#F1FFB1";
		public static const dYellowUint:int=0xF1FFB1;

		/**
		 * 通用灰色
		 */
		public static const gray:String="#9f9f9f";
		public static const grayUint:int=0x9f9f9f;

		/**
		 * 通用蓝色
		 */
		public static const blue:String="#00a2ff";
		public static const blueUint:int=0x00a2ff;

		/**
		 * 通用绿色
		 */
		public static const green:String="#60e71e";
		public static const greenUint:int=0x60e71e;

		/**
		 * 通用黄色
		 */
		public static const yellow:String="#E2CD9E";
		public static const yellowUint:int=0xE2CD9E;

		/**
		 * 通用红色
		 */
		public static const red:String="#ff0000";
		public static const redUint:int=0xff0000;

		/**
		 * 通用紫色
		 */
		public static const purple:String="#ff00ff";
		public static const purpleUint:int=0xff00ff;

		/**
		 * 即橙色
		 */
		public static const orange:String="#FF7902";
		public static const orangeUint:int=0xFF7902;

		/**
		 *  通用普通淡蓝色
		 */
		private static var _textFormatPutong:GTextFormat;
		public static function get textFormatPutong():GTextFormat
		{
			if(!_textFormatPutong)
			{
				_textFormatPutong=new GTextFormat(FontUtil.defaultName, 12, 0xBee8fe, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatPutong.clone();
		}
		

		/**
		 * 通用暗金颜色
		 */
		private static var _textFormatAnjin:GTextFormat
		public static function get textFormatAnjin():GTextFormat
		{
			if(!_textFormatAnjin)
			{
				_textFormatAnjin=new GTextFormat(FontUtil.defaultName, 12, 0xffc293, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatAnjin.clone();
		}
		
		/**
		 * 通用暗黄颜色
		 */
		private static var _textFormatAnHuan:GTextFormat
		public static function get textFormatAnHuan():GTextFormat
		{
			if(!_textFormatAnjin)
			{
				_textFormatAnjin=new GTextFormat(FontUtil.defaultName, 12, 0xf8eacd, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatAnjin.clone();
		}
		

		/**
		 * 通用灰色
		 */
		private static var _textFormatHui:GTextFormat
		public static function get textFormatHui():GTextFormat
		{
			if(!_textFormatHui)
			{
				_textFormatHui=new GTextFormat(FontUtil.defaultName, 12, 0x989795, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatHui.clone();
		}
		

		/**
		 * 通用蓝色
		 */
		private static var  _textFormatLan:GTextFormat
		public static function get textFormatlan():GTextFormat
		{
			if(!_textFormatLan)
			{
				_textFormatLan=new GTextFormat(FontUtil.defaultName, 12, 0x114ef7, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatLan.clone();
		}
		
		/**
		 * 通用绿色
		 */
		private static var  _textFormatLv:GTextFormat
		public static function get textFormatLv():GTextFormat
		{
			if(!_textFormatLv)
			{
				_textFormatLv=new GTextFormat(FontUtil.defaultName, 12, 0x42e554, null, null, null, null, null, TextFormatAlign.LEFT);

			}
			return _textFormatLv.clone();
		}
		
		/**
		 * 通用黄色
		 */
		private static var  _textFormatHuang:GTextFormat
		public static function get textFormatHuang():GTextFormat
		{
			if(!_textFormatHuang)
			{
				_textFormatHuang=new GTextFormat(FontUtil.defaultName, 12, 0xf2de47, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatHuang.clone();
		}
		
		/**
		 * 通用红色
		 */
		private static var _textFormatHong:GTextFormat
		public static function get textFormatHong():GTextFormat
		{
			if(!_textFormatHong)
			{
				_textFormatHong=new GTextFormat(FontUtil.defaultName, 12, 0xdf2121, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatHong.clone();
		}
		
		/**
		 * 通用紫色
		 */
		private static var _textFormatZi:GTextFormat
		public static function get textFormatZi():GTextFormat
		{
			if(!_textFormatZi)
			{
				_textFormatZi=new GTextFormat(FontUtil.defaultName, 12, 0xf72ef0, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatZi.clone();
		}
		
		/**
		 * 通用橙色
		 */
		private static var _textFormatChen:GTextFormat
		public static function get textFormatChen():GTextFormat
		{
			if(!_textFormatChen)
			{
				_textFormatChen=new GTextFormat(FontUtil.defaultName, 12,0xFF5a00, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatChen.clone();
		}
		
		/**
		 * 通用深红色
		 */
		private static var _textFormatDarkRed:GTextFormat
		public static function get textFormatDarkRed():GTextFormat
		{
			if(!_textFormatDarkRed)
			{
				_textFormatDarkRed=new GTextFormat(FontUtil.defaultName, 12,0xCC0066, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatDarkRed.clone();
		}
		
		
		
		/**
		 * 通用淡橙色
		 */
		private static var _textFormatLightChen:GTextFormat
		public static function get textFormatLightChen():GTextFormat
		{
			if(!_textFormatLightChen)
			{
				_textFormatLightChen=new GTextFormat(FontUtil.defaultName, 12,0xFFCC99, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatLightChen.clone();
		}
		
		
		/**
		 * 通用白色
		 */
		private static var _textFormatBai:GTextFormat
		public static function get textFormatBai():GTextFormat
		{
			if(!_textFormatBai)
			{
				_textFormatBai=new GTextFormat(FontUtil.defaultName, 12, 0xffffff, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatBai.clone();
		}
		
		private static var _txtFormatYin:GTextFormat;
		public static function get textFormatYin():GTextFormat
		{
			if(!_txtFormatYin)
			{
				_txtFormatYin=new GTextFormat(FontUtil.defaultName, 12, 0xF1DE42, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _txtFormatYin.clone();
		}
		
		private static var _textFormatJiang:GTextFormat;
		public static function get textFormatJiang():GTextFormat
		{
			if(!_textFormatJiang)
			{
				_textFormatJiang=new GTextFormat(FontUtil.defaultName, 12, 0xffc293, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatJiang.clone();
		}
		
		private static var _textFormatYellow:GTextFormat;
		public static function get textFormatYellow():GTextFormat
		{
			if(!_textFormatYellow)
			{
				_textFormatYellow=new GTextFormat(FontUtil.defaultName, 12, 0xffff00, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatYellow.clone();
		}
		
		
// 以下为物品字体颜色
		public static var colorItemGray:String = "#8C8C8C";
		private static var _textFormatItemGray:GTextFormat
		public static function get textFormatItemGray():GTextFormat
		{
			if(!_textFormatItemGray)
			{
				_textFormatItemGray=new GTextFormat(FontUtil.defaultName, 12, 0x8C8C8C, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemGray.clone();
		}
		
		private static var _textFormatItemWhite:GTextFormat
		public static function get textFormatItemWhite():GTextFormat
		{
			if(!_textFormatItemWhite)
			{
				_textFormatItemWhite=new GTextFormat(FontUtil.defaultName, 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemWhite.clone();
		}
		
		private static var _textFormatItemGreen:GTextFormat
		public static function get textFormatItemGreen():GTextFormat
		{
			if(!_textFormatItemGreen)
			{
				_textFormatItemGreen=new GTextFormat(FontUtil.defaultName, 12, 0x00ff00, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemGreen.clone();
		}
		
		private static var _textFormatItemBlue:GTextFormat
		public static function get textFormatItemBlue():GTextFormat
		{
			if(!_textFormatItemBlue)
			{
				_textFormatItemBlue=new GTextFormat(FontUtil.defaultName, 12, 0x00BEFF, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemBlue.clone();
		}
		
		private static var _textFormatItemPurple:GTextFormat
		public static function get textFormatItemPurple():GTextFormat
		{
			if(!textFormatItemPurple)
			{
				_textFormatItemPurple=new GTextFormat(FontUtil.defaultName, 12, 0xFF00FF, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemPurple.clone();
		}
		
		private static var _textFormatItemOrange:GTextFormat
		public static function get textFormatItemOrange():GTextFormat
		{
			if(!_textFormatItemOrange)
			{
				_textFormatItemOrange=new GTextFormat(FontUtil.defaultName, 12, 0xFF7902, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemOrange.clone();
		}
		
		private static var _textFormatItemRed:GTextFormat
		public static function get textFormatItemRed():GTextFormat
		{
			if(!_textFormatItemRed)
			{
				_textFormatItemRed=new GTextFormat(FontUtil.defaultName, 12, 0xff5b5b, null, null, null, null, null, TextFormatAlign.LEFT);
			}
			return _textFormatItemRed.clone();
		}
		
		private static var _windowTitle:GTextFormat //窗口标题
		private static var _windowTitle2:GTextFormat //npc对话标题
		public static function get windowTitle():GTextFormat
		{
			return _windowTitle || (_windowTitle=new GTextFormat("title", 18, 0xfce4c0, true, null, null, null, null, TextFormatAlign.CENTER))
		}
		
		public static function get windowTitle2():GTextFormat
		{
			return _windowTitle2 || (_windowTitle2=new GTextFormat(FontUtil.defaultName, 17, 0xFCE4C0, true, null, null, null, null, TextFormatAlign.CENTER))
		}
		
		private static var _embedNumberTf:GTextFormat
		public static function get embedNumberTf():GTextFormat
		{
			if(!_embedNumberTf)
			{
				_embedNumberTf=new GTextFormat(FontUtil.EmbedNumberName, 18, 0x00ff00, null, false, null, null, null, TextFormatAlign.CENTER); //嵌入数字
			}
			return _embedNumberTf.clone();
		}
		
		public static const career_1:String="#fff000";
		public static const career_2:String="#00f0ff";
		public static const career_4:String="#FF7902";
		public static const career_8:String="#ff04fc";


		public static function getTextFormatDefaultFont(textFormat:GTextFormat):GTextFormat
		{
			var textFormatCenter:GTextFormat=textFormat.clone();
			textFormatCenter.font=FontUtil.defaultFont.fontName;
			return textFormatCenter;
		}

	}
}
