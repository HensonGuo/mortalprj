package mortal.game.view.market.sale
{
	import com.mui.controls.GCellRenderer;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MktBagItemRenderer extends GCellRenderer
	{
		private var _item:BaseItem;
		public function MktBagItemRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_item = UIFactory.getUICompoment(BaseItem,0,0,this);
			_item.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,2,3);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_item.itemData = null;
			
			_item.dispose(isReuse);
			
			_item = null;
		}
		
		override public function get data():Object
		{
			// TODO Auto Generated method stub
			return super.data;
		}
		
		override public function set data(arg0:Object):void
		{
			// TODO Auto Generated method stub
			super.data = arg0;
			
			
			if(arg0 == null)
			{
				this._item.itemData = null;
				return;
			}
			
			if(arg0 is ItemData)
			{
				this._item.itemData = arg0 as ItemData;
			}
			else if(arg0 is ItemInfo)
			{
				this._item.itemCode = arg0.code;
			}
			else
			{
				this._item.itemData = null;
			}
		}
		
		
		
	}
}