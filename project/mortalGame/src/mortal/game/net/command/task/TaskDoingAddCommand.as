/**
 * 2014-3-6
 * @author chenriji
 **/
package mortal.game.net.command.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.STaskAdd;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class TaskDoingAddCommand extends BroadCastCall
	{
		public function TaskDoingAddCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var task:STaskAdd = mb.messageBase as STaskAdd;
			Cache.instance.task.addTaskDoing(task.playerTask);
			NetDispatcher.dispatchCmd(ServerCommand.TaskDoingAdd, task.playerTask.task.code);
		}
	}
}