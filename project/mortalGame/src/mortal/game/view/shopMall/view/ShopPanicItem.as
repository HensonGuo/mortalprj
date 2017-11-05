package mortal.game.view.shopMall.view
{
	import com.mui.core.GlobalClass;
	
	import mortal.common.display.BitmapDataConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.shopMall.data.ShopPanicData;
	
	public class ShopPanicItem extends BaseItem
	{
		private var _shopPanicData:ShopPanicData;
		
		public function ShopPanicItem()
		{
			super();

			
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			this.isDragAble = false;
			this.isDropAble = false;
		}
		
		public override function set bgName(value:String):void
		{
			if(_bgName == value)
			{
				return;
			}
			_bgName = value;
			if(value)
			{
				_bg.bitmapData = GlobalClass.getBitmapData(value);
				_bg.scale9Grid = ResourceConst.getRectangle(value);
			}
			else
			{
				_bg.bitmapData = GlobalClass.getBitmapData(BitmapDataConst.AlphaBMD);
				_bg.scale9Grid = ResourceConst.getRectangle(BitmapDataConst.AlphaBMD);
			}
		}
		
//		public function setBgStyle(bgName:String,paddingTop:int,paddingLeft:int):void
//		{
//			_paddingTop = paddingTop;
//			_paddingLeft = paddingLeft;
//			this.bgName = bgName;
//			
//			_bg.width = _width;
//			_bg.height = _height;
//			
//			if(_bitmap)
//			{
//				_bitmap.x = _bg.x  + _paddingLeft;
//				_bitmap.y = _bg.y  + _paddingTop;
//			}
//		}
		
		/**
		 * 获取商品详细信息 
		 */
		public function get shopPropData():ShopPanicData
		{
			return _shopPanicData;
		}
		
		/**
		 * 设置=商品信息
		 * @private
		 */
		public function set shopPropData(value:ShopPanicData):void
		{
			_shopPanicData = value;
			this.itemData = new ItemData(_shopPanicData.tShopPanic.itemCode);
			if(value)
			{
				this.source = itemData.itemInfo.url;
			}
			else
			{
				this._bitmap.bitmapData = null;
			}
		}
	}
}