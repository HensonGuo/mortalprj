package mortal.game.scene3D.player.info
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TBuff;
	import Message.DB.Tables.TCareer;
	import Message.Public.EBuffType;
	import Message.Public.EBuffUpdateType;
	import Message.Public.EEntityAttribute;
	import Message.Public.EEntityType;
	import Message.Public.ESex;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SEntityId;
	
	import com.gengine.core.IDispose;
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemEquipInfo;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.tableConfig.BuffConfig;
	import mortal.game.resource.tableConfig.CareerConfig;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.type.AttachType;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 实体数据 
	 * @author heartspeak
	 * 
	 */
	public class EntityInfo implements IDispose
	{
		private var _entityInfo:SEntityInfo;
		private var _bodySize:int;
		
		//属性更新状态
		public var isUpdate:Boolean = false;//是否有更新
		public var isUpdateName:Boolean = false; //名字更新
		public var isUpdateGuildName:Boolean = false; //仙盟名字更新
		public var isUpdateLevel:Boolean = false;//等级更新
		public var isUpdateLife:Boolean = false;//血量更新
		public var isUpdateMana:Boolean = false;//魔法更新
		public var isUpdateSpeed:Boolean = false;//速度更新
		public var isUpdateFighting:Boolean = false;//战斗状态更新
		public var isUpdateBuffer:Boolean = false;//战斗状态更新
		public var isUpdateMount:Boolean = false;//坐骑更新
		public var isUpdateDirection:Boolean = false;//朝向更新
		public var isUpdateDisappear:Boolean = false;//隐身状态
		public var isUpdateClothes:Boolean = false;//衣服
		public var isUpdateWeapon:Boolean = false;//武器
		public var isUpdateCCS:Boolean = false;//阵营职业 性别修改
		public var isUpdateFightMode:Boolean = false;//战斗模式更新
		
		public var fightingType:int = 0;
		public var isDisappear:Boolean = false;//是否隐身状态
		public var clothes:int = 0;
		public var weapon:int = 0;
		
		private var dispatcher : IEventDispatcher = new EventDispatcher();
		
		
		/**
		 * 体积大小 
		 */
		public function get bodySize():int
		{
			if(_bodySize <= 0)
			{
				_bodySize = CareerConfig.instance.getBodySize(_entityInfo.career, _entityInfo.sex==ESex._ESexMan);
			}
			return _bodySize;
		}

		/**
		 * @private
		 */
		public function set bodySize(value:int):void
		{
			_bodySize = value;
		}

		/**
		 * 加侦听
		 */
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void 
		{
			dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		/**
		 * 移除侦听
		 */
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ) : void 
		{
			dispatcher.removeEventListener( type, listener, useCapture );
		}
		
		/**
		 * 派发事件
		 */
		public function dispatchEvent( event:Event ) : Boolean 
		{
			return dispatcher.dispatchEvent( event );
		}
		
		/**
		 * 返回是否有这个侦听
		 */
		public function hasEventListener( type:String ) : Boolean 
		{
			return dispatcher.hasEventListener(type);
		}
		
		public function EntityInfo()
		{
			reset();
		}

		private function reset():void
		{
			_entityInfo = new SEntityInfo();
			_entityInfo.entityId =new SEntityId();
//			_entityInfo.sex = -1;
			_entityInfo.camp = -1;
			_entityInfo.career = -1;
			_entityInfo.code = -1;
			_entityInfo.level = -1;
			_entityInfo.life = -1;
			_entityInfo.mana = -1;
			_entityInfo.maxLife = -1;
			_entityInfo.maxMana = -1;
			_entityInfo.name = "";
			_entityInfo.speed = -1;
			_entityInfo.status = -1;
			_entityInfo.VIP = 0;
			_entityInfo.fighting = false;
			_entityInfo.fightMode = -1;
			_entityInfo.speed = 0;
			_entityInfo.direction = 0;
			_entityInfo.reserveJs = "";
			_entityInfo.points = [];
			_entityInfo.buffs = [];
			_entityInfo.entityShows = new Dictionary();
			_entityInfo.guildId = new SEntityId();
			
			isDisappear = false;
			fightingType = 0;
			clothes = 0;
			weapon = 0;
			
			//重设更新状态
			resetUpdateState();
		}
		
		/**
		 * 重设更新状态 
		 * 
		 */		
		public function resetUpdateState():void
		{
			isUpdate = false;
			isUpdateLevel = false;
			isUpdateName = false;
			isUpdateGuildName = false;
			isUpdateLife = false;
			isUpdateMana = false;
			isUpdateSpeed = false;
			isUpdateFighting = false;
			isUpdateBuffer = false;
			isUpdateMount = false;
			isUpdateDirection = false;
			isUpdateDisappear = false;
			isUpdateClothes = false;
			isUpdateWeapon = false;
			isUpdateCCS = false;
			isUpdateFightMode = false;
		}
		
		public function get entityInfo():SEntityInfo
		{
			return _entityInfo;
		}
		
		/**
		 * 更新整个EntityInfo
		 * @param value
		 * 
		 */
		public function set entityInfo(value:SEntityInfo):void
		{
			_entityInfo = value;
			var buff:int;
			for each(buff in value.buffs)
			{
				var tbuff:TBuff = BuffConfig.instance.getInfoById(buff);
				if(tbuff.type == EBuffType._EBuffTypeDisappear)
				{
					isDisappear = true;
				}
			}
			if(_entityInfo.entityShows)
			{
				updateClothes(_entityInfo.entityShows[EEntityAttribute._EAttributeClothes]);
				updateWeapon(_entityInfo.entityShows[EEntityAttribute._EAttributeWeapon]);
			}
		}
		
		protected function updateClothes(itemCode:int):void
		{
			isUpdate = true;
			isUpdateClothes = true;
			var itemInfo:ItemEquipInfo = ItemConfig.instance.getConfig(itemCode) as ItemEquipInfo;
			if(itemInfo)
			{
				clothes = int(itemInfo.modelId);
			}
			else
			{
				clothes = 0;
			}
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateClothes));
		}
		
		protected function updateWeapon(itemCode:int):void
		{
			isUpdate = true;
			isUpdateWeapon = true;
			var itemInfo:ItemEquipInfo = ItemConfig.instance.getConfig(itemCode) as ItemEquipInfo;
			if(itemInfo)
			{
				weapon = int(itemInfo.modelId);
			}
			else
			{
				weapon = 0;
			}
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateWeapon));
		}
		
		/**
		 * 更新某一项属性 
		 * @param attributes
		 * 
		 */
		public function updateAttribute(attributes:Array,isUpdateShow:Boolean = true):void
		{
			var len:uint = attributes.length;
			for(var i:uint = 0; i < len; i++)
			{
				var item:SAttributeUpdate = attributes[i] as SAttributeUpdate;
				if(item.attribute)
				{
					switch(item.attribute.__value)
					{
						case EEntityAttribute._EAttributeUsername: //名称
						{
							updateName(item.valueStr);
							break;
						}
						case EEntityAttribute._EAttributeLevel: //等级
						{
							_entityInfo.level = item.value;
							isUpdate = true;
							isUpdateLevel = true;
							dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateLevel));
							break;
						}
						case EEntityAttribute._EAttributeLife: //生命
						{
							updateLife(item.value,isUpdateShow);
							break;
						}
						case EEntityAttribute._EAttributeMaxLife:          //最大生命值
						{
							updateMaxLife(item.value,isUpdateShow);
							break;
						}
						case EEntityAttribute._EAttributeMana:           //法力值
						{
							_entityInfo.mana = item.value;
							isUpdateMana = true;
							isUpdate = true;
							dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateMana));
							break;
						}
						case EEntityAttribute._EAttributeMaxMana:           //最大法力值
						{
							updateMaxMana(item.value);
							break;
						}
						case EEntityAttribute._EAttributeSpeed: //速度
						{
							updateSpeed(item.value);
							break;
						}
						case EEntityAttribute._EAttributeCombat: //战斗力
						{
							_entityInfo.combat = item.value;
							dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateComBat));
							break;
						}
						case EEntityAttribute._EAttributeFighting: //战斗状态
						{
							_entityInfo.fighting = Boolean(item.value);
							fightingType = int(item.valueStr);
							isUpdateFighting = true;
							isUpdate = true;
							break;
						}
						case EEntityAttribute._EAttributeBuff: //buff
						{
							updateBuffer(item.value,int(item.valueStr));
							break;
						}
						case EEntityAttribute._EAttributeMount: //坐骑
						{
							isUpdate = true;
							isUpdateMount = true;
							_entityInfo.mountCode = item.value;
							dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateMount));
							break;
						}
						case EEntityAttribute._EAttributeDirection: //朝向
						{
							isUpdate = true;
							isUpdateDirection = true;
							_entityInfo.direction = item.value;
							dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateDirection));
							break;
						}
						case EEntityAttribute._EAttributeClothes: //衣服
						{
							updateClothes(item.value);
							break;
						}
						case EEntityAttribute._EAttributeWeapon: //武器
						{
							updateWeapon(item.value);
							break;
						}
						case EEntityAttribute._EAttributeCamp: //阵营
						{
							isUpdate = true;
							isUpdateCCS = true;
							isUpdateName = true;
							_entityInfo.camp = item.value;
							break;
						}
						case EEntityAttribute._EAttributeCareer: //职业
						{
							updateCareer(item.value);
							break;
						}
						case EEntityAttribute._EAttributeFightMode: //战斗模式
						{
							updateFightMode(item.value);
							break;
						}
						case EEntityAttribute._EAttributeForce: //势力
						{
							isUpdate = true;
							isUpdateName = true;
							_entityInfo.force = item.value;
							break;
						}
						case EEntityAttribute._EAttributeGuildName: //公会名字
						{
							isUpdate = true;
							isUpdateGuildName = true;
							_entityInfo.guildName = item.valueStr;
							break;
						}
						case EEntityAttribute._EAttributeGuildPosition: //公会职位
						{
							isUpdate = true;
							isUpdateGuildName = true;
							_entityInfo.guildPosition = item.value;
							break;
						}
//						case EEntityAttribute._EAttributeSex: //性别
//						{
//							updateSex(item.value);
//							break;
//						}
					}
				}
			}
		}
		
		public function updateLifeShow():void
		{
			isUpdateLife = true;
			isUpdate = true;
		}
		
		public function updateLife(value:int,isUpdateShow:Boolean = true):void
		{
			_entityInfo.life = value;
			if(isUpdateShow)
			{
				isUpdateLife = true;
				isUpdate = true;
			}
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateLife));
		}
		
		public function updateMaxLife(value:int,isUpdateShow:Boolean = true):void
		{
			_entityInfo.maxLife = value;
			if(isUpdateShow)
			{
				isUpdateLife = true;
				isUpdate = true;
			}
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateLife));
		}
		
		public function updateMaxMana(value:int):void
		{
			_entityInfo.maxMana = value;
			isUpdateMana = true;
			isUpdate = true;
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateMana));
		}
		
		public function updateSpeed(value:int):void
		{
			_entityInfo.speed = value;
			isUpdate = true;
			isUpdateSpeed = true;
		}
		
		public function updateName(value:String):void
		{
			_entityInfo.name = value;
			isUpdate = true;
			isUpdateName = true;
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateName));
		}
		
		public function updateLevel(value:int):void
		{
			_entityInfo.level = value;
			isUpdate = true;
			isUpdateLevel = true;
		}
		
		public function updateCareer(value:int):void
		{
			isUpdate = true;
			isUpdateCCS = true;
			_entityInfo.career = value;
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateCareer));
		}
		
		public function updateSex(value:int):void
		{
			isUpdate = true;
			isUpdateCCS = true;
			_entityInfo.sex = value;
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateSex));
		}
		
		public function updateFightMode(value:int):void
		{
			_entityInfo.fightMode = value;
			isUpdate = true;
			isUpdateFightMode = true;
			isUpdateName = true;
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateFightMode));
			
			//更新归属于自己的实体的名字
			var entityInfos:Vector.<EntityInfo> = Cache.instance.entity.getOwnerEntityList(this.entityInfo.entityId);
			var length:int = entityInfos.length;
			for(var i:int = 0;i < length;i++)
			{
				entityInfos[i].isUpdate = true;
				entityInfos[i].isUpdateName = true;
			}
		}
		
		/**
		 * 更新buff
		 * @param value
		 * @param type
		 * 
		 */
		public function updateBuffer(value:int,type:int):void
		{
			var i:int;
			var tbuff:TBuff = BuffConfig.instance.getInfoById(value);
			if(tbuff.type == EBuffType._EBuffTypeDisappear)
			{
				if(type == EBuffUpdateType._EBuffUpdateTypeAdd)
				{
					isDisappear = true;
				}
				else if(type == EBuffUpdateType._EBuffUpdateTypeRemove)
				{
					isDisappear = false;
				}
				isUpdateDisappear = true;
				ThingUtil.isEntitySort = true;
			}
			
			switch(type)
			{
				case EBuffUpdateType._EBuffUpdateTypeAdd:
					_entityInfo.buffs.push(value);
					Log.debug("增加buff"+value);
					break;
				case EBuffUpdateType._EBuffUpdateTypeRemove:
					var length:int = _entityInfo.buffs.length;
					for(i = length - 1;i>=0;i--)
					{
						if(_entityInfo.buffs[i] == value)
						{
							_entityInfo.buffs.splice(i,1);
						}
					}
					Log.debug("删掉buff"+value);
					break;
			}
			
			isUpdate = true;
			isUpdateBuffer = true;
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateBuffs));
		}
		
		public function updateGuildId(guildId:int):void
		{
			var entityId:SEntityId = new SEntityId();
			entityId.id = guildId;
			entityId.type = EEntityType._EEntityTypeGuild;
			entityId.typeEx = this.entityInfo.entityId.typeEx;
			entityId.typeEx2 = this.entityInfo.entityId.typeEx2;
			_entityInfo.guildId = entityId;
			isUpdate = true;
			isUpdateName = true;
		}
		
		public function updateGuildIdByEntityId(guildId:SEntityId):void
		{
			_entityInfo.guildId = guildId;
			isUpdate = true;
			isUpdateName = true;
		}
		
		/**
		 * 更新实体组队的entityId 
		 * @param entityId
		 * 
		 */
		public function updateGroupId(entityId:SEntityId):void
		{
			isUpdate = true;
			isUpdateName = true;
			_entityInfo.groupId = entityId;
			if(EntityUtil.equal(entityId,Cache.instance.group.groupId))
			{
				Dispatcher.dispatchEvent( new DataEvent(EventName.SceneAddGroupmate,this));
			}
			dispatchEvent(new EntityInfoEvent(EntityInfoEventName.UpdateGroupId));
		}
		
		/**其他一些需要的方法*/
		public function get isSelf():Boolean
		{
//			if( _entityInfo.toEntitys && _entityInfo.toEntitys.length >0 )
//			{
//				if( EntityUtil.equal( _entityInfo.toEntitys[0] as SEntityId,RolePlayer.instance.entityInfo.entityInfo.entityId ) )
//				{
//					return true;
//				}
//			}
			return false;
		}
		
		public function get hostEntity():SEntityId
		{
//			if( _entityInfo.toEntitys && _entityInfo.toEntitys.length >0 )
//			{
//				return _entityInfo.toEntitys[0] as SEntityId;
//			}
			return null;
		}
		public function get attachType():int
		{
//			if( _entityInfo && _entityInfo.entityId)
//			{
//				if( _entityInfo.entityId.type  == EntityType.Boss )
//				{
//					if(_entityInfo.toEntitys && _entityInfo.toEntitys.length > 0)
//					{
//						var entityId:SEntityId = _entityInfo.toEntitys[0] as SEntityId;
//						if(EntityUtil.isNullEntity(entityId)) //还是没有归属
//						{
//							return AttachType.NoAttack;
//						}
//						else if( isAttachSelf( entityId ) )  //归属于自己
//						{
//							return AttachType.AttackSelf;
//						}
//						else if( isAttachTeam( entityId ) ) //归属于队友
//						{
//							return AttachType.AttackTeamMate;
//						}
//						return AttachType.HasAttackNoSelf;
//					}
//				}
//				else if( _entityInfo.entityId.type  == EntityType.Player )
//				{
//					if( RolePlayer.instance.isCanFight(_entityInfo) )
//					{
//						return AttachType.AttackSelf;
//					}
//				}
//			}
			return AttachType.NoAttach;
		}
		
		/**
		 * 是否归属于自己
		 * @return 
		 * 
		 */		
		public function isAttachSelf( entityId:SEntityId ):Boolean
		{
			return false;
//			return RolePlayer.instance.entityID == EntityUtil.toString(entityId);
		}
		
		public function isAttachTeam( entityId:SEntityId ):Boolean
		{
//			var ary:Array = Cache.instance.group.players;
//			var entity:IEntity;
//			for each( var miniPlayer:SPublicMiniPlayer in ary  )
//			{
//				if( miniPlayer.online == 1 )
//				{
//					entity = ThingUtil.entityUtil.getEntity(miniPlayer.entityId);
//					if( entity && entity is RolePlayer == false )
//					{
//						if(entity.entityID == EntityUtil.toString(entityId))
//						{
//							return true;
//						}
//					}
//				}
//			}
			return false;
		}
		
		
		/**
		 * 是否可以攻击 
		 * @return 
		 * 
		 */		
		public function isCanAttack():Boolean
		{
			return false;
//			return RolePlayer.instance.isCanFight(_entityInfo);
		}
		
		/**
		 * 是否战斗中 
		 * @return 
		 * 
		 */
		public function get fighting():Boolean
		{
			return _entityInfo.fighting;
		}
		
		public function setNotFighting():void
		{
			_entityInfo.fighting = false;
		}
		
		public function get isDead():Boolean
		{
			return _entityInfo.life <= 0;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			reset();
			if(isReuse)
			{
				ObjectPool.disposeObject(this,EntityInfo);
			}
		}
		
	}
}