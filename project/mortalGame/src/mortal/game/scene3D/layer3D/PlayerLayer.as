package mortal.game.scene3D.layer3D
{
	import baseEngine.core.Pivot3D;
	
	import com.gengine.core.FrameUtil;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.debug.FPS;
	import com.gengine.global.Global;
	
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mortal.common.swfPlayer.data.FramesData;
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.scene3D.player.entity.UserPlayer;
	import mortal.game.scene3D.player.info.EntityInfo;
	
	public class PlayerLayer extends SLayer3D
	{
		private var _globalTimer:FrameTimer;
		
		private static var MAX_DISPOSETIME:Number= 60 * 1000; //销毁swf模型的时间20S
		
		private var _userDisArray:Array = [];  //用户玩家显示数组
		
		public function PlayerLayer(_arg1:String)
		{
			super(_arg1);
			ThingUtil.iniThing(this);
			
			_globalTimer = new FrameTimer();
			_globalTimer.addListener(TimerType.ENTERFRAME, onTimerFrameHandler);
			_globalTimer.start();
		}
		
		private function onTimerFrameHandler(timer:FrameTimer):void
		{
			if( Game.scene.isInitialize )
			{	
				var remain:int = timer.currentCount%5;
				switch(remain)
				{
					case 0:
						sortEntitys();
						break;
					case 1:
					case 2:
					case 3:
					case 4:
						updateEntity();
						createEntitys();
						break;
				}
				
//				ThingUtil.onMouseOver();
				//处理swf资源释放
				framesDataDispose( timer );
//				framesMapDataDispose( timer );
//				byteArrayDispose( timer );
			}
		}
		
		private var _disposeCountTime:Number=0;
		/**
		 * 销毁模型定时器 
		 * @param timer
		 * 
		 */		
		private function framesDataDispose( timer:FrameTimer ):void
		{
			_disposeCountTime+=timer.interval;
			if (_disposeCountTime >= MAX_DISPOSETIME)
			{
				_disposeCountTime=0;
				FramesData.dispose();
			}
		}
		
		/**
		 * 更新深度
		 *
		 */
		public function sortEntitys():void
		{
			if (ThingUtil.isEntitySort)
			{
				//人物所在和平区域什么的变更
				if(ThingUtil.isNameChange)
				{
					Cache.instance.entity.updateAllName();
					ThingUtil.isNameChange = false;
				}
				//不动的实体 只有玩家移动的时候才去计算
				if (ThingUtil.isMoveChange)
				{
					ThingUtil.isMoveChange=false;
					// npc
					ThingUtil.npcUtil.updateEntity();
					// 传送阵
					ThingUtil.passUtil.updateEntity();
					// 跳跃点
					ThingUtil.jumpUtil.updateEntity();
					//场景特效
					ThingUtil.effectUtil.updateEntity();
					//掉落
					ThingUtil.dropItemUtil.updateEntity();
//					//建筑
//					ThingUtil.buildUtil.updateEntity();
//					//模型
//					ThingUtil.buildUtil.updateSharps();
//					//雕塑
//					ThingUtil.statueUtil.updateEntity();
				}
				else 
				{
//					if (ThingUtil.isBuildChange)
//					{
//						//建筑
//						ThingUtil.buildUtil.updateEntity();
//						ThingUtil.isBuildChange=false;
//					}
//					if( ThingUtil.isSharpChange )
//					{
//						//模型
//						ThingUtil.buildUtil.updateSharps();
//						ThingUtil.isSharpChange=false;
//					}
//					if( ThingUtil.isStatueChange )
//					{
//						ThingUtil.statueUtil.updateEntity();
//						ThingUtil.isStatueChange = false;
//					}
				}
				
				
				addAllEntity();
				
				if(Global.isDebugModle)
				{
					FPS.instance.entityNum = ThingUtil.sceneEntityList.length;
				}
				ThingUtil.isEntitySort = false;
			}
		}
		
		/**
		 * 玩家和怪物
		 * 
		 */		
		private function addAllEntity():void
		{
			var entity:IEntity;
			var tempUser:UserPlayer;
			
			for each ( entity in ThingUtil.entityUtil.entitysMap.allEntitys )
			{
				//是否隐身
				var isDisappear:Boolean = entity.entityInfo.isDisappear && !Cache.instance.group.entityIsInGroup(entity.entityInfo.entityInfo.entityId);
				//是否隐藏
				var isHideBoss:Boolean = false;
				if(entity is MonsterPlayer && ThingUtil.entityUtil.isBossHide((entity as MonsterPlayer)._bossInfo.code))
				{
					isHideBoss = true;
				}
				
				if ( SceneRange.isInScene(entity.x2d, entity.y2d) && !isDisappear && !isHideBoss)
				{
					//玩家
					if( entity is UserPlayer )
					{
						tempUser = entity as UserPlayer;
						if (tempUser.addToStage(this))
						{
							ThingUtil.distanceQueueChange=true;
						}
						addUserToAry(tempUser);
					}
					//bossCode屏蔽 基基需求
					else
					{
						if (entity.addToStage(this))
						{
							ThingUtil.distanceQueueChange=true;
						}
					}
				}
//				场景外实体
				else
				{
					if ( entity is RolePlayer == false)
					{
						entity.removeFromStage(this);
						ThingUtil.distanceQueueChange=true;
					}
				}
			}
		}
		
		private function addUserToAry( user:UserPlayer ):void
		{
			//_userDisArray.push(user);
		}
		
		/**
		 * 创建实体 
		 * 
		 */
		private function createEntitys():void
		{
			var entityInfo:EntityInfo = Cache.instance.entity.getFromOffAry();
			while(entityInfo != null)
			{
				ThingUtil.entityUtil.createEntity(entityInfo);
				Cache.instance.entity.removeFromOffAry(entityInfo.entityInfo.entityId);
				entityInfo = Cache.instance.entity.getFromOffAry();
				//超时则停止操作
				if(!FrameUtil.canOperate())
				{
					break;
				}
			}
		}
		
		/**
		 * 更新实体 
		 * 
		 */		
		private function updateEntity():void
		{
			var spritePlayer:SpritePlayer;
			for each(spritePlayer in ThingUtil.entityUtil.entitysMap.allEntitys )
			{
				spritePlayer.updateDisplay();
			}
		}
	}
}