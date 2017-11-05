/**
 * 2014-1-21
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.display.ScaleBitmap;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapShowItem;
	
	public class SmallMapRightTop extends GSprite
	{
		private var _titleBg:ScaleBitmap;
		private var _title0:GBitmap;
		private var _title1:GBitmap;
		private var _items:Array;
		
		public function SmallMapRightTop()
		{
			super();
		}
		
		public function updateItems(arr:Array):void
		{
			for(var i:int = 0; i < arr.length && i < _items.length; i++)
			{
				var item:SmallMapShowItem = _items[i] as SmallMapShowItem;
				item.updateData(arr[i]);
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_titleBg = UIFactory.bg(2, 2, 191, 26, this, ImagesConst.RegionTitleBg);
			_title0 = UIFactory.gBitmap(ImagesConst.MapPic_DTZXS, 10, 7, this);
			_title1 = UIFactory.gBitmap(ImagesConst.MapPic_XS, 142, 7, this);
			
			_items = [];
			for(var i:int = 0; i < 7; i++)
			{
				var item:SmallMapShowItem = new SmallMapShowItem();
				item.x = 6;
				item.y = 24 * i + 29;
				_items.push(item);
				this.addChild(item);
				super.pushUIToDisposeVec(item);
			}
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_titleBg.dispose(isReuse);
			_title0.dispose(isReuse);
			_title1.dispose(isReuse);
			
			_titleBg = null;
			_title0 = null;
			_title1 = null;
			_items = null;
		}
	}
}