package mortal.game.view.pack
{
	import com.mui.controls.GCellRenderer;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.listClasses.ListData;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.item.ItemStyleConst;
	
	public class PackCellRenderer extends GCellRenderer
	{
		private var _packItem:PackItem;
		
		public function PackCellRenderer()
		{
			super();
		
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_packItem = UICompomentPool.getUICompoment(PackItem);
			_packItem.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg2,2,2);
			this.addChild(_packItem);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_packItem.dispose(isReuse);
			
			_packItem = null;
			
			super.disposeImpl(isReuse);
		}
		
		override public function set data(arg0:Object):void
		{
			_packItem.data = arg0;
		}
		
		override public function set listData(arg0:ListData):void
		{
			super.listData = arg0;
			_packItem.pos = listData.index + 1;
		}
	}
}