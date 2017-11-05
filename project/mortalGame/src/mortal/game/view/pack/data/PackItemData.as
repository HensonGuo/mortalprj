package mortal.game.view.pack.data
{
	import mortal.game.resource.info.item.ItemData;
	
	/**
	 * 增加3种物品状态(锁定格子、可开启格子、正在倒计时格子) 
	 * @author Administrator
	 * 
	 */	
	public class PackItemData extends ItemData
	{
		/**锁定格子(可用元宝购买)**/	
		public static var lockItemData:ItemData = new ItemData(null);   
		
		/**可开启格子**/	
		public static var unLockItemData:ItemData = new ItemData(null); 
		
		/**正在倒计时格子 **/		
		public static var unLockingItemData:ItemData = new ItemData(null);    
		
		/**锁定格子(不可用元宝购买)**/
		public static var lockingItemData:ItemData = new ItemData(null);
		
		public function PackItemData(data:*)
		{
			super(data);
		}
	}
}