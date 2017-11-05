package skins
{
	import com.mui.controls.GLabel;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;

	public class CloseButtonStyle extends SkinStyle
	{
		public function CloseButtonStyle()
		{
			
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",new Bitmap(new CloseButton_upSkin(0,0)));//GlobalClass.getBitmap("CloseButton_upSkin"));
			component.setStyle("downSkin",new Bitmap(new CloseButton_upSkin(0,0)));//GlobalClass.getBitmap("CloseButton_upSkin"));
			component.setStyle("overSkin",new Bitmap(new CloseButton_overSkin(0,0)) );//GlobalClass.getBitmap("CloseButton_overSkin"));
		}
	}
}