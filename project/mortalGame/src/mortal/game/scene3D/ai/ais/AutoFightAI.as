/**
 * 2014-3-14
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import Message.Public.ESkillTargetSelect;
	
	import baseEngine.basic.Scene3D;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	
	import flash.geom.Point;
	
	import mortal.game.cache.Cache;
	import mortal.game.control.subControl.Scene3DClickProcessor;
	import mortal.game.mvc.EventName;
	import mortal.game.rules.BossRule;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.ai.AIFactory;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.ai.base.IAICommand;
	import mortal.game.scene3D.ai.data.AIData;
	import mortal.game.scene3D.ai.data.FollowFightAIData;
	import mortal.game.scene3D.ai.singleAIs.AutoFightBossSelectAI;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.util.FightUtil;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.Dispatcher;
	
	public class AutoFightAI extends AICommand
	{
		private var _aiList:Array = [];
		private var _curAI:IAICommand;
		private var _timer:FrameTimer;
		
		// onEnterFrameHandler调用_toNextBossAreaTime次的时候，依然找不到标的， 则走到下个一个区域去打
		private var _toNextBossAreaTime:int = 5;
		// 当前运行_curAreaNotFindTime次依然没找到标的
		private var _curAreaNotFindTime:int = 0;
		private var _isRuning:Boolean = false;
		private var _comboTime:int = 0;
		
		// 走到下一个刷怪区
		private var _paths:Array;
		
		public function AutoFightAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			_timer = new FrameTimer(10);
			_timer.addListener(TimerType.ENTERFRAME, onEnterFrameHandler);
			_timer.start();
			
			// 开始运行
			_isRuning = false;
			startAIList();
			
			Dispatcher.addEventListener(EventName.CDPublicCDEnd, onEnterFrameHandler);
		}
		
		public override function stop():void
		{
			super.stop();
			cancelAll();
			_timer.stop();
			_timer = null;
			_curAreaNotFindTime = 0;
			
			Dispatcher.removeEventListener(EventName.CDPublicCDEnd, onEnterFrameHandler);
		}
		
		private function cancelAll():void
		{
			if(_curAI != null)
			{
				AIFactory.instance.inAIData(_curAI.data);
				_curAI.stop();
				_curAI = null;
			}
			inPoolAllTobeStartAi();
		}
		
		private function startAIList():void
		{
			if(_curAI != null)
			{
				AIFactory.instance.inAIData(_curAI.data);
				_curAI = null
			}
			if(_aiList.length == 0)
			{
//				onEnterFrameHandler(null);
				_isRuning = false;
				return;
			}
			_isRuning = true;
			_curAI = _aiList.shift();
			_curAI.start(startAIList);
		}
		
		private function inPoolAllTobeStartAi():void
		{
			if(_aiList.length == 0)
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
		
		private function onEnterFrameHandler(event:*=null):void
		{
			// 检查有没正在进行中的AI
			if(_isRuning)
			{
				return;
			}

			// 向Cache拿一个可以用的技能, 找到可用的技能、可以打的怪(找怪注意范围)
			var info:SkillInfo = Cache.instance.autoFight.getCanUseSkill((_comboTime > 0 && _comboTime < 5));
			if(info != null)
			{
				if(info.isComboSkill)
				{
					_comboTime++;
					if(_comboTime >= 5)
					{
						_comboTime = 0;
					}
				}
				if(addNextTarget(info))
				{
					_curAreaNotFindTime = 0;
					startAIList();
					return;
				}
			}
			else
			{
				return; // 找不到可用的技能，那么等待技能CD完成
			}
			
			// 如果正在前往下一个刷怪点的路上，那么每走100个像素点，检查一遍是否有怪
			if(_paths != null)
			{
				addToNextPoint();
				return;
			}
			
			// 以上都找不到， 如果超过_toNextBossAreaTime次了， 那么走到下一个挂机区域(前提条件是非范围挂机)
			_curAreaNotFindTime++;
			if(_curAreaNotFindTime >= _toNextBossAreaTime)
			{
				_curAreaNotFindTime = 0;
				// 走到下一个刷怪区
				var p:Point;
				if(_data.range <= 0) // 普通挂机， 则跑到下一个boss刷怪点
				{
					p = Cache.instance.autoFight.getNextBossRereshPoint();
				}
				else // 范围挂机， 则回到挂机点
				{
					p = AutoFightBossSelectAI.instance.sourcePoint;
				}
				if(p == null)
				{
					_paths = null;
					return;
				}
				p = GameMapUtil.getTilePoint(p.x, p.y);
				var p2:Point = RolePlayer.instance.getTilePoint();
				_paths = AstarAnyDirection.findPath(p2.x, p2.y, p.x, p.y, true);
				if(_paths == null || _paths.length == 0)
				{
					return;
				}
				addToNextPoint();
				return;
			}
			// 以上条件都不满足继续等待
		}
		
		private function addToNextPoint():void
		{
			if(_paths == null)
			{
				return;
			}
			var p:AstarTurnPoint;
			
			// 每隔2个点走一次
			if(_paths.length == 1)
			{
				p = _paths[0];
				_paths = null;
			}
			else 
			{
				_paths.shift();
				p = _paths.shift();
				if(_paths.length == 0)
				{
					_paths = null;
				}
			}
			
			addMoveTo(GameMapUtil.getPixelPoint(p._y, p._x), 0); // 确定是倒过来的
			startAIList();
			
//			var curDistance:int = GeomUtil.calcDistance(myx, myy, _nextBossRefreshPoint.x, _nextBossRefreshPoint.y);
//			if(curDistance <= 10) // 范围内， 可以停止了
//			{
//				_nextBossRefreshPoint = null;
//			}
//			else if(curDistance <= 120) // 差一次就完成了
//			{
//				addMoveTo(_nextBossRefreshPoint, 0);
//				startAIList();
//			}
//			else // 继续走100像素点
//			{
//				var p:Point = new Point();
//				p.x = myx + (_nextBossRefreshPoint.x - myx)/curDistance*200;
//				p.y = myy + (_nextBossRefreshPoint.y - myy)/curDistance*200;
//				addMoveTo(p, 0);
//				startAIList();
//			}
		}
		
		private function addNextTarget(info:SkillInfo):Boolean
		{
			if(SystemSetting.instance.isNotAutoSelectMonster.bValue)
			{
				return false;
			}
			var data:FollowFightAIData = AIFactory.instance.outFollowFightAIData();
			data.skillInfo = info;
			var boss:MonsterPlayer = AutoFightBossSelectAI.instance.getEntity() as MonsterPlayer;
			
			if((info.tSkill.targetType & ESkillTargetSelect._ESkillTargetSelectSelf) > 0)
			{	
				data.entitys = [RolePlayer.instance.entityInfo.entityInfo.entityId];
				data.target = RolePlayer.instance;
				data.range = 20000;
				addFollowFight(data);
				return true;
			}
			
			if(boss == null)
			{
				return false;
			}
			else
			{
				// 设置为选中状态
				ThingUtil.selectEntity = boss;
				data.target = boss;
				data.range = boss.entityInfo.bodySize + info.tSkill.distance + RolePlayer.instance.entityInfo.bodySize;
				data.entitys = [boss.entityInfo.entityInfo.entityId];
				switch(info.tSkill.targetSelect)
				{
					case ESkillTargetSelect._ESkillTargetSelectMouseDirection:
					case ESkillTargetSelect._ESkillTargetSelectMouse:
						data.point = FightUtil.getSPoint(boss);
						data.range = info.tSkill.distance + RolePlayer.instance.entityInfo.bodySize;
						break;
				}
				if(BossRule.isCollectBoss(boss._bossInfo.type))
				{
					addMoveTo(new Point(boss.x2d, boss.y2d), 100);
					addCollectAI(boss);
					return true;
				}
				else
				{
					addFollowFight(data);
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 采集ai 
		 * @param target
		 * 
		 */		
		public function addCollectAI(target:MonsterPlayer):void
		{
			var ai:IAICommand = new CollectAI();
			var data:AIData = AIFactory.instance.outAIData();
			data.target = target;
			ai.data = data;
			_aiList.push(ai);
		}
		
		/**
		 * 战斗 
		 * @param isAuto 自动战斗
		 * @param isRound 范围挂机
		 * 
		 */		
		public function addFollowFight(data:FollowFightAIData, isAuto:Boolean=false, isRound:Boolean=false):void
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
		
		/**
		 *  * 寻路到一点 
		 * @param p, 目标点，像素坐标 ， 不能为空
		 * @param range 
		 * @param path 假如不为空，则忽略p， 直接走path
		 * 
		 */			
		public function addMoveTo(p:Point, range:int=-1, path:Array=null):void
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
	}
}