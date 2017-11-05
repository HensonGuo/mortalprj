package mortal.component.skin.button
{
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	public class ButtonSmallStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(4,4,46,10);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xD5B6A2);
		private var _diableTextFormat:TextFormat = new GTextFormat(null,12,0x7c7c7c);
		
		public function ButtonSmallStyle()
		{
			//TODO: implement function
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			var upSkin:ScaleBitmap = GlobalClass.getScaleBitmap("PackBtn_up",_scaleRect);
			var overSkin:ScaleBitmap = GlobalClass.getScaleBitmap("PackBtn_over",_scaleRect);
			
			component.setStyle("upSkin",upSkin);
			component.setStyle("downSkin",upSkin);
			component.setStyle("overSkin",overSkin);
			component.setStyle("disabledSkin",overSkin);
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_diableTextFormat);
			
			component.setStyle("selectedUpSkin",overSkin);
			component.setStyle("selectedDownSkin",overSkin);
			component.setStyle("selectedOverSkin",overSkin);
		}
	}
}