package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	public class TabButtonStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(10,0,47,22);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xB1EFFC);
		private var _textFormatDisable:TextFormat = new GTextFormat(null,12,0xffffff);
		
		public function TabButtonStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getScaleBitmap("TabButton_upSkin",_scaleRect));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap("TabButton_overSkin",_scaleRect));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap("TabButton_overSkin",_scaleRect));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap("TabButton_disabledSkin",_scaleRect));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormatDisable);
		}
	}
}