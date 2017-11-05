/**
 * 2014-1-3
 * @author chenriji
 **/
package mortal.game.view.common.tooltip
{
	import flash.utils.Dictionary;

	public class TooltipType
	{
		public static const Text:String = "纯文本类型";
		public static const Item:String = "普通物品";
		public static const Buff:String = "状态";
		public static const Skill:String = "技能";
		public static const SkillShowNext:String = "技能显示下一级";
		public static const Equipment:String = "装备";
		public static const Rune:String = "符文";
		public static const PetEgg:String = "宠物蛋";
		public static const Mount:String = "坐骑";
		
		
		public static const TestCompareTips:String = "对比tips测试用";
		
		/**
		 * 需要显示对比tips的必须在此注册 
		 */		
		private static const _compareToolTips:Dictionary = new Dictionary();
		
		public static function registerCompareToolTipType(type:String):void
		{
			_compareToolTips[type] = true;
		}
		
		/**
		 * 是否是显示对比tips的类型 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isNeedCompareToolTipType(type:String):Boolean
		{
			if(_compareToolTips[type])
			{
				return true;
			}
			return false;
		}
		
		
		public function TooltipType()
		{
		}
	}
}