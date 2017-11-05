/**
 * 2014-4-11
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaOpNpcBubbleTalk implements ITaskDramaStepCommand
	{
		public function TaskDramaOpNpcBubbleTalk()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
		}
		
		public function dispose():void
		{
		}
	}
}