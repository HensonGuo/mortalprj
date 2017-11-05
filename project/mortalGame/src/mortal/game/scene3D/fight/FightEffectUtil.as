package mortal.game.scene3D.fight
{
	import Framework.MQ.IMessageEx;
	
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TBuff;
	import Message.DB.Tables.TSkill;
	import Message.DB.Tables.TSkillModel;
	import Message.Game.SBeginFight;
	import Message.Game.SDoFight;
	import Message.Game.SDoFights;
	import Message.Game.SSkillCast;
	import Message.Public.EBuffType;
	import Message.Public.EEntityAttribute;
	import Message.Public.EHurtType;
	import Message.Public.ESkillTargetSelect;
	import Message.Public.ESkillTargetType;
	import Message.Public.ESkillType;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SEntityId;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.MathUitl;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.plugins.DynamicPropsPlugin;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.PhysicsPropsPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.tableConfig.BuffConfig;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.resource.tableConfig.SkillModelConfig;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.layer3D.SLayer3D;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.model.data.FightData;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.MovePlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.scene3D.player.entity.UserPlayer;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.type.EffectType;
	import mortal.game.scene3D.util.JumpUtil;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.view.skillProgress.SkillProgressView;
	import mortal.mvc.core.Dispatcher;

	public class FightEffectUtil
	{

		private var _isStart:Boolean=false;
		private var _dcFight:Dictionary=new Dictionary();
		private var _gThis:FightEffectUtil;

		public function FightEffectUtil()
		{
			_gThis=this;
			if (!_isStart)
			{
				TweenPlugin.activate([DynamicPropsPlugin]);
				TweenPlugin.activate([PhysicsPropsPlugin]);
				TweenPlugin.activate([MotionBlurPlugin]);
				_isStart=true;
			}
		}

		private var vcBeginFight:Vector.<SBeginFight>=new Vector.<SBeginFight>();

		private function onPlayerFireHandler(e:PlayerEvent):void
		{
			var player:SpritePlayer=e.player as SpritePlayer;
			if (vcBeginFight.length > 0)
			{
				var sbeginFight:SBeginFight=vcBeginFight.shift();
				beginFight(sbeginFight);
			}
			else
			{
				player.removeEventListener(PlayerEvent.PLAYER_FIRE, onPlayerFireHandler);
			}
		}

		public static var attackMeMonster:MonsterPlayer;
		public static var attackMeCheck:int=-1;
		
		//攻击我的怪物和人物列表
		public static var attackMeMonsterList:Vector.<SEntityId>=new Vector.<SEntityId>();
		public static var attackMeUserList:Vector.<SEntityId> = new Vector.<SEntityId>();
		public static var attackMePetList:Vector.<SEntityId> = new Vector.<SEntityId>();
		private static var dicMonsterTimer:Dictionary=new Dictionary(true);
		private static var dicUserTimer:Dictionary=new Dictionary(true);
		private static var dicPetTimer:Dictionary=new Dictionary(true);

		private static var skillTransferId:int=-1;
		private static var skillTransferIsChange:Boolean=false;
		private static var skillTransferPoint:Point=new Point();

		/**
		 * 清除攻击我的怪物
		 *
		 */
		private static function clearAttackMeMonster():void
		{
			attackMeMonster=null;
		}

		/**
		 * 添加到攻击我的怪物列表
		 * @param entityId
		 *
		 */
		private static function addToAttackList(entityId:SEntityId, time:int=1000):void
		{
			removeFromList(entityId);

			attackMeMonsterList.push(entityId);
			var timer:uint=setTimeout(removeFromList, time, entityId);
			dicMonsterTimer[entityId]=timer;
		}

		private static function removeFromList(entityId:SEntityId):void
		{
			var index:int=attackMeMonsterList.indexOf(entityId);
			if (index != -1)
			{
				attackMeMonsterList.splice(index, 1);
				var timer:uint=dicMonsterTimer[entityId];
				clearTimeout(timer);
			}
		}

		/**
		 * 得到实体
		 * @param entityId
		 * @return
		 *
		 */
		protected function getEntity(entityId:SEntityId, msgEx:IMessageEx=null):IEntity
		{
			return ThingUtil.entityUtil.getEntity(entityId);
		}

		/**
		 * 得到实体
		 * @param entityId
		 * @return
		 *
		 */
		protected function getEntityInfo(entityId:SEntityId, msgEx:IMessageEx=null):EntityInfo
		{
			return Cache.instance.entity.getEntityInfoById(entityId);
		}

		
		
		/**
		 * 得到技能层
		 * @return
		 *
		 */
		protected function getSkillLayer():SLayer3D
		{
			return Game.scene.playerLayer;
		}


		/**
		 * 开始战斗攻击
		 * @param sbeginFight
		 *
		 * EAttributeAttackType = 300,			//攻击类型
		 * EAttributeAttackSkill = 301,		 	//攻击技能
		 */
		public function beginFight(sbeginFight:SBeginFight):void
		{
//			Log.debug("开始攻击",getTimer());
			if (sbeginFight == null)
			{
				return;
			}

			var isEnemy:Boolean=true;
			var i:int;
			var toEntitys:Array=sbeginFight.toEntitys;
			var toPlayer:SpritePlayer;
			var toPlayers:Vector.<SpritePlayer> = new Vector.<SpritePlayer>();

			var fromPlayer:SpritePlayer=getEntity(sbeginFight.fromEntity, sbeginFight.msgEx) as SpritePlayer;
//			if(fromPlayer is RolePlayer)
//			{
//				(fromPlayer as RolePlayer).stopMove();
//			}
			var skillID:int=0;
			var skill:TSkill;
			var targetPoint:Point;//技能释放点
			var targetJumpPoint:Point;//跳跃目标点
			var targetRushForwardPoint:Point;//冲锋目标点

			for each (var attUpdate:SAttributeUpdate in sbeginFight.propertyUpdates)
			{
				switch (attUpdate.attribute.value())
				{
					//技能id
					case EEntityAttribute._EAttributeAttackSkill:
					{
						skillID=attUpdate.value;
						break;
					}
					//技能释放坐标
					case EEntityAttribute._EAttributePointX:
					{
						if (!targetPoint)
						{
							targetPoint=new Point();
						}
						targetPoint.x=attUpdate.value;
						break;
					}
					case EEntityAttribute._EAttributePointY:
					{
						if (!targetPoint)
						{
							targetPoint=new Point();
						}
						targetPoint.y=attUpdate.value;
						break;
					}
					//跳斩
					case EEntityAttribute._EAttributeJumpCutPointX:
					{
						if (!targetJumpPoint)
						{
							targetJumpPoint=new Point();
						}
						targetJumpPoint.x=attUpdate.value;
						break;
					}
					case EEntityAttribute._EAttributeJumpCutPointY:
					{
						if (!targetJumpPoint)
						{
							targetJumpPoint=new Point();
						}
						targetJumpPoint.y=attUpdate.value;
						break;
					}
					//冲锋
					case EEntityAttribute._EAttributeRushForwardPointX:
					{
						if (!targetRushForwardPoint)
						{
							targetRushForwardPoint=new Point();
						}
						targetRushForwardPoint.x=attUpdate.value;
						break;
					}
					case EEntityAttribute._EAttributeRushForwardPointY:
					{
						if (!targetRushForwardPoint)
						{
							targetRushForwardPoint=new Point();
						}
						targetRushForwardPoint.y=attUpdate.value;
						break;
					}
				}
			}

//			if(targetPoint)
//			{
//				targetPoint = GameMapUtil.getPixelPoint(targetPoint.x,targetPoint.y);
//			}
//			if(targetJumpPoint)
//			{
//				targetJumpPoint = GameMapUtil.getPixelPoint(targetJumpPoint.x,targetJumpPoint.y);
//			}
			
			if (fromPlayer == null)
			{
				return;
			}

			//添加到攻击我的怪物、人物、宠物列表
			for (i=0; i < toEntitys.length; i++)
			{
				if (EntityUtil.equal(toEntitys[i] as SEntityId, RolePlayer.instance.entityInfo.entityInfo.entityId))
				{
					if(fromPlayer is MonsterPlayer)
					{
						if (ThingUtil.entityUtil.isAttackAble(fromPlayer, false))
						{
							attackMeMonster=fromPlayer as MonsterPlayer;
							//3秒后没有怪物攻击则释放
							if (attackMeCheck >= 0)
							{
								clearTimeout(attackMeCheck);
							}
							attackMeCheck=setTimeout(clearAttackMeMonster, 3000);
							addToAttackList(fromPlayer.entityInfo.entityInfo.entityId,(fromPlayer as MonsterPlayer).tboss.attackSpeed + 1000);
						}
					}
					if(fromPlayer is UserPlayer)
					{
						if (ThingUtil.entityUtil.isAttackAble(fromPlayer, false))
						{
							addToAttackList(fromPlayer.entityInfo.entityInfo.entityId,3000);
						}
					}
//					if(fromPlayer is PetPlayer)
//					{
//						if (ThingUtil.entityUtil.isAttackAble(fromPlayer, false))
//						{
//							addToAttackList(fromPlayer.entityInfo.entityInfo.entityId,3000);
//						}
//					}
					break;
				}
			}

			for(i =0;i < toEntitys.length;i++)
			{
				toPlayer = getEntity(toEntitys[i], sbeginFight.msgEx) as SpritePlayer;
				if(toPlayer)
				{
					toPlayers.push(toPlayer);
				}
			}
			
			if(fromPlayer is RolePlayer)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ScenePlaySkill,skillID));
			}
			
			skill=SkillConfig.instance.getInfoByName(skillID);
			if(!skill)
			{
				Log.debug("找不到技能！",skillID);	
				return;
			}
			var isCanselSelectTarget:Boolean = false;
			//隐身技能取消选择目标
			if(skill.type == ESkillType._ESkillTypeAddBuff)
			{
				var buff:TBuff = BuffConfig.instance.getInfoById(skill.additionBuff);
				if(buff.type == EBuffType._EBuffTypeDisappear)
				{
					isCanselSelectTarget = true;
				}
			}
			//分身取消选择目标
			if(skill.type == ESkillType._ESkillTypeCopyBody)
			{
				isCanselSelectTarget = true;
			}
			if(isCanselSelectTarget && ThingUtil.selectEntity == fromPlayer)
			{
				ThingUtil.selectEntity = null;
			}
			
//			else
//			{
//				Log.debug("beginFight",skillID,skill.skillModel,sbeginFight.attackId);
//			}
			if (fromPlayer is RolePlayer)
			{
				//播放声音 处理技能Cd 飘技能名字等
				//处理读条 旋风斩例外
				if((skill.useTime > 0 || skill.leadTime > 0) && skill.type != ESkillType._ESKillTypeTornado)
				{
					SkillProgressView.instance.start(skill);
				}
			}
			
			//处理播放技能特效
			var fightEffect:FightEffectBase;
			//读条或者吟唱
			if(skill.useTime > 0 || skill.leadTime > 0)
			{
				fightEffect = ObjectPool.getObject(FightEffectLead);
			}
			//普通技能
			else
			{
				FightData.addBeginFight(sbeginFight.attackId);
				fightEffect = ObjectPool.getObject(FightEffectNormal);
			}
			fightEffect.setAttackId(sbeginFight.attackId);
			fightEffect.setFromPlayer(fromPlayer);
			fightEffect.setSkill(skill);
			if(targetPoint)
			{
				fightEffect.setTargetPoint(targetPoint);
			}
			if(targetJumpPoint)
			{
				fightEffect.setTargetPoint(targetJumpPoint);
			}
			if(targetRushForwardPoint)
			{
				fightEffect.setTargetPoint(targetRushForwardPoint);
			}
			if(toPlayers.length && (skill.targetSelect == ESkillTargetSelect._ESkillTargetSelectAutoTarget || skill.targetSelect == ESkillTargetSelect._ESkillTargetSelectNeedTarget))
			{
				fightEffect.setTargetPlayer(toPlayers[0]);
			}
			fightEffect.setHitPlayers(toPlayers);
			//吟唱不需要回调
			if(skill.useTime <= 0 && skill.leadTime <=0)
			{
				fightEffect.setCallBack(doFightBeginAttackId);
			}
			fightEffect.runStart();
//			processAttack(sbeginFight.attackId,skill,fromPlayer,toPlayers,targetPoint);

			//跳跃
			if(targetJumpPoint)
			{
				mortal.game.scene3D.util.JumpUtil.jumpCut(fromPlayer as MovePlayer,targetJumpPoint.x,targetJumpPoint.y,0.7,null);
			}
			//冲锋
			if(targetRushForwardPoint)
			{
				mortal.game.scene3D.util.JumpUtil.jumpCut(fromPlayer as MovePlayer,targetRushForwardPoint.x,targetRushForwardPoint.y,0.2,null);
			}
			
			if (isEnemy)
			{
				//添加到攻击我的玩家列表 
				for (i=0; i < toEntitys.length; i++)
				{
					if (EntityUtil.equal(toEntitys[i] as SEntityId, RolePlayer.instance.entityInfo.entityInfo.entityId))
					{
						fromPlayer.entityStatus.isAttackRole=true;
					}
				}
			}
		}

		/**
		 * 引导技能释放开始 
		 * 
		 */		
		public function skillCast(skillCast:SSkillCast):void
		{
			var skill:TSkill = SkillConfig.instance.getInfoByName(skillCast.skillId);
			var fromPlayer:SpritePlayer = ThingUtil.entityUtil.getEntity(skillCast.entityId) as SpritePlayer;
			if(!fromPlayer)
			{
				return;
			}
			var skillModle:TSkillModel = SkillModelConfig.instance.getInfoById(skill.skillModel);
			
			//打断不释放技能表现
			if(skillCast.count == -1)
			{
				if(ActionType.isLeadingAction(fromPlayer.actionName))
				{
					fromPlayer.setAction(ActionType.Stand,ActionName.Stand);
				}
				return;
			}
			
			//读条结束
			if(skill.leadCount == 0 && skillModle)
			{
				fromPlayer.setAction(ActionType.attack,skillModle.endAction);
			}
			//吟唱 最后一次则播放结束动作 
			else if(skillCast.count == skill.leadCount)
			{
				if(fromPlayer is MovePlayer && (fromPlayer as MovePlayer).isMove)
				{
					fromPlayer.setAction(ActionType.Walking,ActionName.Walking,true);
				}
				else
				{
					fromPlayer.setAction(ActionType.Stand,ActionName.Stand,true);
				}
			}
			
			//处理技能特效变现
			var toPlayers:Vector.<SpritePlayer> = new Vector.<SpritePlayer>();
			var toPlayer:SpritePlayer;
			for(var i:int = 0;i < skillCast.toEntityIds.length;i++)
			{
				toPlayer = getEntity(skillCast.toEntityIds[i], skillCast.msgEx) as SpritePlayer;
				if(toPlayer)
				{
					toPlayers.push(toPlayer);
				}
			}
			
			var fightEffect:FightEffectBase;
			//读条或者吟唱
			fightEffect = ObjectPool.getObject(FightEffectLeadRelease);
//			fightEffect.setAttackId(sbeginFight.attackId);
			fightEffect.setFromPlayer(fromPlayer);
			fightEffect.setSkill(skill);
			if(skillCast.point &&
				(skill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouseDirection || skill.targetSelect == ESkillTargetSelect._ESkillTargetSelectMouse))
			{
				var point:Point = new Point();
				point.x = skillCast.point.x;
				point.y = skillCast.point.y;
				fightEffect.setTargetPoint(point);
			}
			if(toPlayers.length && (skill.targetSelect == ESkillTargetSelect._ESkillTargetSelectAutoTarget || skill.targetSelect == ESkillTargetSelect._ESkillTargetSelectNeedTarget))
			{
				fightEffect.setTargetPlayer(toPlayers[0]);
			}
			fightEffect.setHitPlayers(toPlayers);
//			fightEffect.setCallBack(doFightBeginAttackId);
			fightEffect.runStart();
		}
		
		private function doFightBeginAttackId(attackId:int):void
		{
			var array:Array=FightData.getDoFight(attackId);
			for each (var doFight:SDoFight in array)
			{
				doFightStart(doFight);
			}
//			Log.debug("removeBeginFight",attackId);
			FightData.removeBeginFight(attackId);
		}

		/**
		 * 战斗伤害列表
		 *
		 */
		public function doFights(paramDoFights:SDoFights):void
		{
			if (paramDoFights == null || paramDoFights.doFights.length == 0)
			{
				return;
			}

			for each (var doF:SDoFight in paramDoFights.doFights)
			{
				_gThis.doFight(doF);
			}
		}

		/**
		 *  战斗伤害
		 * @param doFight
		 *
		 */
		public function doFight(doFight:SDoFight):void
		{
//			Log.debug("doFight：消息",doFight.attackId);
			if (doFight == null)
				return;
			var toEntityInfo:EntityInfo = getEntityInfo(doFight.entity, doFight.msgEx) as EntityInfo;
			if(toEntityInfo)
			{
				toEntityInfo.updateAttribute(doFight.propertyUpdates,false);
			}
			if (!FightData.addDoFight(doFight))
			{
//				Log.debug("!FightData.addDofight",doFight.attackId);
				doFightStart(doFight);
			}

			//自动选择攻击你的对象
		}

		private function doFightStart(doFight:SDoFight):void
		{
//			Log.debug("doFightStart:消息");
			if (doFight == null)
				return;
			var toPlayer:SpritePlayer=getEntity(doFight.entity, doFight.msgEx) as SpritePlayer;
			if (toPlayer == null)
				return;

			var fromPlayer:SpritePlayer=getEntity(doFight.fromEntity, doFight.msgEx) as SpritePlayer;
			var propertyUpdates:Array=doFight.propertyUpdates;
			var isUpdate:Boolean=false;
			var entityInfo:SEntityInfo=toPlayer.entityInfo.entityInfo;
			var toX:int;
			var toY:int;
			var skill:TSkill = SkillConfig.instance.getInfoByName(doFight.skillId);
			var fightUpdateAttribute:FightUpdateAttribtue = new FightUpdateAttribtue();
			if(skill)
			{
				fightUpdateAttribute.textDirection = skill.textDirection;
			}
			//1为竖着飘，0为方向飘
			if(!fromPlayer || toPlayer is RolePlayer || EntityRelationUtil.isOwnerSelf(toPlayer.entityInfo.entityInfo))
			{
				fightUpdateAttribute.textDirection = 1;
			}
			if(!fightUpdateAttribute.textDirection)
			{
				fightUpdateAttribute.fromX = fromPlayer.x2d;
				fightUpdateAttribute.fromY = fromPlayer.y2d;
				fightUpdateAttribute.toX = toPlayer.x2d;
				fightUpdateAttribute.toY = toPlayer.y2d;
			}
			
			
			for each (var attUpdate:SAttributeUpdate in propertyUpdates)
			{
				if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurtType)
				{
					switch (attUpdate.value)
					{
						case EHurtType._EHurtTypeBlock: //格挡
						{
							fightUpdateAttribute.isBlock = true;
							break;
						}
						case EHurtType._EHurtTypeCrit: // 暴击
						{
							fightUpdateAttribute.isCrit = true;
//							if(fromPlayer is RolePlayer)
//							{
//								shake();
//							}
							break;
						}
						case EHurtType._EHurtTypeJouk: // 闪避
						{
							fightUpdateAttribute.isJouk = true;
							break;
						}
						case EHurtType._EHurtTypeCrush: // 闪避
						{
							fightUpdateAttribute.isCrush = true;
							break;
						}
						case EHurtType._EHurtTypeImmune: // 免疫
						{
							fightUpdateAttribute.isImmune = true;
							break;
						}
						case EHurtType._EHurtTypeNormal: //普通伤害
						{
							break;
						}
					}
				}
				//血量
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurt)
				{
					fightUpdateAttribute.hurtNumber = attUpdate.value;
//					Log.debug("doFight：",hurtNumber)
				}
				//蓝量
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeManaHurt)
				{
					fightUpdateAttribute.manaNumber = attUpdate.value;
				}
				//吸收
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurtSuck)
				{
					fightUpdateAttribute.suckNumber=attUpdate.value;
				}
				//转治疗
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurtToCure)
				{
					fightUpdateAttribute.cureNumber=attUpdate.value;
				}
				//反射
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurtReflex)
				{
					fightUpdateAttribute.reflexNumber=attUpdate.value;
				}
				//反弹
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurtRebound)
				{
					fightUpdateAttribute.reboundNumber=attUpdate.value;
				}
				//增益或者减益
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributeHurtPlusMinus)
				{
					fightUpdateAttribute.isAdd=Boolean(attUpdate.value);
				}
				//坐标
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributePointX)
				{
					toX=attUpdate.value;
				}
				else if (attUpdate.attribute.value() == EEntityAttribute._EAttributePointY)
				{
					toY=attUpdate.value;
				}
				else
				{
					isUpdate=true;
				}
			}

			if (fightUpdateAttribute.hurtNumber != 0)
			{
				toPlayer.entityInfo.updateLifeShow();
				toPlayer.hurt(fightUpdateAttribute.hurtNumber);
			}

			if ((fightUpdateAttribute.hurtNumber > 0 || fightUpdateAttribute.manaNumber > 0) && !fightUpdateAttribute.isAdd)
			{
				toPlayer.setAction(ActionType.Injury,ActionName.Injury);
			}

			if((fromPlayer && EntityRelationUtil.isOwnerSelf(fromPlayer.entityInfo.entityInfo))
				|| (toPlayer && EntityRelationUtil.isOwnerSelf(toPlayer.entityInfo.entityInfo)))
			{
				toPlayer.cutHurtImpl(fightUpdateAttribute);
			}

			//处理冲锋拉人技能
//			if(toX && toY)
//			{
//				if(fromPlayer is RolePlayer)
//				{
//					shake();
//				}
//				else if(toPlayer is RolePlayer)
//				{
//					SkillProgress.instance.dispose();
//				}
//				var p:Point = GameMapUtil.getPixelPoint(toX, toY);
//				if(MathUitl.getDistance(RolePlayer.instance.x,p.x,RolePlayer.instance.y,p.y) > 600)
//				{
//					Log.debug("击退或者冲锋坐标异常",RolePlayer.instance.x,RolePlayer.instance.y,p.x,p.y);
//				}
//				toPlayer.isTweening = true;
//				TweenLite.to(toPlayer, 0.25, {x:p.x, y:p.y, onUpdate:function():void
//				{
//					toPlayer.setPixlePoint(toPlayer.x,toPlayer.y,false);
//				},onComplete: function():void
//				{
//					toPlayer.setPixlePoint(toPlayer.x,toPlayer.y,false);
//					toPlayer.isTweening = false;
//				}});
//			}
		}
	}
}
