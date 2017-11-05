/**
 * @date	Mar 3, 2011 8:31:40 PM
 * @author  huangliang
 * 
 */
package mortal.component.skin.textInput
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	import mortal.component.gconst.ResourceConst;

	/**
	 * 公共输入框样式
	 * @author huangliang
	 */
	public class GTextInputStyle extends SkinStyle
	{
		/**
		 * 
		 */
		public function GTextInputStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			super.setStyle(component);
			component.setStyle("textFormat", new GTextFormat(FontUtil.songtiName,12,0xffffff,null,null,null,null,null,null,null,null,5,null));
			component.setStyle("upSkin",ResourceConst.getScaleBitmap("InputBg"));
			component.setStyle("disabledSkin",ResourceConst.getScaleBitmap("DisabledBg"));
			component.setStyle("textPadding",2);
			component.setStyle("focusRectSkin","");
		}
	}
}