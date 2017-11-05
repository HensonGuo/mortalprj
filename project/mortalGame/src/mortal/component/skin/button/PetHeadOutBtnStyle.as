package mortal.component.skin.button
{
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.controls.Button;
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.resource.ImagesConst;
	
	public class PetHeadOutBtnStyle extends SkinStyle
	{
		private var _component:UIComponent;
		private var _textFormat:TextFormat = new GTextFormat(FontUtil.defaultName,13,0xFFcc8c);
		private var _diableTextFormat:TextFormat = new GTextFormat(FontUtil.defaultName,13,0x7c7c7c);
		
		public function PetHeadOutBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			_component = component;
			var upSkin:GBitmap = GlobalClass.getBitmap(ImagesConst.PetHeadOut_upSkin);
			var overSkin:GBitmap = GlobalClass.getBitmap(ImagesConst.PetHeadOut_overSkin);
			
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