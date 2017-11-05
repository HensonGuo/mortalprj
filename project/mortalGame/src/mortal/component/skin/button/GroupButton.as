package mortal.component.skin.button
{
	import com.mui.controls.GButton;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	
	public class GroupButton extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(19,11,1,1);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xD5B6A2);
		private var _diableTextFormat:TextFormat = new GTextFormat(null,12,0x7c7c7c);
		
		public function GroupButton()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			var upSkin:ScaleBitmap = GlobalClass.getScaleBitmap("GroupBtn_upSkin",_scaleRect);
			var overSkin:ScaleBitmap = GlobalClass.getScaleBitmap("GroupBtn_overSkin",_scaleRect);
			
			component.setStyle("upSkin",upSkin);
			component.setStyle("downSkin",upSkin);
			component.setStyle("overSkin",overSkin);
			component.setStyle("disabledSkin",overSkin);
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_diableTextFormat);
			component.setStyle("textPadding",0);
			component.setStyle("selectedUpSkin",overSkin);
			component.setStyle("selectedDownSkin",overSkin);
			component.setStyle("selectedOverSkin",overSkin);
			
			(component as GButton).paddingTop = 2;
		}
	}
}