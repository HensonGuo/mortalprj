package chat.display.menu
{
	import com.mui.core.GlobalClass;
	
	import fl.controls.listClasses.CellRenderer;
	
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	
	public class ListMenuCellRenderer extends CellRenderer
	{
		public function ListMenuCellRenderer()
		{
			super();
			setSize(95,19);
			this.setStyle("downSkin", new Bitmap(new PopUpMenuOverSkin(95,19)));
			this.setStyle("overSkin",new Bitmap(new PopUpMenuOverSkin(95,19)));
			this.setStyle("upSkin",new Bitmap());
			this.setStyle("selectedDownSkin",new Bitmap(new PopUpMenuOverSkin(95,19)));
			this.setStyle("selectedOverSkin",new Bitmap(new PopUpMenuOverSkin(95,19)));
			this.setStyle("selectedUpSkin",new Bitmap(new PopUpMenuOverSkin(95,19)));
			this.setStyle("textFormat",new TextFormat(null,12,0xFFFFFF));
		}
	}
}