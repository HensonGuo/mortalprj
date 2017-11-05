/**
 * @heartspeak
 * 2014-2-18 
 */   	
package mortal.game.utils
{
	import Message.DB.Tables.TBuff;
	import Message.Public.EBuffEffect;
	import Message.Public.EBuffType;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.view.mainUI.roleAvatar.BuffData;
	import mortal.game.view.skill.SkillInfo;
	
	/**
	 * buff标准 
	 * @author
	 * 
	 */
	public class BuffUtil
	{
		public static const ControlWalk:int 			= 1;			//控制走路
		public static const ControlAttack:int 		= 2;			//控制攻击
		public static const ControlReleaseMagic:int 	= 4;			//控制释放魔法
		
		public static const Invincible:int 			= 1024;			//无敌
		
		private static var notEffectDic:Dictionary;					//阻止字典
		
		private static var ignoreToNotEffect:Dictionary;				//免疫 to 阻止]
		
		
		public function BuffUtil()
		{
			
		}
		
		/**
		 * 建立阻止字典 
		 * 
		 */
		private static function buildNotEffect():void
		{
			notEffectDic = new Dictionary();
			
			notEffectDic[EBuffType._EBuffTypeSleepy] 			= ControlWalk | ControlAttack | ControlReleaseMagic;				//睡眠
			notEffectDic[EBuffType._EBuffTypeDizzy]			 	= ControlWalk | ControlAttack | ControlReleaseMagic;				//眩晕
			notEffectDic[EBuffType._EBuffTypeConfused] 			= ControlWalk | ControlAttack | ControlReleaseMagic;				//混乱
			notEffectDic[EBuffType._EBuffTypeFreeze] 			= ControlWalk | ControlAttack | ControlReleaseMagic;				//冻结
			notEffectDic[EBuffType._EBuffTypeHoldStill] 		= ControlWalk;														//定身
			notEffectDic[EBuffType._EBuffTypeBanSkill] 			= ControlReleaseMagic;												//沉默
		}
		
		/**
		 * 建立免疫 to 阻止字典 
		 * 
		 */
		private static function buildIgnoreToNotEffect():void
		{
			ignoreToNotEffect = new Dictionary();
			
			ignoreToNotEffect[EBuffType._EBuffTypeSleepy] 		= EBuffEffect._EBuffEffectSleep;							//睡眠
			ignoreToNotEffect[EBuffType._EBuffTypeDizzy]		= EBuffEffect._EBuffEffectDizzy;						//眩晕
			ignoreToNotEffect[EBuffType._EBuffTypeConfused] 	= EBuffEffect._EBuffEffectConfusion;						//混乱
			ignoreToNotEffect[EBuffType._EBuffTypeHoldStill] 	= EBuffEffect._EBuffEffectHoldStill;						//沉默
			ignoreToNotEffect[EBuffType._EBuffTypeBanSkill] 	= EBuffEffect._EBuffEffectSilence;						//定身
		}
		
		/**
		 * buffType是否对buffRule阻止
		 * @param buffType
		 * @param buffRule
		 * @return 
		 * 
		 */
		public static function effect(buffType:int,buffRule:int):Boolean
		{
			if(!notEffectDic)
			{
				buildNotEffect();
			}
			return (notEffectDic[buffType] & buffRule) != 0;
		}
		
		/**
		 * 对比buff和ignoreEffect对buffRule的综合作用 
		 * @param buffType		阻止列表
		 * @param effectType	免疫列表
		 * @param buffRule		对比对象
		 * @return 
		 * 
		 */
		public static function checkBuffIgnoreEffect(buffType:Array,effectType:int,buffRule:int):Boolean
		{
			if(!ignoreToNotEffect)
			{
				buildIgnoreToNotEffect();
			}
			
			var buffList:Array = [];
			var buffInfo:BuffData
			//处理buffer内部免疫的
			for each(buffInfo in buffType)
			{
				//无敌，免疫所有
				if(buffInfo.tbuff.type == EBuffType._EBuffTypeInvincible)
				{
					return true;
				}
				//状态免疫
				if(buffInfo.tbuff.type == EBuffType._EBuffTypeImmune)
				{
					//有状态免疫的buffer在，免疫效果加上这些buffer的免疫。effect = 0免疫所有buffer
					if(buffInfo.tbuff.effect == 0)
					{
						return true;
					}
					else
					{
						effectType = effectType | buffInfo.tbuff.effect;
					}
				}
			}
			//处理effectType免疫的
			for each(buffInfo in buffType)
			{
				if((ignoreToNotEffect[buffInfo.tbuff.type] & effectType) != 0)//具有免疫作用
				{
					continue;
				}
				buffList.push(buffInfo);
			}
			//判断剩余的
			for each(buffInfo in buffList)//过滤最终影响列表
			{
				if(BuffUtil.effect(buffInfo.tbuff.type,buffRule))
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 在buff影响下是否能移动 
		 * @return 
		 * 
		 */		
		public static function isCanRoleWalk():Boolean
		{
			return checkBuffIgnoreEffect(Cache.instance.buff.buffInfoArray,0,BuffUtil.ControlWalk);
		}
		
		/**
		 * 在buff影响下是否能移动 
		 * @return 
		 * 
		 */
		public static function isCanRoleFireSkill(skill:SkillInfo):Boolean
		{
			return checkBuffIgnoreEffect(Cache.instance.buff.buffInfoArray,skill.tSkill.ignoreBuff,BuffUtil.ControlReleaseMagic);
		}
		
		/**
		 * 在buff影响下是否能攻击
		 * @return 
		 * 
		 */
		public static function isCanRoleAttack():Boolean
		{
			return checkBuffIgnoreEffect(Cache.instance.buff.buffInfoArray,0,BuffUtil.ControlAttack);
		}
		
	}
}