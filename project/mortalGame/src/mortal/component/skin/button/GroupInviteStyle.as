package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	
	public class GroupInviteStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(4,4,46,10);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xD5B6A2);
		private var _diableTextFormat:TextFormat = new GTextFormat(null,12,0x7c7c7c);
		
		public function GroupInviteStyle()
		{
			//TODO: implement function
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getScaleBitmap("InviteBtn_overSkin",_scaleRect));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap("InviteBtn_overSkin",_scaleRect));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap("InviteBtn_upSkin",_scaleRect));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap("InviteBtn_overSkin",_scaleRect));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_diableTextFormat);
			
			component.setStyle("selectedUpSkin",GlobalClass.getScaleBitmap("InviteBtn_overSkin",_scaleRect));
			component.setStyle("selectedDownSkin",GlobalClass.getScaleBitmap("InviteBtn_upSkin",_scaleRect));
			component.setStyle("selectedOverSkin",GlobalClass.getScaleBitmap("InviteBtn_upSkin",_scaleRect));
		}
	}
}