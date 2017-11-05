package mortal.game.view.business
{
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class TradeListRenderer extends GCellRenderer
	{
		protected var _item:BaseItem;
		protected var _bg:ScaleBitmap;
		protected var _txtName:GTextFiled;
		
		public function TradeListRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.bg(2,2,140,48,this,ImagesConst.InputDisablBg);
			_item = UIFactory.getUICompoment(BaseItem,6,6,this);
			_item.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,2,3);
			_item.isDragAble = false;
			_txtName = UIFactory.gTextField("这是橙武",50,18,92,20,this);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_bg.dispose(isReuse);
			_item.dispose(isReuse);
			_txtName.dispose(isReuse);
			
			_bg = null;
			_item = null;
			_txtName = null;
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
			
			if(arg0 is TradeItemVo)
			{
				var tradeItemVo:TradeItemVo = arg0 as TradeItemVo;
				this._item.itemData = tradeItemVo.itemData;
				this._item.amount = tradeItemVo.amount;
				this._txtName.htmlText = ItemsUtil.getItemName(tradeItemVo.itemData);
			}
			else
			{
				this._item.itemData = null;
				this._txtName.htmlText = "";
			}
		}
	}
}