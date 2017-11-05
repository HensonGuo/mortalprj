/**
 * @date 2013-2-28 上午11:29:42
 * @author cjx
 */
package mortal.game.view.common.item
{
	import flash.display.Sprite;
	
	import mortal.common.DisplayUtil;
	import mortal.game.resource.info.item.ItemData;
	
	public class ItemsBox extends Sprite
	{
		
		public var hGat:int = 10;
		public var vGat:int = 10;
		public var itemWidth:int = 32;
		public var itemHeight:int = 32;
		
		public function ItemsBox()
		{
			super();
		}
		
		public function setItems(items:Array,maxCol:int = -1):void
		{
			clear();
			
			var item:BaseItemNormal;
			for(var i:int=0; i<items.length; i++)
			{
				if(items[i] == "" || items[i] == 0)
				{
					continue;
				}
				
				item = new BaseItemNormal();
				item.setSize(itemWidth,itemHeight);
				item.itemData = items[i] is ItemData ? items[i] : new ItemData(parseInt(items[i]));
				
				if(maxCol > 0)
				{
					item.x = (i%maxCol)*(itemWidth+hGat);
					item.y = Math.floor(i/maxCol)*(itemHeight+vGat);
				}
				else
				{
					item.x = i*(itemWidth+hGat);
					item.y = 0;
				}
				
				_outHeight = item.y + itemHeight + vGat;
				this.addChild(item);
			}
		}
		
		/**
		 * 根据index获得物品名称 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getItemNameByIndex(index:int):String
		{
			if(this.numChildren > index)
			{
				var item:BaseItemNormal = this.getChildAt(index) as BaseItemNormal;
				if(item.itemData)
				{
					return item.itemData.name;
				}
			}
			return "";
		}
		
		private var _outHeight:int;
		override public function get height():Number
		{
			return _outHeight;
		}
		
		public function clear():void
		{
			DisplayUtil.removeAllChild(this);
		}
		
	}
}