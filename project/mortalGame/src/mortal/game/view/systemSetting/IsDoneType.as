/**
 * 2014-1-20
 * @author chenriji
 **/
package mortal.game.view.systemSetting
{
	

	public class IsDoneType
	{
		public function IsDoneType()
		{
		}
		
		public static const IsSkillDebug:int = 0;
		
		////////////////////////////////////////////////////// 小地图是否显示xxNPC的， true代表不显示
		public static const MapShowTypePassPoint:int = 1;
		public static const MapShowTypeBoss:int = 2;
		public static const MapShowTypeDailyNpc:int = 3;
		public static const MapShowTypeTaskNPC:int = 4;
		public static const MapShowTypeActivityNPC:int = 5;
		public static const MapShowTypeFuncNPC:int = 6;
		public static const MapShowTypeExchangeNPC:int = 7;
		//////////////////////////////////////////////////////////////////////////////////////////////
		//技能位置的， 自动选择目标, 13个位置， 默认表示选中
		public static const SkillAutoSelectStart:int = 8;
		public static const SkillAutoSelectEnd:int = 20;
		//
		public static const SetFirstSkillToShortCut:int = 21;
		//
		public static const IsNotCD:int = 22;
		// 好友设置
		public static const RefuseStranger:int = 30;
		public static const RefuseOtherApply:int = 31;
		// 自动挂机设置
		public static const SelectBoss:int = 23;
		public static const SelectTaskBoss:int = 24;
		public static const UseMainSkill:int = 25;
		public static const UseAssistSkill:int=  26;
		public static const UseSecondSkillPlan:int = 27;
		
		// 挂机技能是否激活 false 为激活
		public static const AutoFightSkillActiveStart:int = 32;
		public static const AutoFightSkillActiveEnd:int = 44; // 一共13个技能
		// 挂机技能是否激活 false 为激活 方案2
		public static const AutoFightSkillActiveStart2:int = 45;
		public static const AutoFightSkillActiveEnd2:int = 57; // 一共13个技能
		
		//强化设置(道具不足自动购买)
		public static const AutoBuyStrengProp:int = 33;
		public static const AutoBuyGemProp:int = 34;
		
	}
}