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
	import mortal.component.skin.combobox.comboboxSkin.ComboboxSimpleOverSkin;
	import mortal.component.skin.combobox.comboboxSkin.ComboboxSimpleUpSkin;
	import mortal.component.skin.scrollBar.ScrollBarStyle;
	
	public class GComboboxSimpleStyle extends SkinStyle
	{
		private var _rect:Rectangle = new Rectangle(3,4,12,11);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xb1efff,null,null,null,null,null,TextFormatAlign.CENTER);//4f8390
		private var _disTextFormat:TextFormat = new GTextFormat(null,12,0x999999,null,null,null,null,null,TextFormatAlign.CENTER);
		public function GComboboxSimpleStyle()
		{
			super();
		}
		
		private var scrollBarStyle:ScrollBarStyle = new ScrollBarStyle();
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("cellRenderer", ComboboxCellRenderer);
			
			
			component.setStyle("upSkin", ComboboxSimpleUpSkin);
			component.setStyle("overSkin",ComboboxSimpleOverSkin);
			component.setStyle("downSkin", ComboboxSimpleUpSkin);
			component.setStyle("disabledSkin", ComboboxSimpleUpSkin);
			component.setStyle("textFormat",_textFormat);	
			component.setStyle("disabledTextFormat",_disTextFormat);
			
			scrollBarStyle.setStyle(component);
		}
	}
}