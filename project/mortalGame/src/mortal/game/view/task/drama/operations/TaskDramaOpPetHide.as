/**
 * 2014-4-11
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	import Message.Game.SPet;
	import Message.Public.EPetState;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.model.vo.pet.PetOutOrInVO;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskDramaOpPetHide implements ITaskDramaStepCommand
	{
		public function TaskDramaOpPetHide()
		{
		}
		
		private var _lastUid:String;
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			_lastUid = null;
			var hasFightPet:Boolean = Cache.instance.pet.hasPetFight();
			if(hasFightPet)
			{
				_lastUid = Cache.instance.pet.fightPetUid;
				var petOutOrInVO:PetOutOrInVO = new PetOutOrInVO(_lastUid, EPetState._EPetStateIdle);
				Dispatcher.dispatchEvent(new DataEvent(EventName.PetOutOrIn, petOutOrInVO));
			}
			if(callback != null)
			{
				callback.apply();
			}
			
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			if(_lastUid != null)
			{
				var petOutOrInVO:PetOutOrInVO = new PetOutOrInVO(_lastUid, EPetState._EPetStateActive);
				Dispatcher.dispatchEvent(new DataEvent(EventName.PetOutOrIn, petOutOrInVO));
			}
			else if(!Cache.instance.pet.hasPetFight())
			{
				var uid:String = Cache.instance.pet.getHighestLevelPetUid();
				if(uid != null && uid != "")
				{
					petOutOrInVO = new PetOutOrInVO(uid, EPetState._EPetStateActive);
					Dispatcher.dispatchEvent(new DataEvent(EventName.PetOutOrIn, petOutOrInVO));
				}
			}
			if(callback != null)
			{
				callback.apply();
			}
		}
		
		public function dispose():void
		{
		}
	}
}