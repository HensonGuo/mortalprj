/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.view.skill
{
	import Message.DB.Tables.TRune;
	import Message.DB.Tables.TSkill;
	import Message.Public.SSkill;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.skill.panel.data.RuneItemData;
	import mortal.game.view.skill.panel.data.SkillLearnArrowData;

	public class SkillCache
	{
		
		private var _skillLearned:Array = [];
		private var _skillAll:Array;
		
		private var _runeDic:Dictionary = new Dictionary();
		
		public function SkillCache()
		{
		}
		
		/**
		 * 登录完成后， 服务器推送过来并且初始化符文列表 
		 * @param arr
		 * 
		 */		
		public function initRuneList(arr:Array):void
		{
			_runeDic = new Dictionary();
			for(var i:int = 0; i < arr.length; i++)
			{
				var id:int = arr[i];
				var info:TRune = SkillConfig.instance.getRune(id);
				_runeDic[id] = info;
			}
		}
		
		/**
		 * 服务器推送过来并且初始化已经学习的技能列表 
		 * @param data
		 * 
		 */		
		public function initSkillList(data:Array):void
		{
			_skillLearned = [];
			for(var i:int = 0; i < data.length; i++)
			{
				var sSkill:SSkill = data[i] as SSkill;
				addPlayerSkill(sSkill);
			}
		}
		
		/**
		 * 删除符文 
		 * @param id
		 * 
		 */		
		public function removeRune(id:int):void
		{
			delete _runeDic[id];
		}
		
		/**
		 * 添加符文 
		 * @param id
		 * 
		 */		
		public function addRune(id:int):void
		{
			_runeDic[id] = SkillConfig.instance.getRune(id);
		}
		
		/**
		 * 符文升级 
		 * @param id
		 * 
		 */		
		public function runeUpgrade(id:int):void
		{
			var info:TRune = SkillConfig.instance.getRune(id);
			// 删除旧的
			for(var key:* in _runeDic)
			{
				var infoOld:TRune = _runeDic[key];
				if(infoOld.skillBelong == info.skillBelong)
				{
					if(infoOld.runePos == info.runePos)
					{
						delete _runeDic[key];
						break;
					}
				}
			}
			if(info != null)
			{
				_runeDic[info.runeId] = info;
			}
		}
		
		/**
		 * 获取已经激活的符文 
		 * @param serialId
		 * @return 
		 * 
		 */		
		public function getMyRune(runeId:int):TRune
		{
			return _runeDic[runeId];
		}
		
		public function getRunesBySerial(serialId:int):Array
		{
			var res:Array = [];
			var skillInfo:SkillInfo = getSkillBySerialId(serialId);
			
			var isDebug:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
			// 已经激活的
			for each(var info:TRune in _runeDic)
			{
				if(info.skillBelong == serialId)
				{
					var data:RuneItemData = new RuneItemData();
					data.info = info;
					data.actived = true;
					data.canUpgrade = isCanUpgrade(info, skillInfo, true);
					res[info.runePos-1] = data;
				}
			}
			// 当前技能对应的所有1级别符文
			var all:Array = SkillConfig.instance.getRunesBySerial(serialId, 1);
			// 在背包里面，未激活的
			var arr:Array = Cache.instance.pack.backPackCache.getAllItems();
			// 背包有的， 判断能否激活
			for each(var item:ItemData in arr)
			{
				if(ItemsUtil.isRuneStuff(item.itemInfo))
				{
					var bindCode:int = ItemsUtil.getBindCode(item.itemInfo.code);
					for each(info in all)
					{
						if(info.item == bindCode)
						{
							if(res[info.runePos - 1] != null)
							{
								continue; // 已经激活
							}
							data = new RuneItemData();
							data.actived = false;
							data.canUpgrade = isCanUpgrade(info, skillInfo);
							data.info = info;
							res[info.runePos-1] = data;
						}
					}
				}
			}
			
			// 没有材料且没有激活的，显示灰色
			for(var i:int = 0; i < all.length; i++)
			{
				info = all[i];
				if(res[info.runePos - 1] != null)
				{
					continue;
				}
				data = new RuneItemData();
				data.actived = false;
				if(!isDebug)
				{
					data.canUpgrade = false;
				}
				else
				{
					data.canUpgrade = isCanUpgrade(info, skillInfo);
				}
				data.info = info;
				res[info.runePos-1] = data;
			}
			return res;
		}
		
		private function isCanUpgrade(info:TRune, skillInfo:SkillInfo, isLearned:Boolean=false):Boolean
		{
			// 技能没学习
			if(skillInfo == null)
			{
				return false;
			}
			
			var next:TRune = SkillConfig.instance.getNextLevelRune(info.runeId);
			// 满级
			if(next == null)
			{
				return false;
			}
			/// debug模式不消耗，所以可以升级
			var isDebug:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
			if(isDebug)
			{
				return true;
			}
			if(isLearned)
			{
				
			}
			else
			{
				next = info;
			}
			// 等级是否符合
			if(skillInfo.skillLevel < next.skillBelongLevel)
			{
				return false;
			}
			// 经验
			if(next.exp > Cache.instance.role.roleInfo.experience)
			{
				return false;
			}
			// 铜币
			if(next.coin > Cache.instance.role.money.coin + Cache.instance.role.money.coinBind)
			{
				return false;
			}
			// 符能
			if(next.runicPower > Cache.instance.role.money.runicPower)
			{
				return false;
			}

			return true;
		}
		
		/**
		 * 根据skillId，获取已经学习的技能 
		 * @param skillId
		 * @return 
		 * 
		 */		
		public function getSkillBySerialId(serial:int):SkillInfo
		{
			for each(var info:SkillInfo in _skillLearned)
			{
				if(info.tSkill.series == serial)
				{
					return info;
				}
			}
			return null;
		}
		
		/**
		 * 获取所有技能（已经学习的，为学习的） 
		 * @return 
		 * 
		 */		
		public function getAllSkills():Array
		{
			if(_skillAll == null)
			{
				_skillAll = [];
				var serials:Array = SkillConfig.instance.getPlayerSkillSerials(Cache.instance.role.entityInfo.career);
//				serials.push(GameConst.PetSummonSkill);
				for(var i:int = 0; i < serials.length; i++)
				{
					var serialId:int = serials[i];
					var info:SkillInfo = this.getSkillBySerialId(serialId);
					if(info == null)
					{
						info = new SkillInfo();
						info.tSkill = SkillConfig.instance.getFirstSkillBySerialId(serialId);
					}
					if(info.tSkill.posType <= 0 || info.tSkill.posType > 20)
					{
						continue;
					}
					info.autoUse = !ClientSetting.local.getIsDone(IsDoneType.SkillAutoSelectStart + info.position - 1);
					_skillAll[info.position - 1] = info;
				}
			}
			return _skillAll;
		}
		
		/**
		 * 获取玩家当前的所有技能 
		 * @return 
		 * 
		 */		
		public function getAllSkillsLearned():Array
		{
			return _skillLearned;
		}
		
		/**
		 * 获取第一个技能（鼠标点击的默认释放技能） 
		 * @return 
		 * 
		 */		
		public function getFirstSkill():SkillInfo
		{
			for each(var info:SkillInfo in _skillLearned)
			{
				if(info.tSkill.combo != null && info.tSkill.combo != "")
				{
					return info;
				}
			}
			return null;
		}
		
		/**
		 * 获取玩家的某个技能 
		 * @param skillId
		 * @return 
		 * 
		 */		
		public function getSkill(skillId:int):SkillInfo
		{
			return _skillLearned[skillId] as SkillInfo;
		}
		
		public function getSkillByPosType(pos:int, isLearned:Boolean=true):SkillInfo
		{
			var datas:Array = _skillLearned;
			if(!isLearned)
			{
				datas = getAllSkills();
			}
			for each(var info:SkillInfo in datas)
			{
				if(info.position == pos)
				{
					return info;
				}
			}
			return null;
		}
		
		public function addPlayerSkill(sSkill:SSkill):void
		{
			var info:SkillInfo = new SkillInfo();
			var skillId:int = sSkill.skillId;
			var tSkill:TSkill = SkillConfig.instance.getInfoByName(skillId);
			info.tSkill = tSkill;
			info.cdDt = sSkill.cdDt;
			info.learned = true;
			// 是否自动选择目标、选择方向
			info.autoUse = !(ClientSetting.local.getIsDone(IsDoneType.SkillAutoSelectStart + tSkill.posType - 1));
			_skillLearned[skillId] = info;
			
			if(_skillAll != null)
			{
				_skillAll[info.position - 1] = info;
			}
		}
		
		public function delPlayerSkill(skillId:int):void
		{
			var info:SkillInfo = _skillLearned[skillId];
			delete _skillAll[info.position - 1];
			delete _skillLearned[skillId];
		}
		
		public function updatePlayerSkill(sSkill:SSkill):void
		{
			var info:SkillInfo = _skillLearned[sSkill.skillId];
			if(info)
			{
				info.cdDt = sSkill.cdDt;
			}
		}
		
		public function upgradePlayerSkill(sSkill:SSkill):void
		{
			if(_skillLearned == null)
			{
				return;
			}
			var newInfo:TSkill = SkillConfig.instance.getInfoByName(sSkill.skillId);
			// 找到旧的并删除
			for each(var info:SkillInfo in _skillLearned)
			{
				if(SkillUtil.isNextSkillByTskill(newInfo, info.tSkill))
				{
					delPlayerSkill(info.skillId);
					delete _skillAll[info.position - 1];
					break;
					
				}
			}
			// 添加新的
			addPlayerSkill(sSkill);
//			
//			// 更新all
//			info = getSkill(sSkill.skillId);
//			info.autoUse = !SystemSetting.local.getIsDone(IsDoneType.SkillAutoSelectStart + info.position - 1);
//			_skillAll[info.position - 1] = info;
		}
		
		public function getArrowDatas():Array
		{
			if(_skillLearned == null)
			{
				return arrowDatas;
			}
			for each(var info:SkillInfo in _skillLearned)
			{
				if(info.position <= 0)
				{
					continue;
				}
				var data:SkillLearnArrowData = arrowDatas[info.position - 1];
				if(data == null)
				{
					continue;
				}
				data.isActive = info.learned;
			}
			return arrowDatas;
		}
		
		private var arrowDatas:Array = [
			new SkillLearnArrowData(60, 160, 1, "SkillPanel_down"),
			new SkillLearnArrowData(107, 215, 2, "SkillPanel_rightTop"),
			new SkillLearnArrowData(225, 162, 3, "SkillPanel_rightTop"),
			new SkillLearnArrowData(348, 134, 4, "SkillPanel_right"),
//			new SkillLearnArrowData(60, 282, 5, "SkillPanel_down"),
			new SkillLearnArrowData(109, 345, 6, "SkillPanel_right"),
			new SkillLearnArrowData(227, 299, 7, "SkillPanel_rightTop"),
			new SkillLearnArrowData(351, 278, 8, "SkillPanel_right"),
			new SkillLearnArrowData(470, 278, 9, "SkillPanel_right"),
			new SkillLearnArrowData(227, 376, 10, "SkillPanel_rightDown"),
			new SkillLearnArrowData(351, 407, 11, "SkillPanel_right"),
			new SkillLearnArrowData(470, 407, 12, "SkillPanel_right")
//			new SkillLearnArrowData(225, 160, 13, "SkillPanel_rightTop")
			
		];
	}
}