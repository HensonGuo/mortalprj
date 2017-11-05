package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	public class NextPageButtonStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(1,1,8,8);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xB1EFFC);
		
		public function NextPageButtonStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("NextPageBtn_upSkin"));
			component.setStyle("downSkin",GlobalClass.getBitmap("NextPageBtn_upSkin"));
			component.setStyle("overSkin",GlobalClass.getBitmap("NextPageBtn_overSkin"));
			component.setStyle("disabledSkin",GlobalClass.getBitmap("NextPageBtn_upSkin"));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormat);
		}
	}
}