/**
 * 2014-1-13
 * @author chenriji
 **/
package mortal.game.scene3D.util
{
	import Message.BroadCast.SEntityInfo;
	import Message.Public.EEntityType;
	import Message.Public.ESkillTargetSelect;
	import Message.Public.ESkillTargetType;
	import Message.Public.ESkillType;
	import Message.Public.SPoint;
	
	import mortal.game.scene3D.ai.data.FollowFightAIData;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.PetPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.scene3D.player.entity.UserPlayer;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.SystemSetting;

	public class FightUtil
	{
		public function FightUtil()
		{
		}
		
		/**
		 * 是否可进行普通攻击
		 * @param entity
		 * @return 
		 * 
		 */
		public static function isNormalAttackable(entity:IEntity,tips:Boolean=true):Boolean
		{
			if(entity is RolePlayer)
			{
				return false;
			}
			else if(entity is UserPlayer)
			{
				var info:SEntityInfo = entity.entityInfo.entityInfo;
				if(EntityRelationUtil.getFriendlyLevel(info) == EntityRelationUtil.FIREND)
				{
					return false;
				}
				return !EntityRelationUtil.isFriend(entity.entityInfo.entityInfo);
			}
			
			if(entity is SpritePlayer)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 根据技能ID查找适合的攻击、或者生肖对象 
		 * @param skillId
		 * @param isForce true表示不管当前有没有选中的目标都返回新的， false表示假如有选中的目标则返回选中的
		 * @return [IEntity]
		 * 
		 */		
		public static function selectEntityBySkill(res:FollowFightAIData, isByClick:Boolean=false, isForce:Boolean=false):void
		{
			var info:SkillInfo = res.skillInfo;
			res.range = info.distance;
			res.isSkillThenWalk = false;
			var arr:Array = ThingUtil.entityUtil.entitysMap.getEntityByRangle(SceneRange.display);
			var entity:IEntity;
			var targetType:int = info.tSkill.targetType;
			// 是否瞬移技能
			var isTransfer:Boolean = info.tSkill.type == ESkillType._ESkillTypeTransfer;
			if(isTransfer)
			{
				setDirectionParams(res, isByClick);
				return;
			}
			
			var max:int = Math.pow(2, 30);
			var selected:Boolean;
			var targetSize:int = 0;
			
			// 技能类型
			for(var i:int = 1; i < max; i *= 2)
			{
				if((targetType & i) > 0)
				{
					if(i == ESkillTargetType._ESkillTargetTypeEnemy) 
					{
						// 目标类型为敌人的时候，需要根据ESkillSelectType判断
						switch(info.tSkill.targetSelect)
						{
							case ESkillTargetSelect._ESkillTargetSelectNeedTarget:
								if(ThingUtil.selectEntity != null)
								{
									res.entitys = [ThingUtil.selectEntity.entityInfo.entityInfo.entityId];
									targetSize = ThingUtil.selectEntity.entityInfo.bodySize;
								}
								if(FightUtil.isNormalAttackable(ThingUtil.selectEntity))
								{
									res.target = ThingUtil.selectEntity;
									res.range = RolePlayer.instance.entityInfo.bodySize + info.distance + targetSize;
								}
								return;
								break;
							case ESkillTargetSelect._ESkillTargetSelectAutoTarget:
								entity = getEntityByParams(targetType, arr);
								break;
							case ESkillTargetSelect._ESkillTargetSelectSelf:
								res.entitys = [];// RolePlayer.instance.entityInfo.entityInfo.entityId
//								if(ThingUtil.selectEntity != null && !(ThingUtil.selectEntity).isDead)
//								{
//									res.entitys.push(ThingUtil.selectEntity.entityInfo.entityInfo.entityId);
//								}
								res.target = RolePlayer.instance;
								return;
								break;
							
							case ESkillTargetSelect._ESkillTargetSelectMouseDirection:
							case ESkillTargetSelect._ESkillTargetSelectMouse:
								res.entitys = [];
								
								// 鼠标点击的， 没有目标， 那么不允许使用技能
								if(isByClick)
								{
									if(ThingUtil.selectEntity == null)
									{
										// 没有目标不允许释放
										res.entitys = null;
										res.point = null;
									}
									else if(FightUtil.isNormalAttackable(ThingUtil.selectEntity))
									// 有目标则以目标为中心点释放
									{
										res.entitys = [];
										res.isSkillThenWalk = false;
										res.point = getSPoint(ThingUtil.selectEntity);
									}
								}
								// 键盘使用技能
								else
								{
									selected = !ClientSetting.local.getIsDone(
										IsDoneType.SkillAutoSelectStart + info.position - 1);
									if(selected) // 勾选了以目标为中心，以目标为中心释放技能
									{
										// 没有目标, 则以鼠标为中心释放
										if(ThingUtil.selectEntity == null)
										{
											res.entitys = [];
											res.point = SceneRange.getMousePoint();
											// 没有目标，且以鼠标为方向的技能， 那么先放技能，再走到目标点
//											if(info.tSkill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouseDirection)
//											{
												res.isSkillThenWalk = true;
//											}
										}
										else if(FightUtil.isNormalAttackable(ThingUtil.selectEntity))
										// 有目标，则以目标为中心释放
										{
											res.entitys = [ThingUtil.selectEntity.entityInfo.entityInfo.entityId];
											res.point = getSPoint(ThingUtil.selectEntity);
										}
									}
									else // 以鼠标为中心释放技能
									{
										res.entitys = [];
										res.point = SceneRange.getMousePoint();
										// 没有目标，且以鼠标为方向的技能， 那么先放技能，再走到目标点
//										if(info.tSkill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouseDirection)
//										{
											res.isSkillThenWalk = true;
//										}
									}
								}
								
								// 假如是一目标为中心释放的， 并且当前没选中目标，则先走到鼠标中心范围内，再放
								if(res.point != null && info.tSkill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouse)
								{
									res.range = info.distance + RolePlayer.instance.entityInfo.bodySize;
								}
								else if(info.tSkill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouseDirection)
								{
									res.range = 1000000;
								}
								
								// 移动目标
								if(ThingUtil.selectEntity != null && FightUtil.isNormalAttackable(ThingUtil.selectEntity))
								{
									res.target = ThingUtil.selectEntity;
								}
								return;
								break;
						}
						
					}
					else
					{
						entity = getEntityByParams(targetType, arr);
					}
					if(entity != null)
					{
						res.target = entity;
						res.range = info.distance + RolePlayer.instance.entityInfo.bodySize + entity.entityInfo.bodySize;
						res.entitys = [entity.entityInfo.entityInfo.entityId];
						return;
					}
				}
			}
		}
		
		private static function setDirectionParams(res:FollowFightAIData, isByClick:Boolean=false):void
		{
			res.entitys = [];
			if(isByClick) // 鼠标点击， 则以面向为目标方向
			{
				// 玩家当前的弧度， 以右边为0， 顺时针为正
				var direction:Number = RolePlayer.instance.direction/180 * Math.PI;
				res.point = new SPoint();
				res.point.x = RolePlayer.instance.x2d + 100*Math.cos(direction);
				res.point.y = RolePlayer.instance.y2d + 100*Math.sin(direction);
			}
			else // 键盘使用，则以鼠标为方向
			{
				res.point = SceneRange.getMousePoint();
				res.isSkillThenWalk = true;
			}
		}
		
		public static function getSPoint(entity:IEntity):SPoint
		{
			var res:SPoint = new SPoint();
			res.x = entity.x2d;
			res.y = entity.y2d;
			return res;
		}
		
		private static function getEntityByParams(targetType:int, arr:Array):IEntity
		{
			var res:IEntity;
			var isDead:Boolean = false;
			var friendType:int = EntityRelationUtil.ENEMY;
			var entityType:int = EEntityType._EEntityTypePlayer;
			
			switch(targetType) // 这个是 3 = 1+ 2的， 以后改
			{
				case 3:
				case ESkillTargetType._ESkillTargetTypeSelf:
					res = RolePlayer.instance;
					isDead = false;
					break;
				case ESkillTargetType._ESkillTargetTypeFriend:
					isDead = false;
					friendType = EntityRelationUtil.FIREND;
					break;
				
				
				case ESkillTargetType._ESkillTargetTypeDeadBodyFriend:
					isDead = true;
					friendType = EntityRelationUtil.FIREND;
					break;
				
				case ESkillTargetType._ESkillTargetTypeDeadBodyEnemy:
					isDead = true;
					friendType = EntityRelationUtil.ENEMY;
					entityType = -1;
					break;
				
				case ESkillTargetType._ESkillTargetTypeEnemy:
					isDead = false;
					friendType = EntityRelationUtil.ENEMY;
					entityType = -1;
					break;
				
				////////////////////////////////////////
				
				case ESkillTargetType._ESkillTargetTypeDeadBodySelf:
					if(RolePlayer.instance.isDead)
					{
						res = RolePlayer.instance;
					}
					else
					{
						ThingUtil.selectEntity = null;
					}
					entityType = -1;
					isDead = true;
					break;
				case ESkillTargetType._ESkillTargetTypeMaster: // 宠物对主人释放
					res = RolePlayer.instance;
					isDead = false;
					break;
			}
			if(res != null)
			{
				if(res != RolePlayer.instance)
				{
					ThingUtil.selectEntity = res;
				}
				return res;
			}
			
			return ThingUtil.entityUtil.entitysMap.selectEntity(entityType, null, friendType, false, isDead, arr);
		}
		
		public static function isEntityCanBeAutoSelected(entity:IEntity):Boolean
		{
			if(entity is PetPlayer)
			{
				return !SystemSetting.instance.isNotAutoSelectPet.bValue;
			}
			else if(entity is UserPlayer)
			{
				return !SystemSetting.instance.isNotAutoSelectPlayer.bValue;
			}
			else if(entity is MonsterPlayer)
			{
				return !SystemSetting.instance.isNotAutoSelectMonster.bValue;
			}
			return true;
		}
				
	}
}