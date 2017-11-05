package mortal.game.scene3D.layer3D.utils
{
	import Message.BroadCast.SEntityInfo;
	import Message.BroadCast.SEntityMoveInfo;
	import Message.Public.SEntityId;
	import Message.Public.SPoint;
	
	import baseEngine.core.Pivot3D;
	
	import com.gengine.core.FrameUtil;
	import com.gengine.debug.Log;
	import com.gengine.game.core.GameSprite;
	
	import extend.language.Language;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.tableConfig.ProxyConfig;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.layer3D.EntityDictionary;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MovePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.mvc.core.Dispatcher;

	public class EntityUtil extends EntityLayerUtil
	{
		
		private var _entitysMap:EntityDictionary;
		
		public function EntityUtil( $layer:PlayerLayer)
		{
			super($layer);
			_entitysMap = new EntityDictionary();
		}
		
		public static const LinkStr:String = "_";
		
		public static function toString( entityID:SEntityId ):String
		{
			return entityID.type.toString() + LinkStr + entityID.typeEx.toString()+LinkStr+entityID.typeEx2.toString() + LinkStr + entityID.id.toString();
		}
		
		public static function equal( entityID:SEntityId , entityId1:SEntityId ):Boolean
		{
			if(!entityID || !entityId1)
			{
				return false;
			}
			return entityID.id == entityId1.id && entityID.type == entityId1.type && entityID.typeEx == entityId1.typeEx && entityID.typeEx2 == entityId1.typeEx2;
		}
		
		public static function isSelf( entityID:SEntityId ):Boolean
		{
			return equal(entityID,Cache.instance.role.entityInfo.entityId);
		}
		
		public static function petEqual( entityID:SEntityId , entityId1:SEntityId ):Boolean
		{
			return entityID.id == entityId1.id && entityID.typeEx == entityId1.typeEx && entityID.typeEx2 == entityId1.typeEx2;
		}
		
		/**
		 * 是否是实体的归属 
		 * @param selfId   实体自己的信息
		 * @param info   所需要判断归属的实体信息
		 * @return 
		 * 
		 */
		public static function isOwerEntity(  info:SEntityInfo ,selfId:SEntityId ):Boolean
		{
//			if( info.toEntitys && info.toEntitys.length >0 )
//			{
//				if( EntityUtil.equal( info.toEntitys[0] as SEntityId,selfId ) )
//				{
//					return true;
//				}
//			}
			return false;
		}
		
		/**
		 * 是否是相同势力 
		 * @param info
		 * @param info1
		 * @return 
		 * 
		 */		
		public static function isSameProxy( info:SEntityId,info1:SEntityId ):Boolean
		{
			return info.typeEx2 == info1.typeEx2;
		}
		
		public static function isSameServer(info:SEntityId,info1:SEntityId ):Boolean
		{
			if(!info || !info1)
			{
				return false;
			}
			return info.typeEx2 == info1.typeEx2 && info.typeEx == info1.typeEx ;
		}
		
		public static function isSameProxyByRole(info:SEntityId):Boolean
		{
			return Cache.instance.role.entityInfo.entityId.typeEx2 == info.typeEx2;
		}
		
		public static function isSameServerByRole(info:SEntityId):Boolean
		{
			var roleEntityId:SEntityId = Cache.instance.role.entityInfo.entityId;
			return isSameServer(roleEntityId,info);
		}
		
		public static function isSameServerByProxyAndServer(proxyId:int,serverId:int):Boolean
		{
			var roleEntityId:SEntityId = Cache.instance.role.entityInfo.entityId;
			return roleEntityId.typeEx2 == proxyId && roleEntityId.typeEx == serverId;
		}
		
		public static function isSameProxyByRoleProxyId(proxyId:int):Boolean
		{
			return Cache.instance.role.entityInfo.entityId.typeEx2 == proxyId;
		}
		
		public static function get ProxyName():String
		{
			return Language.getString(10014);
		}
		
		public static function getProxyName( info:SEntityId ):String
		{
			if( isSameProxyByRole(info ) )
			{
				return ProxyConfig.instance.getProxyName(info.typeEx2)+"_"+info.typeEx;
			}
			return ProxyName+"_"+info.typeEx;
		}
		
		public static function getProxyNameByProxyAndServer(proxy:int, server:int, splitLabel:String="_"):String
		{
			if( isSameProxyByRoleProxyId(proxy ) )
			{
				return ProxyConfig.instance.getProxyName(proxy) + splitLabel + server;
			}
			return ProxyName + splitLabel + server;
		}
		
		public static function isNullEntity(id:SEntityId):Boolean
		{
			if(id == null)
			{
				return true;
			}
			if(id.id == 0 && id.type == 0 && id.typeEx == 0 && id.typeEx2 == 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 是否可攻击
		 * @param entity
		 * @return 
		 * 
		 */
		public function isAttackAble(entity:IEntity,tips:Boolean=true):Boolean
		{
			if(entity)
			{
				return true;
			}
			return false;
		}
		
		public function addPlayers( entityID:SEntityId, player:SpritePlayer ):void
		{
			_entitysMap.addEntity( entityID , player);
		}
		
		/**
		 * 根据ID 获取 IEntity 
		 * @param entityID
		 * @return 
		 * 
		 */		
		public function getEntity( entityID:SEntityId ):IEntity
		{
			return _entitysMap.getEntity(entityID);
		}
		
		/**
		 * 移动实体 
		 * @param entityId
		 * @param points
		 * 
		 */		
		public function moveEntity(moveInfo:SEntityMoveInfo, points:Array):void
		{
			var player:SpritePlayer;
//			if( moveInfo.msgEx )
//			{
//				player = ThingUtil.sceneEntityUti.getEntity(moveInfo.entityId,moveInfo.msgEx.ex1) as SpritePlayer;
//			}
//			else
//			{
				player = _entitysMap.getEntity(moveInfo.entityId) as SpritePlayer;
//			}
			
			if (player)
			{
				player.walking(points); //GameMapUtil.getPixelPointArray(points));
			}
			ThingUtil.isEntitySort = true;
		}
		
		/**
		 * 移动实体转向 
		 * @param entityId
		 * @param points
		 * 
		 */		
		public function diversionEntity(moveInfo:SEntityMoveInfo, points:Array):void
		{
			var player:SpritePlayer;
//			if( moveInfo.msgEx )
//			{
//				player = ThingUtil.sceneEntityUti.getEntity(moveInfo.entityId,moveInfo.msgEx.ex1) as SpritePlayer;
//			}
//			else
//			{
				player = _entitysMap.getEntity(moveInfo.entityId) as SpritePlayer;
//			}
			
			if (player)
			{
				player.diversion(points); //GameMapUtil.getPixelPointArray(points));
			}
			ThingUtil.isEntitySort = true;
		}
		
		/**
		 * 创建实体 
		 * @param entityInfo
		 * 
		 */		
		public function createEntity(entityInfo:EntityInfo):void
		{
			var info:SEntityInfo = entityInfo.entityInfo;
			if( info.msgEx == null )
			{
				var player:SpritePlayer = _entitysMap.getEntity(info.entityId) as SpritePlayer;
				if(player == null)
				{
					player = EntityClass.getInstanceByType(info.entityId.type) as SpritePlayer;
					_entitysMap.addEntity(info.entityId, player);
					
					Dispatcher.dispatchEvent(new DataEvent(EventName.Scene_AddEntity, info));
				}
				player.updateInfo(entityInfo,true);
				player.addToStage(layer);
				ThingUtil.isEntitySort = true;
			}
		}
		
//		/**
//		 * 添加多个玩家
//		 * @param array
//		 *
//		 */
//		public function addEntitys(array:Array):void
//		{
//			var len:int=array.length;
//			var info:SEntityInfo;
//			while( array.length > 0 )
//			{
//				info = array.shift() as SEntityInfo;
//				if( info )
//				{
//					addEntity(info);
//				}
//			}
//		}
//		
//		/**
//		 * 添加玩家 
//		 * @param info
//		 * 
//		 */		
//		public function addEntity(info:SEntityInfo):void
//		{
//			if(info == null)
//			{
//				return;
//			}
////			if(FrameUtil.canOperate())
////			{
//				addEntityStart(info);
////			}
////			else
////			{
////				ThingUtil.delayEntityUtil.addTempEntity(info);
////			}
//		}
//		
//		/**
//		 * 添加玩家到场景
//		 * @param info
//		 *
//		 */
//		private function addEntityStart(info:SEntityInfo):void
//		{
//			if( info.msgEx == null )
//			{
//				info.entityId.msgEx = null;
//				var player:SpritePlayer = _entitysMap.getEntity(info.entityId) as SpritePlayer;
//				if(player == null)
//				{
//					player = EntityClass.getInstanceByType(info.entityId.type) as SpritePlayer;
//					_entitysMap.addEntity(info.entityId, player);
//					
//					Dispatcher.dispatchEvent(new DataEvent(EventName.Scene_AddEntity, info));
//				}
//				player.updateInfo(info,true);
////				Log.debug("添加实体：" + info.name);
//				layer.addChild(player);
//			}
//			else
//			{
////				info.entityId.msgEx = info.msgEx;
////				var entity:SpritePlayer=ThingUtil.sceneEntityUtil.getEntity(info.entityId,info.msgEx.ex1) as SpritePlayer;
////				if (entity == null)
////				{
////					entity= EntityClass.getInstanceByType(info.entityId.type) as SpritePlayer;
////					ThingUtil.sceneEntityUtil.addEntity(info.entityId, entity,info.msgEx.ex1);
////				}
////				else
////				{
////					entity.traceLog("增加实体存在:");
////				}
////				entity.updateInfo(info,true);
////				ThingUtil.isPetEntitySort = true;
//			}
//		}
		
		/**
		 * 删除多个实体 
		 * @param ary
		 * 
		 */
		public function removeEntitys(ary:Array):void
		{
			var len:int=ary.length;
			for each (var entityId:SEntityId in ary)
			{
				removeEntity(entityId);
			}
		}
		
		/**
		 * 删除一个 实体 
		 * @param entityID
		 * 
		 */		
		public function removeEntity(entityID:SEntityId):void
		{
			if(entityID == null) 
			{
				return;
			}
			
			if( entityID.msgEx == null )
			{
//				if( entityID.type == EntityType.Boss )
//				{				
//					var monster:MonsterPlayer  = _entitysMap.getEntity(entityID) as MonsterPlayer;
//					if( monster == null ) return;
//					
//					//铜钱怪
//					if(monster.bossType == EBossType._EBossTypeCoin)
//					{
//						monster.tryDeath();
//					}
//						//采集怪
//					else if(  monster.bossType == EBossType._EBossTypeCollection )
//					{
//						_entitysMap.removeEntity(entityID)
//						monster.death();
//					}
//					else if( monster.life > 0 || monster.isDead == false)
//					{
//						_entitysMap.removeEntity(entityID);
//						monster.dispose();
//					}
//					else if( monster.bossType != EBossType._EBossTypeNomarl )
//					{
//						_entitysMap.removeEntity(entityID);
//						monster.dispose();
//					}
//					else
//					{
//						monster.isDead = true;
//					}
//					return;
//				}
				if( entityID.type == EntityType.DropItem )
				{
					ThingUtil.dropItemUtil.removeDropItem(entityID);
					return;
				}
//				else if( entityID.type == EntityType.SimpleDropItem )
//				{
//					ThingUtil.dropItemUtil.removeSimpleDropItem(entityID);
//					return;
//				}
//				else if( entityID.type == EntityType.NpcShop )
//				{
//					ThingUtil.npcShopUtil.removeNpcShop(entityID);
//					return;
//				}
				
				var player:Pivot3D = _entitysMap.removeEntity(entityID) as Pivot3D;
				if( player == null ) return;
				player.dispose();
			}
		}
		
		override public function removeAll():void
		{
			for each( var pivot:Pivot3D in _entitysMap.allEntitys )
			{
				if( pivot )
				{
					pivot.dispose();
				}
			}
			_entitysMap.removeAll();
		}

		public function get entitysMap():EntityDictionary
		{
			return _entitysMap;
		}

		public function set entitysMap(value:EntityDictionary):void
		{
			_entitysMap = value;
		}
		
		public function refreshPoint(entityId:SEntityId, points:Array):void
		{
			var player:SpritePlayer=_entitysMap.getEntity(entityId) as SpritePlayer;
			if (player)
			{
				//Log.debug("瞬间移动："+ entityToString(entityId)+"--"+points[0].x+":"+points[0].y);
				var spoint:SPoint = points[points.length - 1] as SPoint;
				if(player is MovePlayer)
				{
					(player as MovePlayer).stopMove();
				}
				player.setPixlePoint( spoint.x,spoint.y ); //GameMapUtil.getPixelPointArray(points));
				ThingUtil.isMoveChange = true;
			}
		}

		protected var _hideBossCodeArray:Vector.<int> = new Vector.<int>();
		/**
		 * 更新一个怪物的bossCode是否添加到场景 
		 * @param bossCode
		 * @param isAdd
		 * 
		 */
		public function updateBossIsAddToStage(bossCode:int,isAdd:Boolean):void
		{
			var index:int = _hideBossCodeArray.indexOf(bossCode);
			if(isAdd && index < 0)
			{
				_hideBossCodeArray.push(bossCode);
			}
			if(!isAdd && index >= 0)
			{
				_hideBossCodeArray.slice(index,1);
			}
		}
		
		/**
		 * 某一个bossCode的怪物是否隐藏 
		 * @param bossCode
		 * @return 
		 * 
		 */		
		public function isBossHide(bossCode:int):Boolean
		{
			return _hideBossCodeArray.indexOf(bossCode) >= 0;
		}
		
		/**
		 * 更新实体名字显示 
		 * 
		 */		
		public function updateHeadContainer():void
		{
			_entitysMap.updateHeadContainer();
		}
		
	}
}
