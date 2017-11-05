package mortal.game.scene3D.model.data
{
	import flash.utils.Dictionary;
	
	import mortal.game.resource.GameDefConfig;

	public class ActionType
	{
		/**
		 * 动作类型 
		 * 
		 */		
		public function ActionType()
		{
		}
		
		public static const Stand:String = "stand";  	//站立
		public static const Walking:String = "run";  //走动
		public static const attack:String = "attack";//攻击
		public static const leadStart:String = "leadStart";//吟唱准备
		public static const leading:String = "leading";//吟唱持续
		public static const Injury:String = "hurt";	// 受伤
		public static const Death:String = "die"; 	// 死亡
		public static const Jump:String = "jump";//跳跃
		
		/**
		 * 是否攻击动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isAttackAction(action:String):Boolean
		{
			return ActionName.attackActionList.indexOf(action) != -1;
		}
		
		/**
		 * 是否吟唱起始动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isLeadStartAction(action:String):Boolean
		{
			return Boolean(ActionName.leadActionDic[action]);
		}
		
		/**
		 * 是否吟唱中动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isLeadingAction(action:String):Boolean
		{
			var leadActionDic:Dictionary = ActionName.leadActionDic;
			if(action == ActionName.Tornado)
			{
				return true;
			}
			for each(var actionTemp:String in leadActionDic)
			{
				if(actionTemp == action)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 是否移动动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isWalkAction(action:String):Boolean
		{
			return ActionName.walkingActionList.indexOf(action) >= 0;
		}
		
		/**
		 * 是否站立动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isStandAction(action:String):Boolean
		{
			return ActionName.standActionList.indexOf(action) >= 0;
		}
		
		/**
		 * 是否受伤动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isInjuryAction(action:String):Boolean
		{
			return ActionName.injuryActionList.indexOf(action) >= 0;
		}
		
		/**
		 * 是否死亡动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isDeathAction(action:String):Boolean
		{
			return ActionName.deathActionList.indexOf(action) >= 0;
		}
		
		/**
		 * 是否跳跃动作 
		 * @param action
		 * @return 
		 * 
		 */		
		public static function isJumpAction(action:String):Boolean
		{
			return ActionName.jumpActionList.indexOf(action) >= 0;
		}
	}
}