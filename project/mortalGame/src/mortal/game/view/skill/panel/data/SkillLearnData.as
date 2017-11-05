/**
 * 2014-1-16
 * @author chenriji
 **/
package mortal.game.view.skill.panel.data
{
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.skill.SkillInfo;

	public class SkillLearnData
	{
		public function SkillLearnData()
		{
		}
		
		/**
		 * 是否开启 
		 */		
		public var opened:Boolean;
		/**
		 * 当前技能信息 
		 */		
		public var info:SkillInfo;
		public var learned:Boolean;
		public var upgradable:Boolean;
//		public var needBook:ItemData;
//		public var runes:Array;
	}
}