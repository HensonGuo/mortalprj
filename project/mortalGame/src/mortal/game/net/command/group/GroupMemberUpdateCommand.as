package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import Message.BroadCast.SEntityUpdate;
	import Message.Public.EEntityAttribute;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SEntityId;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class GroupMemberUpdateCommand extends BroadCastCall
	{
		public function GroupMemberUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GroupMemberUpdateCommand");
			var msg:SEntityUpdate = mb.messageBase as SEntityUpdate;
			
			for each(var attUpdate:SAttributeUpdate in msg.propertyUpdates)
			{
				entityInfoUpdate(attUpdate , msg.entityId);
			}
		}
		
		private function entityInfoUpdate(attUpdate:SAttributeUpdate , entityId:SEntityId):void
		{
			var obj:Object = new Object();
			switch( attUpdate.attribute.__value )
			{
				case EEntityAttribute._EAttributeGroupMemberOnline	:   //玩家在线
					obj = {"type":EEntityAttribute._EAttributeGroupMemberOnline	 , "value":attUpdate.value , "id":entityId.id};
					NetDispatcher.dispatchCmd(ServerCommand.updateTeamMateState,obj);
					break;
				case EEntityAttribute._EAttributeGroupMemberAttacked:   //玩家受攻击
					obj = {"type":EEntityAttribute._EAttributeGroupMemberAttacked	 , "value":attUpdate.value , "id":entityId.id};
					NetDispatcher.dispatchCmd(ServerCommand.updateTeamMateState,obj);
					break;
				case EEntityAttribute._EAttributeSpaceId:   //玩家位置
					obj = {"type":EEntityAttribute._EAttributeSpaceId	 , "value":attUpdate.value , "id":entityId.id};
					NetDispatcher.dispatchCmd(ServerCommand.updateTeamMateState,obj);
					break;
			}
		}
	}
}