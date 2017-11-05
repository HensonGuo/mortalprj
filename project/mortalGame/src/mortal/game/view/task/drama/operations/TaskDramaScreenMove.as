/**
 * 2014-4-11
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import mortal.game.Game;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaScreenMove implements ITaskDramaStepCommand
	{
		public function TaskDramaScreenMove()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			Game.scene.tweenScrollRect(data.valueOne, data.valueTwo, 1.0, tweenFinish1);
			function tweenFinish1():void
			{
				if(callback != null)
				{
					callback.apply();
				}
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			Game.scene.stopTweenScrollRect(1, tweenFinish2);
			function tweenFinish2():void
			{
				if(callback != null)
				{
					callback.apply();
				}
			}
		}
		
		public function dispose():void
		{
		}
	}
}