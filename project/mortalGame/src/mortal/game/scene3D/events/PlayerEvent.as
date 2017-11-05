package mortal.game.scene3D.events
{
	import flash.events.Event;
	
	import mortal.game.scene3D.player.entity.IEntity;

	public class PlayerEvent extends Event
	{
		/**
		 * 开始行走
		 * */
		public static const WALK_START:String="walk_Start";
		/**
		 * 行走结束
		 * */
		public static const WALK_END:String = "walk_end";
		/**
		 * 正在行走
		 * */
		public static const ON_WALK:String  = "on_walk";
		
		/**
		 * 开始走一个格子
		 */		
		public static const GIRD_WALK_START:String = "gird_walk_start";
		/**
		 * 走完一个格子
		 */		
		public static const GIRD_WALK_END:String = "gird_walk_end";
		
		/**
		 * 攻击帧
		 */		
		public static const PLAYER_FIRE:String = "player_fire";
		
//		/**
//		 * 攻击 的 攻击动作
//		 */		
//		public static const PLAYER_FIRE_START:String = "player_fire_start";
		/**
		 * 攻击完成
		 */		
		public static const PLAYER_FIRE_COMPLETE:String = "player_fire_complete";
		/**
		 * 施法持续施法动作开始
		 */		
		public static const PLAYER_LEADING:String = "PLAYER_LEADING";
		/**
		 * 施法持续施法动作结束
		 */		
		public static const PLAYER_LEADING_END:String = "PLAYER_LEADING_END";
		/**
		 * 实体死亡 
		 */		
		public static const ENTITY_DEAD:String = "entityDead";
		
		/**
		 * 实体复活
		 */		
		public static const ENTITY_Relived:String = "entityRelived";
		
		/**
		 * 间隔攻击的时间已经到达 
		 */		
		public static const ATTACK_GAP_TIMEOUT:String = "attactGapTimeOut";
		
		/**
		 * 地形阻挡不可攻击 
		 */
		public static const ObstructNotFight:String = "地形阻挡不可以攻击";
		
		/**
		 * 玩家被选择 
		 */		
		public static const SELECTED:String = "selected";
		
		/**
		 * 玩家被选择 
		 */		
		public static const UPDATEINFO:String = "updateinfo";
		
		/**
		 * 升级 
		 */
		public static const RoleLevelUpdate:String = "人物等级更新";
		/**
		 * 双修
		 */
		public static const DoubleRest:String = "doubleRest";
		
		public static const ServerPoint:String = "服务器坐标点";
		
		
		public static const RoleTurned:String = "角色变身";
		
		public static const Enter_Fight:String = "进入战斗";

		public static const Exit_Fight:String = "结束战斗";
		
		public static const UpdateEquip:String = "UpdateEquip";
		
		public static const FlyChange:String = "FlyChange";
		
		public static const SunBathChange:String = "结束阳光沐浴";
		
		public static const MarrySkillTurnChange:String = "仙侣技能幻化";
		
		public static const StopRest:String = "停止打坐";
		
		public static const PlayerManaUpdate:String = "魔法值更新";
		
		public static const JumpPointEnd:String = "JumpPointEnd"; // 跳跃点跳跃完毕
		
		public static const SkillPointEnd:String = "SkillPointEnd"; // 位置技能释放完毕
		
		/**
		 * 人物 
		 */		
		private var _player:IEntity;
		
		public var data:Object;
		
		
		public function PlayerEvent( type:String,entity:IEntity,paramData:Object = null)
		{
			_player = entity;
			data = paramData;
			super(type,true,true);
		}
		
		/**
		 * 人物 
		 * @return 
		 * 
		 */		
		public function get player():IEntity
		{
			return _player;
		}

	}
}