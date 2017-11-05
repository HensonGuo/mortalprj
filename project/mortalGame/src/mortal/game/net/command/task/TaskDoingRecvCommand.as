/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.net.command.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SSeqPlayerTask;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class TaskDoingRecvCommand extends BroadCastCall
	{
		public function TaskDoingRecvCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var tasks:SSeqPlayerTask = mb.messageBase as SSeqPlayerTask;
			Cache.instance.task.initTaskDoing(tasks.playerTasks);
			NetDispatcher.dispatchCmd(ServerCommand.TaskDoingRecv, tasks.playerTasks);
		}
	}
}