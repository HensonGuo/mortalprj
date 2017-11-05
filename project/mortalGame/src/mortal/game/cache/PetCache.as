/**
 * @heartspeak
 * 2014-2-12 
 */   	

package mortal.game.cache
{
	import Message.DB.Tables.TConst;
	import Message.DB.Tables.TSkill;
	import Message.Game.SPet;
	import Message.Game.SPetUpdate;
	import Message.Game.SSeqPet;
	import Message.Public.EEntityAttribute;
	import Message.Public.EPetState;
	import Message.Public.EUpdateType;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SExtraFightAttribute;
	import Message.Public.SSFightAttribute;
	import Message.Public.SSeqAttributeUpdate;
	import Message.Public.SSkill;
	
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.PetConst;
	import mortal.game.manager.MsgManager;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.skill.SkillInfo;

	public class PetCache
	{
		public var fightMode:int = 0;
		//出战宠物Uid
		public var fightPetUid:String = "";
		//宠物列表
		public var pets:Array = [];
		//宠物技能仓库
		private var _skillLib:Dictionary;
		//随机技能每日一次免费
		public var canFreeFreshSkill:Boolean = false;
		
		public function PetCache()
		{
		}
		
		/**
		 * 通过uid获取Spet 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getSpetByUid(uid:String):SPet
		{
			for(var i:int = 0;i < pets.length;i++)
			{
				if((pets[i] as SPet).publicPet.uid == uid)
				{
					return pets[i] as SPet;
				}
			}
			return null;
		}
		
		/**
		 * 更新出战宠物信息 
		 * @param value
		 * 
		 */		
		public function setFightPet(value:SPet):void
		{
			if(value)
			{
				if(pets.length == 0)
				{
					pets.push(value);
				}
				fightPetUid = value.publicPet.uid;
			}
		}
		
		
		/**
		 * 更新宠物列表 
		 * @param pets
		 * 
		 */
		public function setPets(value:SSeqPet):void
		{
			pets = value.pets;
			fightMode = value.fightMode;
			sort();
			for(var i:int = 0;i < pets.length;i++)
			{
				var pet:SPet = pets[i] as SPet;
				if(pet.publicPet.state == EPetState._EPetStateActive)
				{
					fightPetUid = pet.publicPet.uid;
					return;
				}
			}
		}
		
		/**
		 * 增加或者删除一个宠物 
		 * @param petUpdate
		 * 
		 */
		public function updatePet(petUpdate:SPetUpdate):void
		{
			switch(petUpdate.updateType)
			{
				case EUpdateType._EUpdateTypeAdd:
					var i:int;
					var length:int = petUpdate.petsBaseInfo.length;
					for(i = 0; i < length;i++)
					{
						pets.push(petUpdate.petsBaseInfo[i]);
					}
					sort();
					break;
				case EUpdateType._EUpdateTypeDel:
					for(i = 0;i < pets.length;i++)
					{
						var pet:SPet = pets[i] as SPet;
						if(pet.publicPet.uid == petUpdate.uid)
						{
							pets.splice(i,1);
							if (petUpdate.uid == fightPetUid)
								fightPetUid = "";
							break;
						}
					}
					break;
			}
		}
		
		/**
		 * 排列宠物列表 
		 * 
		 */
		public function sort():void
		{
			pets.sort(sortPet);
		}
		
		/**
		 * 排列宠物 按等级和资质 
		 * @param pet1
		 * @param pet2
		 * 
		 */		
		private function sortPet(pet1:SPet,pet2:SPet):int
		{
			if(pet1.publicPet.level > pet2.publicPet.level)
			{
				return -1;
			}
			else if(pet1.publicPet.level < pet2.publicPet.level)
			{
				return 1;
			}
			else if(pet1.publicPet.talent >= pet2.publicPet.talent)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		/**
		 * 更新宠物基础属性 
		 * 
		 */		
		public function updatePetBaseAttribute(msg:SSFightAttribute):void
		{
			var petUid:String = msg.uid;
			var pet:SPet = getSpetByUid(petUid);
			if(pet)
			{
				pet.baseFight = msg.baseFight;
			}
		}
		
		/**
		 * 更新宠物战斗属性 
		 * @param msg
		 * 
		 */		
		public function updatePetFightAttribute(msg:SExtraFightAttribute):void
		{
			var petUid:String = msg.uid;
			var pet:SPet = getSpetByUid(petUid);
			if(pet)
			{
				pet.extraFight = msg.extraFightAttribute;
				pet.addPercent = msg.addPercentAttribute;
			}
		}
		
		/**
		 * 是否有宠物出战
		 * 
		 */	
		public function hasPetFight():Boolean
		{
			for (var i:int = 0; i < pets.length; i++)
			{
				var pet:SPet = pets[i] as SPet;
				if (pet.publicPet.state == EPetState._EPetStateActive)
					return true;
			}
			return false;
		}
		
		/**
		 * 获取等级最高的宠物
		 * 
		 */
		public function getHighestLevelPetUid():String
		{
			var highestLevel:int = 0;
			var highestLevelUid:String = null;
			for(var i:int = 0;i < pets.length;i++)
			{
				var pet:SPet = pets[i] as SPet;
				if(pet.publicPet.level > highestLevel)
				{
					highestLevel = pet.publicPet.level;
					highestLevelUid = pet.publicPet.uid;
				}
			}
			return highestLevelUid;
		}
		
		
		
		/**
		 * 更新技能仓库
		 * 
		 */
		public function updateSkillLib(lib:Dictionary):void
		{
			_skillLib = lib;
		}
		
		public function getLibSkill(pos:int):SkillInfo
		{
			if (_skillLib == null)
				return null;
			var skillID:int =  _skillLib[pos];
			if (skillID == 0)
				return null;
			var tSkill:TSkill = SkillConfig.instance.getInfoByName(skillID);
			var skillInfo:SkillInfo = new SkillInfo();
			skillInfo.tSkill = tSkill;
			return skillInfo;
		}
		
		/**
		 * 更新宠物技能
		 * 
		 */
		public function updatePetSkill(petuid:String, sSkill:SSkill):void
		{
			var petSkillMap:Dictionary = getPetSkillList(petuid);
			petSkillMap[sSkill.pos] = sSkill.skillId;
		}
		
		public function removePetSkill(petuid:String, pos:int):void
		{
			var petSkillMap:Dictionary = getPetSkillList(petuid);
			petSkillMap[pos] = null;
			delete petSkillMap[pos];
		}
		
		public function getPetSkill(petuid:String, pos:int):SkillInfo
		{
			var petSkillMap:Dictionary = getPetSkillList(petuid);
			var skillID:int =  petSkillMap[pos];
			if (skillID == 0)
				return null;
			var tSkill:TSkill = SkillConfig.instance.getInfoByName(skillID);
			var skillInfo:SkillInfo = new SkillInfo();
			skillInfo.tSkill = tSkill;
			return skillInfo;
		}
		
		/**
		 * 获取天赋技能列表
		 * 
		 */
		public function getTalentSkillList(petuid:String):Vector.<SkillInfo>
		{
			var list:Vector.<SkillInfo> = new Vector.<SkillInfo>();
			for (var i:int = PetConst.TALENT_SKILL_START_POS; i <= PetConst.TALENT_SKILL_END_POS; i++)
			{
				var skill:SkillInfo = getPetSkill(petuid, i);
				if (skill == null)
					continue;
				list.push(skill);
			}
			return list;
		}
		
		/**
		 * 获取被动技能的开孔数
		 * 
		 */
		public function getPassiveSkillOpenPosNum(petuid:String):int
		{
			var pet:SPet = getSpetByUid(petuid);
			if (pet.publicPet.growth < PetConst.OPEN_SKILL_POS_5_REQUIRE_GROWTH)
				return 4;
			if (pet.publicPet.growth < PetConst.OPEN_SKILL_POS_6_REQUIRE_GROWTH)
				return 5;
//			if (pet.publicPet.blood)
			return 8;
		}
		
		private function getPetSkillList(petuid:String):Dictionary
		{
			var pet:SPet = getSpetByUid(petuid);
			return pet.publicPet.skillIds;
		}
	}
}