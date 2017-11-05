package mortal.game.view.common.item
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;

	public class FriendSkinCellRenderer extends NoSkinCellRenderer
	{
		public function FriendSkinCellRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.setStyle("downSkin",GlobalClass.getBitmap("Friend_over"));
			this.setStyle("overSkin",GlobalClass.getBitmap("Friend_over"));
			this.setStyle("upSkin",new Bitmap());
			this.setStyle("selectedDownSkin",GlobalClass.getBitmap("Friend_over"));
			this.setStyle("selectedOverSkin",GlobalClass.getBitmap("Friend_over"));
			this.setStyle("selectedUpSkin",GlobalClass.getBitmap("Friend_over"));
		}
	}
}