/**
 * 2014-4-14
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.NPCPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaNpcTalk implements ITaskDramaStepCommand
	{
		private var _callback:Function;
		private var timerId:int = -1;
		
		public function TaskDramaNpcTalk()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			var npc:IEntity = ThingUtil.npcUtil.getNpc(data.talkNpc);
			if(npc == null)
			{
				// 没配置npc，则自己说话
				npc = RolePlayer.instance;
			}
			if(npc != null)
			{
				LayerManager.entityTalkLayer.addTalk(npc, data.talkText, 5000);
				timerId = setTimeout(talkFinished, 5500);
			}
		}
		private function talkFinished():void
		{
			timerId = -1;
			if(_callback != null)
			{
				_callback.apply();
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			var npc:IEntity = ThingUtil.npcUtil.getNpc(data.talkNpc);
			if(npc == null)
			{
				npc = RolePlayer.instance;
			}
			if(npc != null)
			{
				LayerManager.entityTalkLayer.removeTalk(npc);
			}
			if(timerId > 0)
			{
				clearTimeout(timerId);
				timerId = -1;
			}
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
		
		public function dispose():void
		{
			if(timerId > 0)
			{
				clearTimeout(timerId);
				timerId = -1;
			}
		}
	}
}