/**
 * 2014-1-14
 * @author chenriji
 **/
package mortal.game.net.command.skill
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.ESkillUpdateType;
	import Message.Public.SSkillUpdate;
	
	import extend.language.Language;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.skill.SkillCache;
	import mortal.mvc.core.NetDispatcher;
	
	public class SkillUpdateCommand extends BroadCastCall
	{
		public function SkillUpdateCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var data:SSkillUpdate = mb.messageBase as SSkillUpdate;
			var cache:SkillCache = Cache.instance.skill;
			switch(data.op)
			{
				case ESkillUpdateType._ESkillUpdateTypeAdd:
					cache.addPlayerSkill(data.skill);
					MsgManager.showRollTipsMsg(Language.getString(20057));
					NetDispatcher.dispatchCmd(ServerCommand.SkillAdd, data.skill);
					break;
				case ESkillUpdateType._ESkillUpdateTypeRemove:
					cache.delPlayerSkill(data.skill.skillId);
					NetDispatcher.dispatchCmd(ServerCommand.SkillRemove, data.skill);
					break;
				case ESkillUpdateType._ESkillUpdateTypeUpdate:
					cache.updatePlayerSkill(data.skill);
					NetDispatcher.dispatchCmd(ServerCommand.SkillUpdate, data.skill);
					break;
				case ESkillUpdateType._ESkillUpdateTypeUpgrade:
					cache.upgradePlayerSkill(data.skill);
					MsgManager.showRollTipsMsg(Language.getString(20058));
					NetDispatcher.dispatchCmd(ServerCommand.SkillUpgrade, data.skill);
					break;
			}
		}
	}
}