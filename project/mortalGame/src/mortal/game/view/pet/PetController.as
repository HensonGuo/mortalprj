/**
 * @heartspeak
 * 2014-2-24 
 */   	

package mortal.game.view.pet
{
	import Message.Game.SPet;
	import Message.Game.SPetUpdate;
	import Message.Game.SSeqPet;
	import Message.Public.EPetState;
	import Message.Public.EUpdateType;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.events.DataEvent;
	import mortal.game.model.vo.pet.PetChangeNameVO;
	import mortal.game.model.vo.pet.PetOutOrInVO;
	import mortal.game.model.vo.pet.PetUpdateBloodVO;
	import mortal.game.model.vo.pet.PetUpdateGrowthVO;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.pet.view.PetFreshSkillBookPanel;
	import mortal.game.view.pet.view.PetOpenEggWindow;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.events.ViewEvent;
	import mortal.mvc.interfaces.IView;
	
	public class PetController extends Controller
	{
		private var _petModule:PetModule;
		private var _isGetPet:Boolean = false;
		
		public function PetController()
		{
			super();
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.PetOutOrIn,onPetOutOrIn);
			Dispatcher.addEventListener(EventName.PetOutOrInByShortCut, onPetOutOrInByShortCut);
			Dispatcher.addEventListener(EventName.PetDeletePet,onPetDeletePet);
			Dispatcher.addEventListener(EventName.PetChangeName,onPetChangeName);
			Dispatcher.addEventListener(EventName.PetUpdateGrowth,onPetUpdateGrowth);
			Dispatcher.addEventListener(EventName.PetUpdateBlood,onPetUpdateBlood);
			
			Dispatcher.addEventListener(EventName.PetLearnSkill,onPetLearnSkill);
			Dispatcher.addEventListener(EventName.PetSealSkill,onPetSealSkill);
			Dispatcher.addEventListener(EventName.PetUnsealSkill,onPetUnSealSkill);
			Dispatcher.addEventListener(EventName.PetFreshSkillBook,onFreshSkillBook);
			Dispatcher.addEventListener(EventName.PetGetSkillBook,onGetSkillBook);
			Dispatcher.addEventListener(EventName.PetChangeSkillPos,onPetSkillChangePos);
			Dispatcher.addEventListener(EventName.PetSkillBookOpen,onOpenFreshSkillBookPanel);
			
			NetDispatcher.addCmdListener(ServerCommand.PetAddOrRemove,onPetAddOrRemove);
		}
		
		override protected function initView():IView
		{
			if(!_petModule)
			{
				_petModule = new PetModule();
				_petModule.addEventListener(WindowEvent.SHOW,onViewShow);
				_petModule.addEventListener(WindowEvent.CLOSE,onViewHide);
			}
			return _petModule;
		}
		
		//打开宠物界面 添加事件监听
		protected function onViewShow(e:Event):void
		{
			if(!_isGetPet)
			{
				GameProxy.pet.getPlayerPetInfo();
				_isGetPet = true;
			}
			
			NetDispatcher.addCmdListener(ServerCommand.PetInfoUpdate,onPetInfoUpdate);
			NetDispatcher.addCmdListener(ServerCommand.PetAttributeUpdate,onPetAttributeUpdate);
		}
		
		//关闭宠物界面  销毁事件监听
		protected function onViewHide(e:Event):void
		{
			NetDispatcher.removeCmdListener(ServerCommand.PetInfoUpdate,onPetInfoUpdate);
			NetDispatcher.removeCmdListener(ServerCommand.PetAttributeUpdate,onPetAttributeUpdate);
		}
		
		/**
		 * 更新宠物信息 
		 * @param pet
		 * 
		 */
		protected function onPetInfoUpdate(obj:Object):void
		{
			_petModule.updatePets(cache.pet.pets);
		}
		
		/**
		 * 更新宠物Uid 
		 * @param uid
		 * 
		 */		
		private function onPetAttributeUpdate(uid:String):void
		{
			_petModule.updatePetAttribute(uid);
		}
		
		/**
		 * 宠物出战或者回收 
		 * @param e
		 * 
		 */
		protected function onPetOutOrIn(e:DataEvent):void
		{
			var petOutOrIn:PetOutOrInVO = e.data as PetOutOrInVO;
			GameProxy.pet.setPetState(petOutOrIn.petUid,petOutOrIn.type);
		}
		
		/**
		 * 快捷键宠物出战或者回收 
		 * 
		 */
		protected function onPetOutOrInByShortCut(e:DataEvent):void
		{
			var hasPetFight:Boolean = cache.pet.hasPetFight();
			if (hasPetFight)
			{
				GameProxy.pet.setPetState(cache.pet.fightPetUid,EPetState._EPetStateIdle);
			}
			else
			{
				if (cache.pet.fightPetUid != "")
					GameProxy.pet.setPetState(cache.pet.fightPetUid,EPetState._EPetStateActive);
				else
					GameProxy.pet.setPetState(cache.pet.getHighestLevelPetUid(),EPetState._EPetStateActive);
			}
		}
		
		/**
		 * 宠物放生 
		 * @param e
		 * 
		 */		
		protected function onPetDeletePet(e:DataEvent):void
		{
			var petUid:String = e.data as String;
			GameProxy.pet.setPetState(petUid,EPetState._EPetStateRelease);
		}
		
		/**
		 * 宠物修改名
		 * @param e
		 * 
		 */
		protected function onPetChangeName(e:DataEvent):void
		{
			var changeName:PetChangeNameVO = e.data as PetChangeNameVO;
			GameProxy.pet.setName(changeName.petUid,changeName.name);
		}
		
		/**
		 * 宠物提升成长
		 * @param e
		 * 
		 */
		protected function onPetUpdateGrowth(e:DataEvent):void
		{
			var vo:PetUpdateGrowthVO = e.data as PetUpdateGrowthVO;
			GameProxy.pet.updateGrowth(vo.petUid,vo.isAutoBuy,vo.count,vo.target);
		}
		
		/**
		 * 宠物提升血脉
		 * @param e
		 * 
		 */
		protected function onPetUpdateBlood(e:DataEvent):void
		{
			var vo:PetUpdateBloodVO = e.data as PetUpdateBloodVO;
			GameProxy.pet.updateBlood(vo.petUid,vo.blood,vo.isTenTimesUpdate?10:1,vo.isAutoBuyItems);
		}
		
		/**
		 * 获得或者删除一个宠物
		 * @param e
		 * 
		 */		
		protected function onPetAddOrRemove(petUpdate:SPetUpdate):void
		{
			if(petUpdate.updateType == EUpdateType._EUpdateTypeAdd)
			{
				PetOpenEggWindow.instance.updatePet(petUpdate.petsBaseInfo[0] as SPet);
			}
		}
		
		/**
		 * 学习技能
		 * @param e
		 */		
		protected function onPetLearnSkill(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.pet.learnSkill(obj.petuid, obj.skillbookuid);
		}
		
		/**
		 * 封印技能
		 * @param e
		 */		
		protected function onPetSealSkill(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.pet.sealSkill(obj.petuid, obj.skillID);
		}
		
		/**
		 * 解封技能
		 * @param e
		 */		
		protected function onPetUnSealSkill(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.pet.unsealSkill(obj.petuid, obj.fromPos, obj.toPos);
		}
		
		/**
		 * 技能位置更改
		 * @param e
		 */		
		protected function onPetSkillChangePos(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.pet.updateSkillPos(obj.petuid, obj.skillID, obj.toPos);
		}
		
		/**
		 * 刷新宠物技能书
		 * @param e
		 */		
		protected function onFreshSkillBook(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.pet.randPetSkill(obj.itemuid, obj.times, obj.onlyUseBindGold, obj.isFree);
		}
		
		/**
		 * 获取宠物技能书
		 * @param e
		 */		
		protected function onGetSkillBook(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.pet.getRandPetSkill(obj.itemuid, obj.skillBookCode);
		}
		
		/**
		 * 获取宠物技能书刷新界面
		 * @param e
		 */	
		protected function onOpenFreshSkillBookPanel(e:DataEvent):void
		{
			PetFreshSkillBookPanel.instance.setData(e.data as ItemData);
			PetFreshSkillBookPanel.instance.show();
		}
	}
}