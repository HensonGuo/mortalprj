/**
 * 2013-12-16
 * @author chenriji
 **/
package mortal.game.control.subControl
{
	import Message.Public.SPassPoint;
	import Message.Public.SPoint;
	
	import baseEngine.system.Device3D;
	
	import com.gengine.global.Global;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.rules.BossRule;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.Game2DPlayer;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.NPCPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.item.ItemPlayer;
	import mortal.game.scene3D.player.item.JumpPlayer;
	import mortal.game.scene3D.player.item.PassPlayer;
	import mortal.game.scene3D.util.FightUtil;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.Dispatcher;

	public class Scene3DClickProcessor
	{
		private var _scene:GameScene3D;
		private var _lastClickScene:int = 0;
		
		public function Scene3DClickProcessor(scene:GameScene3D)
		{
			_scene = scene;
		}
		
		public function work(e:MouseEvent):void
		{
			if(e.target == Global.stage)
			{
//				Alert.show("wo shi yige wenben,dianji 地面");
				
				var scenePoint:Point=Scene3DUtil.getSceneMousePostion(e.stageX,e.stageY,true);

				if(ThingUtil.overEntity)
				{
					//只有Entity可以选择
					if(ThingUtil.overEntity is IEntity)
					{
						ThingUtil.selectEntity = ThingUtil.overEntity as IEntity;
					}
					sceneClickEntity(ThingUtil.overEntity,e);
				}
				else
				{
					var nowClickScene:int = getTimer();
					//最短点击地面时间限制
					if(nowClickScene - _lastClickScene < 150)
					{
						return;
					}
					_lastClickScene = nowClickScene;

					AIManager.cancelAll();
					
					if(!RolePlayer.instance.isDead  && !RolePlayer.instance.isJumping)
					{
						gotoPoint(scenePoint, true, 0);
					}
				}

			}
		}
		
		/**
		 * 场景点击目标 
		 * @param iEntity
		 * @param event
		 * 
		 */
		private function sceneClickEntity(clickObject:Game2DPlayer,event:MouseEvent):void
		{
			_scene.removePointMark();
			if(clickObject is PassPlayer)
			{
				var pt:SPassPoint = PassPlayer(clickObject).passPoint;
				AIManager.onAIControl(AIType.GoToAndPass, pt);
			}
			else if(clickObject is JumpPlayer)
			{
				var p:Point = new Point();
				p.x = JumpPlayer(clickObject).spoint.x;
				p.y = JumpPlayer(clickObject).spoint.y;
				AIManager.onAIControl(AIType.GoToAndJump, p); 
			}
			else if(clickObject is ItemPlayer)
			{
				if((clickObject as ItemPlayer).dropEntityInfo)
				{
					Dispatcher.dispatchEvent( new DataEvent(EventName.PickDropItem,(clickObject as ItemPlayer).dropEntityInfo.entityId));
				}
			}
			else
			{
				var entity:IEntity;
				if(clickObject is IEntity)
				{
					entity = clickObject as IEntity;
				}
				if(entity && !RolePlayer.instance.isDead && !RolePlayer.instance.isJumping)
				{
					var isSelectNotFight:Boolean = SystemSetting.instance.isSelectNotAutoAttack.bValue;
					//AI移动到NPC
					if(entity is NPCPlayer)
					{
						AIManager.onAIControl(AIType.ClickNpc, NPCPlayer(entity).npcInfo.tnpc.code);
					}
					else if(entity is MonsterPlayer && BossRule.isCollectBoss(MonsterPlayer(entity)._bossInfo.type))
					{
						AIManager.onAIControl(AIType.Collect, entity);
					}
					if(isSelectNotFight)
					{
						ThingUtil.selectEntity = entity;
					}
					else if(!isSelectNotFight)
					{
						if(!entity.isDead && FightUtil.isNormalAttackable(entity))
						{
							var info:SkillInfo = Cache.instance.skill.getFirstSkill();
							if(info == null)
							{
								return;
							}
							Dispatcher.dispatchEvent(new DataEvent(EventName.SkillCheckAndSkillAI, info));
						}
					}
				}
			}
		}
		
		/**
		 * 走到场景的某一点， 会判断是否通过跳跃点到达 
		 * @param endPoint 像素点
		 * @param isStartNow 是否立马开始AI
		 * @param range 距离目标点多远算到达
		 * 
		 */			
		public static function gotoPoint(endPoint:Point, isStartNow:Boolean=true, range:int=-1):void
		{
			var startPoint:Point = new Point(RolePlayer.instance.x2d, RolePlayer.instance.y2d);
			
			var isWalk:Boolean = true;
			var scene:GameScene3D = GameScene3D(Device3D.scene);
			
			if(startPoint.x == endPoint.x && startPoint.y == endPoint.y)
			{
				return;
			}
			
			var pw:int = Game.mapInfo.pieceWidth;
			var ph:int = Game.mapInfo.pieceHeight;
			// 测试目标点是否可走，假如不可走， 那么改成test的中点
			var test:Point = AstarAnyDirection.findNearestWalkablePoint(endPoint.x/pw, endPoint.y/ph);
			var tilePointEnd:Point = GameMapUtil.getTilePoint(endPoint.x, endPoint.y);
			if(test.y != tilePointEnd.x || test.x != tilePointEnd.y)
			{
				endPoint.x = (test.y + 0.5) * pw;
				endPoint.y = (test.x + 0.5) * ph;
			}
			
			var p:Point = new Point(endPoint.x,endPoint.y);
			scene.addPointMark(p.x, p.y);
			
			// 原始A星寻路距离（单位是格子个数)
			var distanceNoJump:Number = 10000000;
			var pathAry:Array = scene.findPath(startPoint.x, startPoint.y, endPoint.x, endPoint.y, isWalk);
			if(pathAry != null && pathAry.length > 0)
			{
				distanceNoJump = AstarTurnPoint(pathAry[pathAry.length - 1]).distance;
			}
			
			// 计算通过跳跃点到达的距离
			var jumpPoints:Array = Game.sceneInfo.jumpPoints;
			if(jumpPoints != null && jumpPoints.length >= 2)
			{
				//循环每一组跳跃点的开始、结束点
				for(var i:int = 0; i < jumpPoints.length; i+= 2)
				{
					var sp:SPoint = new SPoint();
					var ep:SPoint = new SPoint();
					sp.x = jumpPoints[i].x/pw;
					sp.y = jumpPoints[i].y/ph;
					ep.x = jumpPoints[i+1].x/pw;
					ep.y = jumpPoints[i+1].y/ph;
					
					
					var d1:Number = GeomUtil.calcDistance(sp.x, sp.y, startPoint.x/pw, startPoint.y/ph) 
						+ GeomUtil.calcDistance(ep.x, ep.y, endPoint.x/pw, endPoint.y/ph);
					var d2:Number = GeomUtil.calcDistance(sp.x, sp.y, endPoint.x/pw, endPoint.y/ph) 
						+ GeomUtil.calcDistance(ep.x, ep.y, startPoint.x/pw, startPoint.y/ph);
					d1 = Math.min(d1, d2);
					
					// 通过跳跃点， 直线的距离小于原始距离，才计算(剪枝)
					if(d1 < distanceNoJump)
					{
						d1 = Number.MAX_VALUE;
						d2 = Number.MAX_VALUE;
						var arr1:Array = scene.findPath(startPoint.x, startPoint.y, jumpPoints[i].x, jumpPoints[i].y, isWalk);
						var arr2:Array = scene.findPath(jumpPoints[i+1].x, jumpPoints[i+1].y, endPoint.x, endPoint.y, isWalk);
						
						var arr3:Array = scene.findPath(startPoint.x, startPoint.y, jumpPoints[i+1].x, jumpPoints[i+1].y, isWalk);
						var arr4:Array = scene.findPath(jumpPoints[i].x, jumpPoints[i].y, endPoint.x, endPoint.y, isWalk);
						
						if(arr1 != null && arr1.length > 0 && arr2 != null && arr2.length > 0)
						{
							d1 = AstarTurnPoint(arr1[arr1.length - 1]).distance 
								+ AstarTurnPoint(arr2[arr2.length - 1]).distance;
						}
						
						if(arr3 != null && arr3.length > 0 && arr4 != null && arr4.length > 0)
						{
							d2 = AstarTurnPoint(arr3[arr3.length - 1]).distance 
								+ AstarTurnPoint(arr4[arr4.length - 1]).distance;
						}
						
						// 通过跳跃点的寻路距离 小于不通过跳跃点的寻路距离， 那么用跳跃点的AI
						if(Math.min(d1, d2) < distanceNoJump)
						{
							var endPoint1:Point = new Point();
							if(d2 < d1)
							{
								endPoint1.x = ep.x + 0.5;
								endPoint1.y = ep.y + 0.5;
								arr1 = arr3;
								arr2 = arr4;
							}
							else
							{
								endPoint1.x = sp.x + 0.5;
								endPoint1.y = sp.y + 0.5;
							}
							// 坐标转换
							endPoint = GameMapUtil.getPixelPoint(endPoint1.x, endPoint1.y);
//							endPoint = GameMapUtil.getPixelPoint(endPoint.x, endPoint.y);
							
							if(isStartNow)
							{
								AIManager.cancelAll();
							}
							//先移动到endPoint1
							AIManager.addMoveTo(endPoint, range, arr1);
							// 跳跃
							AIManager.addJump(endPoint1);
							AIManager.addDelayAI(200);
							// 再移动到endPoint
							AIManager.addMoveTo(p, range, arr2);
							
							if(isStartNow)
							{
								AIManager.start();
							}
							return;
						}
					}
				}
			}
			
			if(pathAry == null || pathAry.length == 0)
			{
				return;
			}
			
			if(isStartNow)
			{
				AIManager.cancelAll();
			}
			AIManager.addMoveTo(p, range, pathAry);
			if(isStartNow)
			{
				AIManager.start();
			}
			
		}
		
		public static function gotoPointByJumpPoint(jumpPoints:Array, endPoint:Point, isStartNow:Boolean=true, range:int=-1):void
		{
			var startPoint:Point = RolePlayer.instance.getTilePoint();
			var sJump:SPoint;
			var eJump:SPoint;
			var startIndex:int = 0;
			var minDistance:int = int.MAX_VALUE;
			for(var i:int = 0; i < jumpPoints.length; i+= 2)
			{
				var sp:SPoint = new SPoint();
				var ep:SPoint = new SPoint();
				var pw:int = Game.mapInfo.pieceWidth;
				var ph:int = Game.mapInfo.pieceHeight;
				sp.x = jumpPoints[i].x/pw;
				sp.y = jumpPoints[i].y/ph;
				ep.x = jumpPoints[i+1].x/pw;
				ep.y = jumpPoints[i+1].y/ph;
				
				var d1:Number = GeomUtil.calcDistance(sp.x, sp.y, startPoint.x/pw, startPoint.y/ph) 
					+ GeomUtil.calcDistance(ep.x, ep.y, endPoint.x/pw, endPoint.y/ph);
				var d2:Number = GeomUtil.calcDistance(sp.x, sp.y, endPoint.x/pw, endPoint.y/ph) 
					+ GeomUtil.calcDistance(ep.x, ep.y, startPoint.x/pw, startPoint.y/ph);
				d1 = Math.min(d1, d2);
				
				if(d1 < d2 && d1 < minDistance)
				{
					minDistance = d1;
					sJump = sp;
					eJump = ep;
					
				}
				else if(d2 < minDistance)
				{
					minDistance = d2;
					sJump = ep;
					eJump = sp;
				}
			}
			
			// 测试能否走到跳跃点， 跳跃点能否走到终点
			
			
			// 坐标转换
			
			if(isStartNow)
			{
				AIManager.cancelAll();
			}
			//先移动到endPoint1
			AIManager.addMoveTo(GameMapUtil.getPixelPoint(sJump.x, sJump.y), range);
			// 跳跃
			var jumpPoint:Point = new Point(sJump.x + 0.5, sJump.y + 0.5);
			AIManager.addJump(jumpPoint);
			AIManager.addDelayAI(200);
			// 再移动到endPoint
			AIManager.addMoveTo(endPoint, range);
			
			if(isStartNow)
			{
				AIManager.start();
			}
		}
	}
}