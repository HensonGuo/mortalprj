/**
 * 2014-2-17
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import com.gengine.utils.SWFProfiler;
	import com.mui.controls.GSprite;
	
	import mortal.common.DisplayUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapWorldRegionData;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapWorldRegionItem;
	
	public class SmallMapWorldRegion extends GSprite
	{
		private var _items:Array;
		private var _datas:Array;
		
		public function SmallMapWorldRegion()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_items = [];
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_items = [];
		}
		
		public function updateAll(datas:Array):void
		{
			if(_datas == datas)
			{
				return;
			}
			_datas = datas;
			for(var i:int = 0; i < datas.length; i++)
			{
				var data:SmallMapWorldRegionData = datas[i];
				var item:SmallMapWorldRegionItem = getItem(i);
				item.update(data);
				if(item.parent == null)
				{
					this.addChild(item);
				}
			}
			for(;i < _items.length; i++)
			{
				DisplayUtil.removeMe(_items[i]);
			}
		}
		
		private function getItem(index:int):SmallMapWorldRegionItem
		{
			var res:SmallMapWorldRegionItem = _items[index];
			if(res == null)
			{
				res = new SmallMapWorldRegionItem();
				pushUIToDisposeVec(res);
				_items[index] = res;
				this.addChild(res);
			}
			return res;
		}
	}
}