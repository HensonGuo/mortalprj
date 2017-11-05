/**
 * @date	2011-3-8 上午11:41:19
 * @author  宋立坤
 * 
 */	
package chat.style
{
	import chat.ChatRes;
	
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	public class ScrollPaneStyle extends SkinStyle
	{ 
		public function ScrollPaneStyle()
		{
			super();
		}
		private var scrollBarStyle:ScrollBarStyle = new ScrollBarStyle();
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",new Bitmap());
			scrollBarStyle.setStyle(component);
			component.setStyle("focusRectSkin",ChatRes.getScaleBitmap(WindowCenterB,new Rectangle(10,10,21,23)));
		}
	}
}