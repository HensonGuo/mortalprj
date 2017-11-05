/**
 * 2014-2-20
 * @author chenriji
 **/
package mortal.component.skin.button
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.game.resource.ImagesConst;
	
	public class TaskCatogeryStyle extends SkinStyle
	{
		private var _scaleRect:Rectangle = new Rectangle(7, 11, 1, 1);
		private var _textFormat:TextFormat = new GTextFormat(null,12,0xB1EFFC);
		private var _textFormatDisable:TextFormat = new GTextFormat(null,12,0xffffff);
		
		public function TaskCatogeryStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",GlobalClass.getScaleBitmap(ImagesConst.TaskCatogeryBtn_upSkin, _scaleRect));
			component.setStyle("downSkin",GlobalClass.getScaleBitmap(ImagesConst.TaskCatogeryBtn_overSkin, _scaleRect));
			component.setStyle("overSkin",GlobalClass.getScaleBitmap(ImagesConst.TaskCatogeryBtn_overSkin, _scaleRect));
			component.setStyle("disabledSkin",GlobalClass.getScaleBitmap(ImagesConst.TaskCatogeryBtn_disabledSkin, _scaleRect));
			component.setStyle("selectedSkin",GlobalClass.getScaleBitmap(ImagesConst.TaskCatogeryBtn_disabledSkin, _scaleRect));
			component.setStyle("textFormat",_textFormat);
			component.setStyle("disabledTextFormat",_textFormatDisable);
		}
	}
}