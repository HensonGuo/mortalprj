package skins
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	public class ButtonStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(20,13,29,1);
		private var _textFormat:TextFormat = new TextFormat("宋体",12,0xB1EFFC);
		
		private static var gButton_upSkin:BitmapData = new GButton_upSkin(0,0);
		private static var gButton_overSkin:BitmapData = new GButton_overSkin(0,0);
		private static var gButton_disabledSkin:BitmapData = new GButton_disabledSkin(0,0);
		
		public function ButtonStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",ResouceConst.getScaleBitmap(gButton_upSkin,_scaleRect));
			component.setStyle("downSkin",ResouceConst.getScaleBitmap(gButton_upSkin,_scaleRect));
			component.setStyle("overSkin",ResouceConst.getScaleBitmap(gButton_overSkin,_scaleRect));
			component.setStyle("disabledSkin",ResouceConst.getScaleBitmap(gButton_disabledSkin,_scaleRect));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormat);
		}
	}
}