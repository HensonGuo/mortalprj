/**
 * @heartspeak
 * 2014-3-17 
 */   	

package mortal.game.view.mainUI.petAvatar
{
	import Message.Game.SPet;
	import Message.Game.SPetUpdate;
	import Message.Public.EPetState;
	import Message.Public.EUpdateType;
	
	import mortal.game.events.DataEvent;
	import mortal.game.model.vo.pet.PetChangeModeVO;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.mainUI.avatar.PetAvatar;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class PetAvatarController extends Controller
	{
		protected var _petAvatar:PetAvatarView;
		
		//关联的宠物
		protected var _pet:SPet;
		
		public function PetAvatarController()
		{
			super();
		}
		
		override protected function initView():IView
		{
			if(!_petAvatar)
			{
				_petAvatar = new PetAvatarView();
			}
			return _petAvatar;
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.PetFightPetUpdate,onFightPetUpdate);
			NetDispatcher.addCmdListener(ServerCommand.PetStateUpdate,onUpdatePet);
			NetDispatcher.addCmdListener(ServerCommand.PetModeUpdate,onUpdatePet);
			NetDispatcher.addCmdListener(ServerCommand.PetAddOrRemove,onPetAddOrRemove);
			NetDispatcher.addCmdListener(ServerCommand.PetDead,onPetDead);
			NetDispatcher.addCmdListener(ServerCommand.PetInfoUpdate,onPetInfoUpdate);
			
			Dispatcher.addEventListener(EventName.SceneAddSelfPet,onAddSelfPet);
			Dispatcher.addEventListener(EventName.PetChangeMode,onChangePetMode);
		}
		
		/**
		 * 宠物更新 
		 * 
		 */
		protected function onPetInfoUpdate(obj:Object):void
		{
			for (var i:int = 0; i < cache.pet.pets.length; i++)
			{
				var fightPet:SPet =  cache.pet.pets[i] as SPet;
				if(fightPet.publicPet.state == EPetState._EPetStateActive)
				{
					 onFightPetUpdate(fightPet); 
				}
			}
		}
		
		/**
		 * 出战宠物更新 
		 * 
		 */
		protected function onFightPetUpdate(pet:SPet):void
		{
			if(pet)
			{
				(view as PetAvatarView).updatePet(pet);
				_pet = pet;
				view.show();
				var petEntityInfo:EntityInfo = cache.entity.getEntityInfoById(pet.publicPet.entityId);
				if(petEntityInfo)
				{
					(view as PetAvatarView).updateEntityInfo(petEntityInfo);
				}
			}
		}
		
		/**
		 * 宠物战斗模式或者跟随状态更新 
		 * @param pet
		 * 
		 */		
		protected function onUpdatePet(pet:SPet):void
		{
			//更新出战宠物
			if(pet.publicPet.state == EPetState._EPetStateActive)
			{
				onFightPetUpdate(pet);
			}
			else
			{
				//更新当前宠物的信息
				if(_pet && pet.publicPet.uid == _pet.publicPet.uid)
				{
					(view as PetAvatarView).updatePet(pet);
				}
			}
		}
		
		/**
		 * 宠物移除 
		 * @param e
		 * 
		 */
		protected function onPetAddOrRemove(petUpdate:SPetUpdate):void
		{
			if(petUpdate.updateType == EUpdateType._EUpdateTypeDel)
			{
				if (_pet && _pet.publicPet.uid == petUpdate.uid)
					view.hide();
			}
		}
		
		/**
		 * 宠物死亡
		 * @param pet
		 * 
		 */
		protected function onPetDead(pet:SPet):void
		{
			if (pet.publicPet.uid != cache.pet.fightPetUid)
				return;
			(view as PetAvatarView).onPetDead();
		}
		
		/**
		 * 场景添加自己的宠物 
		 * @param e
		 * 
		 */
		protected function onAddSelfPet(e:DataEvent):void
		{
			view.show();
			var entityInfo:EntityInfo = e.data as EntityInfo;
			(view as PetAvatarView).updateEntityInfo(entityInfo);
		}
		
		/**
		 * 修改宠物的战斗模式 
		 * @param e
		 * 
		 */
		protected function onChangePetMode(e:DataEvent):void
		{
			var petChangeMode:PetChangeModeVO = e.data as PetChangeModeVO;
			GameProxy.pet.setPetMode(petChangeMode.petUid,petChangeMode.type);
		}
	}
}