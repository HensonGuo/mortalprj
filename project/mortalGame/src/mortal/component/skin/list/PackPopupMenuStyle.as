package mortal.component.skin.list
{
	import com.mui.core.GlobalClass;
	import com.mui.skins.SkinStyle;
	
	import fl.core.UIComponent;
	
	import mortal.game.view.common.menu.ListMenuCellRenderer;
	
	public class PackPopupMenuStyle extends SkinStyle
	{
		public function PackPopupMenuStyle()
		{
			super();
		}
		
		override public function setStyle(component:UIComponent):void
		{
			component.setStyle("skin",GlobalClass.getBitmap("PopUpMenuBg_pack"));
			component.setStyle("cellRenderer",ListMenuCellRenderer);
		}
	}
}