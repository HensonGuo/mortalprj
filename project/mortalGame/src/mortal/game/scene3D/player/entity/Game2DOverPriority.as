/**
 * @heartspeak
 * 2014-1-22 
 */   	

package mortal.game.scene3D.player.entity
{
	/**
	 * 鼠标判断优先级，数字越大、优先级越高 
	 * @author heartspeak
	 * 
	 */	
	public class Game2DOverPriority
	{
		public static const NPC:int = 100;//NPC
		public static const Drop:int = 50;//掉落
		public static const Use:int = 40;//玩家
		public static const Pet:int = 30;//宠物
		public static const Monster:int = 20;//怪物
		public static const Pass:int = 10;//传送阵
		public static const Jump:int = 10;//跳跃点
		
		public function Game2DOverPriority()
		{
		}
	}
}