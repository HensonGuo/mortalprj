package mortal.component.skin.textInput
{
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	/**
	 * 公共输入框样式
	 * @author huangliang
	 */
	public class NoSkinInputStyle extends SkinStyle
	{
		/**
		 * 
		 */
		public function NoSkinInputStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			super.setStyle(component);
			component.setStyle("textFormat", new GTextFormat(FontUtil.songtiName,12,0xffffff,null,null,null,null,null,null,null,null,5,null));
			component.setStyle("upSkin",new Bitmap());
			component.setStyle("disabledSkin",new Bitmap());
			component.setStyle("focusRectSkin","");
		}
	}
}