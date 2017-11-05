package mortal.component.skin.Label
{
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	public class GLabelStyle extends SkinStyle
	{
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xb1efff);
		
		public function GLabelStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("textFormat",_textFormat);
		}
	}
}