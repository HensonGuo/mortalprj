package mortal.game.net.command.player
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SFightAttribute;
	import Message.Public.SSFightAttribute;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	

	public class FightAttributeBaseCommand extends BroadCastCall
	{
		public function FightAttributeBaseCommand( type:Object )
		{
			super(type);
		}
		override public function call(mb:MessageBlock):void
		{
			var msg:SSFightAttribute = mb.messageBase as SSFightAttribute;
			if(msg.uid)
			{
				//宠物
				Cache.instance.pet.updatePetBaseAttribute(msg);
				NetDispatcher.dispatchCmd(ServerCommand.PetAttributeUpdate,msg.uid);
			}
			else
			{
				//人物
				_cache.role.fightAttributeBase = msg.baseFight;
				NetDispatcher.dispatchCmd(ServerCommand.RoleFightAttributeBaseChange, _cache.role.fightAttributeBase);
			}
		}
	}
}