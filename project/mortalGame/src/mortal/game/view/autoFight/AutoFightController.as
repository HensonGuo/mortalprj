/**
 * 2014-3-11
 * @author chenriji
 **/
package mortal.game.view.autoFight
{
	import fl.data.DataProvider;
	
	import mortal.component.gconst.GameConst;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.ai.singleAIs.AutoFightBossSelectAI;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.autoFight.data.AFSkillPlanIndex;
	import mortal.game.view.autoFight.data.SelectBossData;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.skillProgress.SkillProgressView;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class AutoFightController extends Controller
	{
		private var _module:AutoFightModule;
		public function AutoFightController()
		{
			super();
		}
		
		protected override function initView():IView
		{
			if(_module == null)
			{
				_module = new AutoFightModule();
			}
			return _module;
		}
		
		protected override function initServer():void
		{
			super.initServer();
			
			NetDispatcher.addCmdListener(ServerCommand.SkillAdd, updateAllSkillInfos);// 监听技能学习
			
			Dispatcher.addEventListener(EventName.AutoFight_ShowHide, showHideAutoSetModule);
			Dispatcher.addEventListener(EventName.AutoFight_A, autoFightHandler);
			Dispatcher.addEventListener(EventName.AutoFight_BossNotSelect, bossNotSelectHandler);
			Dispatcher.addEventListener(EventName.AutoFight_Round, roundFightHandler);
			Dispatcher.addEventListener(EventName.AutoFight_LoadDefault, loadDefaultHandler);
			Dispatcher.addEventListener(EventName.AutoFight_Save, saveHandler);
			Dispatcher.addEventListener(EventName.AutoFight_PlanChange, planChangeHandler);
			Dispatcher.addEventListener(EventName.CDPublicCDEnd, publicCdEndHandler);
		}
		
		private function showHideAutoSetModule(evt:DataEvent):void
		{
			if(_module && !_module.isHide)
			{
				_module.hide();
				return;
			}
			if(_module == null)
			{
				_module = new AutoFightModule();
			}
			_module.show();
			
			updateAllDatas(false);
		}
		
		private function publicCdEndHandler(evt:DataEvent):void
		{
			
		}
		
		private function updateAllSkillInfos(obj:Object):void
		{
			if(_module && !_module.isHide)
			{
				updateAllDatas(false);
			}
		}
		
		private function planChangeHandler(evt:DataEvent):void
		{
			if(_module == null)
			{
				return;
			}
			var index:int = _module.getPlanIndex();
			var data:DataProvider = cache.autoFight.getMainSkillData(index, false, false);
			_module.updateMainSkillList(data);
		}
		
		private function roundFightHandler(evt:DataEvent):void
		{
			cache.autoFight.resetBossPointIndex();
			AutoFightBossSelectAI.instance.sourcePoint.x = RolePlayer.instance.x2d;
			AutoFightBossSelectAI.instance.sourcePoint.y = RolePlayer.instance.y2d;
			AutoFightBossSelectAI.instance.range = GameConst.RoundFightDistance;
			AIManager.onAIControl(AIType.AutoFight, GameConst.RoundFightDistance);
		}
		
		private function autoFightHandler(evt:DataEvent):void
		{
			cache.autoFight.resetBossPointIndex();
			AutoFightBossSelectAI.instance.range = -1;
			AutoFightBossSelectAI.instance.sourcePoint.x = RolePlayer.instance.x2d;
			AutoFightBossSelectAI.instance.sourcePoint.y = RolePlayer.instance.y2d;
			AIManager.onAIControl(AIType.AutoFight, -1);
		}
		
		private function loadDefaultHandler(evt:DataEvent):void
		{
			updateAllDatas(true);
		}
		
		private function saveHandler(evt:DataEvent):void
		{
			var isSave:Boolean = cache.autoFight.saveCacheDatas();
			if(_module != null)
			{
				isSave = _module.saveModuleDatas() || isSave;
			}
			
			if(isSave)
			{
				ClientSetting.save();
			}
		}
		
		private function bossNotSelectHandler(evt:DataEvent):void
		{
			var data:SelectBossData = evt.data as SelectBossData;
			if(data == null)
			{
				return;
			}
			cache.autoFight.setBossNotSelect(data.boss.code, !data.selected);
		}
		
		/**
		 * 更新所有数据 
		 * @param isDefault
		 * 
		 */		
		private function updateAllDatas(isDefault:Boolean):void
		{
			var datas:DataProvider = cache.autoFight.getBossList(Game.mapInfo.mapId, isDefault);
			_module.updateBossList(datas);
			
			var mainSkillPlan:int = AFSkillPlanIndex.plan1;
			if(ClientSetting.local.getIsDone(IsDoneType.UseSecondSkillPlan))
			{
				mainSkillPlan = AFSkillPlanIndex.plan2;
			}
			datas = cache.autoFight.getMainSkillData(mainSkillPlan, isDefault);
			_module.updateMainSkillList(datas);
			
			datas = cache.autoFight.getAssistSkillData(isDefault);
			_module.updateAssistSkillList(datas);
			
			_module.updateSelected(isDefault);
		}
	}
}