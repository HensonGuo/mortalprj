/**
 * @date 2011-4-21 下午07:25:18
 * @author  hexiaoming
 *
 */
package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;

	import fl.core.UIComponent;

	import flash.display.Bitmap;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;

	public class TextButtonStyle extends SkinStyle
	{
		private var _textFormat:TextFormat=new GTextFormat(null, 12, 0xF1FFB1);
		private var _textFormatDisable:TextFormat=new GTextFormat(null, 12, 0x9f9f9f);

		public function TextButtonStyle()
		{
			super();
		}

		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin", Bitmap);
			component.setStyle("downSkin", Bitmap);
			component.setStyle("overSkin", Bitmap);
			component.setStyle("disabledSkin", Bitmap);
			component.setStyle("textFormat", _textFormat);
			component.setStyle("disabledTextFormat", _textFormatDisable);
		}
	}
}