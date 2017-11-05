package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	
	import mortal.game.resource.ImagesConst;
	
	public class PageBtnStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(10,8,9,4);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0x71A0D4);
		private var _disabledTextFormat:TextFormat = new GTextFormat(null,12,0xD89372);
		
		public function PageBtnStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_upSkin,_scaleRect));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_upSkin,_scaleRect));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_overSkin,_scaleRect));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_disabledSkin,_scaleRect));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_disabledTextFormat);
			
			component.setStyle("selectedUpSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_overSkin,_scaleRect));
			component.setStyle("selectedDownSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_upSkin,_scaleRect));
			component.setStyle("selectedOverSkin",GlobalClass.getScaleBitmap(ImagesConst.PageBtn_overSkin,_scaleRect));
		}
	}
}