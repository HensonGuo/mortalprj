package mortal.game.net.command.player
{
	import Framework.MQ.MessageBlock;
	
	import Message.BroadCast.SEntityInfo;
	import Message.Game.SRole;
	import Message.Public.EEntityAttribute;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SFightAttribute;
	import Message.Public.SSeqAttributeUpdate;
	
	import com.gengine.debug.Log;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class BroadcastEntityAttUpdateCommand extends BroadCastCall
	{
		public function BroadcastEntityAttUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive BroadcastEntityAttributeUpdateCommand");
			var sFightAttribute:SFightAttribute = Cache.instance.role.fightAttribute;
			var sRole:SRole = Cache.instance.role.roleInfo;
			var updates:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
			var attUpdate:SAttributeUpdate;
			for each(  attUpdate in updates.updates  )
			{
				switch( attUpdate.attribute.__value )
				{
					case EEntityAttribute._EAttributeLife:           //生命值更新
					{
						sRole.life = attUpdate.value;
						NetDispatcher.dispatchCmd( ServerCommand.LifeUpdate,null);
						break;
					}
					case EEntityAttribute._EAttributeLifeAdd:       //生命值增加
					{
						sRole.life += attUpdate.value;
						NetDispatcher.dispatchCmd( ServerCommand.LifeUpdate,null);
						break;
					}
					case EEntityAttribute._EAttributeMana:           //魔法值更新
					{
						sRole.mana = attUpdate.value;
						NetDispatcher.dispatchCmd( ServerCommand.ManaUpdate,null);
						break;
					}
					case EEntityAttribute._EAttributeManaAdd:           //魔法值增加
					{
						sRole.mana += attUpdate.value;
						NetDispatcher.dispatchCmd( ServerCommand.ManaUpdate,null);
						break;
					}
					case EEntityAttribute._EAttributeStamina:           //体力更新
					{
						break;
					}
					case EEntityAttribute._EAttributeMaxLife:          //最大生命值
					{
						sFightAttribute.maxLife = attUpdate.value;
						NetDispatcher.dispatchCmd( ServerCommand.ManaUpdate,null);
						break;
					}
					case EEntityAttribute._EAttributeMaxMana:           //最大法力值
					{
						sFightAttribute.maxMana = attUpdate.value;
						NetDispatcher.dispatchCmd( ServerCommand.ManaUpdate,null);
						break;
					}
				}
			}
		}
	}
}