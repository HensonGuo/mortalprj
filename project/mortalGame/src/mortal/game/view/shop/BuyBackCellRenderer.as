package mortal.game.view.shop
{
	import Message.Game.SBuyBackItem;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.mvc.core.Dispatcher;
	
	public class BuyBackCellRenderer extends GCellRenderer
	{
		private var _buyBackIem:BaseItem;
		
		private var _sBuyBackItem:SBuyBackItem;
		
		public function BuyBackCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_buyBackIem = UICompomentPool.getUICompoment(BaseItem);
			_buyBackIem.createDisposedChildren();
			_buyBackIem.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,3,3);
			_buyBackIem.isDragAble = false;
			_buyBackIem.isDropAble = false;
			_buyBackIem.isShowLock = true;
			_buyBackIem.x = 5;
			_buyBackIem.y = 5;
			this.addChild(_buyBackIem);
			_buyBackIem.configEventListener(MouseEvent.CLICK,buyBack);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_buyBackIem.dispose(isReuse);
			
			_buyBackIem = null;
			super.disposeImpl(isReuse);
		}
		
		override public function set data(arg0:Object):void
		{
			if(arg0.data == null)
			{
				_sBuyBackItem = null;
				_buyBackIem.itemData = null;
				return;
			}
			_sBuyBackItem = arg0.data as SBuyBackItem;
			_buyBackIem.itemData = new ItemData(_sBuyBackItem.itemCode);
			_buyBackIem.amount = _sBuyBackItem.amount;
			if(ItemsUtil.isBind(_buyBackIem.itemData) || _sBuyBackItem.bind == 1)
			{
				_buyBackIem.isBind = true;
			}
			else
			{
				_buyBackIem.isBind = false;
			}
			
			_buyBackIem.toolTipData = _sBuyBackItem;
		
		}
		
		private function buyBack(e:MouseEvent):void
		{
			if(_sBuyBackItem != null)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.BuyBack,_sBuyBackItem.uid));
			}
		}
	}
}