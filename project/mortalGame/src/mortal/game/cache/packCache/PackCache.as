package mortal.game.cache.packCache
{
	import Message.Public.EPlayerItemPosType;
	import Message.Public.SPlayerItem;
	
	import mortal.game.resource.info.item.ItemData;
	

	public class PackCache
	{
		private const Type_BackPack:int = EPlayerItemPosType._EPlayerItemPosTypeBag; //背包
		private const Type_WareHouse:int = EPlayerItemPosType._EPlayerItemPosTypeWarehouse; //仓库
		private const Type_Role:int = EPlayerItemPosType._EPlayerItemPosTypeRole;  //角色身上的装备物品
		private const Type_Task:int = EPlayerItemPosType._EPlayerItemPosTypeTask; //背包面板中的任务物品
		private const Type_Embed:int = EPlayerItemPosType._EPlayerItemPosTypeEmbed; //镶嵌包中的物品
//		public static const Type_PetWareHouseExtend:int = EPlayerItemPosType._EPlayerItemPosTypePetWarehouse;//宠物扩展仓库
		
		/**
		 * 背包信息cache
		 */
		public var backPackCache:BackPackCache = new BackPackCache(Type_BackPack);
		
		/**
		 * 角色身上装备的物品 
		 */		
		public var packRolePackCache:PackRolePackCache = new PackRolePackCache(Type_Role);
		
		/**
		 * 镶嵌包中的物品
		 */		
		public var embedPackCache:EmbedPackCache = new EmbedPackCache(Type_Embed);
		
		/**
		 * 根据窗口的posType获取相应的背包缓存
		 */
		public function getPackChacheByPosType(posType:int):PackPosTypeCache
		{
			switch (posType)
			{
				case Type_BackPack:
					return backPackCache;
				case Type_Role:
					return packRolePackCache;
				case Type_Embed :
					return embedPackCache;
				default:
					return null;
			}
		}
		
		/**
		 * 根据Uid和posType返回物品 
		 * @param uid
		 * @param posType
		 * @return 
		 * 
		 */
		public function getItemDataByUid(uid:String,posType:int=0):ItemData
		{
			var posTypeCache:PackPosTypeCache = getPackChacheByPosType(posType);
			return posTypeCache.getItemDataByUid(uid);
		}
		
		/**
		 * 更新item的splayerItem 
		 * @param sitem
		 * @return 
		 * 
		 */
		public function updateItemByPlayerItem(sitem:SPlayerItem):ItemData
		{
			var posTypeCache:PackPosTypeCache = getPackChacheByPosType(sitem.posType);
			return posTypeCache.updateSPlayerItem(sitem);
		}


	}
}
