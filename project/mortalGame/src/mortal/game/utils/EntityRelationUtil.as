/**
 * @heartspeak
 * 2014-3-10 
 */   	

package mortal.game.utils
{
	import Message.BroadCast.SEntityIdInfo;
	import Message.BroadCast.SEntityInfo;
	import Message.Public.EEntityFightMode;
	import Message.Public.EEntityType;
	import Message.Public.EFightMode;
	import Message.Public.EForce;
	import Message.Public.SEntityId;
	import Message.Public.SGroupPlayer;
	
	import extend.language.Language;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.cache.EntityCache;
	import mortal.game.manager.MsgManager;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.info.EntityInfo;

	public class EntityRelationUtil
	{
		public static const FIREND:int = 1;//友好的
		public static const ENEMY:int = 2;//敌对的
		public static const NEUTRAL:int = 3;//中立的
		
		public function EntityRelationUtil()
		{
		}
		
		/**
		 * 是否是自己的宠物 
		 * @param entityId
		 * @param myEntityId
		 * @return 
		 * 
		 */				
		public static function isSelfPetByEntityId(entityId:SEntityId, myEntityId:SEntityId = null):Boolean
		{
			if(myEntityId == null)
			{
				myEntityId = Cache.instance.role.roleEntityInfo.entityInfo.entityId
			}
			if( entityId.type == EEntityType._EEntityTypePet )
			{
				if( entityId.id == myEntityId.id 
					&& entityId.typeEx == myEntityId.typeEx 
					&& entityId.typeEx2 == myEntityId.typeEx2 )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 是否归属于某一个Entity的 
		 * @param entityId
		 * @return 
		 * 
		 */		
		public static function isOwnerSelf(entityInfo:SEntityInfo,myEntityId:SEntityId = null):Boolean
		{
			if(!myEntityId)
			{
				myEntityId = Cache.instance.role.roleEntityInfo.entityInfo.entityId;
			}
			var entityOwnerId:SEntityId = entityInfo.entityId;
			if(entityInfo.ownerEntityId && entityInfo.ownerEntityId.id != 0)
			{
				entityOwnerId = entityInfo.ownerEntityId;
			}
			return EntityUtil.equal(myEntityId,entityOwnerId);
		}
		
		/**
		 * 获取实体的主人 信息 
		 * @param info
		 * @return
		 * 
		 */		
		public static function getSummonMaster( info:SEntityInfo ):SEntityInfo
		{
			if( info.ownerEntityId )
			{
				if( info.ownerEntityId.type == EEntityType._EEntityTypePlayer )
				{
					var entity:EntityInfo = Cache.instance.entity.getEntityInfoById(info.ownerEntityId);
					if( entity )
					{
						return entity.entityInfo;
					}
				}
			}
			return info;
		}
		
		/**
		 * 自己对实体的 是否友好
		 * @param entityId
		 * @param isTips
		 * 
		 */	
		public static function isFriend(info:SEntityInfo,isTips:Boolean = false):Boolean
		{
			//获取实体的归属
			info = getSummonMaster(info);
			var isInfoPlayer:Boolean = info.entityId.type == EEntityType._EEntityTypePlayer;
			var myEntityInfo:SEntityInfo = Cache.instance.role.entityInfo;
			if(EntityUtil.equal(info.entityId, myEntityInfo.entityId))
			{
				return true;
			}
			
			//判断战斗模式是否可攻击
			switch(myEntityInfo.fightMode)
			{
				case EEntityFightMode._EEntityFightModePeace:
					if(isInfoPlayer)
					{
						return true;
					}
					break;
				case EEntityFightMode._EEntityFightModeGoodEvil:
					if(isInfoPlayer && info.fightMode != EEntityFightMode._EEntityFightModeFight)
					{
						return true;
					}
					break;
				case EEntityFightMode._EEntityFightModeFight:
					break;
				default:
					break;
			}
			//判断地图模式是否可以攻击
			var isMapFriend:Boolean = isMapfightModeFriend(info,isTips);
			if(isMapFriend)
			{
				return true;
			}
			//判断安全区
			if(isInfoPlayer && isMapSafeArea(info))
			{
				return true;
			}
			return false;
		}
	
		
		/**
		 * 获取实体对自己的友好等级
		 * @param sentityInfo
		 * @param myEntityInfo
		 * @param isTip
		 * @return
		 * 
		 */
		public static function getFriendlyLevel(info:SEntityInfo):int
		{
			info = getSummonMaster(info);
			var isPlayer:Boolean = info.entityId.type == EEntityType._EEntityTypePlayer;
			var myEntityInfo:SEntityInfo = Cache.instance.role.entityInfo;
			if(EntityUtil.equal(info.entityId, myEntityInfo.entityId))
			{
				return EntityRelationUtil.FIREND;
			}
			
			//判断安全区
			if(isPlayer && isMapSafeArea(info))
			{
				return EntityRelationUtil.FIREND;
			}
			//地图模式队友
			var isMapFriend:Boolean = isMapfightModeFriend(info,false);
			if(isMapFriend)
			{
				return EntityRelationUtil.FIREND;
			}
			//战斗模式
			if(isPlayer)
			{
				switch(info.fightMode)
				{
					case EEntityFightMode._EEntityFightModeFight:
						return EntityRelationUtil.ENEMY;
					case EEntityFightMode._EEntityFightModeGoodEvil:
						return EntityRelationUtil.NEUTRAL;
					case EEntityFightMode._EEntityFightModePeace:
						return EntityRelationUtil.FIREND;
				}
			}
			return EntityRelationUtil.ENEMY;
		}
		
		/**
		 * 地图模式判断是不是友方
		 * @return 
		 * 
		 */		
		private static function isMapfightModeFriend(info:SEntityInfo, isTip:Boolean):Boolean
		{
			var fightMode:int = Game.sceneInfo.sMapDefine.fightMode;
			var myEntityInfo:SEntityInfo = Cache.instance.role.entityInfo;
			var isSameServer:Boolean = EntityUtil.isSameServer(info.entityId, myEntityInfo.entityId);
			
			//如果info 不是人物 则按照势力模式规则判断
			if(info.entityId.type != EEntityType._EEntityTypePlayer)
			{
				fightMode = EFightMode._EFightModeForce;
			}
			//自由模式(不限制PK)
			if( fightMode == EFightMode._EFightModeFree )
			{
				return  EntityUtil.equal(info.entityId,myEntityInfo.entityId);
			}
			//服务器模式
			if( fightMode & EFightMode._EFightModeServer )
			{
				if( isSameServer )
				{
					if (isTip)
					{
						MsgManager.showRollTipsMsg( Language.getString(11028) );//"相同服务器，不可以攻击");
					}
					return true;
				}
			}
			//组队模式
			if(fightMode & EFightMode._EFightModeTeam)
			{
				if(isInRoleGroup(info))
				{
					if (isTip)
					{
						MsgManager.showRollTipsMsg( Language.getString(11029) );//"不可以攻击队友");
					}
					return true;
				}
			}
			// 公会模式
			if( fightMode & EFightMode._EFightModeGuild )
			{
				if(info && isSameServer && EntityUtil.equal(info.guildId,myEntityInfo.guildId) 
					&& myEntityInfo.guildId.id != 0 )
				{
					if (isTip)
					{
						MsgManager.showRollTipsMsg(Language.getString(11027));//"相同仙盟，不可以攻击");
					}
					return true;
				}
			}
			//阵营模式
			if( fightMode & EFightMode._EFightModeCamp )
			{
				if( info.camp == myEntityInfo.camp && isSameServer)
				{
					if (isTip)
					{
						MsgManager.showRollTipsMsg( Language.getString(11027) );//"相同阵营，不可以攻击");
					}
					return true;
				}
			}
//			//联盟模式
//			if( fightMode & EfightMode._EfightModeCampUnion )
//			{
//				if( _campUnion > 0 && info.camp != _campUnion && camp != _campUnion )
//				{
//					if (isTip)
//					{
//						MsgManager.showRollTipsMsg( Language.getString(11028) );//"联盟阵营，不可以攻击");
//					}
//					return true;
//				}
//			}
			//势力模式
			if( fightMode & EFightMode._EFightModeForce )
			{
				//中立怪和装饰怪
				if(info.force == EForce._EForceNeutral || info.force == EForce._EForceDecorate)
				{
					return true;
				}
				//服务器怪
				else if(info.force == EForce._EForceServer && EntityUtil.isSameServer(info.entityId,myEntityInfo.entityId))
				{
					if (isTip)
					{
						MsgManager.showRollTipsMsg( Language.getString(11028));//"相同服务器，不可以攻击");
					}
					return true;
				}
				//仙盟怪 
				else if(info.force == EForce._EForceGuild && EntityUtil.equal(info.guildId,myEntityInfo.guildId))
				{
					return true;
				}
				//相同势力为友好的
				else
				{
					if(info.force == myEntityInfo.force)
					{
						if (isTip)
						{
							MsgManager.showRollTipsMsg( Language.getString(11028));//"相同势力，不可以攻击";
						}
						return true;
					}
				}
			}
			//和平模式
			if( fightMode & EFightMode._EFightModePeace )
			{
				if(info.entityId.type == EEntityType._EEntityTypePlayer)
				{
//					if (isTip)
//					{
//						MsgManager.showRollTipsMsg(Language.getString(11067));
//					}
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 是否地图安全区  判断自己和实体
		 * @param info
		 * 
		 */
		public static function isMapSafeArea(info:SEntityInfo):Boolean
		{
			var isCross:Boolean = false;
			return GameMapUtil.isMapPeaceArea(info.entityId,isCross) || GameMapUtil.isMapPeaceArea(Cache.instance.role.entityInfo.entityId,isCross);
		}
		
		/**
		 * 是否在自己的队伍中 包括宠物判断 
		 * @param sentityInfo
		 * @return 
		 * 
		 */		
		public static function isInRoleGroup( sentityInfo:SEntityInfo ):Boolean
		{
			//本服城 有队伍
			if( Cache.instance.group.isInGroup )
			{
				return Cache.instance.group.entityIsInGroup(sentityInfo.entityId);
			}
			return false;
		}
	}
}