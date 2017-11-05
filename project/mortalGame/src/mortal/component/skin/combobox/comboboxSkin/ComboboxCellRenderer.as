package mortal.component.skin.combobox.comboboxSkin
{
	import com.mui.controls.GCellRenderer;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	
	public class ComboboxCellRenderer extends GCellRenderer
	{
		private var _bg:ScaleBitmap;
		private var _across:ScaleBitmap;
		
		public function ComboboxCellRenderer()
		{
			super();
			init();
		}
		
		public function init():void
		{
			_across = ResourceConst.getScaleBitmap(ImagesConst.Menu_overSkin);
			
			var emptyBmp:Bitmap = new Bitmap()
			this.setStyle("downSkin",emptyBmp);
			this.setStyle("overSkin",_across);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",emptyBmp);
			this.setStyle("selectedOverSkin",_across);
			this.setStyle("selectedUpSkin",emptyBmp);
		}
	}
}