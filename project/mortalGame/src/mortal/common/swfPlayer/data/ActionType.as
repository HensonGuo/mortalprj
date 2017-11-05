/**
 * @date	2011-4-7 上午11:19:53
 * @author  jianglang
 * 
 */	

package mortal.common.swfPlayer.data
{
	public class ActionType
	{
		private static var _acitonMap:Object = {"1":"攻击","2":"站立","3":"走动","4":"受伤","5":"死亡","6":"休息","7":"坐骑站立","8":"坐骑走动"};
		
		public static const Attack:int = 1;	// 攻击
		public static const Stand:int = 2;  	//站立
		public static const Walking:int = 3;  // 走动
		
		
		public static const Injury:int = 4;	// 受伤
		public static const Death:int = 5; 	// 死亡
		public static const Rest:int = 6;  	// 休息
		
		public static const MountStand:int = 7;  	// 坐骑站立
		
		public static const MountWalk:int = 8;  	// 坐骑走动
		
		public static const Stall:int= 9;//摆摊
		
		public static const StandMountStand:int = 10;  	// 坐骑站立
		
		public static const StandMountWalk:int = 11;  	// 坐骑走动
		
		public static const RestMountStand:int = 12; //打坐坐骑
		public static const RestMountWalk:int = 13; //打坐坐骑
		
		public static const flyStand:int = 14; //飞行站立
		public static const flyWalk:int = 15; //飞行走动
		
		public static const flyMountStand:int = 16; //飞行坐骑
		public static const flyMountWalk:int = 17; //飞行坐骑
		
		public static const SunBath:int = 18; //阳光沐浴
		
		public static const DefaultAction:int = 2;
		
		
		public function ActionType()
		{
			
		}
		
		public static function getAction( action:int ):String
		{
			return _acitonMap[action];
		}
	}
}
