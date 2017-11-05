/**
 * 物品项
 * @date	2014-3-24 下午02:42:27
 * @author chenriji
 * 
 */

package mortal.game.view.common
{
	import com.mui.controls.GCellRenderer;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.item.BaseItem;
	
	public class ItemCellRenderer extends GCellRenderer
	{
		private var _baseItem:BaseItem;
		private var _itemData:ItemData;
		
		public function ItemCellRenderer()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_baseItem = UIFactory.baseItem(0, 0, 41, 41, this);
			_baseItem.isShowLock = true;
			_baseItem.isDragAble = false;
			_baseItem.mouseEnabled = true;
			_baseItem.mouseChildren = false;
			_baseItem.doubleClickEnabled = true;
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_baseItem.dispose(isReuse);
			_baseItem = null;
			_itemData = null;
		}
		
		public override function set data(arg0:Object):void
		{
			super.data = arg0;
			
			_itemData = arg0 as ItemData;
			if(_itemData)
			{
				_baseItem.itemData = _itemData;
			}
		}
		
		override public function set selected(arg0:Boolean):void
		{
			super.selected = arg0;
			if(arg0 && _itemData)
			{
				_baseItem.filters = [FilterConst.itemChooseFilter];
			}
			else
			{
				_baseItem.filters = [];
			}
		}
	}
}