/**
 * 2014-3-6
 * @author chenriji
 **/
package mortal.game.net.command.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SSeqTask;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class TaskCanGetAddCommand extends BroadCastCall
	{
		public function TaskCanGetAddCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var task:SSeqTask = mb.messageBase as SSeqTask;
			Cache.instance.task.addTaskCanGets(task.tasks);
			NetDispatcher.dispatchCmd(ServerCommand.TaskCanGetAdd, task.tasks);
		}
	}
}