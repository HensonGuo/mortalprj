/**
 * 2014-2-11
 * @author chenriji
 **/
package mortal.game.view.skill.panel.data
{
	public class SkillLearnArrowData
	{
		public function SkillLearnArrowData(xx:int, yy:int, poss:int, urll:String="SkillPanel_right")
		{
			x = xx;
			y = yy;
			pos = poss;
			url = urll;
		}
		
		public var x:int;
		public var y:int;
		public var pos:int = 1;
		public var url:String = "SkillPanel_right";
		public var isActive:Boolean=false;
	}
}