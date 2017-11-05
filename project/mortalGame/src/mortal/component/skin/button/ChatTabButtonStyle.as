
 /**
 * @heartspeak
 * 2014-3-11 
 */   	

package mortal.component.skin.button
{
	import com.mui.controls.GButton;
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	
	public class ChatTabButtonStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(18,8,1,1);
		private var _textFormat:GTextFormat;
		private var _textFormatDisable:GTextFormat;
		
		public function ChatTabButtonStyle()
		{
			_textFormat = GlobalStyle.textFormatPutong.setFont(FontUtil.defaultName);
			_textFormatDisable = GlobalStyle.textFormatJiang.setFont(FontUtil.defaultName);
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getScaleBitmap("channel_upSkin",_scaleRect));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap("channel_overSkin",_scaleRect));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap("channel_overSkin",_scaleRect));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap(ImagesConst.channel_disabledSkin,_scaleRect));
			component.setStyle("textPadding",0);
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormatDisable);
			(component as GButton).paddingTop = 2;
		}
	}
}