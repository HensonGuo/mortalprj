/**
 * 2014-3-12
 * @author chenriji
 **/
package mortal.game.view.autoFight.data
{
	import mortal.game.view.skill.SkillInfo;

	public class AFSkillData
	{
		public function AFSkillData()
		{
		}
		
		public var isActive:Boolean = true;
		public var value:int;
		public var info:SkillInfo;
		public var isMainSkill:Boolean = false;
		public var titleName:String = "";
		
	}
}