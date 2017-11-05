/**
 * @date 2011-3-10 下午03:32:00
 * @author  hexiaoming
 * 
 */ 
package chat.style
{
	import chat.style.scrollBar.DownArrowDisabledSkin;
	import chat.style.scrollBar.DownArrowOverSkin;
	import chat.style.scrollBar.DownArrowUpSkin;
	import chat.style.scrollBar.ThumbIcon;
	import chat.style.scrollBar.ThumbOverSkin;
	import chat.style.scrollBar.ThumbUpSkin;
	import chat.style.scrollBar.TrackUpSkin;
	import chat.style.scrollBar.UpArrowOverSkin;
	import chat.style.scrollBar.UpArrowUpSkin;
	
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.geom.Rectangle;
	
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