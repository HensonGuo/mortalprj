/**
 * @date 2011-4-21 下午03:57:52
 * @author  hexiaoming
 * 
 */ 
package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	public class LastPageBtnStyle extends SkinStyle
	{
		public function LastPageBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("LastPageBtn_upSkin"));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap("LastPageBtn_upSkin"));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap("LastPageBtn_overSkin"));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap("LastPageBtn_upSkin"));
		}
	}
}