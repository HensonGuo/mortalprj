/**
 * 2014-3-27
 * @author chenriji
 **/
package mortal.game.view.skill.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.ERuneUpdateType;
	import Message.Public.SRuneUpdate;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class RuneUpdateCommand extends BroadCastCall
	{
		public function RuneUpdateCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var data:SRuneUpdate = mb.messageBase as SRuneUpdate;
			switch(data.op)
			{
				case ERuneUpdateType._ERuneUpdateTypeAdd:
					Cache.instance.skill.addRune(data.runeId);
					NetDispatcher.dispatchCmd(ServerCommand.RuneAdd, data.runeId);
					break;
				case ERuneUpdateType._ERuneUpdateTypeRemove:
					Cache.instance.skill.removeRune(data.runeId);
					NetDispatcher.dispatchCmd(ServerCommand.RuneRemove, data.runeId);
					break;
				case ERuneUpdateType._ERuneUpdateTypeUpdate:
					Cache.instance.skill.runeUpgrade(data.runeId);
					NetDispatcher.dispatchCmd(ServerCommand.RuneLevelUp, data.runeId);
					break;
			}
		}
	}
}