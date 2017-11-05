/**
 * 2014-3-13
 * @author chenriji
 **/
package mortal.game.view.skill
{
	public class SkillHookType
	{
		public function SkillHookType()
		{
		}
		
		/**
		 * 挂机不释放 
		 */		
		public static const no:int = 0;
		/**
		 * 攻击技能 
		 */		
		public static const attack:int = 1;
		/**
		 * 生命 
		 */		
		public static const life:int = 2;
		/**
		 * 法力 
		 */		
		public static const mana:int = 3;
		/**
		 * 状态，buff 
		 */		
		public static const buff:int = 4;
	}
}