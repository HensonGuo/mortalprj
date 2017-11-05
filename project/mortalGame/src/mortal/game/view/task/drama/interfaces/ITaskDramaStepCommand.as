package mortal.game.view.task.drama.interfaces
{
	import Message.DB.Tables.TTaskDrama;
	
	public interface ITaskDramaStepCommand
	{
		function call(data:TTaskDrama, callback:Function=null):void;
		function cancel(data:TTaskDrama, callback:Function=null):void;
//		function dispose():void;
	}
}