/**
 * 2014-1-14
 * @author chenriji
 **/
package mortal.game.net.command.skill
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SSkillMsg;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class SkillListCommand extends BroadCastCall
	{
		public function SkillListCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var data:SSkillMsg = mb.messageBase as SSkillMsg;
			Cache.instance.skill.initSkillList(data.skills);
			
			NetDispatcher.dispatchCmd(ServerCommand.SkillListUpdate, null);
		}
	}
}