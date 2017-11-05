/**
 * 2014-4-29
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaDelay implements ITaskDramaStepCommand
	{
		private var _timerId:int = -1;
		private var _callback:Function;
		public function TaskDramaDelay()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			if(_timerId > 0)
			{
				clearTimeout(_timerId);
				_timerId = -1;
			}
			_timerId = setTimeout(timeOut, data.valueOne);
		}
		
		private function timeOut():void
		{
			_timerId = -1;
			if(_callback != null)
			{
				_callback.apply();
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			if(_timerId > 0)
			{
				clearTimeout(_timerId);
				_timerId = -1;
			}
			if(_callback != null)
			{
				_callback.apply();
			}
		}
		
		public function dispose():void
		{
		}
	}
}