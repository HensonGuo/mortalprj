package mortal.game.scene3D.layer3D
{
	import Message.Public.SEntityId;
	
	import com.gengine.debug.GameStatistical;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.ai.singleAIs.AutoFightBossSelectAI;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.util.FightUtil;
	import mortal.game.utils.EntityRelationUtil;

	public class EntityDictionary
	{
		private var _map:Dictionary;
		private var _length:int;
		
		public function EntityDictionary( weakKeys:Boolean = false )
		{
			_map = new Dictionary( weakKeys );
		}
		
		public function get allEntitys():Dictionary
		{
			return _map;
		}
		
		public function get length():int
		{
			return _length;
		}
		
		public function addEntity( entityID:SEntityId , entity:IEntity,isShow:Boolean = true ):IEntity
		{
			_map[ entityToString( entityID )  ] = entity;
			_length += 1;
			GameStatistical.sceneObjNum ++;
			return entity;
		}
		
		public function removeEntity( entityID:SEntityId ,isShow:Boolean = true):IEntity
		{
			if( entityID == null ) return null;
			var entityIdStr:String = entityToString(entityID);
			var entity:IEntity = _map[ entityIdStr ];
			if( entity )
			{
				_map[entityIdStr] = null;
				_length -= 1;
				GameStatistical.sceneObjNum --;
				delete _map[ entityIdStr ];
			}
			return entity;
		}
		
		public function getEntityByString(entityIDStr:String):IEntity
		{
			return _map[entityIDStr];
		}
		
		public function getEntity( entityID:SEntityId ):IEntity
		{
			return _map[ entityToString(entityID)];
		}
		

		private function entityToString( entityID:SEntityId ):String
		{
			return EntityUtil.toString(entityID);
		}
		
		private function getDistance( object:DisplayObject , object1:DisplayObject ):Number
		{
			return Math.pow(object.x - object1.x,2)+Math.pow( object.y - object1.y,2);
		}
		
		/**
		 * 获取 范围内的 实体对象 
		 * @param rect
		 * @param type  type == 0 全部实体 
		 * @param inRect 是否仅限于在屏幕内搜索
		 * @return 
		 * 
		 */		
		public function getEntityByRangle( rect:Rectangle ,type:int=0 ,inRect:Boolean = true):Array
		{
			var ary:Array = new Array();
			for each( var entity:IEntity in _map  )
			{
				if( inRect == false || rect.contains(entity.x2d,entity.y2d) )
				{
					if( type == 0 && entity.isDead == false) 
					{
						ary.push(entity);
					}
					else if( entity.type == type && entity.isDead == false)
					{
						ary.push(entity);
					}
				}
			}
			return ary;
		}
		
		public function removeAll():void
		{
			_map = new Dictionary();
			_length = 0;
			GameStatistical.sceneObjNum = 0;
		}
		
		/**
		 * 选择实体 
		 * @param type 参考EEntityType
		 * @param round 选择屏幕范围
		 * @param friendType 参考FriendType 中立、友好、敌人（暂时未做处理）
		 * @param source 数据源
		 * @param isOnlyDead 是否只取已经死亡的
		 * @param isForceChange 是否切换目标
		 * @return 
		 * 
		 */		
		public function selectEntity(entityType:int=-1, round:Rectangle=null, friendType:int=20, 
									 isForceChange:Boolean=false, isOnlyDead:Boolean=false, source:Array=null, isSelfInclude:Boolean=false):IEntity
		{
			if(ThingUtil.selectEntity && !isForceChange)
			{
				// 当前的符合条件就不改了( 对于选中的，就算是和平模式的也可以杀，对于没选中的，和平模式的不能选中)
				if(isEntityFit(ThingUtil.selectEntity, entityType, friendType, isOnlyDead, true)
					&& isInDicPlayer(ThingUtil.selectEntity)
				)
				{
					return ThingUtil.selectEntity;
				}
			}
			
			if(round == null)
			{
				round = SceneRange.display;
			}
			if(source == null)
			{
				source = this.getEntityByRangle(round);
			}
			AutoFightBossSelectAI.instance.updateMyPoint();
			source.sort(AutoFightBossSelectAI.instance.sortByDistance);
			
			for(var i:int = 0; i < source.length; i++)
			{
				var entity:IEntity = source[i] as IEntity;
				if(entity == null)
				{
					continue;
				}
				if(!FightUtil.isEntityCanBeAutoSelected(entity))
				{
					continue;
				}
				if(!isEntityFit(entity, entityType, friendType, isOnlyDead))
				{
					continue;
				}
				if(!isSelfInclude && entity == RolePlayer.instance)
				{
					continue;
				}
				
				if(isForceChange && ThingUtil.selectEntity == entity)
				{
					continue;
				}
				else
				{
					ThingUtil.selectEntity = entity;
					return entity;
				}
			}
			
			ThingUtil.selectEntity = null;
			return null;
		}
		
		public function isEntityFit(entity:IEntity, type:int, friendType:int, isDead:Boolean, isCurSelected:Boolean=false):Boolean
		{
			if(type != -1 && entity.type != type)
			{
				return false;
			}
			if(isDead && !entity.isDead)
			{
				return false;
			}
			if(!isDead && entity.isDead)
			{
				return false;
			}
			// friendType 以后再处理
			var isFriend:Boolean = EntityRelationUtil.isFriend(entity.entityInfo.entityInfo);
			var isToMeFriend:Boolean = EntityRelationUtil.getFriendlyLevel(entity.entityInfo.entityInfo) 
				==  EntityRelationUtil.FIREND;
			if(isCurSelected) // 对选中的， 只要自己对他不友好就可以干
			{
				if(friendType == EntityRelationUtil.FIREND)
				{
					// 自己、自己的好有、自己的宠物、好有的宠物
					if(!isFriend)
					{
						return false;
					}
				}
				else if(isFriend)
				{
					return false
				}
			}
			else // 对于非选中的， 目标为敌人的话， 要自己对他不友好且他对自己也不友好才能打
			{
				if(friendType == EntityRelationUtil.FIREND)
				{
					// 自己、自己的好有、自己的宠物、好有的宠物
					if(!isFriend || !isToMeFriend)
					{
						return false;
					}
				}
				else if(isFriend || isToMeFriend)
				{
					return false
				}
			}
			return true;
		}
		
		public function isInDicPlayer(entity:IEntity):Boolean
		{
			var t:int = entity.type;
			return t == EntityType.Boss || t == EntityType.Player || t == EntityType.Pet;
		}
		
		/**
		 * 更新实体场景头顶显示 
		 * 
		 */		
		public function updateHeadContainer():void
		{
			for each(var entity:IEntity in _map)
			{
				entity.updateHeadContainer();
			}
		}
	}
}
