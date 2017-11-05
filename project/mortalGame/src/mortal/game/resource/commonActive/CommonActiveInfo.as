/**
 * 公共活动配置
 * @date	2013-1-12 下午08:04:38
 * @author shiyong
 * 
 */
package mortal.game.resource.commonActive
{
	import mortal.game.resource.info.item.ItemData;

	public class CommonActiveInfo
	{
		public var id:int;//活动编号
		public var title:String;//活动标题
		public var category:int;//消耗道具大类
		public var type:int;//消耗道具小类
		public var rewards:String;//活动物品奖励编号串
		public var itemcodes:String;//道具code串
		
		public var tip1:String;//提示文字
		public var tip2:String;//提示文字
		public var tip3:String;//提示文字
		public var tip4:String;//提示文字
		public var tip5:String;//提示文字
		public var tip6:String;//提示文字
		public var tip7:String;//提示文字
		public var tip8:String;//提示文字
		public var tip9:String;//提示文字
		
		
		/**
		 *奖励ItemData数组 
		 */		
		public var rewardItemDatas:Array;
		public var itemCodeArray:Array;
		
		public function CommonActiveInfo()
		{
		}
		
		/**
		 *解析 
		 * 
		 */		
		public function initParse():void
		{
			rewardItemDatas = new Array();
			var itemCodes:Array = rewards.split("#");
			var itemCode:int;
			for (var i:int = 0; i < itemCodes.length; i++) 
			{
				itemCode = int(itemCodes[i]);
				rewardItemDatas.push(new ItemData(itemCode));
			}
			
			//解析道具
			itemCodeArray = new Array();
			itemCodes = itemcodes.split("#");
			for (var j:int = 0; j < itemCodes.length; j++) 
			{
				itemCode = int(itemCodes[j]);
				itemCodeArray.push(itemCode);
			}
		}
	}
}