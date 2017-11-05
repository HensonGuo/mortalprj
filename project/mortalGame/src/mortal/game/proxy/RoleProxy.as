/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.proxy
{
	import Message.DB.Tables.TSkill;
	import Message.Game.AMI_IRole_activeRune;
	import Message.Game.AMI_IRole_learnSkill;
	import Message.Game.AMI_IRole_saveClientSetting;
	import Message.Game.AMI_IRole_upgradeRune;
	import Message.Game.AMI_IRole_upgradeSkill;
	import Message.Game.AMI_IRole_useDrugBag;
	
	import extend.language.Language;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.mvc.core.Proxy;
	
	public class RoleProxy extends Proxy
	{
		public function RoleProxy()
		{
			super();
		}
		
		/**
		 * 学习技能 
		 * @param skillId
		 * 
		 */		
		public function learnSkill(skillId:int, isDebug:Boolean=true):void
		{
			rmi.iRolePrx.learnSkill_async(new AMI_IRole_learnSkill(learnSkillSuccess, null, skillId), skillId , isDebug);
		}
		private function learnSkillSuccess(obj:AMI_IRole_learnSkill):void
		{
			var id:int = int(obj.userObject);
			var tskill:TSkill = SkillConfig.instance.getInfoByName(id);
			if(tskill != null)
			{
				MsgManager.addTipText(Language.getStringByParam(20254, tskill.name), MsgHistoryType.SkillMsg);
			}
		}
		
		/**
		 * 升级技能 
		 * @param skillId
		 * 
		 */		
		public function upgradeSkill(skillId:int, isDebug:Boolean=true):void
		{
			rmi.iRolePrx.upgradeSkill_async(new AMI_IRole_upgradeSkill(upgradeSkillSuccess, null, skillId), skillId, isDebug);
		}
		private function upgradeSkillSuccess(obj:AMI_IRole_upgradeSkill):void
		{
			var id:int = int(obj.userObject);
			var tskill:TSkill = SkillConfig.instance.getInfoByName(id);
			if(tskill != null)
			{
				MsgManager.addTipText(Language.getStringByParam(20255, tskill.skillLevel + 1, tskill.name), MsgHistoryType.SkillMsg);
			}
		}
		
		/**
		 * 激活符文 
		 * @param runeId
		 * 
		 */		
		public function activeRune(runeId:int, isDebug:Boolean=false):void
		{
			rmi.iRolePrx.activeRune_async(new AMI_IRole_activeRune(), runeId, isDebug);
		}
		
		/**
		 * 升级符文 
		 * @param runeId
		 * 
		 */		
		public function upgradeRune(runeId:int, isDebug:Boolean=false):void
		{
			rmi.iRolePrx.upgradeRune_async(new AMI_IRole_upgradeRune(), runeId, isDebug);
		}
		
		
		/**
		 * 保存客户端设置 
		 * @param type
		 * @param str
		 * 
		 */		
		public function saveClientSetting(type:int, str:String):void
		{
			rmi.iRolePrx.saveClientSetting_async(new AMI_IRole_saveClientSetting(), type, str);
		}
		
		/**
		 * 使用药包
		 * @param type 药包类型，EDrug
		 * @param uid 人物药包传空。宠物传实际uid
		 */
		public function useDrugBag(type:int,uid : String = ""):void
		{
			rmi.iRolePrx.useDrugBag_async(new AMI_IRole_useDrugBag(useDrugBagSuccess),type,uid);
//			function useDrugBagSuccess():void
//			{
//				if(uid == "")
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.UseDrugBagSuccess,type));
//				}
//				else
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.PetUseDrugBagSuccess,type));
//				}
//				
//			}
		}
		
		private function useDrugBagSuccess(e:AMI_IRole_useDrugBag):void
		{
			
		}
	}
}