/**
 * @date	2011-3-7 下午12:53:33
 * @author  宋立坤
 * 
 */	
package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	public class MoveBtnStyle extends SkinStyle
	{
		public function MoveBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("TaskTrackMove_upSkin"));
			component.setStyle("downSkin",GlobalClass.getBitmap("TaskTrackMove_downSkin"));
			component.setStyle("overSkin",GlobalClass.getBitmap("TaskTrackMove_downSkin"));
		}
	}
}