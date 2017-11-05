/**
 * @heartspeak
 * 2014-4-16 
 */   	
package mortal.component.skin.scrollPane
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	
	import mortal.component.skin.scrollBar.ScrollBarChatStyle;
	import mortal.component.skin.scrollBar.ScrollBarStyle;
	
	public class ChatScrollPaneStyle extends SkinStyle
	{
		public function ChatScrollPaneStyle()
		{
			super();
		}
		private var scrollBarStyle:ScrollBarChatStyle = new ScrollBarChatStyle();
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("upSkin",new Bitmap());
			scrollBarStyle.setStyle(component);
//			component.setStyle("focusRectSkin",GlobalClass.getScaleBitmap("WindowCenterB"));
		}
	}
}