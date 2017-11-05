package mortal.game.cache.packCache
{
	import mortal.game.resource.info.item.ItemData;

	/**
	 * @date   2014-4-3 下午4:52:39
	 * @author dengwj
	 */	 
	public class EmbedPackCache extends PackPosTypeCache
	{
		public function EmbedPackCache(posType:int)
		{
			super(posType);
		}
		
		/**
		 * 根据UID获取对应宝石 
		 * @param uid
		 * 
		 */		
		public function getGemByUid(uid:String):ItemData
		{
			return this.getItemDataByUid(uid);
		}
	}
}