/**
 * 2014-2-18
 * @author chenriji
 **/
package mortal.game.scene3D.ai.data
{
	import Message.Public.SPoint;
	
	import mortal.game.view.skill.SkillInfo;

	public class FollowFightAIData extends AIData
	{
		public function FollowFightAIData()
		{
		}
		
		public var skillInfo:SkillInfo;
		public var entitys:Array;
		public var point:SPoint;
		public var isSkillThenWalk:Boolean = false;
	}
}