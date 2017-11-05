package mortal.game.net.command.player
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	import Message.Public.SExtraFightAttribute;
	import Message.Public.SFightAttribute;
	import Message.Public.SSFightAttribute;
	
	import com.gengine.debug.Log;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.NetDispatcher;
	
	public class FightAttributeCommand extends BroadCastCall
	{
		/**
		 * 人物战斗最终属性更新(附加值和基础值的) 
		 * @param type
		 * 
		 */		
		public function FightAttributeCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
//			Log.debug("I have receive FightAttributeCommand");
			switch(mb.messageHead.command)
			{
				//处理扩展属性
				case EPublicCommand._ECmdPublicFightAttributeExtra:
					var extraMsg:SExtraFightAttribute = mb.messageBase as SExtraFightAttribute;
					if(extraMsg.uid)
					{
						Cache.instance.pet.updatePetFightAttribute(extraMsg);
						NetDispatcher.dispatchCmd(ServerCommand.PetAttributeUpdate,extraMsg.uid);
					}
					break;
				//处理战斗属性
				case EPublicCommand._ECmdPublicFightAttribute:
					var msg:SSFightAttribute = mb.messageBase as SSFightAttribute;
					_cache.role.fightAttribute = msg.baseFight;
					// 更改最大生命 和最大魔法
					_cache.role.roleEntityInfo.updateMaxLife(msg.baseFight.maxLife);
					_cache.role.roleEntityInfo.updateMaxMana(msg.baseFight.maxMana);
					_cache.role.roleEntityInfo.updateSpeed(msg.baseFight.speed);
					NetDispatcher.dispatchCmd(ServerCommand.RoleFightAttributeChange, _cache.role.fightAttribute);
					break;
			}
		}
	}
}