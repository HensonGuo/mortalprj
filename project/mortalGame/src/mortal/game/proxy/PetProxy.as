/**
 * @heartspeak
 * 2014-2-19 
 */   	

package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IPet_getPetInfo;
	import Message.Game.AMI_IPet_getPlayerPetInfo;
	import Message.Game.AMI_IPet_getRandPetSkill;
	import Message.Game.AMI_IPet_learnSkill;
	import Message.Game.AMI_IPet_randPetSkill;
	import Message.Game.AMI_IPet_refreshGrowth;
	import Message.Game.AMI_IPet_sealPetSkill;
	import Message.Game.AMI_IPet_setName;
	import Message.Game.AMI_IPet_setPetMode;
	import Message.Game.AMI_IPet_setPetState;
	import Message.Game.AMI_IPet_unsealPetSkill;
	import Message.Game.AMI_IPet_upgradeBlood;
	import Message.Game.SPet;
	import Message.Public.EPetMode;
	import Message.Public.EPetState;
	
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.GameConst;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	public class PetProxy extends Proxy
	{
		public function PetProxy()
		{
			super();
		}
		
		/**
		 * 获取玩家宠物信息 
		 * 
		 */		
		public function getPlayerPetInfo():void
		{
			rmi.iPetPrx.getPlayerPetInfo_async( new AMI_IPet_getPlayerPetInfo());
		}
		
		/**
		 * 设置宠物出战状态  出战或者收回或者放生宠物
		 * @param uid
		 * @param state
		 * 
		 */
		public function setPetState(uid:String,state:int):void
		{
			var pet:SPet = cache.pet.getSpetByUid(uid);
			if(state == EPetState._EPetStateActive && pet.publicPet.life <= 0)
			{
				RolePlayer.instance.stopWalkSendPoint();
				AIManager.cancelAll();
				GameProxy.sceneProxy.fight([],GameConst.PetSummonSkill,null,0,uid);
			}
			else
			{
				rmi.iPetPrx.setPetState_async( new AMI_IPet_setPetState(),uid,new EPetState(state));	
			}
		}
		
		/**
		 * 设置宠物 战斗模式
		 * @param uid
		 * @param mode
		 * 
		 */		
		private var _setUID:String;
		private var _setMode:int;
		
		public function setPetMode(uid:String,mode:int):void
		{
			_setUID = uid;
			_setMode = mode;
			rmi.iPetPrx.setPetMode_async( new AMI_IPet_setPetMode(setPetModeSuccess),uid,new EPetMode(mode));
		}
		
		private function setPetModeSuccess(e:AMI_IPet_setPetMode):void
		{
			cache.pet.fightMode = _setMode;
			var pet:SPet =  cache.pet.getSpetByUid(_setUID);
			NetDispatcher.dispatchCmd(ServerCommand.PetModeUpdate,pet);
		}
		
		/**
		 * 设置宠物名字 
		 * @param uid
		 * @param name
		 * 
		 */		
		public function setName(uid:String,name:String):void
		{
			rmi.iPetPrx.setName_async( new AMI_IPet_setName(),uid,name);
		}
		
		/**
		 * 获取玩家宠物信息
		 * 
		 */		
		public function getPetInfo(playerId:int,uids:Array):void
		{
			rmi.iPetPrx.getPetInfo_async(new AMI_IPet_getPetInfo(),playerId,uids);
		}
		
		/**
		 * 提升成长 
		 * 
		 */		
		public function updateGrowth(petUid:String,autoBuy:Boolean,count:int = 1,target:int = 0):void
		{
			rmi.iPetPrx.refreshGrowth_async( new AMI_IPet_refreshGrowth(),petUid,autoBuy,count,target);
		}
		
		/**
		 * 提升血脉 
		 * @param petUid uid
		 * @param blood  血脉编号
		 * @param items	 物品数组 暂时不用
		 * @param count	0为道具提升 1为元宝提升
		 * 
		 */
		public function updateBlood(petUid:String,blood:int,count:int = 0, autoBuy:Boolean = false):void
		{
			rmi.iPetPrx.upgradeBlood_async(new AMI_IPet_upgradeBlood(),petUid,blood,count,autoBuy);
		}
		
		/**
		 * 添加宠物寿命   待定
		 * 
		 */		
		public function addLifespan(uid:String):void
		{
			
		}
		
		
		
		
		/**
		 *技能学习
		 * @param petUid uid
		 * @param skillBookUid
		 */		
		public function learnSkill(uid:String, skillBookUid:String):void
		{
			rmi.iPetPrx.learnSkill_async(new AMI_IPet_learnSkill(), uid, skillBookUid);
		}
		
		/**
		 *技能封印
		 * @param petUid uid
		 * @param skillID
		 */		
		public function sealSkill(uid:String, skillID:int):void
		{
			rmi.iPetPrx.sealPetSkill_async(new AMI_IPet_sealPetSkill(), uid, skillID);
		}
		
		/**
		 *解除技能封印
		 * @param petUid uid
		 * @param fromPos
		 * @param toPos
		 */		
		public function unsealSkill(uid:String, fromPos:int, toPos:int):void
		{
			rmi.iPetPrx.unsealPetSkill_async(new AMI_IPet_unsealPetSkill(), uid, fromPos, toPos);
		}
		
		/**
		 *刷新宠物技能位置
		 * @param petUid uid
		 * @param skillID
		 * @param pos
		 */		
		public function updateSkillPos(uid:String, skillid:int, pos:int):void
		{
			rmi.iPetPrx.unsealPetSkill_async(new AMI_IPet_unsealPetSkill(), uid, skillid, pos);
		}
		
		/**
		 *刷新宠物技能位置
		 * @param    itemUid  物品uid
		 * @param	time	 刷新次数
		 * @return   codes	 技能书code
		 */		
		public function randPetSkill(itemUid:String, times:int, onlyUseBindGold:Boolean, isFree:Boolean = false):void
		{
			rmi.iPetPrx.randPetSkill_async(new AMI_IPet_randPetSkill(randPetSkillSuccess, randPetSkillFail), itemUid, times, onlyUseBindGold, isFree);
		}
		
		private function randPetSkillSuccess(e:AMI_IPet_randPetSkill, codes:Array):void
		{
			MsgManager.showRollTipsMsg("刷新成功");
			NetDispatcher.dispatchCmd(ServerCommand.PetFreshSkillBook,null);
		}
		
		private function randPetSkillFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("刷新失败");
		}
		
		
		/**
		 *获取随机宠物技能
		 * @param    itemUid  物品uid
		 * @return   skillIds 技能id
		 */		
		public function getRandPetSkill(yihunshiUid:String, skillBookCode:int):void
		{
			rmi.iPetPrx.getRandPetSkill_async(new AMI_IPet_getRandPetSkill(getRandPetSkillSuccess, getRandPetSkillFail), yihunshiUid, skillBookCode);
		}
		
		private function getRandPetSkillSuccess(e:AMI_IPet_getRandPetSkill):void
		{
			MsgManager.showRollTipsMsg("成功获得");
			NetDispatcher.dispatchCmd(ServerCommand.PetGetSkillBook,null);
		}
		
		private function getRandPetSkillFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("获取失败");
		}
	}
}