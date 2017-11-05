/**
 * @date 2011-6-8 下午03:44:36
 * @author  宋立坤
 * 
 */  
package mortal.game.model
{
	import flash.utils.Dictionary;

	public class BossAreaInfo
	{
		public var id:int;				//区域id
		public var name:String;		//区域名字
		public var mapId:int;			//地图id
		public var px:int;				//像素坐标
		public var py:int;				//像素坐标
		public var boss:Array = [];	//boss[i] = BossRefreshInfo
		public var plans:Array = [];	//plans[i] = 刷怪方案id
		
		public function BossAreaInfo()
		{
		}
		
		/**
		 * 更新数据 
		 * @param refreshDic
		 * 
		 */
		public function updateData(refreshDic:Dictionary):void
		{
//			boss.splice(0);
//			
//			var index:int;
//			var length:int = plans.length;
//			var plan:int;
//			var bossInfo:BossRefreshInfo;
//			while(index < length)
//			{
//				plan = plans[index];
//				bossInfo = refreshDic[plan];
//				boss.push(bossInfo);
//				index++;
//			}
		}
	}
}