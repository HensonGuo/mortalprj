/**
 * @date	2011-2-28 下午07:29:19
 * @author  jianglang
 * 游戏配置全局类
 */	

package mortal.component.gconst
{
	import extend.language.Language;
	
	import flash.display.BitmapData;

	public class GameConst
	{
			
		public static var somersaultCd:int;//翻滚Cd
		public static var somersaultDistance:int;//翻滚距离
		public static var PetSummonSkill:int;//出战宠物技能
		public static var PlayerMaxLevel:int;//玩家最高等级
		public static var MarketBroadcastCost:int;//市场广播消费
		public static var MarketMinFee:int;//市场最低手续费
		
		public static const Num_ZhongWen:Array = Language.getString(20159).split(",");
		public static const NpcOutDistance:int = 300;
		public static const NpcInDistance:int = 120;
		public static const RoundFightDistance:int = 500;
//		public static const NullBitMapData:BitmapData = new BitmapData(0,0);
		
		public function GameConst()
		{
		}
	}
}
