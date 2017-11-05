package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	
	public class TabarNewStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(19,12,1,1);
		private var _textFormat:TextFormat =  new GTextFormat(null,12,0xa49e91);
		private var _textFormatDisable:TextFormat = new GTextFormat(null,12,0xf8eacd);
		
		public function TabarNewStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getScaleBitmap(ImagesConst.TabButton2_upSkin,_scaleRect));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap(ImagesConst.TabButton2_overSkin,_scaleRect));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap(ImagesConst.TabButton2_overSkin,_scaleRect));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap(ImagesConst.TabButton2_dowmSkin,_scaleRect));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormatDisable);
		}
	}
}