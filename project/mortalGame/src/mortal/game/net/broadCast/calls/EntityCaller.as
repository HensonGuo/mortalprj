package mortal.game.net.broadCast.calls
{
	import Framework.MQ.MessageBlock;
	
	import Message.BroadCast.SEntityInfo;
	import Message.BroadCast.SEntityMoveInfo;
	import Message.BroadCast.SSeqEntityInfo;
	import Message.Command.ECmdBroadCast;
	import Message.Public.SEntityId;
	
	import mortal.game.Game;
	import mortal.game.mvc.GameController;
	import mortal.game.net.broadCast.BroadCastCall;

	public class EntityCaller extends BroadCastCall
	{
		public function EntityCaller( type:String )
		{
			super(type);
		}
		
		override public function call( mb:MessageBlock ):void
		{
			if( ECmdBroadCast.convert( mb.messageHead.command ) == null ) return;
			
			switch( mb.messageHead.command )
			{
				case ECmdBroadCast.ECmdBroadcastEntityInfo.value(): //个体信息 10001
				{
					GameController.scene.addEntity(mb.messageBase as SEntityInfo);
					break;
				}
				case ECmdBroadCast.ECmdBroadcastEntityInfos.value(): // 多个实体信息 10002
				{
					GameController.scene.addEntitys((mb.messageBase as SSeqEntityInfo).entityInfos); 
					break;
				}
				case ECmdBroadCast.ECmdBroadcastEntityMoveInfo.value()://移动信息 10003
				{
					var moveInfo:SEntityMoveInfo = mb.messageBase as SEntityMoveInfo;
					GameController.scene.moveEntity(moveInfo.entityId , moveInfo.points);
					break;
				}
				case ECmdBroadCast.ECmdBroadcastEntityLeftInfo.value()://个人离开 10004
				{
					var seid:SEntityId = mb.messageBase as SEntityId;
					GameController.scene.removeEntity( seid );
					break;
				}
				case ECmdBroadCast.ECmdBroadcastEntityAttributeUpdate.value()://个体属性更新 10005
				{
					break;
				}
				case ECmdBroadCast.ECmdBroadcastEntityAttributeUpdates.value()://个体属性批量更新 10006
				{
					break;
				}
			}
		}
	}
}