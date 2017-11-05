package mortal.component.skin.dataGrid
{
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	
	public class DataGridStyle extends SkinStyle
	{
		public function DataGridStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("skin",new Bitmap());
			component.setStyle("headerDisabledSkin",new Bitmap());
			component.setStyle("headerUpSkin",new Bitmap());
		}
	}
}