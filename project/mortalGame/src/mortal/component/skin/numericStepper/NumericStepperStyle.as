/**
 * @date 2011-3-3 下午07:54:45
 * @author  wangyang
 * 
 */  
package mortal.component.skin.numericStepper
{
	import com.greensock.layout.AlignMode;
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.ResourceConst;
	
	public class NumericStepperStyle extends SkinStyle
	{
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xFCFEC,null,null,null,null,null,TextFormatAlign.RIGHT);
		public function NumericStepperStyle()
		{
			super();
			_textFormat.align = AlignMode.RIGHT;
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin", ResourceConst.getScaleBitmap("InputDisablBg"));
			component.setStyle("upArrowUpSkin",GlobalClass.getBitmap("numUp_upSkin"));
			component.setStyle("upArrowOverSkin",GlobalClass.getBitmap("numUp_overSkin"));
			component.setStyle("upArrowDownSkin",GlobalClass.getBitmap("numUp_upSkin"));
			component.setStyle("downArrowUpSkin",GlobalClass.getBitmap("numDown_upSkin"));
			component.setStyle("downArrowOverSkin",GlobalClass.getBitmap("numDown_overSkin"));
			component.setStyle("downArrowDownSkin",GlobalClass.getBitmap("numDown_upSkin"));
			component.setStyle("focusRectSkin",Sprite);
//			component.setStyle("TextInput_upskin", GlobalClass.getScaleBitmap("InputBg",new Rectangle(15,10,1,4)));
			component.setStyle("TextInput_disabledSkin",GlobalClass.getScaleBitmap("WindowCenterB",new Rectangle(4,4,36,21)));
			component.setStyle("textFormat",_textFormat);
			
			component.setStyle("maxBtnDownSkin",GlobalClass.getBitmap("numMax_upSkin"));
			component.setStyle("maxBtnUpSkin",GlobalClass.getBitmap("numMax_upSkin"));
			component.setStyle("maxBtnOverSkin",GlobalClass.getBitmap("numMax_overSkin"));
			
			component.setStyle("minBtnDownSkin",GlobalClass.getBitmap("numMin_upSkin"));
			component.setStyle("minBtnUpSkin",GlobalClass.getBitmap("numMin_upSkin"));
			component.setStyle("minBtnOverSkin",GlobalClass.getBitmap("numMin_overSkin"));
			
		}
	}
}