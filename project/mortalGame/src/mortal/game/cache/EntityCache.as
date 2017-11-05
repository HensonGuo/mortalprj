/**
 * @heartspeak
 * 2014-2-8 
 */   	

package mortal.game.cache
{
	import Message.BroadCast.SEntityInfo;
	import Message.BroadCast.SEntityUpdate;
	import Message.BroadCast.SSeqEntityInfo;
	import Message.BroadCast.SSeqEntityUpdate;
	import Message.Public.SEntityId;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.utils.Dictionary;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 所有除了自己人物以外的其他实体（人物、怪物、宠物）的数据缓存 
	 * @author heartspeak
	 * 
	 */	
	public class EntityCache
	{
		//实体的字典
		private var _dic:Dictionary = new Dictionary();
		//还没创建过的离线数值
		private var _offAry:Array = [];
		
		public function EntityCache()
		{
		}
		
		public function getEntityInfoById(entityId:SEntityId):EntityInfo
		{
			if(EntityUtil.equal(entityId,Cache.instance.role.roleEntityInfo.entityInfo.entityId))
			{
				return Cache.instance.role.roleEntityInfo;
			}
			return _dic[EntityUtil.toString(entityId)];
		}
		
		/**
		 * 从没创建过的列表中获取一个 
		 * @return 
		 * 
		 */
		public function getFromOffAry():EntityInfo
		{
			if(_offAry.length)
			{
				return _offAry[0] as EntityInfo;
			}
			return null;
		}
		
		/**
		 * 添加多个实体 
		 * 
		 */	
		public function addEntitys(entityInfos:SSeqEntityInfo):void
		{
			var array:Array = entityInfos.entityInfos;
			var info:SEntityInfo;
			for (var i:int=0; i < array.length; i++)
			{
				info = array[i];
				info.msgEx = entityInfos.msgEx;
				addEntity(info);
			}
		}
		
		/**
		 * 添加实体 
		 * 
		 */		
		public function addEntity(info:SEntityInfo):void
		{
			var entityInfo:EntityInfo = ObjectPool.getObject(EntityInfo) as EntityInfo;
			entityInfo.entityInfo = info;
			//队友进入
			if(EntityUtil.equal(entityInfo.entityInfo.groupId,Cache.instance.group.groupId))
			{
				Dispatcher.dispatchEvent( new DataEvent(EventName.SceneAddGroupmate,entityInfo));
			}
			//自己的宠物
			if(EntityRelationUtil.isSelfPetByEntityId(entityInfo.entityInfo.entityId))
			{
				Dispatcher.dispatchEvent( new DataEvent(EventName.SceneAddSelfPet,entityInfo));
			}
			if(_dic[EntityUtil.toString(info.entityId)] == null)
			{
				_offAry.push(entityInfo);
				_dic[EntityUtil.toString(info.entityId)] = entityInfo;	
			}
		}
		
		/**
		 * 删除多个实体 
		 * 
		 */		
		public function removeEntitys(ary:Array):void
		{
			var len:int = ary.length;
			for each (var entityId:SEntityId in ary)
			{
				removeEntity(entityId);
			}
		}
		
		/**
		 * 删除单个实体 
		 * 
		 */		
		public function removeEntity(entityId:SEntityId):void
		{
			var entityIdStr:String = EntityUtil.toString(entityId);
			var entityInfo:EntityInfo = _dic[entityIdStr];
			delete _dic[entityIdStr];
			var offIndex:int = _offAry.indexOf(entityInfo);
			if(offIndex != -1)
			{
				_offAry.splice(offIndex,1);
			}
			if(entityInfo)
			{
				//队友离开
				if(EntityUtil.equal(entityInfo.entityInfo.groupId,Cache.instance.group.groupId))
				{
					Dispatcher.dispatchEvent( new DataEvent(EventName.SceneRemoveGroupmate,entityId));
				}
				entityInfo.dispose();
			}
		}
		
		public function removeFromOffAry(entityId:SEntityId):void
		{
			var entityIdStr:String = EntityUtil.toString(entityId);
			var entityInfo:EntityInfo = _dic[entityIdStr];
			var offIndex:int = _offAry.indexOf(entityInfo);
			if(offIndex != -1)
			{
				_offAry.splice(offIndex,1);
			}
		}
		
		/**
		 * 更新单个实体属性 
		 * 
		 */
		public function updateAttribute(seu:SEntityUpdate):void
		{
			var entityInfo:EntityInfo;
			var entityIdStr:String = EntityUtil.toString(seu.entityId);
			if( seu.msgEx == null )
			{
				entityInfo = _dic[entityIdStr];
			}
			if(entityInfo)
			{
				entityInfo.updateAttribute(seu.propertyUpdates);
			}
		}
		
		/**
		 * 批量更新多个属性 
		 * @param seu
		 * 
		 */		
		public function updateAttributes(seqEntityUpdate:SSeqEntityUpdate):void
		{
			for each(var sentityUpdate:SEntityUpdate in seqEntityUpdate )
			{
				updateAttribute(sentityUpdate);
			}
		}
		
		//----------------------一些获取实体信息的函数--------------------
		/**
		 * 获取所有实体信息 
		 * @return 
		 * 
		 */		
		public function getAllEntityInfo(type:int = 0):Array
		{
			var ary:Array = [];
			for each(var entityInfo:EntityInfo in _dic)
			{
				if(entityInfo.entityInfo.entityId.type == type || type == 0)
				{
					ary.push(entityInfo);
				}
			}
			return ary;
		}
		
		/**
		 * 获取自己的宠物实体 
		 * @return 
		 * 
		 */
		public function getSelfPet():EntityInfo
		{
			for each(var entityInfo:EntityInfo in _dic)
			{
				if(EntityRelationUtil.isSelfPetByEntityId(entityInfo.entityInfo.entityId))
				{
					return entityInfo;
				}
			}
			return null;
		}
		
		/**
		 * 获取实体的相关宠物
		 * @return 
		 * 
		 */		
		public function getEntityPet(entityId:SEntityId):EntityInfo
		{
			for each(var entityInfo:EntityInfo in _dic)
			{
				if(EntityRelationUtil.isSelfPetByEntityId(entityInfo.entityInfo.entityId,entityId))
				{
					return entityInfo;
				}
			}
			return null;
		}
		
		/**
		 * 获取属于一个玩家的所有实体 
		 * @param entityId
		 * @return 
		 * 
		 */		
		public function getOwnerEntityList(entityId:SEntityId):Vector.<EntityInfo>
		{
			var list:Vector.<EntityInfo> = new Vector.<EntityInfo>();
			for each(var entityInfo:EntityInfo in _dic)
			{
				if(EntityRelationUtil.isOwnerSelf(entityInfo.entityInfo,entityId))
				{
					list.push(entityInfo);
				}
			}
			return list;
		}
		
		public function updateAllName():void
		{
			for each(var entityInfo:EntityInfo in _dic)
			{
				entityInfo.isUpdateName = true;
				entityInfo.isUpdate = true;
			}
		}
		
		public function clearAll():void
		{
			var entityInfo:EntityInfo;
			for each(entityInfo in _dic)
			{
				removeEntity(entityInfo.entityInfo.entityId);
			}
			_dic = new Dictionary();
			_offAry.length = 0;
		}
	}
}