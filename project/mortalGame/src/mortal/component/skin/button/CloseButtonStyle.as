package mortal.component.skin.button
{
	import com.mui.controls.GLabel;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;

	public class CloseButtonStyle extends SkinStyle
	{
		public function CloseButtonStyle()
		{
			
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("CloseButton_upSkin"));
			component.setStyle("downSkin",GlobalClass.getBitmap("CloseButton_upSkin"));
			component.setStyle("overSkin",GlobalClass.getBitmap("CloseButton_overSkin"));
		}
	}
}