package mortal.game.view.common.menu
{
	import fl.controls.listClasses.CellRenderer;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	
	public class ListMenuCellRenderer extends CellRenderer
	{
		public function ListMenuCellRenderer()
		{
			super();
			var across:Bitmap = ResourceConst.getScaleBitmap(ImagesConst.Menu_overSkin);
			
			setSize(95,19);
//			this.filters = [FilterConst.glowFilter];
			this.setStyle("downSkin",new Bitmap());
			this.setStyle("overSkin",across);
			this.setStyle("upSkin",new Bitmap());
			this.setStyle("selectedDownSkin",new Bitmap());
			this.setStyle("selectedOverSkin",across);
			this.setStyle("selectedUpSkin",new Bitmap());
			this.setStyle("textFormat",new GTextFormat(null,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER));
			this.setStyle("disabledTextFormat",new GTextFormat(null,12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER));
		}
		
	}
}