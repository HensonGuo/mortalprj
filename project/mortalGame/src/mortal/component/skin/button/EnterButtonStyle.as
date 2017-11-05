/**
 * @heartspeak
 * 2014-3-11 
 */   	
package mortal.component.skin.button
{
	import com.mui.controls.GLabel;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import mortal.game.resource.ImagesConst;
	
	public class EnterButtonStyle extends SkinStyle
	{
		public function EnterButtonStyle()
		{
			
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap(ImagesConst.ButtonChat_upSkin));
			component.setStyle("downSkin",GlobalClass.getBitmap(ImagesConst.ButtonChat_upSkin));
			component.setStyle("overSkin",GlobalClass.getBitmap(ImagesConst.ButtonChat_overSkin));
			component.setStyle("disabledSkin",GlobalClass.getBitmap(ImagesConst.ButtonChat_upSkin));
		}
	}
}