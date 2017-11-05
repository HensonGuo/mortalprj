/**
 * 2014-1-22
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.display.ScaleBitmap;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapLeftTipsItem;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapShowItem;
	
	public class SmallMapLeftTips extends GSprite
	{
		private var _items:Array;
		private var _bg:ScaleBitmap;
		
		public function SmallMapLeftTips()
		{
			super();
		}
		
		public function updateItems(arr:Array):void
		{
			for(var i:int = 0; i < arr.length && i < _items.length; i++)
			{
				var item:SmallMapLeftTipsItem = _items[i] as SmallMapLeftTipsItem;
				item.updateData(arr[i]);
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.bg(-2, -6, 122, 350, this);
			_items = [];
			for(var i:int = 0; i < 11; i++)
			{
				var item:SmallMapLeftTipsItem = new SmallMapLeftTipsItem();
				item.x = 6;
				item.y = 26 * i;
				_items.push(item);
				this.addChild(item);
				super.pushUIToDisposeVec(item);
			}
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bg.dispose(isReuse);
			
			_bg = null;
			_items = null;
		}
	}
}