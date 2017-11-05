package mortal.component.skin
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	public class ButtonRandomStyle extends SkinStyle
	{
		public function ButtonRandomStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("careerRandomBtn"));
			component.setStyle("downSkin",GlobalClass.getBitmap("careerRandomBtn"));
			component.setStyle("overSkin",GlobalClass.getBitmap("careerRandomBtn"));
			component.setStyle("disabledSkin",GlobalClass.getBitmap("careerRandomBtn"));
		}
	}
}