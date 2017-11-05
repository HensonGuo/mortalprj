package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	public class PrevPageButtonStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(2,2,1,1);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xB1EFFC);
		
		public function PrevPageButtonStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getBitmap("PrevPageBtn_upSkin"));
			component.setStyle("downSkin",GlobalClass.getBitmap("PrevPageBtn_upSkin"));
			component.setStyle("overSkin",GlobalClass.getBitmap("PrevPageBtn_overSkin"));
			component.setStyle("disabledSkin",GlobalClass.getBitmap("PrevPageBtn_upSkin"));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormat);
		}
	}
}