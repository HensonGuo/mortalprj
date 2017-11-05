/**
 * @date	2011-3-15 下午06:43:53
 * @author  jianglang
 * 
 */	

package mortal.game.rules
{
	import Message.Public.EEntityType;

	public class EntityType
	{
		public static const Player : int = EEntityType._EEntityTypePlayer;
		public static const Boss : int = EEntityType._EEntityTypeBoss;
//		public static const LifeBoss : int = EEntityType._EEntityTypeLifeBoss;
//		public static const LifeBossEx : int = EEntityType._EEntityTypeLifeBossEx;//可选中的生命怪
		public static const Pet : int = EEntityType._EEntityTypePet;
		public static const DropItem : int = EEntityType._EEntityTypeDrop;  //掉落实体
		public static const Transport : int = EEntityType._EEntityTypeEscort;//护送怪
//		public static const Escort : int = EEntityType._EEntityTypeEscort;
//		public static const NpcShop:int = EEntityType._EEntityTypeNpcShop; //掉落商店
		
		public static const NPC:int = 10001;
		public static const Pass:int = 10002;//传送阵
		public static const Scene:int = 10003;//场景
		public static const Point:int = 10004;//点
		
//		public static const SimpleDropItem : int = EEntityType._EEntityTypeDefenseCopyItem;  //单个掉落实体
		
		public function EntityType()
		{
			
		}
	}
}
