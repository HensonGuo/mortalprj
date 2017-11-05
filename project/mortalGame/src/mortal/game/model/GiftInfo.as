/**
 * @date 2011-6-2 下午08:58:23
 * @author  宋立坤
 * 
 */  
package mortal.game.model
{
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;

	public class GiftInfo
	{
		public var code:int;			//编号
		public var name:String;		//名字
		public var itemCodes:Array;	//奖励物品列表
		public var star:int;			//星级
		public var url:String = "";	//路径
		private var _items:Array;		//礼包中包含的物品
		private var _des:String;		//描述
		
		public function GiftInfo()
		{
			itemCodes = [];
			_items = [];
		}
		
		/**
		 * 礼包中包含的物品 
		 * @param str
		 * 
		 */
		public function setItems(str:String):void
		{
			_items.length = 0;
			
			var itemsList:Array = str.split("#");
			var index:int;
			var length:int = itemsList.length;
			var item:ItemData;
			while(index < length)
			{
				var itemList:Array = String(itemsList[index]).split(",");
				if(itemList.length > 0 && int(itemList[0]) != 0)
				{
					item = new ItemData(int(itemList[0]));
					item.itemAmount = itemList[1];
					_items.push(item);
				}
				index++;
			}
		}
		
		public function get items():Array
		{
			return _items;
		}
		
		public function set des(value:String):void
		{
			while(value.indexOf("￥") != -1)
			{
				value = value.replace("￥","\"");
			}
			_des = value;
		}
		
		public function get des():String
		{
			return _des;
		}
			
	}
}