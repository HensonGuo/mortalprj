/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.resource.info.item
{
	import Message.Public.SPlayerItem;
	
	import mortal.game.resource.ItemConfig;
	

	public class ItemData
	{
		private var _serverData:SPlayerItem = new SPlayerItem();
		
		private var _extInfo:ItemExInfo;
		
		private var _itemInfo:ItemInfo;
	
		
		
		/**
		 * 构建函数 
		 * @param data 类型可以是SPlayerItem或者int(物品的code)
		 * 
		 */		
		public function ItemData(data:*)
		{
			if(data is SPlayerItem)
			{
				this.data = data;
			}
			else if(data is int)
			{
				var splayerItem:SPlayerItem = new SPlayerItem();
				splayerItem.itemCode = data;
				this.data = splayerItem;
			}
		}
		
		/**
		 * 配置数据 (客户端数据)
		 */
		public function get itemInfo():ItemInfo
		{
			return _itemInfo;
		}

		/**
		 * 扩展数据（从_data.jsStr中json解析来） 
		 */
		public function get extInfo():ItemExInfo
		{
			return _extInfo;
		}

		/**
		 * @private
		 */
		public function set extInfo(value:ItemExInfo):void
		{
			_extInfo = value;
		}

		/**
		 * 服务器数据 
		 */
		public function get serverData():SPlayerItem
		{
			return _serverData;
		}

		/**
		 * @private
		 */
		public function set serverData(value:SPlayerItem):void
		{
			_serverData = value;
		}

		public function set data(value:SPlayerItem):void
		{
			// 服务器数据
			_serverData = value;
			// 配置数据
			_itemInfo = ItemConfig.instance.getConfig(value.itemCode);
			// 扩展数据
			if(_serverData.jsStr != null && _serverData.jsStr != "")
			{
				var obj:Object = JSON.parse(value.jsStr);
				if(obj)
				{
					if(_extInfo)
					{
						_extInfo.clear();
					}
					else
					{
						_extInfo = new ItemExInfo();
					}
					_extInfo.putObject(obj);
				}
				else
				{
					_extInfo = null;
				}
			}
		}
		
		public function get itemAmount():int
		{
			if(_serverData)
			{
				return _serverData.itemAmount;
			}
			else
			{
				return -1;
			}
		}
		
		public function set itemAmount(amount:int):void
		{
			_serverData.itemAmount = amount;
		}
		
		public function get name():String
		{
			return itemInfo.name;
		}
		
		public function get uid():String
		{
			return _serverData.uid;
		}
		
		public function get itemCode():int
		{
			return itemInfo.code;
		}
		
		public function get posType():int
		{
			return _serverData.posType;
		}
	}
}