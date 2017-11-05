package mortal.game.manager
{
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	
	import mortal.game.manager.mouse.IMouseRule;

	public class MouseRuleManager
	{
		private static var _dcObjRule:Dictionary = new Dictionary();
		
		/**
		 * 添加规则 
		 * 
		 */		
		public static function addRule(obj:InteractiveObject,ruleClass:Class,callBack:Function = null):void
		{
			var ruleObj:RuleObj = getRuleObj(obj,ruleClass);
			if(ruleObj.obj)
			{
				return;
			}
			var rule:IMouseRule = new ruleClass() as IMouseRule;
			rule.target = obj;
			rule.addCall(callBack);
			rule.startRule();
			
			ruleObj.ruleClass = ruleClass;
			ruleObj.obj = obj;
			_dcObjRule[ruleObj] = rule;
		}
		
		/**
		 * 移除规则 
		 * @param obj
		 * @param ruleClass
		 * 
		 */
		public static function removeRule(obj:InteractiveObject,ruleClass:Class):void
		{
			var ruleObj:RuleObj = getRuleObj(obj,ruleClass);
			if(!ruleObj.obj)
			{
				return;
			}
			var rule:IMouseRule = _dcObjRule[ruleObj];
			if(rule)
			{
				rule.endRule();
			}
			delete _dcObjRule[ruleObj];
		}
		
		/**
		 * 获取规则对象 
		 * @param obj
		 * @param ruleClass
		 * 
		 */
		public static function getRuleObj(obj:InteractiveObject,ruleClass:Class):RuleObj
		{
			for(var key:* in _dcObjRule)
			{
				if(key is RuleObj)
				{
					var ruleObj:RuleObj = key as RuleObj;
					if(ruleObj.obj == obj && ruleObj.ruleClass == ruleClass)	
					{
						return ruleObj;
					}
				}
			}
			return new RuleObj();
		}
	}
}

import flash.display.InteractiveObject;

class RuleObj
{
	public var ruleClass:Class;
	public var obj:InteractiveObject;
	public var callBack:Function;
}