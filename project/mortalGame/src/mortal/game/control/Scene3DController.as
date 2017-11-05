package mortal.game.control
{
	import Framework.MQ.MessageBlock;
	
	import Message.BroadCast.SDropEntityInfo;
	import Message.BroadCast.SEntityInfo;
	import Message.BroadCast.SEntityMoveInfo;
	import Message.BroadCast.SEntityUpdate;
	import Message.BroadCast.SSeqDropEntityInfo;
	import Message.BroadCast.SSeqEntityIdInfo;
	import Message.BroadCast.SSeqEntityInfo;
	import Message.BroadCast.SSeqEntityUpdate;
	import Message.Command.ECmdBroadCast;
	import Message.Command.EPublicCommand;
	import Message.DB.Tables.TSkill;
	import Message.Game.SBeginFight;
	import Message.Game.SDoFight;
	import Message.Game.SSkillCast;
	import Message.Public.ESkillType;
	import Message.Public.SBroadcastGroupIdUpdate;
	import Message.Public.SEntityId;
	import Message.Public.SGuildIdUpdate;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	import Message.Public.SPoints;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.control.subControl.Scene3DClickProcessor;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.events.SceneEvent;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.MapLoader;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.player.entity.MovePlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEvent;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.scene3D.player.item.ItemPlayer;
	import mortal.game.scene3D.util.JumpUtil;
	import mortal.game.view.skillProgress.SkillProgressView;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class Scene3DController extends Controller
	{
		
//		private var _entritysAry:Array = [];
		private var _dropItemAry:Array = [];
		private var _scene:GameScene3D;
		private var _clickProcessor:Scene3DClickProcessor;
		
		public function Scene3DController()
		{
			super();
		}
		
		override protected function initView():IView
		{
			_scene = Game.scene;
			_clickProcessor = new Scene3DClickProcessor(_scene);
			if (_scene != null)
			{
				_scene.addEventListener(SceneEvent.INIT, onSceneInitHandler);
			}
			return null;
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityInfo, onBroadCastHandler); // 单个实体信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityInfos, onBroadCastHandler); //批量实体信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityMoveInfo, onBroadCastHandler); // 实体移动信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityDiversion, onBroadCastHandler); // 实体移动信息
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicRoleMoveTo, onBroadCastHandler); // 实体移动信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityLeftInfo, onBroadCastHandler); // 实体离开信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityLeftInfos, onBroadCastHandler); // 实体离开信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityAttributeUpdate, onBroadCastHandler); //实体更新信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityGuildIdUpdate, onBroadCastHandler); //实体公会信息
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityAttributeUpdates, onBroadCastHandler); //批量实体更新
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityGroupIdUpdate, onBroadCastHandler); //批量实体更新
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastDropEntityInfo, onBroadCastHandler); // 单个物品掉落
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastDropEntityInfos, onBroadCastHandler); // 多个物品掉落
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityFlashInfo,onBroadCastHandler);//实体移动
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityOwner ,onBroadCastHandler);//实体归属
//			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityToEntityUpdate,onEntityToEntityUpdateHandler);//更新toEntitys
			
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityDoFight, onBroadCastHandler); //执行战斗操作
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityDoFights, onBroadCastHandler); //执行战斗操作
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityBeginFight, onBroadCastHandler); //实体开始战斗
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityBeginCollect, onBroadCastHandler);//实体开始采集
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntitySkillCast, onBroadCastHandler);//实体开始采集
			
			//跳跃相关
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntitySomersault, onBroadCastHandler);//实体翻滚
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityJump, onBroadCastHandler);//实体跳跃
			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityJumpPoint, onBroadCastHandler);//实体跳跃点
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicRoleSomersault, onBroadCastHandler);//自己翻滚
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicRoleJump, onBroadCastHandler);//自己跳跃
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicRoleJumpPoint, onBroadCastHandler);//自己跳跃点
			
//			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityNpcShop,onNpcShopBroadCastHandler);//NPC 掉落
//			NetDispatcher.addCmdListener(ECmdBroadCast._ECmdBroadcastEntityDropSimpleItem,onEntityDropSimpleItemHandler);
			//关于优先级说明，数字越大优先级越高，地图应该先更新，之后才是自动寻路继续寻路
			NetDispatcher.addCmdListener(ServerCommand.MapPointUpdate, onMapPointUpdate); //地图更新
//			RolePlayer.instance.addEventListener(RolePlayerEvent.ControlStateChange,onControlStateChange);
			
//			ClockManager.instance.addEventListener(TimeEvent.ServerOpenDayChange,onServerOpenDayChangeHandler); //开服时间改变
			Dispatcher.addEventListener(EventName.SceneSomersault,onSceneSomersault);//翻滚
			Dispatcher.addEventListener(EventName.KeyPickDropItem,keyPickDropItemHandler);
			Dispatcher.addEventListener(EventName.PickDropItem,keyPickDropItemHandler);
			
			cache.role.roleEntityInfo.addEventListener(EntityInfoEventName.UpdateFightMode,onUpdateFightMode);
		}
		
		private function onBroadCastHandler(mb:MessageBlock):void
		{
			var moveInfo:SEntityMoveInfo;
			var point:SPoint;
			var i:int;
			var player:MovePlayer;
			var entityInfo:SEntityInfo;
			var entityId:SEntityId;
			switch (mb.messageHead.command)
			{
				case ECmdBroadCast._ECmdBroadcastEntityInfo: //个体信息 10001
				{
					Log.debug("ECmdBroadCast._ECmdBroadcastEntityInfo");
					Log.debug((mb.messageBase as SEntityInfo).entityId.id);
					cache.entity.addEntity(mb.messageBase as SEntityInfo);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityInfos: // 多个实体信息 10002
				{
					Log.debug("ECmdBroadCast._ECmdBroadcastEntityInfos",(mb.messageBase as SSeqEntityInfo).entityInfos.length);
					for each( entityInfo in (mb.messageBase as SSeqEntityInfo).entityInfos)
					{
						Log.debug(entityInfo.entityId.id);
					}
					cache.entity.addEntitys(mb.messageBase as SSeqEntityInfo);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityMoveInfo: //移动信息 10003
				{
					moveInfo = mb.messageBase as SEntityMoveInfo;
					moveEntity(moveInfo, moveInfo.points);
//					Log.debug("ECmdBroadCast._ECmdBroadcastEntityMoveInfo");
//					for(i =0;i < moveInfo.points.length;i++)
//					{
//						point = moveInfo.points[i] as SPoint;
//						Log.debug(point.x,point.y);
//					}
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityDiversion: //移动转向信息 10003
				{
					moveInfo = mb.messageBase as SEntityMoveInfo;
					diversionEntity(moveInfo, moveInfo.points);
//					Log.debug("ECmdBroadCast._ECmdBroadcastEntityDiversion");
//					for(i = 0;i < moveInfo.points.length;i++)
//					{
//						point = moveInfo.points[i] as SPoint;
//						Log.debug(point.x,point.y);
//					}
					break;
				}
				//自己进入混乱状态
				case EPublicCommand._ECmdPublicRoleMoveTo:
				{
					var points:SPoints = mb.messageBase as SPoints;
					roleMoveTo(points);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastDropEntityInfo: //物品掉落
				{
					dropItem( mb.messageBase as SDropEntityInfo );
					break;
				}
				case ECmdBroadCast._ECmdBroadcastDropEntityInfos: //物品掉落批量
				{
					dropItems( mb.messageBase as SSeqDropEntityInfo );
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityLeftInfo: //个人离开 10004
				{
					Log.debug("ECmdBroadCast._ECmdBroadcastEntityLeftInfo");
					Log.debug((mb.messageBase as SEntityId).id);
					removeEntity(mb.messageBase as SEntityId);
					cache.entity.removeEntity(mb.messageBase as SEntityId);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityLeftInfos://批量移除
				{
					Log.debug("ECmdBroadCast._ECmdBroadcastEntityLeftInfos",(mb.messageBase as SSeqEntityIdInfo).entityIds.length);
					for each(entityId in (mb.messageBase as SSeqEntityIdInfo).entityIds)
					{
						Log.debug(entityId.id);
					}
					var infos:SSeqEntityIdInfo = mb.messageBase as SSeqEntityIdInfo;
					ThingUtil.entityUtil.removeEntitys(infos.entityIds);
					cache.entity.removeEntitys(infos.entityIds);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityAttributeUpdate: //个体属性更新 10005
				{
//					updateAttributes(mb.messageBase as SEntityUpdate);
					cache.entity.updateAttribute(mb.messageBase as SEntityUpdate);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityAttributeUpdates: //个体属性更新 10005
				{
//					updateAttributess(mb.messageBase as SSeqEntityUpdate);
					cache.entity.updateAttributes(mb.messageBase as SSeqEntityUpdate);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityGroupIdUpdate: //个体组队信息更新
				{
					updateEntityGroupId(mb.messageBase as SBroadcastGroupIdUpdate);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityBeginFight: //实体开始战斗
				{
					if (_scene)
					{
						var beginFight:SBeginFight = mb.messageBase as SBeginFight;
						
						if( beginFight.msgEx == null )
						{
							ThingUtil.fightUtil.beginFight(beginFight);
						}
					}
//					//Log.debug("开始战斗时间点：" + getTimer());
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityDoFight: //执行战斗操作
				{
					if (_scene)
					{
						var dofight:SDoFight = mb.messageBase as SDoFight;
						
						
						if( dofight.msgEx == null )
						{
							ThingUtil.fightUtil.doFight(dofight);
						}
					}
//					
//					//Log.debug("执行战斗时间点：" + getTimer());
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityDoFights: //执行战斗操作
				{
//					if (_scene)
//					{
//						var doFights:SDoFights = mb.messageBase as SDoFights;
//						
//						if(!FrameUtil.canOperate())
//						{
//							//卡的情况下只处理血量
//							doHurts(doFights.doFights);
//							break;
//						}
//						
//						ThingUtil.fightUtil.doFights(doFights);
//					}
					
					//Log.debug("执行战斗时间点：" + getTimer());
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntitySkillCast: //读条执行
				{
					var skillCast:SSkillCast = mb.messageBase as SSkillCast;
					//如果是自己处理读条
					if(EntityUtil.equal(skillCast.entityId,cache.role.roleEntityInfo.entityInfo.entityId))
					{
						var skill:TSkill = SkillConfig.instance.getInfoByName(skillCast.skillId);
						if(skill.type != ESkillType._ESKillTypeTornado)
						{
							SkillProgressView.instance.updateCount(skill,skillCast.count);
						}
					}
					//处理动作
					ThingUtil.fightUtil.skillCast(skillCast);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityOwner: //更新怪物归属
				{
//					var sentityIdPair:SEntityIdPair = mb.messageBase as SEntityIdPair;
//					ThingUtil.entityUtil.updateAttack(sentityIdPair);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityBeginCollect://开始采集
				{
//					if (_scene)
//					{
//						ThingUtil.collectUtil.beginFight(mb.messageBase as SBeginFight);
//					}
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityFlashInfo:  //实体拉倒某一个坐标
				{
					var info1:SEntityMoveInfo = mb.messageBase as SEntityMoveInfo;
					ThingUtil.entityUtil.refreshPoint(info1.entityId,info1.points);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntitySomersault://实体翻滚
				{
					moveInfo = mb.messageBase as SEntityMoveInfo;
					point = moveInfo.points[1];
					player = ThingUtil.entityUtil.getEntity(moveInfo.entityId) as MovePlayer;
					JumpUtil.somersault(player,point.x,point.y);
					break;
				}
				case EPublicCommand._ECmdPublicRoleSomersault://自己翻滚
				{
					Cache.instance.cd.somersaultCd.startCoolDown();
					point = (mb.messageBase as SPoints).points[1];
					JumpUtil.somersault(RolePlayer.instance,point.x,point.y);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityJump://实体跳跃
				case ECmdBroadCast._ECmdBroadcastEntityJumpPoint://实体跳跃
				{
					moveInfo = mb.messageBase as SEntityMoveInfo;
//					point = moveInfo.points[1];
					player = ThingUtil.entityUtil.getEntity(moveInfo.entityId) as MovePlayer;
//					JumpUtil.jump(player,point.x,point.y);
					JumpUtil.jumpPoints(player,moveInfo.points);
					break;
				}
				case EPublicCommand._ECmdPublicRoleJump://自己跳跃
				case EPublicCommand._ECmdPublicRoleJumpPoint://自己跳跃点
				{
					JumpUtil.jumpPoints(RolePlayer.instance,(mb.messageBase as SPoints).points);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityStop:
				{
					stopEntityMove(mb.messageBase as SEntityId);
					break;
				}
				case ECmdBroadCast._ECmdBroadcastEntityGuildIdUpdate:
				{
					updateEntityGuildId(mb.messageBase as SGuildIdUpdate);
					break;
				}
			}
		}
		
		private function updateEntityGroupId(groupIdUpdate:SBroadcastGroupIdUpdate):void
		{
			//如果是自己更新自己的
			if(EntityUtil.equal(groupIdUpdate.updateEntityId,cache.role.roleEntityInfo.entityInfo.entityId))
			{
				cache.role.roleEntityInfo.updateGroupId(groupIdUpdate.groupId);
				ThingUtil.isNameChange = true;
			}
			//更新别人的
			var entityInfo:EntityInfo = cache.entity.getEntityInfoById(groupIdUpdate.updateEntityId);
			if(entityInfo)
			{
				entityInfo.updateGroupId(groupIdUpdate.groupId);
			}
		}
		
//		private function updateAttributes( sentityUpdate:SEntityUpdate ):void
//		{
//			if (_scene && _scene.isInitialize)
//			{
//				ThingUtil.userUtil.updateAttribute(sentityUpdate);
//			}
//			else
//			{
//				for each( var info:SEntityInfo in _entritysAry )
//				{
//					//如果在离线数组中的
//					if( EntityUtil.toString(info.entityId) == EntityUtil.toString(sentityUpdate.entityId) )
//					{
//						UserUtil.updateEntityAttribute(info,sentityUpdate.propertyUpdates);
//						return;
//					}
//				}
//			}
//		}
//		
//		private function updateAttributess( seqEntityUpdate:SSeqEntityUpdate ):void
//		{
//			for each(var sentityUpdate:SEntityUpdate in seqEntityUpdate )
//			{
//				updateAttributes(seqEntityUpdate);
//			}
//		}
		
		/* 移动实体
		* @param entityId
		* @param points
		*
		*/
		public function moveEntity(moveInfo:SEntityMoveInfo, points:Array):void
		{
			if (_scene)
			{
				var pary:Array=[];
				var p:SPoint;
				for (var i:int=0; i < points.length; i++)
				{
					p = points[i];
					var targetPoint:AstarTurnPoint = new AstarTurnPoint();
					targetPoint.setValue(p.x, p.y);
					pary.push(targetPoint);
				}
				ThingUtil.entityUtil.moveEntity(moveInfo, pary);
			}
		}
		
		/* 转向移动实体
		* @param entityId
		* @param points
		*
		*/
		public function diversionEntity(moveInfo:SEntityMoveInfo, points:Array):void
		{
			if (_scene)
			{
				var pary:Array=[];
				var p:SPoint;
				for (var i:int=0; i < points.length; i++)
				{
					p = points[i];
					var targetPoint:AstarTurnPoint = new AstarTurnPoint();
					targetPoint.setValue(p.x, p.y);
					pary.push(targetPoint);
				}
				ThingUtil.entityUtil.diversionEntity(moveInfo, pary);
			}
		}
		
		/* 转向移动实体
		* @param entityId
		* @param points
		*
		*/
		public function roleMoveTo(points:SPoints):void
		{
			if (_scene)
			{
				var pary:Array=[];
				var p:SPoint;
				for (var i:int=0; i < points.points.length; i++)
				{
					p = points.points[i];
					var targetPoint:AstarTurnPoint = new AstarTurnPoint();
					targetPoint.setValue(p.x, p.y);
					pary.push(targetPoint);
				}
				Log.debug("roleMoveTo:",pary);
				RolePlayer.instance.inServerMove = true;
				RolePlayer.instance.walking(pary);
			}
		}
			
		private function onSceneInitHandler(event:SceneEvent):void
		{
//			// 添加实体
//			if (_entritysAry.length)
//			{
//				Log.debug("_entritysAry:" + _entritysAry);
//				ThingUtil.entityUtil.addEntitys(_entritysAry);
//				_entritysAry.length = 0;
//			}
			if(_dropItemAry.length)
			{
				ThingUtil.dropItemUtil.addDropItems(_dropItemAry);
				_dropItemAry.length = 0;
			}
			
			//添加事件
			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN,onSceneMouseClick);
			RolePlayer.instance.addEventListener(PlayerEvent.GIRD_WALK_START, onGirdWalkStartHandler);
			RolePlayer.instance.addEventListener(PlayerEvent.ServerPoint,onServerPointsHandler);
			RolePlayer.instance.addEventListener(PlayerEvent.WALK_END, onWalkEndHandler);
			
			Dispatcher.dispatchEvent(new DataEvent( EventName.Scene_Update,Game.sceneInfo ));
			
			ThingUtil.isMoveChange = true;
		}
		
		/**
		 * 移动点 
		 * @param event
		 * 
		 */
		private function onGirdWalkStartHandler(event:PlayerEvent):void
		{
			//更新玩家当前位置
//			Dispatcher.dispatchEvent(new DataEvent(EventName.MapUpdateRolePosition, RolePlayer.instance.currentPoint));
			if( RolePlayer.instance.isCanControlWalk)
			{
				GameProxy.sceneProxy.move(RolePlayer.instance.serverPoints);
			}
		}
		
		/**
		 * 起步或者转向 
		 * @param event
		 * 
		 */
		private function onServerPointsHandler(event:PlayerEvent):void
		{
			if( RolePlayer.instance.isCanControlWalk)
			{
				GameProxy.sceneProxy.diversion(RolePlayer.instance.serverPoints);
			}
		}
		
		/**
		 * 移动结束 
		 * @param e
		 * 
		 */		
		private function onWalkEndHandler(e:PlayerEvent):void
		{
			GameProxy.sceneProxy.clearLastPoint();
			_scene.removePointMark();
		}
		
		private var _lastClickScene:int;
		
		private function onSceneMouseClick(e:MouseEvent):void
		{
			if(_clickProcessor == null || !_scene.getMouseEnabled())
			{
				return;
			}
			_clickProcessor.work(e);
		}
		
//		/**
//		 * 添加多个玩家
//		 * @param array
//		 *
//		 */
//		public function addEntitys(entityInfos:SSeqEntityInfo):void
//		{
//			var array:Array = entityInfos.entityInfos;
//			var info:SEntityInfo;
//			for (var i:int=0; i < array.length; i++)
//			{
//				info = array[i];
//				info.msgEx = entityInfos.msgEx;
//			}
//			if (_scene && _scene.isInitialize)
//			{
//				ThingUtil.entityUtil.addEntitys(array);
//			}
//			else
//			{
//				_entritysAry=_entritysAry.concat(array);
//			}
//		}
		
//		/**
//		 * 添加玩家
//		 * @param info
//		 *
//		 */
//		public function addEntity(info:SEntityInfo):void
//		{
//			if (_scene && _scene.isInitialize)
//			{
//				ThingUtil.entityUtil.addEntity(info);
//			}
//			else
//			{
//				_entritysAry.push(info);
//			}
//		}
		
		/**
		 * 删除单个实体
		 * @param info
		 *
		 */
		public function removeEntity(info:SEntityId):void
		{
			//Log.debug("server delete:" + info.id);
			if (_scene)
			{
				ThingUtil.entityUtil.removeEntity(info);
			}
		}
		
		/**
		 * 掉落物品 
		 * @param dropEntityInfo
		 * 
		 */		
		private function dropItem(dropEntityInfo:SDropEntityInfo):void
		{
			if (_scene && _scene.isInitialize)
			{
				ThingUtil.dropItemUtil.addDropItem(dropEntityInfo);
			}
			else
			{
				_dropItemAry.push(dropEntityInfo);
			}
		}
		
		/**
		 * 掉落多个物品 
		 * @param dropEntityInfos
		 * 
		 */		
		private function dropItems(dropEntityInfos:SSeqDropEntityInfo):void
		{
			if (_scene && _scene.isInitialize)
			{
				ThingUtil.dropItemUtil.addDropItems(dropEntityInfos.entityInfos);
			}
			else
			{
				_dropItemAry = _dropItemAry.concat(dropEntityInfos.entityInfos);
			}
		}
		
		private var _tempMapPassTo:SPassTo;
		
		private function onMapPointUpdate(passTo:SPassTo):void
		{
			if (_scene == null || _scene.isInitialize == false)
			{
				if(passTo.mapId == MapFileUtil.mapID)
				{
					_tempMapPassTo = passTo;
					return;
				}
				else
				{
					MapLoader.instance.stop();
//					_entritysAry.length = 0;
				}
			}
			
			mapPassTo(passTo);
		}
		
		private function mapPassTo( data:SPassTo ):void
		{
//			RolePlayer.instance.entityInfo.setNotFighting();
			
			//副本内传送
			if( data.passToId == 10 || data.mapId != MapFileUtil.mapID )
			{
				if( ThingUtil.selectEntity != null )
				{
					ThingUtil.selectEntity.selected = false;
				}
				
				//离开场景  通过GameMapUtil.curMapState判断地图状态
				Dispatcher.dispatchEvent(new DataEvent( EventName.LeaveScene,MapFileUtil.mapID ));
				
				_scene.clearAll();
				
				RolePlayer.instance.stopMove();
				MapFileUtil.mapID = data.mapId;
				GameMapUtil.curMapState.initMapId( data.mapId);
				// 场景改变
				Dispatcher.dispatchEvent(new DataEvent( EventName.ChangeScene ));
				
				_scene.setPlayerPoint(data.mapId, data.toPoint.x, data.toPoint.y);
			}
			else
			{
//				if( SceneRange.display.contains( data.toPoint.x,data.toPoint.y ) == false )
//				{
//					if( ThingUtil.selectEntity )
//					{
//						ThingUtil.selectEntity.selected = false;
//					}
//					_scene.mapLayer.clearMap(); // 清理地图
//					_scene.mapGroundLayer.clearMap();
//				}
				RolePlayer.instance.setPixlePoint(data.toPoint.x,data.toPoint.y);
				RolePlayer.instance.stopMove();
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChangePosition));
				ThingUtil.isMoveChange = true;
			}
			_scene.removePointMark();
			
		}
		
		/**
		 * 翻滚 
		 * @param e
		 * 
		 */		
		private function onSceneSomersault(e:DataEvent):void
		{
			var p:Point = e.data as Point;
			var sp:SPoint = new SPoint();
			sp.x = p.x;
			sp.y = p.y;
//			Log.debug("发送翻滚坐标",p.x,p.y);
			GameProxy.sceneProxy.somersault(sp);
		}
		
		/**
		 * 快捷键拾取掉落物品 
		 * @param e
		 * 
		 */
		private function keyPickDropItemHandler(e:DataEvent):void
		{
			if(Cache.instance.pack.backPackCache.isPackFull())
			{
				MsgManager.showRollTipsMsg("背包已满");
				return;
			}
			var entityId:SEntityId = e.data as SEntityId;
			if(!entityId)
			{
				var dropItemPlayer:ItemPlayer = ThingUtil.dropItemUtil.getRandomDropItem(true);
				if(dropItemPlayer)
				{
					entityId = dropItemPlayer.dropEntityInfo.entityId;
				}
			}
			if(entityId)
			{
				GameProxy.sceneProxy.pickup(entityId);
			}
		}
		
		/**
		 * 自己改变战斗模式 
		 * 
		 */
		private function onUpdateFightMode(e:EntityInfoEvent):void
		{
			ThingUtil.isNameChange = true;
		}
		
		/**
		 * 停止移动 
		 * @param entityId
		 * 
		 */
		private function stopEntityMove(entityId:SEntityId):void
		{
			var movePlayer:MovePlayer = ThingUtil.entityUtil.getEntity(entityId) as MovePlayer;
			if(movePlayer)
			{
				movePlayer.stopMove();
			}
		}
		
		/**
		 * 更新实体仙盟Id 
		 * @param guildIdUpdate
		 * 
		 */		
		private function updateEntityGuildId(guildIdUpdate:SGuildIdUpdate):void
		{
			var entityInfo:EntityInfo = cache.entity.getEntityInfoById(guildIdUpdate.updateEntityId);
			entityInfo.updateGuildIdByEntityId(guildIdUpdate.guildId);
		}
	}
}