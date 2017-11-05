package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.component.gconst.FilterConst;
	
	public class ButtonNewStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(15,15,1,1);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xcce4ff);
		private var _diableTextFormat:TextFormat = new GTextFormat(null,12,0x7c7c7c);
		
		public function ButtonNewStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			var upSkin:ScaleBitmap = GlobalClass.getScaleBitmap("SampleButton_upSkin",_scaleRect);
			var overSkin:ScaleBitmap = GlobalClass.getScaleBitmap("SampleButton_overSkin",_scaleRect);
			
			component.setStyle("upSkin",upSkin);
			component.setStyle("downSkin",upSkin);
			component.setStyle("overSkin",overSkin);
			component.setStyle("disabledSkin",overSkin);
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_diableTextFormat);
			(component as Button).textField.filters = [FilterConst.buttonDropShadowFilter];
			
			component.setStyle("selectedUpSkin",overSkin);
			component.setStyle("selectedDownSkin",overSkin);
			component.setStyle("selectedOverSkin",overSkin);
		}
	}
}