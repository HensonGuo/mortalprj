/**
 * 继承BaseItem，增加背景图PackItemBg
 * 
 * @date 2012-3-14 上午11:06:18
 * @author cjx
 */
package mortal.game.view.common.item
{
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	
	import mortal.component.gconst.ResourceConst;
	
	public class BaseItemNormal extends BaseItem
	{
		
		private var _itemBg:ScaleBitmap;
		
		public function BaseItemNormal()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_itemBg = ResourceConst.getScaleBitmap("PackItemBg");
			_itemBg.x = -3;
			_itemBg.y = -3;
			this.addChild(_itemBg);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_itemBg.dispose(isReuse);
		}
		
		override protected function resetBitmapSize():void
		{
			super.resetBitmapSize();
			
			if(_itemBg)
			{
				_itemBg.width = _width + 6;
				_itemBg.height = _height + 6;
			}
		}
	}
}