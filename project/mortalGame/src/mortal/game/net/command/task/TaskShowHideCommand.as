/**
 * 2014-4-8
 * @author chenriji
 **/
package mortal.game.net.command.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.STaskShowMsg;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class TaskShowHideCommand extends BroadCastCall
	{
		public function TaskShowHideCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var msg:STaskShowMsg = mb.messageBase as STaskShowMsg;
			Cache.instance.npc.updateShows(msg);
			NetDispatcher.dispatchCmd(ServerCommand.TaskNpcShowHideUpdate, msg);
		}
	}
}