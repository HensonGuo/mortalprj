/**
 * 2014-3-11
 * @author chenriji
 **/  
package mortal.game.rules
{
	import Message.Public.EBossCategory;
	import Message.Public.EBossType;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;

	public class BossRule
	{
		public function BossRule()
		{
		}
	
		/**
		 * 是否 精英怪 boss怪 稀有怪 
		 * @param showType
		 * @return 
		 * 
		 */
		public static function isBossBoss(category:int):Boolean
		{
			return (category == EBossCategory._EBossCategoryBoss 
				|| category == EBossCategory._EBossCategoryElite 
				|| category == EBossCategory._EBossCategoryRare);
		}
		
		/**
		 * 是否普通怪 
		 * @param type
		 * @return 
		 * 
		 */
		public static function isNormalBoss(category:int):Boolean
		{
			return category == EBossCategory._EBossCategoryNormal;
		}
		
		/**
		 * 是否战斗怪 
		 * @return 
		 * 
		 */
		public static function isFightBoss(bossType:int):Boolean
		{
			return bossType == EBossType._EBossTypeNomarl 
				|| bossType == EBossType._EBossTypeCollect
				|| bossType == EBossType._EBossTypePassageFight
				|| bossType == EBossType._EBossTypeBarrierFight
				|| bossType == EBossType._EBossTypeEscortFight;
		}
		
		/**
		 * 是否采集怪 
		 * @param bossType
		 * @return 
		 * 
		 */
		public static function isCollectBoss(bossType:int):Boolean
		{
			return bossType == EBossType._EBossTypeCollect;
		}
		
		
		/**
		 * 是否答题怪 
		 * @param bossType
		 * @return 
		 * 
		 */		
		public static function isQuestionBoss(bossType:int):Boolean
		{
			return bossType == EBossType._EBossTypeQuestion;
		}
		
		/**
		 * 是否种植怪
		 * @param bossType
		 * @return 
		 * 
		 */		
		public static function isPlantBoss(bossType:int):Boolean
		{
			return bossType == EBossType._EBossTypeFlower;
		}
		
		/**
		 * 是否机械怪 
		 * @param bossType
		 * @return 
		 * 
		 */		
		public static function isMechineBoss(bossType:int):Boolean
		{
			return bossType == EBossType._EBossTypeMachine;
		}
		
		/**
		 * 是否防守塔怪 
		 * @param bossType
		 * @return 
		 * 
		 */		
		public static function isDefenceTower(bossType:int):Boolean
		{
			return bossType == EBossType._EBossTypeMachine;
		}
		
		/**
		 * 是否某种类型怪 
		 * @param entity
		 * @param bossType
		 * @return 
		 * 
		 */
		public static function isTypeBossByEntity(entity:IEntity,bossType:int):Boolean
		{
			if(entity && (entity is MonsterPlayer) && !entity.isDead)
			{
				var boss:MonsterPlayer = entity as MonsterPlayer;
				if(boss && boss._bossInfo && boss.tboss)
				{
					return boss.type == bossType;
				}
			}
			return false;
		}
	}
}