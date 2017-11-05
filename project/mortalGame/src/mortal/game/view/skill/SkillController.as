/**
 * 2014-1-9
 * @author chenriji
 **/
package mortal.game.view.skill
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EGateCommand;
	import Message.Command.EPublicCommand;
	import Message.Game.AMI_ITest_getThreatList;
	import Message.Public.SBossThreatList;
	import Message.Public.SPublicSeqInt;
	import Message.Public.SRuneUpdate;
	import Message.Public.SSkill;
	import Message.Public.SThreat;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import frEngine.loaders.resource.info.ABCInfo;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.rules.BossRule;
	import mortal.game.scene3D.ai.AIFactory;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.ai.data.FollowFightAIData;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.util.FightUtil;
	import mortal.game.utils.BuffUtil;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.skill.panel.data.RuneItemData;
	import mortal.game.view.skill.panel.data.SkillLearnArrowData;
	import mortal.game.view.skill.panel.data.SkillLearnData;
	import mortal.game.view.skill.test.SkillThreadModule;
	import mortal.game.view.skill.test.SkillThreatData;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class SkillController extends Controller
	{
		private var _module:SkillLearnModule;
		
		public function SkillController()
		{
			super();
		}
		
		protected override function initView():IView
		{
			if(_module == null)
			{
				_module = new SkillLearnModule();
			}
			return _module ;
		}
		
		public function get isModuleShowing():Boolean
		{
			if(_module == null)
			{
				return false;
			}
			return !_module.isHide;
		}
		
		protected override function initServer():void
		{
			
			NetDispatcher.addCmdListener(ServerCommand.SkillAdd, updateAllSkillInfos);// 监听技能学习
			NetDispatcher.addCmdListener(ServerCommand.SkillUpgrade, updateAllSkillInfos);// 监听技能升级
			NetDispatcher.addCmdListener(ServerCommand.ExpUpdate, updateAllSkillInfos);
			NetDispatcher.addCmdListener(ServerCommand.SkillPointUpdate, updateAllSkillInfos);
			NetDispatcher.addCmdListener(ServerCommand.CoinUpdate, updateAllSkillInfos);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemAdd, updateAllSkillInfos); // 获得技能书，符文材料
			NetDispatcher.addCmdListener(EGateCommand._ECmdGateRune, runeGotHandler);
			// 更新符文是否可升级
			NetDispatcher.addCmdListener(ServerCommand.RuneAdd, updateRuneUpgradebleHandler);
			NetDispatcher.addCmdListener(ServerCommand.RuneRemove, updateRuneUpgradebleHandler);
			NetDispatcher.addCmdListener(ServerCommand.RuneLevelUp, updateRuneUpgradebleHandler);
			NetDispatcher.addCmdListener(ServerCommand.RunePowerUpdate, updateRuneUpgradebleHandler);
			
			
			Dispatcher.addEventListener(EventName.SkillPanel_ViewInited, viewInitedHandler);
			Dispatcher.addEventListener(EventName.SkillShowHideModule, showHideHandler);
			Dispatcher.addEventListener(EventName.Skill_SelectPos, selectPosHandler);
			
			
			//////////////////
			Dispatcher.addEventListener(EventName.SkillUpgradeReq, skillUpgradeReqHandler);
			// 符文
			Dispatcher.addEventListener(EventName.Skill_RuneUpgrade, runeUpgradeHandler);
			
			// 请求使用技能：根据目标类型调用不同的ai
			Dispatcher.addEventListener(EventName.SkillCheckAndSkillAI, checkAndStartSkillAI);
			//请求服务器使用技能
			Dispatcher.addEventListener(EventName.SkillAskServerUseSkill, useSkillReqHandler);
			
			Dispatcher.addEventListener(EventName.SkillShowSkillInfo, showSkillInfoHandler);
			
			// 测试
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicTestBossThreat, bossThreatHandler);
		}
		
		private var _lastCustomPos:int = -1;
		private function selectPosHandler(evt:DataEvent):void
		{
			_lastCustomPos = int(evt.data);
			if(_module && !_module.isHide)
			{
				autoSelectSkill(_lastCustomPos);
				_lastCustomPos = -1;
			}
		}
		
		private function showHideHandler(evt:DataEvent):void
		{
			var isShow:Boolean = evt.data as Boolean;
			if(isShow)
			{
				view.show();
			}
			else
			{
				if(_module != null && !_module.isHide)
				{
					_module.hide();
				}
			}
		}
		
		private function runeUpgradeHandler(evt:DataEvent):void
		{
			var data:RuneItemData = evt.data as RuneItemData;
			if(data == null)
			{
				return;
			}
			
			var isDebug:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
			if(!data.actived) // 激活符文
			{
				GameProxy.role.activeRune(data.info.runeId, isDebug);
			}
			else // 升级符文
			{
				GameProxy.role.upgradeRune(data.info.runeId, isDebug);
			}
		}
		
		private function updateRuneUpgradebleHandler(obj:Object):void
		{
			if(_module != null && !_module.isHide)
			{
				autoSelectSkill(_module.selectedPos);
			}
		}
		
		private function runeGotHandler(mb:MessageBlock):void
		{
			var arr:SPublicSeqInt = mb.messageBase as SPublicSeqInt;
			cache.skill.initRuneList(arr.publicSeqInt);
		}
		
		private function bossThreatHandler(obj:MessageBlock):void
		{
			var data:SBossThreatList = obj.messageBase as SBossThreatList;
			var provider:DataProvider = new DataProvider();
			var highLow:Dictionary = new Dictionary();
			for each(var s:SThreat in data.topThreats)
			{
				highLow[s.name] = 1;
			}
			for each(s in data.lowestThreats)
			{
				highLow[s.name] = 2;
			}
			for(var i:int = 0; i < data.threatList.length; i++)
			{
				s = data.threatList[i];
				var t:SkillThreatData = new SkillThreatData();
				t.data = s;
				t.index = i+1;
				if(highLow[s.name] == 1)
				{
					t.isHight = true;
				}
				else if(highLow[s.name] == 2)
				{
					t.isLow = true;
				}
				provider.addItem(t);
			}
			if(_threatModule && !_threatModule.isHide)
			{
				_threatModule.updateList(provider);
			}
		}
		private var _threatModule:SkillThreadModule;
		public function get threatModule():SkillThreadModule
		{
			if(_threatModule == null)
			{
				_threatModule = new SkillThreadModule();
			}
			return _threatModule;
		}
		
		private function updateAllSkillInfos(obj:Object=null):void
		{
			if(_module != null && !_module.isHide)
			{
				updateSkillInfos();
			}
		}
		
		/**
		 * 视图初始化完毕，可以更新数据了 
		 * @param evt
		 * 
		 */		
		private function viewInitedHandler(evt:DataEvent):void
		{
			// 给视图设置数据
			updateSkillInfos();
			// 更新是否开启
//			setNotOpen();
		}
		
		private function skillUpgradeReqHandler(evt:DataEvent):void
		{
			var id:int = int(evt.data);
			if(id == 0)
			{
				return;
			}
			var info:SkillInfo = cache.skill.getSkill(id);
			var isDebug:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsSkillDebug);
			if(info == null)
			{
				// 学习技能
				GameProxy.role.learnSkill(id, isDebug);
				return;
			}
			else
			{
				// 升级技能
				GameProxy.role.upgradeSkill(id, isDebug);
			}
			
		}
		
		/**
		 * 请求使用技能：根据目标类型调用不同的ai 
		 * @param skillInfo
		 * 
		 */		
		public function checkAndStartSkillAI(evt:DataEvent):void
		{
			var info:SkillInfo = evt.data as SkillInfo;
			if(info == null)
			{
				return;
			}
			info = cache.skill.getSkillBySerialId(info.tSkill.series);
			if(info == null)
			{
				return;
			}
			var data:FollowFightAIData = AIFactory.instance.outFollowFightAIData();
			data.skillInfo = info;
			FightUtil.selectEntityBySkill(data, cache.shortcut.isLastKeyByClick);
			if(data.target == null && data.point == null)
			{
				MsgManager.showRollTipsMsg(Language.getString(20054));
				AIFactory.instance.inFollowFightAIData(data);
			}
			else if(data.isSkillThenWalk)
			{
				AIManager.cancelAll();
				var endPoint:Point = new Point(data.point.x, data.point.y);
				var skillPoint:Point = GeomUtil.getPointByDistance(RolePlayer.instance.x2d, RolePlayer.instance.y2d, 
					data.point.x, data.point.y, data.range - 20);
				data.point.x = skillPoint.x;
				data.point.y = skillPoint.y;
				
//				Dispatcher.dispatchEvent(new DataEvent(EventName.SkillAskServerUseSkill, data));
				AIManager.addFightOnce(data);
				AIManager.addDelayAI(500);
				AIManager.addMoveTo(endPoint, 20);
				AIManager.start();
			}
			else if(data.target != null)
			{
				// 攻击对象是采集怪
				if(data.target is MonsterPlayer && BossRule.isCollectBoss((data.target as MonsterPlayer)._bossInfo.type))
				{
					AIManager.onAIControl(AIType.Collect, data.target);
				}
				else
				{
					AIManager.onAIControl(AIType.Follow_fight, data);
				}
			}
			else if(data.point != null)
			{
				AIManager.cancelAll();
				var p:Point = new Point(data.point.x, data.point.y);
				AIManager.addMoveTo_CheckJump(p, false, data.range);
				AIManager.addFollowFight(data);
				AIManager.start();
			}
		}
		
		private var _nextUseSkillTime:int = 0;
		public var _lastUseTime:int= 0;
		/**
		 * 向服务器申请使用技能 
		 * @param evt
		 * 
		 */		
		private function useSkillReqHandler(evt:DataEvent):void
		{
			var data:FollowFightAIData = evt.data as FollowFightAIData;
			if(data == null)
			{
				return;
			}
			var now:int = getTimer();
			if(now < _nextUseSkillTime)
			{
				return;
			}
			_nextUseSkillTime = now + 200;
			var skillInfo:SkillInfo = data.skillInfo;
			if(skillInfo == null)
			{
				return;
			}
			if(!BuffUtil.isCanRoleFireSkill(skillInfo))
			{
				MsgManager.showRollTipsMsg(Language.getString(20126));
				return;
			}
			var cd:ICDData = cache.cd.getCDData(skillInfo, CDDataType.skillInfo);
			var isNotCD:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsNotCD);
			if(!isNotCD && cd && cd.isCoolDown)
			{
				MsgManager.showRollTipsMsg(Language.getStringByParam(20051, Language.getString(20052)));
				return;
			}
			_lastUseTime = now;
			RolePlayer.instance.stopWalkSendPoint();
			GameProxy.sceneProxy.fight(data.entitys, skillInfo.skillId, data.point);
			if(ThingUtil.selectEntity != null && ThingUtil is MonsterPlayer)
			{
				GameRMI.instance.iTestPrx.getThreatList_async(new AMI_ITest_getThreatList(), ThingUtil.selectEntity.entityInfo.entityInfo.entityId);
			}
		}
		
		private function showSkillInfoHandler(evt:DataEvent):void
		{
			var info:SkillInfo = evt.data as SkillInfo;
			if(_module != null)
			{
				_module.selectSkillItem(info);
			}
		}
		
		private function updateSkillInfos():void
		{
			// 更新技能CD
			
			if(_module == null)
			{
				return;
			}
			// 更新箭头
			updateArrows();
			
			// 更新技能图标
			var allSkill:Array = cache.skill.getAllSkills();
			for(var i:int = 0; i < allSkill.length; i++)
			{
				var info:SkillInfo = allSkill[i] as SkillInfo;
				if(info.tSkill.posType <= 0 || info.tSkill.posType > 20)
				{
					continue;
				}
				_module.updateSkillInfo(info.tSkill.posType, info);
			}
			if(_lastCustomPos >= 0)
			{
				autoSelectSkill(_lastCustomPos);
				_lastCustomPos = -1;
			}
			else
			{
				// 自动选择一个选中的
				var index:int = _module.selectedPos;
				autoSelectSkill(index);
			}
		}
		
		private function updateArrows():void
		{
			var datas:Array = cache.skill.getArrowDatas();
			for each(var data:SkillLearnArrowData in datas)
			{
				_module.updateArrow(data);
			}
		}
		
		private function autoSelectSkill(pos:int=-1):void
		{
			if(_module == null)
			{
				return;
			}
			var infos:Array = _module.getAllSkillInfos();
			if(pos > 0)
			{
				var skillInfo:SkillInfo = infos[pos] as SkillInfo;
				if(skillInfo != null)
				{
					_module.selectSkillItem(skillInfo)
					return;
				}
			}
			for(var i:int = 0; i < infos.length; i++)
			{
				var info:SkillInfo = infos[i];
				if(info != null)
				{
					if(info.learnable())
					{
						_module.selectSkillItem(info); // 可学习的
						return;
					}
					if(info.upgradable())
					{
						_module.selectSkillItem(info);// 可升级的
						return;
					}
				}
			}
			_module.selectSkillItem(infos[1] as SkillInfo); // 默认选中第一个
		}
		
		private function setNotOpen():void
		{
			for(var i:int = 8; i <= 13; i++)
			{
				_module.setNotOpen(i);
			}
		}
		
		
	}
}