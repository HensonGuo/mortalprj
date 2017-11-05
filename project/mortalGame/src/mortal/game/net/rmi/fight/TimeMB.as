package mortal.game.net.rmi.fight
{
	import Framework.MQ.MessageBlock;
	import Framework.Serialize.SerializeStream;
	
	import Message.BroadCast.SBeginFight;
	import Message.BroadCast.SDoFight;
	import Message.BroadCast.SDoFights;
	import Message.BroadCast.SEntityInfo;
	import Message.BroadCast.SEntityMoveInfo;
	import Message.BroadCast.SEntityUpdate;
	import Message.BroadCast.SSeqEntityIdInfo;
	import Message.BroadCast.SSeqEntityInfo;
	import Message.Public.SEntityId;
	import Message.Public.SEntityIdPair;
	
	import mortal.game.scene.layer.utils.EntityUtil;
	import mortal.game.scene.player.entity.RolePlayer;

	public class TimeMB
	{
		public var time:int;
		
		public var mb:MessageBlock = new MessageBlock();
		
		public function read( os :SerializeStream ) : void
		{
			time = os.readInt();
			mb.__read(os);
			
			//将自己的角色EntityId转化为别人
			changeRoleMsg();
		}
		
		private function changeRoleMsg():void
		{
			var obj:Object = mb.messageBase;
			var entityId:SEntityId;
			var entityInfo:SEntityInfo;
			if(obj is SEntityInfo)
			{
				entityInfo = obj as SEntityInfo;
				changeRoleEntityId(entityInfo.entityId);
			}
			else if(obj is SSeqEntityInfo)
			{
				var entityInfos:Array = (obj as SSeqEntityInfo).entityInfos;
				for each(entityInfo in entityInfos)
				{
					changeRoleEntityId(entityInfo.entityId);
				}
			}
			else if(obj is SEntityMoveInfo)
			{
				changeRoleEntityId((obj as SEntityMoveInfo).entityId);
			}
			else if(obj is SEntityId)
			{
				changeRoleEntityId(obj as SEntityId);
			}
			else if(obj is SSeqEntityIdInfo)
			{
				var entityIds:Array = (obj as SSeqEntityIdInfo).entityIds;
				for each( entityId in entityIds)
				{
					changeRoleEntityId(entityId);
				}
			}
			else if(obj is SEntityUpdate)
			{
				changeRoleEntityId((obj as SEntityUpdate).entityId);
			}
			else if(obj is SBeginFight)
			{
				changeRoleEntityId((obj as SBeginFight).fromEntity);
				var toEntitys:Array = (obj as SBeginFight).toEntitys;
				for each( entityId in toEntitys)
				{
					changeRoleEntityId(entityId);
				}
			}
			else if(obj is SDoFight)
			{
				changeRoleEntityId((obj as SDoFight).entity);
				changeRoleEntityId((obj as SDoFight).fromEntity);
			}
			else if(obj is SDoFights)
			{
				for each(var dofight:SDoFight in (obj as SDoFights).doFights)
				{
					changeRoleEntityId(dofight.entity);
					changeRoleEntityId(dofight.fromEntity);
				}
			}
			else if(obj is SEntityIdPair)
			{
				changeRoleEntityId((obj as SEntityIdPair).fromEntityId);
				changeRoleEntityId((obj as SEntityIdPair).toEntityId);
			}
		}
		
		private function changeRoleEntityId(entityId:SEntityId):void
		{
			if(EntityUtil.equal(entityId,RolePlayer.instance.entityInfo.entityInfo.entityId))
			{
				entityId.id = int.MAX_VALUE;
			}
		}
	}
}