/**
 * 增加数量
 * @date	2011-3-7 下午12:53:33
 * @author  shiyong
 * 
 */	
package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import mortal.game.resource.ImagesConst;
	
	public class AddBtnStyle extends SkinStyle
	{
		public function AddBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap(ImagesConst.AddBtn_upSkin));
			component.setStyle("downSkin",GlobalClass.getBitmap(ImagesConst.AddBtn_upSkin));
			component.setStyle("overSkin",GlobalClass.getBitmap(ImagesConst.AddBtn_overSkin));
		}
	}
}