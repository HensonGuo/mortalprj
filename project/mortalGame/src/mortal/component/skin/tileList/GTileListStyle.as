/**
 * @date 2011-4-8 下午04:15:46
 * @author  wyang
 * 
 */  

package mortal.component.skin.tileList
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	import mortal.component.skin.scrollBar.ScrollBarStyle;
	
	public class GTileListStyle extends SkinStyle
	{
		public function GTileListStyle()
		{
			super();
		}
		
		private var scrollBarStyle:ScrollBarStyle = new ScrollBarStyle();
		
		override public function setStyle(component:UIComponent):void
		{
			super.setStyle(component);
			component.setStyle("skin",new Bitmap());
			scrollBarStyle.setStyle(component);
		}
	}
}