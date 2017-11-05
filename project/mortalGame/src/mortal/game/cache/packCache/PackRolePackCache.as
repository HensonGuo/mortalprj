package mortal.game.cache.packCache
{
	import mortal.game.resource.info.item.ItemData;

	public class PackRolePackCache extends PackPosTypeCache
	{
		public function PackRolePackCache(posType:int)
		{
			super(posType);
		}
		
		/**
		 *通过装备类型找到该装备 
		 * @param Type
		 * @return 
		 * 
		 */		
		public function getEquipByType(Type:int):ItemData
		{
			var len:int = _allItems.length;
			for(var i:int ; i < len ; i++)
			{
				if(_allItems[i] && (_allItems[i] as ItemData).itemInfo.type == Type)
				{
					return _allItems[i] as ItemData;
				}
			}
			return null
		}
		
	}
}