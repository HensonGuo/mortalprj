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
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	
	public class MountBtnStyle extends SkinStyle
	{
		private var _component:UIComponent;
		private var _scaleRect:Rectangle = new Rectangle(44, 17, 1, 1);
		private var _textFormat:TextFormat = new GTextFormat(FontUtil.defaultName,13,0xFFcc8c);
		private var _diableTextFormat:TextFormat = new GTextFormat(FontUtil.defaultName,13,0x7c7c7c);
		
		public function MountBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			_component = component;
			var upSkin:ScaleBitmap = GlobalClass.getScaleBitmap("EnterCopyBtn_upSkin",_scaleRect);
			var overSkin:ScaleBitmap = GlobalClass.getScaleBitmap("EnterCopyBtn_upSkin",_scaleRect);
			
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
			(component as Button).textField.filters = [FilterConst.buttonDropShadowFilter,FilterConst.buttonGlowFilter];
			//			(component as Button).textField.height = 24;
//			(component as GButton).paddingTop = 4;
		}
	}
}