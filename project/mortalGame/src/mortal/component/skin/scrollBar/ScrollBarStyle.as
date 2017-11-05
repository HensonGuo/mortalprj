/**
 * @date 2011-3-10 下午03:32:00
 * @author  hexiaoming
 * 
 */ 
package mortal.component.skin.scrollBar
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	
	import mortal.component.skin.scrollPane.DownArrowDisabledSkin;
	import mortal.component.skin.scrollPane.DownArrowOverSkin;
	import mortal.component.skin.scrollPane.DownArrowUpSkin;
	import mortal.component.skin.scrollPane.ThumbDisabledSkin;
	import mortal.component.skin.scrollPane.ThumbIcon;
	import mortal.component.skin.scrollPane.ThumbOverSkin;
	import mortal.component.skin.scrollPane.ThumbUpSkin;
	import mortal.component.skin.scrollPane.TrackDisabledSkin;
	import mortal.component.skin.scrollPane.TrackUpSkin;
	import mortal.component.skin.scrollPane.UpArrowDisabledSkin;
	import mortal.component.skin.scrollPane.UpArrowOverSkin;
	import mortal.component.skin.scrollPane.UpArrowUpSkin;

	public class ScrollBarStyle extends SkinStyle
	{
		private var _rect:Rectangle = new Rectangle(3,4,12,11);
		public function ScrollBarStyle()
		{
		}
		
		override public function setStyle(component:UIComponent):void
		{
			
			//向下按钮
			component.setStyle("downArrowUpSkin",DownArrowUpSkin);
			component.setStyle("downArrowOverSkin",DownArrowOverSkin);
			component.setStyle("downArrowDownSkin",DownArrowUpSkin);
			
			component.setStyle("downArrowDisabledSkin",DownArrowDisabledSkin);
			
			//向上按钮
			component.setStyle("upArrowUpSkin",UpArrowUpSkin);
			component.setStyle("upArrowOverSkin",UpArrowOverSkin);
			component.setStyle("upArrowDownSkin",UpArrowUpSkin);
			
			component.setStyle("upArrowDisabledSkin",UpArrowUpSkin);
			
			
			//轨道底
			component.setStyle("trackUpSkin",TrackUpSkin);
			component.setStyle("trackOverSkin",TrackUpSkin);
			component.setStyle("trackDownSkin",TrackUpSkin);
			
			component.setStyle("trackDisabledSkin",TrackUpSkin);
			
			
			//滑块
			component.setStyle("thumbUpSkin", ThumbUpSkin);
			component.setStyle("thumbOverSkin", ThumbOverSkin);
			component.setStyle("thumbDownSkin", ThumbUpSkin);
			
			component.setStyle("thumbDisabledSkin",ThumbUpSkin);
			
			//滑块中
			component.setStyle("thumbIcon",ThumbIcon);
		}
	}
}