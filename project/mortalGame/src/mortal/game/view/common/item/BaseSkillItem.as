/**
 * @date 2013-8-1 下午12:07:59
 * @author cjx
 */
package mortal.game.view.common.item
{
	import Message.Db.Tables.TSkill;
	
	import mortal.game.view.skill.SkillInfo;

	public class BaseSkillItem extends BaseItemNormal
	{
		
		private var _skillInfo:SkillInfo;
		private var _skill:TSkill;
		
		public function BaseSkillItem()
		{
			super();
		}
		
		public function get skillInfo():SkillInfo
		{
			return _skillInfo;
		}
		
		public function set skillInfo(value:SkillInfo):void
		{
			_skillInfo = value;
			if(_skillInfo)
			{
				skill = _skillInfo.tSkill;
			}
			else
			{
				skill = null;
			}
		}
		
		public function get skill():TSkill
		{
			return _skill;
		}
		
		public function set skill(value:TSkill):void
		{
			_skill = value;
			if(_skillInfo)
			{
				_skillInfo.tSkill = _skill;
			}
			else
			{
				_skillInfo = new SkillInfo();
				_skillInfo.tSkill = _skill;
			}
			if(_skill)
			{
				source = _skill.skillIcon.toString()+".jpg";
			}
			else
			{
				source = null;
			}
		}
		
		override public function get toolTipData():*
		{
			if(_skillInfo)
			{
				return _skillInfo.getShortToolTips();
			}
			return "";
		}
		
	}
}