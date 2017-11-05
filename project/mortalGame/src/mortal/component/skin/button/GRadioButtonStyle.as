package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	public class GRadioButtonStyle extends SkinStyle
	{
		public function GRadioButtonStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upIcon",GlobalClass.getBitmap("GRadioButton_upSkin"));
			component.setStyle("overIcon",GlobalClass.getBitmap("GRadioButton_upSkin"));
			component.setStyle("downIcon",GlobalClass.getBitmap("GRadioButton_upSkin"));
			component.setStyle("selectedUpIcon",GlobalClass.getBitmap("GRadioButton_selectedSkin"));
			component.setStyle("selectedDownIcon",GlobalClass.getBitmap("GRadioButton_selectedSkin"));
			component.setStyle("selectedOverIcon",GlobalClass.getBitmap("GRadioButton_selectedSkin"));
			component.setStyle("textFormat",new GTextFormat(null,12,0xb1efff));
			component.setStyle("textPadding",0);
		}
	}
}