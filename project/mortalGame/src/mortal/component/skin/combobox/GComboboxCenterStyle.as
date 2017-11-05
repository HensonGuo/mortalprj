package mortal.component.skin.combobox
{
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import flash.text.TextFormatAlign;
	
	import mortal.component.skin.combobox.comboboxSkin.ComboboxCellRenderer;
	import mortal.component.skin.combobox.comboboxSkin.ComboboxOverSkin;
	import mortal.component.skin.combobox.comboboxSkin.ComboboxUpSkin;
	import mortal.component.skin.scrollBar.ScrollBarStyle;
	
	public class GComboboxCenterStyle extends SkinStyle
	{
		private var _rect:Rectangle = new Rectangle(3,4,12,11);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xb1effc,null,null,null,null,null,TextFormatAlign.CENTER);
		private var _disTextFormat:TextFormat = new GTextFormat(null,12,0x999999,null,null,null,null,null,TextFormatAlign.CENTER);
		public function GComboboxCenterStyle()
		{
			super();
		}
		
		private var scrollBarStyle:ScrollBarStyle = new ScrollBarStyle();
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("cellRenderer", ComboboxCellRenderer);
			
			
			component.setStyle("upSkin", ComboboxUpSkin);
			component.setStyle("overSkin",ComboboxOverSkin);
			component.setStyle("downSkin", ComboboxUpSkin);
			component.setStyle("disabledSkin", ComboboxUpSkin);
			component.setStyle("textFormat",_textFormat);	
			component.setStyle("disabledTextFormat",_disTextFormat);
			
			scrollBarStyle.setStyle(component);
		}
	}
}