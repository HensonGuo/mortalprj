/**
 * @heartspeak
 * 2014-2-12 
 */   	
package mortal.game.net.command.pet
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EGateCommand;
	import Message.Game.SPet;
	import Message.Game.SPetUpdate;
	import Message.Game.SSeqPet;
	import Message.Public.EEntityAttribute;
	import Message.Public.EPetState;
	import Message.Public.ESkillUpdateType;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SPetSkillUpdate;
	import Message.Public.SPublicBool;
	import Message.Public.SPublicDictIntInt;
	import Message.Public.SSeqAttributeUpdate;
	
	import com.gengine.debug.Log;
	
	import mortal.game.cache.Cache;
	import mortal.game.cache.PetCache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.mvc.core.NetDispatcher;
	
	public class PetCommand extends BroadCastCall
	{
		public function PetCommand(type:Object)
		{
			super(type);
		}
		
		/**
		 *数据推入缓存 
		 * @param mb
		 * 
		 */		
		override public function call(mb:MessageBlock):void
		{
			super.call(mb);
			var pets:SSeqPet;
			switch(mb.messageHead.command)
			{
				//所有宠物信息
				case EGateCommand._ECmdGatePetInfo:
					pets = mb.messageBase as SSeqPet;
					Cache.instance.pet.setPets(pets);
					NetDispatcher.dispatchCmd(ServerCommand.PetInfoUpdate,null);
					break;
				//宠物属性更新
				case EGateCommand._ECmdGatePetUpdate:
					var attribute:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
					var updatePetUid:String = updateAttributes(attribute);
					NetDispatcher.dispatchCmd(ServerCommand.PetAttributeUpdate,updatePetUid);
					break;
				//出战宠物信息
				case EGateCommand._ECmdGateFightPetInfo:
					pets = mb.messageBase as SSeqPet;
					if(pets.pets.length)
					{
						Cache.instance.pet.setFightPet(pets.pets[0]);
					}
					NetDispatcher.dispatchCmd(ServerCommand.PetFightPetUpdate,pets.pets[0]);
					break;
				//获得或者删除一个宠物
				case EGateCommand._ECmdGatePetInfoUpdate:
					var spetUpdate:SPetUpdate = mb.messageBase as SPetUpdate;
					Cache.instance.pet.updatePet(spetUpdate);
					NetDispatcher.dispatchCmd(ServerCommand.PetAddOrRemove,spetUpdate);
					NetDispatcher.dispatchCmd(ServerCommand.PetInfoUpdate,null);
					break;
				//更新宠物技能
				case EGateCommand._ECmdGatePetSkillUpdate:
					var petSkillUpdate:SPetSkillUpdate = mb.messageBase as SPetSkillUpdate;
					updateSkill(petSkillUpdate);
					NetDispatcher.dispatchCmd(ServerCommand.PetSkillUpdate,null);
					break;
				//更新宠物技能仓库
				case EGateCommand._ECmdGatePetSkillWarehouse:
					var wareHouseData:SPublicDictIntInt = mb.messageBase as SPublicDictIntInt;
					Cache.instance.pet.updateSkillLib(wareHouseData.publicDictIntInt);
					NetDispatcher.dispatchCmd(ServerCommand.PetSkillUpdate,null);
					break;
				//免费刷新同步
				case EGateCommand._ECmdGatePetSkillRandDaily:
					var bool:SPublicBool = mb.messageBase as SPublicBool;
					Cache.instance.pet.canFreeFreshSkill = bool.publicBool;
					NetDispatcher.dispatchCmd(ServerCommand.PetFreshSkillBook,null);
					break;
			}
			
		}
		
		/**
		 * 更新宠物属性 
		 * 
		 */		
		public function updateAttributes(attributes:SSeqAttributeUpdate):String
		{
			var petUid:String;
			for each(var attribute:SAttributeUpdate in attributes.updates)
			{
				var ary:Array = attribute.valueStr.split("#");
				petUid = ary[0];
				var pet:SPet = Cache.instance.pet.getSpetByUid(petUid);
				if(!pet)
				{
					continue;
				}
				switch(attribute.attribute.value())
				{
					case EEntityAttribute._EAttributePetState:
						pet.publicPet.state = attribute.value;
						if (pet.publicPet.state == EPetState._EPetStateActive)
							Cache.instance.pet.fightPetUid = pet.publicPet.uid;
						NetDispatcher.dispatchCmd(ServerCommand.PetStateUpdate,pet);
						break;
					case EEntityAttribute._EAttributeFightMode:
						Cache.instance.pet.fightMode = attribute.value;
						NetDispatcher.dispatchCmd(ServerCommand.PetModeUpdate,pet);
						break;
					case EEntityAttribute._EAttributePetLifespan:
						pet.publicPet.lifeSpan = attribute.value;
						break;
					case EEntityAttribute._EAttributeLife:
						pet.publicPet.life = attribute.value;
						if (pet.publicPet.life == 0)
							NetDispatcher.dispatchCmd(ServerCommand.PetDead,pet);
						break;
					case EEntityAttribute._EAttributeMaxLife:
						pet.baseFight.maxLife = attribute.value;
						break;
					case EEntityAttribute._EAttributePetGrowth:
						if(pet.publicPet.growth > attribute.value)
						{
							MsgManager.showRollTipsMsg("提升失败");
						}
						else
						{
							MsgManager.showRollTipsMsg("提升成功");
						}
						pet.publicPet.growth = attribute.value;
						break;
					case EEntityAttribute._EAttributePetGrowthMax:
						pet.publicPet.growthMax = attribute.value;
						break;
					case EEntityAttribute._EAttributeExperience:
						pet.publicPet.experience = Number(ary[1]);
						break;
					case EEntityAttribute._EAttributeLevel:
						pet.publicPet.level = attribute.value;
						var selfPet:EntityInfo = Cache.instance.entity.getSelfPet();
						if(selfPet)
						{
							selfPet.updateLevel(attribute.value);
							NetDispatcher.dispatchCmd(ServerCommand.PetFightPetUpdate,pet);
						}
						break;
					case EEntityAttribute._EAttributePetGrowth:
						pet.publicPet.growth = attribute.value;
						break;
					case EEntityAttribute._EAttributePetName:
						pet.publicPet.name = ary[1];
						selfPet = Cache.instance.entity.getSelfPet();
						if(selfPet)
						{
							selfPet.updateName(ary[1]);
							NetDispatcher.dispatchCmd(ServerCommand.PetFightPetUpdate,pet);
						}
						break;
					case EEntityAttribute._EAttributePetBlood:
						pet.publicPet.blood = ary[1];
						break;
				}
			}
			Log.error(petUid != null && petUid != "", "petUid=" + petUid + ", uid同步错误，服务端请检查");
			return petUid;
		}
		
		
		private function updateSkill(petSkillUpdate:SPetSkillUpdate):void
		{
			var cache:PetCache = Cache.instance.pet;
			switch(petSkillUpdate.op)
			{
				case ESkillUpdateType._ESkillUpdateTypeAdd:
				case ESkillUpdateType._ESkillUpdateTypeUpdate:
				case ESkillUpdateType._ESkillUpdateTypeUpgrade:
					cache.updatePetSkill(petSkillUpdate.petUid, petSkillUpdate.skill);
					break;
				case ESkillUpdateType._ESkillUpdateTypeRemove:
					cache.removePetSkill(petSkillUpdate.petUid, petSkillUpdate.skill.pos);
					break;
			}
		}
	}
}