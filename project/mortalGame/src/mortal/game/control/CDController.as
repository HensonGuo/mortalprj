/**
 * 2014-1-11
 * @author chenriji
 **/
package mortal.game.control
{
	import Message.DB.Tables.TSkill;
	import Message.Public.ESkillAffectCdType;
	import Message.Public.SSkill;
	
	import flash.utils.getTimer;
	
	import mortal.game.cache.CDCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.ClockManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataPublicCD;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.SkillUtil;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class CDController extends Controller
	{
		public function CDController()
		{
			super();
		}
		
		protected override function initServer():void
		{
			// 监听技能已经更新的事件来初始化
			NetDispatcher.addCmdListener(ServerCommand.SkillListUpdate, skillListUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.SkillAdd, skillAddHandler);
			NetDispatcher.addCmdListener(ServerCommand.SkillRemove, skillRemoveHandler);
			NetDispatcher.addCmdListener(ServerCommand.SkillUpdate, skillUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.SkillUpgrade, skillUpgradeHandler);
			
			// 监听技能使用成功的事件
			Dispatcher.addEventListener(EventName.ScenePlaySkill, skillUseSucessHandler);
			
			
			////////////////////////////////////// 物品的CD
			NetDispatcher.addCmdListener(ServerCommand.BackpackDataChange, itemListUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemAdd, addItemCDHandler);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemDel, delItemCDHandler);
			NetDispatcher.addCmdListener(ServerCommand.ItemCDTime, setItemCDHandler);
			// 药品使用成功
			NetDispatcher.addCmdListener(ServerCommand.BackPackUseItemSuccess, useItemSucessHandler);
		}
		
		private function itemListUpdateHandler(obj:Object):void
		{
			var all:Array = cache.pack.backPackCache.getAllItems();
			if(all == null)
			{
				return;
			}
			for each(var itemData:ItemData in all)
			{
				if(itemData == null)
				{
					return;
				}
				addItemCDHandler(itemData);
			}
		}
		
		private function addItemCDHandler(obj:Object):void
		{
			var itemData:ItemData = obj as ItemData;
			if(itemData.itemInfo.cdTime <= 0)
			{
				return;
			}
			var key:String = CDCache.getKey(itemData.itemInfo);
			var cd:ICDData = cache.cd.registerCDData(CDDataType.itemData, key);
			cd.totalTime = itemData.itemInfo.cdTime * 1000;
		}
		
		private function delItemCDHandler(obj:Object):void
		{
//			var itemData:ItemData = obj as ItemData;
//			var items:Array = cache.pack.backPackCache.getItemsByCode(itemData.itemInfo.code);
//			if(items == null || items.length == 0)
//			{
//				// 确定没有了再删除
//				var key:String = CDCache.getKey(itemData.itemInfo);
////				var cd:ICDData = cache.cd.registerCDData(CDDataType.itemData, key);
//				cache.cd.unregisterCDData(CDDataType.itemData, key);
//			}
		}
		
		private function setItemCDHandler(obj:Object):void
		{
			
		}
		
		private function useItemSucessHandler(obj:Object):void
		{
			var code:int = int(obj);
			if(code <= 0)
			{
				return;
			}
			var itemData:ItemData = new ItemData(code);
			if(itemData == null || itemData.itemInfo.cdTime <= 0)
			{
				return;
			}
			var cd:ICDData = cache.cd.getCDData(itemData, CDDataType.itemData);
			cd.startCoolDown();
		}
		
		private function skillListUpdateHandler(obj:Object):void
		{
			var skills:Array = cache.skill.getAllSkillsLearned();
			if(skills == null)
			{
				return;
			}
			for each(var info:SkillInfo in skills)
			{
				var cd:ICDData = cache.cd.registerCDData(CDDataType.skillInfo, info.skillId.toString());
				cd.totalTime = info.tSkill.cooldownTime;
				addSkillPublicCD(info, cd);
				
				// 检查是否正在CD中
				// 上次使用到现在多少毫秒了
				var leftTime:int =  info.cdDt.time - ClockManager.instance.nowDate.time; 
				if(leftTime > info.tSkill.cooldownTime)
				{
					leftTime = 0;
				}
				if(leftTime > 500)
				{
					cd.beginTime = getTimer() - info.tSkill.cooldownTime + leftTime;
					cd.startCoolDown();
				}
				
			}
		}
		
		private function skillAddHandler(obj:Object):void
		{
			var skill:SSkill = obj as SSkill;
			var info:SkillInfo = cache.skill.getSkill(skill.skillId);
			if(info == null)
			{
				return;
			}
			var cd:ICDData = cache.cd.registerCDData(CDDataType.skillInfo, info.skillId.toString());
			cd.totalTime = info.tSkill.cooldownTime;
			addSkillPublicCD(info, cd);
		}
		
		
		private function skillRemoveHandler(obj:Object):void
		{
			var skill:SSkill = obj as SSkill;
			var info:SkillInfo = cache.skill.getSkill(skill.skillId);
			if(info == null)
			{
				return;
			}
			cache.cd.unregisterCDData(CDDataType.skillInfo, info.skillId.toString());
			removeSkillPublicCD(info.skillId);
		}
		
		private function skillUpdateHandler(obj:Object):void
		{
			var skill:SSkill = obj as SSkill;
			var info:SkillInfo = cache.skill.getSkill(skill.skillId);
			if(info == null)
			{
				return;
			}
			var cd:ICDData = cache.cd.getCDDataByKeyType(CDDataType.skillInfo, info.skillId.toString());
			if(cd != null)
			{
				var needCDTime:int = skill.cdDt.time - ClockManager.instance.nowDate.time;
				if(needCDTime < 0)
				{
					// 已经过了CD的时间了
					return;
				}
				var usedTime:int = cd.totalTime - needCDTime;
				cd.beginTime = getTimer() - usedTime;
				cd.startCoolDown();
			}
		}
		
		/**
		 * 技能升级， 返回的是新的技能 
		 * @param obj
		 * 
		 */		
		private function skillUpgradeHandler(obj:Object):void
		{
			var skill:SSkill = obj as SSkill;
			var info:SkillInfo = cache.skill.getSkill(skill.skillId);
			if(info == null)
			{
				return;
			}
			var preSkill:TSkill = SkillConfig.instance.getSkillByLevel(info.tSkill.series, info.tSkill.skillLevel - 1);
			if(preSkill != null)
			{
				// 删除之前的
				cache.cd.unregisterCDData(CDDataType.skillInfo, preSkill.skillId.toString());
				removeSkillPublicCD(preSkill.skillId);
			}
			// 添加新的
			var cd:ICDData = cache.cd.registerCDData(CDDataType.skillInfo, skill.skillId.toString());
			cd.totalTime = info.cooldownTime;
			addSkillPublicCD(info, cd);
		}
		
		private function addSkillPublicCD(info:SkillInfo, cdData:ICDData):void
		{
			var cd:CDDataPublicCD = cache.cd.registerCDData(CDDataType.publicCD, "skillPublicCD") as CDDataPublicCD;
			if(info.tSkill.affectCdType == ESkillAffectCdType._ESkillAffectCdTypeNormal // 产生公共CD、也受公共CD影响
//				|| info.tSkill.affectCdType == ESkillAffectCdType._ESkillAffectCdTypeNoCheck) // 产生公共CD， 不受公共CD影响
			)
			{
				cd.addPublicCD(info.skillId, cdData); // 受公共cd影响的放进这里
			}
		}
		
		private function removeSkillPublicCD(skillId:int):void
		{
			var cd:CDDataPublicCD = cache.cd.registerCDData(CDDataType.publicCD, "skillPublicCD") as CDDataPublicCD;
			cd.removePublicCD(skillId);
		}
		
		private function skillUseSucessHandler(evt:DataEvent):void
		{
			trace("......................服务器申请到返回的时间:" + (getTimer() - GameController.skill._lastUseTime));
			var skillId:int = int(evt.data);
			var cd:ICDData = cache.cd.getCDDataByKeyType(CDDataType.skillInfo, skillId.toString());
			if(cd != null)
			{
				cd.startCoolDown();
			}
			
			var skill:TSkill = SkillConfig.instance.getInfoByName(skillId);
			// 不产生公共CD
			if(skill.affectCdType == ESkillAffectCdType._ESkillAffectCdTypeNoCheckNoAffect)
			{
				return;
			}
			// 公共CD
			cd = cache.cd.registerCDData(CDDataType.publicCD, "skillPublicCD");
			if(cd.isCoolDown)
			{
				return;
			}
			cd.totalTime = skill.publicCdTime==0?1000:skill.publicCdTime;
			cd.startCoolDown();
		}
	}
}