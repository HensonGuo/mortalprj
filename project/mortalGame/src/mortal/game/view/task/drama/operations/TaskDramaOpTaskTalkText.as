/**
 * 2014-4-11
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import flash.utils.setTimeout;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaOpTaskTalkText implements ITaskDramaStepCommand
	{
		public function TaskDramaOpTaskTalkText()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			MsgManager.showTaskTarget(data.talkText, 5);
			setTimeout(finished, 5000);
			function finished():void
			{
				if(callback != null)
				{
					callback.apply();
				}
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
		}
		
		public function dispose():void
		{
		}
	}
}