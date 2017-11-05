package mortal.component.skin.textInput
{
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.ResourceConst;
	
	/**
	 * 公共输入框样式2
	 * @date   2014-3-10 下午12:32:20
	 * @author dengwj
	 */	 
	public class GTextInputStyle2 extends SkinStyle
	{
		public function GTextInputStyle2()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			super.setStyle(component);
			component.setStyle("textFormat", new GTextFormat(FontUtil.songtiName,12,0xffffff,null,null,null,null,null,null,null,null,5,null));
			component.setStyle("upSkin",ResourceConst.getScaleBitmap("InputDisablBg"));
			component.setStyle("disabledSkin",ResourceConst.getScaleBitmap("DisabledBg"));
			component.setStyle("textPadding",2);
			component.setStyle("focusRectSkin","");
		}
	}
}