/**
 * 2014-3-6
 * @author chenriji
 **/
package mortal.game.net.command.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.STaskRemove;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class TaskCanGetDelCommand extends BroadCastCall
	{
		public function TaskCanGetDelCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var task:STaskRemove = mb.messageBase as STaskRemove;
			Cache.instance.task.delTaskCanGet(task.taskCode);
			NetDispatcher.dispatchCmd(ServerCommand.TaskCanGetDel, task.taskCode);
		}
	}
}