/**
 * 2014-3-11
 * @author chenriji
 **/
package mortal.game.view.autoFight
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TBossRefresh;
	import Message.Game.SProcess;
	import Message.Public.ETaskProcess;
	import Message.Public.SEntityId;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.resource.SceneConfig;
	import mortal.game.resource.tableConfig.BossConfig;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.sceneInfo.BossRefreshInfo;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.view.autoFight.data.AFSkillData;
	import mortal.game.view.autoFight.data.AFSkillPlanIndex;
	import mortal.game.view.autoFight.data.SelectBossData;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.skill.SkillHookType;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.task.data.TaskInfo;

	public class AutoFightCache
	{
		private var _bossNotSelect:Dictionary = new Dictionary();
		// 第一方按攻击技能，  还有状态技能保存在这里
		private var _skillDatas:Dictionary = new Dictionary();
		// 第二方案攻击技能
		private var _skillDatas2:Dictionary = new Dictionary();
		
		public function AutoFightCache()
		{
		}
		
		public function setBossNotSelect(bossId:int, notSelected:Boolean):void
		{
			_bossNotSelect[bossId] = notSelected;
		}
		
		public function resetBossNotSelect():void
		{
			_bossNotSelect = new Dictionary();
		}
		
		public function isBossSelected(bossId:int):Boolean
		{
			return !_bossNotSelect[bossId];
		}
		
		private var _curBossPointIndex:int = -1;
		private var _lastMapId:int = -1;
		private var _bossPoints:Array;
		public function getNextBossRereshPoint():Point
		{
			if(Game.mapInfo.mapId != _lastMapId)
			{
				_lastMapId = Game.mapInfo.mapId;
				updateToCurMapBossPoints();
			}
			if(_bossPoints == null || _bossPoints.length == 0)
			{
				MsgManager.showRollTipsMsg("本地图没有配置boss刷怪点");
			}
			_curBossPointIndex++;
			if(_curBossPointIndex >= _bossPoints.length)
			{
				_curBossPointIndex = 0;
			}
			return _bossPoints[_curBossPointIndex];
		}
		
		public function resetBossPointIndex():void
		{
			_curBossPointIndex = -1;
		}
		
		private function updateToCurMapBossPoints():void
		{
			var info:SceneInfo = SceneConfig.instance.getSceneInfo(_lastMapId);
			if(info == null)
			{
				return;
			}
			_bossPoints = [];
			var arr:Array = info.bossRefreshs;
			for(var i:int = 0; i < arr.length; i++)
			{
				var ref:BossRefreshInfo = arr[i] as BossRefreshInfo;
				_bossPoints.push(new Point(ref.x, ref.y));
			}
		}
		
		public function getBossList(mapId:int, isDefault:Boolean=false):DataProvider
		{
			var res:DataProvider = new DataProvider();
			var info:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			if(info == null)
			{
				return res;
			}
			var arr:Array = info.bossRefreshs;
			for(var i:int = 0; i < arr.length; i++)
			{
				var refreshInfo:BossRefreshInfo = arr[i] as BossRefreshInfo;
				var arr2:Array = refreshInfo.bosses;
				for(var j:int = 0; j < arr2.length; j++)
				{
					var data:SelectBossData = new SelectBossData();
					data.boss = arr2[j];
					if(!isDefault)
					{
						data.selected = !(_bossNotSelect[data.boss.code]);
					}
					else
					{
						data.selected = true;
					}
					res.addItem(data);
				}
			}
			return res;
		}
		
		/**
		 * 攻击技能的数据
		 * @param planNum 1为
		 * @return 
		 * 
		 */		
		public function getMainSkillData(planNum:int=0, isDefault:Boolean=false, isReset:Boolean=true):DataProvider
		{
			var skills:Array = Cache.instance.skill.getAllSkills();
			var res:DataProvider = new DataProvider();
			var start:int = IsDoneType.AutoFightSkillActiveStart;
			var dic:Dictionary = _skillDatas;
			if(planNum == AFSkillPlanIndex.plan2)
			{
				start = IsDoneType.AutoFightSkillActiveStart2;
				dic = _skillDatas2;
			}
			for(var i:int = 0; i < skills.length; i++)
			{
				var info:SkillInfo = skills[i];
				if(info == null)
				{
					continue;
				}
				if(info.tSkill.hookType == SkillHookType.attack)
				{
					if(!isReset && dic[info.position] != null)
					{
						res.addItem(dic[info.position]);
						continue;
					}
					var data:AFSkillData = new AFSkillData();
					data.info = info;
					if(!isDefault)
					{
						data.isActive = !ClientSetting.local.getIsDone(info.position + start - 1);
					}
					else
					{
						data.isActive = true;
					}
					data.isMainSkill = true;
					data.value = -1;
					dic[info.position] = data;
					res.addItem(data);
				}
			}
			return res;
		}
		
		/**
		 * 辅助技能的数据 
		 * @return 
		 * 
		 */		
		public function getAssistSkillData(isDefault:Boolean=false):DataProvider
		{
			var skills:Array = Cache.instance.skill.getAllSkills();
			var res:DataProvider = new DataProvider();
			var values:Array = ClientSetting.local.AFAssistSkillValues;
			var start:int = IsDoneType.AutoFightSkillActiveStart;
			for(var i:int = 0; i < skills.length; i++)
			{
				var info:SkillInfo = skills[i];
				if(info == null)
				{
					continue;
				}
				if(info.tSkill.hookType == SkillHookType.buff
					|| info.tSkill.hookType == SkillHookType.life
					|| info.tSkill.hookType == SkillHookType.mana
				)
				{
					var data:AFSkillData = new AFSkillData();
					data.info = info;
					if(!isDefault)
					{
						data.isActive = !ClientSetting.local.getIsDone(info.position + start - 1);
					}
					else
					{
						data.isActive = true;
					}
					data.isMainSkill = false;
					data.value = values[info.position - 1];
					data.titleName = getHookName(info.tSkill.hookType);
					_skillDatas[info.position] = data;
					res.addItem(data);
				}
			}
			return res;
		}
		
		private function getHookName(type:int):String
		{
			var res:String = "";
			switch(type)
			{
				case SkillHookType.life:
					res = Language.getString(20178);
					break;
				case SkillHookType.mana:
					res = Language.getString(20179);
					break;
				case SkillHookType.buff:
					res = Language.getString(20180);
					break;
			}
			return res;
		}
		
		/**
		 * 返回是否有更改 
		 * @return 
		 * 
		 */		
		public function saveCacheDatas():Boolean
		{
			var res:Boolean = false;
			var start:int = IsDoneType.AutoFightSkillActiveStart;
			var index:int;
			for each(var data:AFSkillData in _skillDatas)
			{
				if(data == null)
				{
					continue;
				}
				// 因为默认是false代表着active状态的， 也就是说默认状态下是选中的
				index = data.info.position + start - 1;
				if(data.isActive == ClientSetting.local.getIsDone(index))
				{
					res = true;
					ClientSetting.local.setIsDone(!data.isActive, index);
				}
				// 如果是状态技能（生命、魔法）， 那么要保存那个值
				index = data.info.position-1;
				if((data.info.tSkill.hookType == SkillHookType.life|| data.info.tSkill.hookType == SkillHookType.mana)
					&& ClientSetting.local.AFAssistSkillValues[index] != data.value)
				{
					res = true;
					ClientSetting.local.AFAssistSkillValues[index] = data.value;
					ClientSetting.isChanged = true;
				}
			}
			start = IsDoneType.AutoFightSkillActiveStart2;
			for each(data in _skillDatas2)
			{
				if(data == null)
				{
					continue;
				}
				// 因为默认是false代表着active状态的， 也就是说默认状态下是选中的
				index = data.info.position + start - 1;
				if(data.isActive == ClientSetting.local.getIsDone(index))
				{
					res = true;
					ClientSetting.local.setIsDone(!data.isActive, index);
					ClientSetting.isChanged = true;
				}
			}
			return res;
		}
		
		/**
		 * 获取一个可用的技能 (攻击技能 》 buff技能 》 五连击技能)
		 * @param isCombo 是否只获取五连击
		 * @return 
		 * 
		 */		
		public function getCanUseSkill(isCombo:Boolean=false):SkillInfo
		{
			var roleInfo:SEntityInfo = Cache.instance.role.roleEntityInfo.entityInfo;
			var sIndex:int = IsDoneType.AutoFightSkillActiveStart;
			var useMainSkill:Boolean = ClientSetting.local.getIsDone(IsDoneType.UseMainSkill);
			var useAssistSkill:Boolean = ClientSetting.local.getIsDone(IsDoneType.UseAssistSkill);
			if(ClientSetting.local.getIsDone(IsDoneType.UseSecondSkillPlan))
			{
				sIndex = IsDoneType.AutoFightSkillActiveStart2;
			}
			
			// 所有已经学习的技能
//			var mainSkill:SkillInfo;
			var assistSkill:SkillInfo;
			var comboSkill:SkillInfo;
			
			var skills:Array = Cache.instance.skill.getAllSkillsLearned();
			for each(var info:SkillInfo in skills)
			{
				if(info == null)
				{
					continue;
				}
				// CD中的技能跳过
				var cd:ICDData = Cache.instance.cd.getCDData(info, CDDataType.skillInfo);
				if(cd && cd.isCoolDown)
				{
					continue;
				}
				
				// 技能没激活使用跳过
				var isActive:Boolean = !ClientSetting.local.getIsDone(sIndex + info.position - 1);
				if(!isActive)
				{
					continue;
				}
				
				// 只限定使用五连击
				if(isCombo)
				{
					if(info.isComboSkill)
					{
						return info;
					}
					else
					{
						continue;
					}
				}
				
				
				var targetPercent:int = ClientSetting.local.AFAssistSkillValues[info.position - 1];
				if(targetPercent == 0)
				{
					targetPercent = 100;
				}
				
				// 假如是主动攻击技能
				if(info.tSkill.hookType == SkillHookType.attack)
				{
					if(info.isComboSkill)
					{
						comboSkill = info;
					}
					else
					{
						return info;
					}
				}
				else if(info.tSkill.hookType == SkillHookType.life) // 生命状态技能
				{
					var cur:int = roleInfo.life/roleInfo.maxLife * 100;
					if(cur <= targetPercent)
					{
						return info;
					}
				}
				else if(info.tSkill.hookType == SkillHookType.mana) // 魔法状态技能
				{
					cur = roleInfo.mana/roleInfo.maxMana * 100;
					if(cur <= targetPercent)
					{
						return info;
					}
				}
				else if(info.tSkill.hookType == SkillHookType.buff)
				{
					// 身上没有info对应的buff状态则当前技能可用
					if(Cache.instance.buff.getBuffById(info.tSkill.additionBuff) == null)
					{
						assistSkill = info;
					}
				}
			}
			
			if(assistSkill == null)
			{
				return comboSkill;
			}
			return assistSkill;
		}
		
		/**
		 * 寻找一个可攻击的boss (当前目标>攻击来源>召唤怪>任务怪(选择的情况下)>筛选怪物>最近的怪)
		 * @return 
		 * 
		 */		
		public function getCanFightBoss(range:int=-1):IEntity
		{
			if(ThingUtil.selectEntity != null && !ThingUtil.selectEntity.isDead)
			{
				var entityInfo:SEntityInfo= ThingUtil.selectEntity.entityInfo.entityInfo;
				if(!EntityRelationUtil.isFriend(entityInfo))
				{
					return ThingUtil.selectEntity;
				}
			}
			
//			ThingUtil.entityUtil.entitysMap
			return null;
		}
		
		public function getCurMapTaskBoss():Dictionary
		{
			var res:Dictionary = new Dictionary();
			var tasks:Array = Cache.instance.task.taskDoing;
			for each(var info:TaskInfo in tasks)
			{
				var curStep:int = info.curStep;
				var arr:Array = info.stask.processMap[curStep];
				if(arr == null)
				{
					continue;
				}
				for(var j:int = 0; j < arr.length; j++)
				{
					var process:SProcess = arr[j] as SProcess;
					if(process == null)
					{
						continue;
					}
					var bossCode:int = -1;
					switch(process.type)
					{
						case ETaskProcess._ETaskProcessCollect: // 前往{mapid}采集{bossid}获得{物品id}（0/n）
							bossCode = process.contents[0];
							break;
						case ETaskProcess._ETaskProcessDrop: // 前往{mapid}击杀{bossid}获得{物品id}（0/n）
							bossCode = process.contents[0];
							break;
						case ETaskProcess._ETaskProcessEscort: // 将{bossid}护送前往{npcid}
							// [编号，类型#怪物id,地图id,npcid]			
							bossCode = process.contents[0];
							break;
						case ETaskProcess._ETaskProcessKill: // 前往{mapid}击杀{bossid}（0/n）
							// [编号，类型#怪物id,地图id,杀怪数量]			
							bossCode = process.contents[0];
							break;
					}
					if(bossCode != -1 && !_bossNotSelect[bossCode])
					{
						res[bossCode] = true;
					}
				}
			}
			
			return res;
		}
		
	}
}