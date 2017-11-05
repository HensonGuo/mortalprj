/**
 * 2013-12-16
 * @author chenriji
 **/
package mortal.game.scene3D.ai
{
	import Message.Public.SPassPoint;
	import Message.Public.SPoint;
	
	import com.gengine.game.MapConfig;
	
	import flash.geom.Point;
	
	import mortal.component.gconst.GameConst;
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.control.subControl.Scene3DClickProcessor;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.ai.ais.AutoFightAI;
	import mortal.game.scene3D.ai.ais.CallBackAI;
	import mortal.game.scene3D.ai.ais.ClickNpcAI;
	import mortal.game.scene3D.ai.ais.CollectAI;
	import mortal.game.scene3D.ai.ais.DelayAI;
	import mortal.game.scene3D.ai.ais.FightOnceAI;
	import mortal.game.scene3D.ai.ais.FlyBootAI;
	import mortal.game.scene3D.ai.ais.FollowAI;
	import mortal.game.scene3D.ai.ais.FollowFightAI;
	import mortal.game.scene3D.ai.ais.JumpAI;
	import mortal.game.scene3D.ai.ais.MoveAI;
	import mortal.game.scene3D.ai.ais.PassAI;
	import mortal.game.scene3D.ai.base.IAICommand;
	import mortal.game.scene3D.ai.data.AIData;
	import mortal.game.scene3D.ai.data.CallBackData;
	import mortal.game.scene3D.ai.data.FollowFightAIData;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.mapToMapPath.MapPathSearcher;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.skill.SkillInfo;
	

	public class AIManager
	{

		private static var _aiList:Array = [];
		private static var _curAI:IAICommand;
		private static var _isCancelAll:Boolean = false;
		
		
		/**
		 * 执行ai组合 
		 * @param aiType
		 * 
		 */		
		public static function onAIControl(aiType:int, ...params):void
		{
			cancelAll();
			
			var p:Point;
			
			switch(aiType)
			{
				case AIType.Follow:
					addFollow(ThingUtil.selectEntity);
					break;
				
				case AIType.Follow_fight:
					addFollowFight(params[0] as FollowFightAIData);
					break;
				
				case AIType.ClickNpc:
					p = new Point(ThingUtil.selectEntity.x2d, ThingUtil.selectEntity.y2d);
					addMoveTo(p, GameConst.NpcInDistance);
					addClickNpcAI(params[0]);
					break;
				
				case AIType.FlyBoot:
					addFlyBoot(params[0]);
					break;
				
				case AIType.GoToAndPass:
					var pt:SPassPoint = params[0] as SPassPoint;
					if(pt != null)
					{
						p = new Point();
						p.x = pt.point.x;
						p.y = pt.point.y;
						addMoveTo_CheckJump(p, false, 0);
						addPassToMap(pt);
					}
					break;
				case AIType.GoToAndJump:
					p = params[0] as Point;
					if(p != null)
					{
						var pw:int = Game.mapInfo.pieceWidth;
						var ph:int = Game.mapInfo.pieceHeight;
						p.x = (int(p.x/pw) + 0.5)*pw;
						p.y = (int(p.y/ph) + 0.5)*ph;
						addMoveTo_CheckJump(p, false, 0);
						var tp:Point = new Point(int(p.x/pw) + 0.5, int(p.y/ph) + 0.5);
						addJump(tp);
					}
					break;
				case AIType.GoToOtherMap:
					addMoveToOtherMap(params[0], params[1], params[2]);
					break;
				case AIType.AutoFight:
					addAutoFight(params[0]);
					break;
				case AIType.Collect:
					var monster:MonsterPlayer = params[0] as MonsterPlayer;
					addMoveTo(new Point(monster.x2d, monster.y2d), 100);
					addCollectAI(monster);
					break;
			}
			
			// 如果当前AI不能停止， 那么等到当前ai执行完之后，再继续执行之后的ai
			if(_curAI != null && !_curAI.stopable)
			{
				return;
			}
			
			
			start();
		}
		
		
		/**
		 * 停止并清除当前所有AI  
		 * @return flash=当前的并未停止但是待执行的已经取消了， true=所有的都已经取消了
		 * 
		 */			
		public static function cancelAll():Boolean
		{
			if(_curAI != null)
			{
				// 当前执行中的ai不能停止，那么清空之后的列表，并return
				if(!_curAI.stopable)
				{
					inPoolAllTobeStartAi();
					return false;
				}
				_isCancelAll = true;
				AIFactory.instance.inAIData(_curAI.data);
				_curAI.stop();
				_curAI = null;
				_isCancelAll = false;
			}
			inPoolAllTobeStartAi();
			return true;
		}
		
		/**
		 * 开始执行AI 
		 * 
		 */		
		public static function start():void
		{
			if(_isCancelAll)
			{
				return;
			}
			if(_curAI != null)
			{
				AIFactory.instance.inAIData(_curAI.data);
				_curAI = null
			}
			if(_aiList == null || _aiList.length == 0)
			{
				return;
			}
			
			_curAI = _aiList.shift();
			_curAI.start(start);
		}
		
		private static function inPoolAllTobeStartAi():void
		{
			if(_aiList == null || _aiList.length == 0)
			{
				return;
			}
			for(var i:int = 0; i < _aiList.length; i++)
			{
				var tmp:IAICommand = _aiList[i];
				AIFactory.instance.inAIData(tmp.data);
			}
			_aiList = [];
		}
		
		/**
		 * 添加单个ai 
		 * @param ai
		 * 
		 */		
		public static function addAI(ai:IAICommand):void
		{
			_aiList.push(ai);
		}
		
		/**
		 * 添加ai组合(添加多个ai )
		 * @param ais
		 * 
		 */		
		public static function addAIs(ais:Array):void
		{
			_aiList = _aiList.concat(ais);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public static function addAutoFight(range:int=-1):void
		{
			var ai:IAICommand = new AutoFightAI();
			var data:AIData = AIFactory.instance.outAIData();
			ai.data = data;
			data.range = range;
			_aiList.push(ai);
		}
		
		/**
		 *  * 寻路到一点 
		 * @param p, 目标点，像素坐标 ， 不能为空
		 * @param range 
		 * @param path 假如不为空，则忽略p， 直接走path
		 * 
		 */			
		public static function addMoveTo(p:Point, range:int=-1, path:Array=null):void
		{
			var ai:IAICommand = new MoveAI();
			var data:AIData = AIFactory.instance.outAIData();
			ai.data = data;
			data.target = p;
			data.params = path;
			if(range != -1)
			{
				MoveAI(ai).range = range;
			}
			_aiList.push(ai);
		}
		
		/**
		 * 移动到某个点， 并且加入通过跳跃点最近的话， 是会走跳跃点路径的:1. 添加第一个移动AI， 2.跳跃AI， 3.移动AI 
		 * @param endPoint 像素坐标
		 * @param range 
		 * 
		 */		
		public static function addMoveTo_CheckJump(endPoint:Point, isStartNow:Boolean=false, range:int=-1):void
		{
			Scene3DClickProcessor.gotoPoint(endPoint, isStartNow, range);
		}
		
		/**
		 * 跳跃点， 格子坐标, 而且要格子中间， 就是x + 0.5， y + 0.5
		 * @param p
		 * 
		 */		
		public static function addJump(p:Point):void
		{
			var ai:IAICommand = new JumpAI();
			var data:AIData = AIFactory.instance.outAIData();
			ai.data = data;
			data.target = p;
			_aiList.push(ai);
		}
		
		/**
		 * 小飞鞋到一点 ， 格子坐标
		 * @param target
		 * 
		 */		
		public static function addFlyBoot(obj:Object):void
		{
			var ai:IAICommand = new FlyBootAI();
			var data:AIData = new AIData();//AIFactory.instance.outAIData(); 
			data.meRole = RolePlayer.instance;
			data.scene = Game.scene;
			data.params = obj;
			ai.data = data;
			_aiList.push(ai);
		}
		
		/**
		 * 跟随(随着target的移动而更改目标点， 例如点击角色攻击的时候可以选择follow + fight) 
		 * @param target
		 * 
		 */		
		public static function addFollow(target:IEntity):void
		{
			var ai:IAICommand;
			var data:AIData;
			ai = new FollowAI();
			data = AIFactory.instance.outAIData();
			ai.data = data;
			data.target = ThingUtil.selectEntity;
			_aiList.push(ai);
		}
		
		/**
		 * 传送阵AI 
		 * @param pt
		 * 
		 */		
		public static function addPassToMap(pt:SPassPoint):void
		{
			var ai:IAICommand;
			var data:AIData;
			ai = new PassAI();
			data = AIFactory.instance.outAIData();
			ai.data = data;
			data.params = pt;
			_aiList.push(ai);
		}
		
		/**
		 * 从地图A到达地图B的某点 ,, 像素坐标
		 * @param fromMapId 地图A
		 * @param toMapId 地图B
		 * @param targetPoint 目标点 像素坐标
		 * 
		 */		
		public static function addMoveToOtherMap(fromMapId:int, toMapId:int, targetPoint:Point, moveRange:int=0):void
		{
			if(fromMapId == toMapId)
			{
				addMoveTo(targetPoint, moveRange);
				return;
			}
			var path:Vector.<SPassPoint> = MapPathSearcher.findMapPath(fromMapId, toMapId);
			if(path == null || path.length == 0)
			{
				return;
			}
			for(var i:int = 0; i < path.length; i++)
			{
				var p:SPassPoint = path[i];
				
				// 先到达传送阵
				var tp:Point = new Point(p.point.x, p.point.y);
				tp.x = (int(tp.x/Game.mapInfo.pieceWidth) + 0.5) * Game.mapInfo.pieceWidth;
				tp.y = (int(tp.y/Game.mapInfo.pieceHeight) + 0.5) * Game.mapInfo.pieceHeight;
				addMoveTo(tp, 0);
				// 再传送AI
				addPassToMap(p);
			}
			
			// 最后添加目标点
			addMoveTo(targetPoint, moveRange);
		}
		
		/**
		 * 延迟执行下一步 
		 * @param time 单位毫秒
		 * 
		 */		
		public static function addDelayAI(millonSecond:int):void
		{
			var ai:IAICommand;
			var data:AIData;
			ai = new DelayAI();
			data = AIFactory.instance.outAIData();
			ai.data = data;
			data.params = millonSecond;
			_aiList.push(ai);
		}
		
		/**
		 * 战斗 
		 * @param isAuto 自动战斗
		 */		
		public static function addFollowFight(data:FollowFightAIData, isAuto:Boolean=false):void
		{
			if(data.skillInfo == null)
			{
				data.skillInfo = Cache.instance.skill.getFirstSkill();
				if(data.skillInfo == null)
				{
					return;
				}
			}
			var ai:IAICommand;
			ai = new FollowFightAI();
//			data.range = data.skillInfo.distance;
			
			ai.data = data;
			_aiList.push(ai);
		}
		
		public static function addFightOnce(data:FollowFightAIData):void
		{
			var ai:IAICommand = new FightOnceAI();
			ai.data = data;
			_aiList.push(ai);
		}
		
		/**
		 * 捡物品 
		 * 
		 */		
//		public static function pickupItem(item:BaseItem):void
//		{
//			
//		}
		
		public static function addClickNpcAI(npcId:int):void
		{
			var ai:IAICommand = new ClickNpcAI();
			var data:AIData = AIFactory.instance.outAIData();
			data.params = npcId;
			ai.data = data;			
			_aiList.push(ai);
		}
		
		/**
		 * 添加回调函数 
		 * @param callback 回调函数
		 * @param params 参数, null为无参数回调
		 * 
		 */		
		public static function addCallback(callback:Function, params:Object=null):void
		{
			var data:CallBackData = new CallBackData();
			data.meRole = RolePlayer.instance;
			data.scene = Game.scene;
			var ai:IAICommand = new CallBackAI();
			ai.data = data;
			data.callback = callback;
			data.params = params;
			_aiList.push(ai);
		}
		
		/**
		 * 采集ai 
		 * @param target
		 * 
		 */		
		public static function addCollectAI(target:MonsterPlayer):void
		{
			var ai:IAICommand = new CollectAI();
			var data:AIData = AIFactory.instance.outAIData();
			data.target = target;
			ai.data = data;
			_aiList.push(ai);
		}
	}
}
