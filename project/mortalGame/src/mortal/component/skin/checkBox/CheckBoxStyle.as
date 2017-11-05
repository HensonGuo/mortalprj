/**
 * @date 2011-3-14 下午05:10:01
 * @author  wangyang
 * 
 */  
package mortal.component.skin.checkBox
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import mortal.common.GTextFormat;
	import mortal.game.resource.ImagesConst;
	
	public class CheckBoxStyle extends SkinStyle
	{
		public function CheckBoxStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_upSkin));
			component.setStyle("overIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_upSkin));
			component.setStyle("downIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_selectedSkin));
			component.setStyle("disabledIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_disableSkin));
			component.setStyle("selectedDisabledIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_selectDisableSkin));
			component.setStyle("selectedUpIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_selectedSkin));
			component.setStyle("selectedDownIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_selectedSkin));
			component.setStyle("selectedOverIcon",GlobalClass.getBitmap(ImagesConst.GCheckBox_selectedSkin));
			component.setStyle("textFormat",new GTextFormat(null,12,0xb1efff));
			component.setStyle("disabledTextFormat",new GTextFormat(null,12,0xCCCCCC));
			component.setStyle("textPadding",0);
		}
	}
}