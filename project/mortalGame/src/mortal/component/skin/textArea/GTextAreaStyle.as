/**
 * @date	2011-3-29 上午11:40:28
 * @author  宋立坤
 * 
 */	
package mortal.component.skin.textArea
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.skin.GlobalSkin;
	import mortal.component.skin.scrollBar.ScrollBarStyle;

	public class GTextAreaStyle extends SkinStyle
	{
		private static var textFormat:TextFormat;
		public function GTextAreaStyle()
		{
			super();
		}
		private var scrollBarStyle:ScrollBarStyle = new ScrollBarStyle();
		override public function setStyle(component:UIComponent):void
		{
			if(!textFormat)
			{
				textFormat = GlobalStyle.getTextFormatDefaultFont(GlobalStyle.textFormatPutong);		
			}
			component.setStyle("upSkin",new Bitmap());
			component.setStyle("textPadding ",0);
			component.setStyle("textFormat",textFormat);
			scrollBarStyle.setStyle(component);
			
		}
	}
}