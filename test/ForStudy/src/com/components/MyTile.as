package com.components
{
	import com.awt.containers.Tile;
	import com.awt.core.UIComponent;
	import com.modules.ShopItem;
	
	import flash.display.Sprite;
	
	public class MyTile extends Tile
	{
		private var _tileNumber:int;
		
		public function MyTile()
		{
			super();
		}
		
		public function set tileNumber(i:int):void
		{
			_tileNumber = i;
			addToUI(i);
		}
		
		private function addToUI(i:int):void
		{
			var currentCol:int = -1;
			for(var n:int=0;n<i;n++)
			{
				if(n%3 == 0)
				{
					currentCol++;
				}
				var shopItem:ShopItem = new ShopItem();
				shopItem.x = (n%3)*182;
				shopItem.y = currentCol*84;
				this.addChild(shopItem);
			}
		}
	}
}