/**
 * 2014-4-14
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TTaskDrama;
	
	import com.mui.controls.Alert;
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaBossAction implements ITaskDramaStepCommand
	{
		public function TaskDramaBossAction()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			var boss:MonsterPlayer = this.getBossByCode(data.entity);
			var repeat:Boolean = (data.valueOne == 1);
			if(boss != null)
			{
				boss.playAction(data.talkText, repeat, data.valueTwo, bossActionEnd);
			}
			else
			{
				Alert.show("没找到对应的boss：" + data.entity);
				bossActionEnd();
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