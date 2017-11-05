/**
 * 2014-2-21
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
	
	public class TaskCanGetRecvCommand extends BroadCastCall
	{
		public function TaskCanGetRecvCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var data:SSeqTask = mb.messageBase as SSeqTask;
			Cache.instance.task.initTaskCanGet(data.tasks);
			NetDispatcher.dispatchCmd(ServerCommand.TaskCanGetRecv, data.tasks);
		}
	}
}