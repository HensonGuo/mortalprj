/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.view.skill
{
	import Message.DB.Tables.TSkill;
	import Message.Public.ESkillRangeType;
	import Message.Public.ESkillTargetSelect;
	import Message.Public.ESkillTargetType;
	import Message.Public.ESkillTriggType;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.tableConfig.SkillConfig;

	public class SkillUtil
	{
		public function SkillUtil()
		{
		}
		
		public static function getCarrer(skill:TSkill):int
		{
			switch(skill.career)
			{
				case 1:
					break;
			}
			return 0;
		}
		
		public static function isNextSkillByTskill(next:TSkill, pre:TSkill):Boolean
		{
			if(next.series != pre.series)
			{
				return false;
			}
			if(next.skillLevel == pre.skillLevel + 1)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 获取所有需要CD的技能 
		 * @return [tSkill, tSkill]
		 * 
		 */		
		public static function getNeedCoolDownSkills():Array
		{
			var res:Array = [];
			var dic:Dictionary = SkillConfig.instance.getSkillsDic();
			for each(var tSkill:TSkill in dic)
			{
				if(tSkill.career > 0)
				{
					if(tSkill.posType > 0)
					{
						if(tSkill.cooldownTime > 0)
						{
							res.push(tSkill);
						}
					}
				}
			}
			return res;
		}
		
		public static function getSkillDesc(skillId:int):String
		{
			var info:TSkill = SkillConfig.instance.getInfoByName(skillId);
			if(info == null)
			{
				return "";
			}
			var descId:int = parseInt(info.skillDescription);
			if(descId >= 10000000 && descId <= 99999999)
			{
				return "等策划把描述配置表";
			}
			return info.skillDescription;
		}
		
		/**
		 * 群体技能，单体技能，被动技能 
		 * @param skill
		 * @return 
		 * 
		 */		
		public static function getSkillUseTypeName(skill:TSkill):String
		{
			if(skill.triggerType == ESkillTriggType._ESkillTriggBeAttack
				|| skill.triggerType == ESkillTriggType._ESkillTriggBorn)
			{
				return Language.getString(20235);
			}
			if(skill.rangeType == ESkillRangeType._ESkillRangeTypeSingle)
			{
				return Language.getString(20233);
			}
			return Language.getString(20234);
		}
		
		public static function getBassicAttackPercentage(skill:TSkill):int
		{
			var str:String = skill.hurtEffect.toString();
			return parseInt(str.substr(str.length - 3));
		}
		
		public static function getAttachAttackValue(skill:TSkill):int
		{
			var str:String = skill.hurtEffect.toString();
			return parseInt(str.substr(0, str.length - 3));
		}
		
		public static function isAutoFightSkill(info:SkillInfo):Boolean
		{
			var targetType:int = info.tSkill.targetType;
			if(!(targetType &ESkillTargetType._ESkillTargetTypeEnemy))
			{
				return false;
			}
			return true;
		}
	}
}