/**
 * @date 2011-3-17 下午05:29:11
 * @author  hexiaoming
 * 
 */ 
package mortal.component.skin.button
{
	import com.mui.controls.GLabel;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	public class DownButtonStyle extends SkinStyle
	{
		public function DownButtonStyle()
		{
			
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("DownButton_up"));
			component.setStyle("downSkin",GlobalClass.getBitmap("DownButton_down"));
			component.setStyle("overSkin",GlobalClass.getBitmap("DownButton_over"));
		}
	}
}