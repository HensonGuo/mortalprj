package mortal.game.scene3D.ai
{
	public class AIType
	{
		////////////////////////////////////////////    AI组合的名称
		/**
		 * 移动到某一点，并且使用技能 
		 */		
		public static const Move_Fight:int = 0;
		/**
		 * 跟随 
		 */		
		public static const Follow:int = 1;
		/**
		 * 跟随某个实体， 走到范围内使用技能 
		 */		
		public static const Follow_fight:int = 2;
		/**
		 * 点击NPC， 参数：npcId:int 
		 */		
		public static const ClickNpc:int = 3;
		/**
		 * 小飞鞋, 参数：SPassTo，  传入mapId， toPoint的x、y就行了，  单位为像素点
		 */		
		public static const FlyBoot:int = 4;
		
		/**
		 * 传送阵，地图切图点 
		 */		
		public static const GoToAndPass:int = 5;
		/**
		 * 跳跃, 参数：JumpPoint的Point， 像素为单位
		 */		
		public static const GoToAndJump:int = 6;
		/**
		 * 从地图A到地图B的某个点 , 参数fromMapId:int, toMapId:int, targetPoint:Point单位为像素
		 */		
		public static const GoToOtherMap:int = 7;
		/**
		 * 自动挂机（普通挂机或者范围挂机）, 参数：设置range则可， -1表示普通挂机， 大于0表示范围挂机 
		 */		
		public static const AutoFight:int = 8;
		/**
		 * 采集AI， 1.先移动到位置， 2.采集， 参数：MonsterPlayer 
		 */		
		public static const Collect:int = 9;
		
		///////////////////////////////////////////// 细分每一种AI的名称
		
		public function AIType()
		{
		}
	}
}