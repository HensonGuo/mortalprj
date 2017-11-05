/**
 * @date 2011-4-21 下午03:55:19
 * @author  hexiaoming
 * 
 */ 
package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	public class FirstPageBtnStyle extends SkinStyle
	{
		public function FirstPageBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("FirstPageBtn_upSkin"));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap("FirstPageBtn_upSkin"));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap("FirstPageBtn_overSkin"));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap("FirstPageBtn_upSkin"));
		}
	}
}