/**
 * 2014-4-14
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TTaskDrama;
	
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.NPCPlayer;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaNpcAction implements ITaskDramaStepCommand
	{
		public function TaskDramaNpcAction()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			var npc:NPCPlayer = ThingUtil.npcUtil.getNpc(data.entity);
			var repeat:Boolean = (data.valueOne == 1);
			if(npc != null)
			{
//				npc.playAction(data.talkText, repeat, data.valueTwo, bossActionEnd);
			}
			
			function bossActionEnd():void
			{
				if(callback != null)
				{
					callback.apply();
				}
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			var boss:MonsterPlayer = this.getBossByCode(data.entity);
			if(boss != null)
			{
				
			}
		}
		
		private function getBossByCode(code:int):MonsterPlayer
		{
			var all:Dictionary = ThingUtil.entityUtil.entitysMap.allEntitys;
			for each(var entity:IEntity in all)
			{
				if(entity is MonsterPlayer)
				{
					var info:TBoss = (entity as MonsterPlayer)._bossInfo;
					if(info.code == code)
					{
						return entity as MonsterPlayer;
					}
				}
			}
			return null;
		}
		
		public function dispose():void
		{
		}
	}
}