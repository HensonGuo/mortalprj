/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.game.view.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	import Message.DB.Tables.TNpc;
	import Message.DB.Tables.TTaskDrama;
	import Message.Game.SPlayerTaskUpdate;
	import Message.Game.SProcess;
	import Message.Public.EStepType;
	import Message.Public.ETaskGroup;
	import Message.Public.ETaskProcess;
	import Message.Public.SDramaStepMsg;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	import com.mui.controls.Alert;
	
	import fl.data.DataProvider;
	
	import flash.geom.Point;
	
	import flashx.textLayout.tlf_internal;
	
	import mortal.common.net.CallLater;
	import mortal.component.gLinkText.GLinkTextData;
	import mortal.component.gconst.GameConst;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.model.NPCInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.TaskProxy;
	import mortal.game.resource.SceneConfig;
	import mortal.game.resource.TaskConfig;
	import mortal.game.resource.tableConfig.NPCConfig;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.view.task.data.GLinkTextDataParser;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.data.TaskIntroduceData;
	import mortal.game.view.task.drama.TaskDramaOperator;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class TaskController extends Controller
	{
		private var _trackModule:TaskTrackModule;
		private var _taskModule:TaskModule;
		private var _dramaSteper:TaskDramaOperator;
		
		public function TaskController()
		{
			super();
		}
		
		public override function get view():IView
		{
			if(_trackModule == null)
			{
				_trackModule = new TaskTrackModule();
			}
			return _trackModule;
		}
		
		public function get taskMoudle():TaskModule
		{
			if(_taskModule == null)
			{
				_taskModule = new TaskModule();
			}
			return _taskModule;
		}
		
		protected override function initServer():void
		{			
			////////////////////////////////////////////////////////////////////////////// 桌面的任务追踪
			Dispatcher.addEventListener(EventName.TaskShowHideModule, showHideTaskModuleHandler);
			
			// 监听任务事件
			NetDispatcher.addCmdListener(ServerCommand.TaskCanGetRecv, initTaskCanGetHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskDoingRecv, initTaskDoingHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskUpdate, taskUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.RoleLevelUpdate, taskUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskDoingAdd, taskDoingAddHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskDoingDel, removeFromDoingHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskCanGetAdd, taskCanGetAddHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskCanGetDel, taskCanGetDelHandler);
			// 成功领取任务之后，任务导航栏自动跳到当前任务
			NetDispatcher.addCmdListener(ServerCommand.TaskGetSucess, taskGetSucessHandler); 
			
			// 剧情任务
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicDramaStepMsg, dramaStepHandler);
			Dispatcher.addEventListener(EventName.Task_DramaNextStep, dramaNextStepHandler);
			
			////////////////////////////////////////////////////////////////////////////// Q键的任务面板
			Dispatcher.addEventListener(EventName.TaskModuleTabChange, taskModuleTabChangeHandler);
			Dispatcher.addEventListener(EventName.TaskMoudleViewTaskInfo, viewTaskInfoHandler);
			
			
			/// 任务放弃、快速完成、快速提交等
			Dispatcher.addEventListener(EventName.TaskGiveupTask, giveupTaskHandler);
			Dispatcher.addEventListener(EventName.TaskQuickComplete, quickCompleteHandler);
			Dispatcher.addEventListener(EventName.TaskQuickCompleteFinish, quickCompleteFinishHandler);
			Dispatcher.addEventListener(EventName.TaskQuickFinish, quickFinishHandler);
			
			
			// 任务基础功能（领取任务、完成任务等）
			Dispatcher.addEventListener(EventName.TaskAskNextStep, askNextStepHandler);
			
			// ///////////////////////////////////////// GLinkText相关
			Dispatcher.addEventListener(EventName.FlyBoot_GLinkText, linkTextFlyBootHandler);
			Dispatcher.addEventListener(EventName.TaskTraceTargetEvent, clickToTargetHandler); // 点击任务连接文本，自动移动并且挂机
			
			// 舞台大小更改
			Dispatcher.addEventListener(EventName.StageResize, stagetResizeHandler);
		}
		
		private function stagetResizeHandler(evt:DataEvent):void
		{
			if(_dramaSteper != null)
			{
				_dramaSteper.stageResizeHandler();
			}
		}
		
		private function taskGetSucessHandler(obj:Object):void
		{
			if(_trackModule != null)
			{
				_trackModule.showDoingTasks();
			}
		}
		
		private function dramaNextStepHandler(evt:DataEvent):void
		{
			var data:TTaskDrama = evt.data as TTaskDrama;
			if(data == null)
			{
				return;
			}
//			if(data.step == 24)
//			{
//				data = TaskConfig.instance.getDrama(data.dramaCode, 27); // 下一步数据
//			}
//			else if(data.step >= 17 && data.step && data.step < 22)
//			{
//				data = TaskConfig.instance.getDrama(data.dramaCode, 22); // 下一步数据
//			}
//			else if(data.step == 13)
//			{
//				data = TaskConfig.instance.getDrama(data.dramaCode, 15); // 下一步数据
//			}
//			else
//			{
				data = TaskConfig.instance.getDrama(data.dramaCode, data.step + 1); // 下一步数据
//			}
			if(data == null || data.type >= EStepType._EStepTypeBuffAdd)
			{
				// 找不到下一步的配置，或者下一步的是服务器的配置，那么告诉服务器我完成这一步了
				GameProxy.task.finishDramaStep(data.step - 1);
				Log.error("前端告诉服务器完成了：code=" + data.dramaCode + ", step=" + (data.step- 1));
				return;
			}
			else // 客户端的步骤， 继续执行
			{
				if(_dramaSteper == null)
				{
					_dramaSteper = new TaskDramaOperator();
				}
				Log.error("前端继续执行步骤：code=" + data.dramaCode + ", step=" + data.step);
				_dramaSteper.operate(data);
			}
		}
		
		private function dramaStepHandler(mb:MessageBlock):void
		{
			var step:SDramaStepMsg = mb.messageBase as SDramaStepMsg;
			if(step == null)
			{
				return;
			}
			if(_dramaSteper == null)
			{
				_dramaSteper = new TaskDramaOperator();
			}
			var data:TTaskDrama = TaskConfig.instance.getDrama(step.dramaCode, step.step);
			if(data == null)
			{
				Alert.show("服务器发来的dramaCode=" + step.dramaCode +", step=" + step.step + "， 找不到配置");
				return;
			}
			Log.error("服务器告诉前端执行步骤：code=" + step.dramaCode + ", step=" + step.step);
			_dramaSteper.operate(data);
		}
		
		private function quickCompleteHandler(evt:DataEvent):void
		{
			var info:TaskInfo = evt.data as TaskInfo;
			if(info == null)
			{
				return;
			}
			GameProxy.task.quickComplete(info.stask.code);
		}
		
		private function quickCompleteFinishHandler(evt:DataEvent):void
		{
			var info:TaskInfo = evt.data as TaskInfo;
			if(info == null)
			{
				return;
			}
			GameProxy.task.quickComplete(info.stask.code);
			GameProxy.task.endTask(0, info.stask.code);
		}
		
		private function quickFinishHandler(evt:DataEvent):void
		{
			var info:TaskInfo = evt.data as TaskInfo;
			if(info == null)
			{
				return;
			}
			GameProxy.task.endTask(0, info.stask.code);
		}
		
		private function taskCanGetAddHandler(obj:Object):void
		{
			initTaskCanGetHandler(null);
		}
		
		private function taskCanGetDelHandler(obj:Object):void
		{
			var code:int = int(obj);
			_trackModule.taskCanGet.removeItem(code);
			if(_taskModule!= null && !_taskModule.isHide && _taskModule.selectedIndex == 1)
			{
				taskModuleTabChangeHandler(null);
			}
		}
		
		private function giveupTaskHandler(evt:DataEvent):void
		{
			var info:TaskInfo = evt.data as TaskInfo;
			if(info == null)
			{
				return;
			}
			GameProxy.task.cancelTask(info.stask.code);
			
			if(_taskModule != null && !_taskModule.isHide)
			{
				_taskModule.updateDesc(null);
			}
		}
		
		private function linkTextFlyBootHandler(evt:DataEvent):void
		{
			var data:GLinkTextData = evt.data as GLinkTextData;
		
			var pt:SPassTo = new SPassTo();
			pt.mapId = data.mapId;
			pt.toPoint = new SPoint();
			pt.toPoint.x = data.x;
			pt.toPoint.y = data.y;
			
			AIManager.cancelAll();
			// 飞行
			AIManager.addFlyBoot(pt);
			
			switch(data.type)
			{
				case GLinkTextData.boss:
					// 添加自动挂机, 以后做
					break;
				case GLinkTextData.Point:
					AIManager.addCallback(gotoPointFinished, data);
					break;
				case GLinkTextData.npc:
					AIManager.addDelayAI(300);
					AIManager.addClickNpcAI(data.value1);
					break;
			}
			AIManager.start();
		}
		
		private function clickToTargetHandler(evt:DataEvent):void
		{
			var target:GLinkTextData = evt.data as GLinkTextData;
			
			switch(target.type)
			{
				case GLinkTextData.boss: // 去到那个点，然后挂机打boss
					AIManager.cancelAll();
					// 暂时移动到， 等写完挂机ai
					AIManager.onAIControl(AIType.GoToOtherMap, Game.mapInfo.mapId, target.mapId, new Point(target.x, target.y));
					AIManager.start();
					break;
				case GLinkTextData.Point: // 去到那个点
					AIManager.cancelAll();
					AIManager.addMoveToOtherMap(Game.mapInfo.mapId, target.mapId, new Point(target.x, target.y), 60);
					AIManager.addCallback(gotoPointFinished, target);
					AIManager.start();
					break; 
				case GLinkTextData.npc:
					if(target.value1 <= 0)
					{
						// 显示自己的头像
						AIManager.cancelAll();
//						AIManager.start();
						GameController.npc.npcDialog.show();
						GameController.npc.npcDialog.showSelf(target.data as TaskInfo, target.htmlText);
						return; 
					}
					// 找到那个npc的位置
					var sceneInfo:SceneInfo = SceneConfig.instance.getSceneInfoByNpcId(target.value1);
					if(sceneInfo == null)
					{
						return;
					}
					var npcInfo:NPCInfo = sceneInfo.getNpcInfo(target.value1);
					if(npcInfo == null)
					{
						return;
					}
					
					AIManager.cancelAll();
					if(target.value2 == 0)
					{
						AIManager.addMoveToOtherMap(Game.mapInfo.mapId, target.mapId, 
							GameMapUtil.getPixelPoint(npcInfo.snpc.point.x/Game.mapInfo.pieceWidth, npcInfo.snpc.point.y/Game.mapInfo.pieceHeight),
							GameConst.NpcInDistance);
					}
					AIManager.addClickNpcAI(target.value1);
					AIManager.start();
					break;
			}
			
		}
		
		private function askNextStepHandler(evt:DataEvent):void
		{
			var arr:Array = evt.data as Array;
			if(arr == null)
			{
				return;
			}
			var info:TaskInfo = arr[0] as TaskInfo;
			var npcInfo:NPCInfo = arr[1] as NPCInfo;
			var npcId:int = npcInfo.tnpc.code;
			var taskId:int = info.stask.code;
			if(info == null || npcInfo == null)
			{
				return;
			}
			if(info.isCanget())
			{
				GameProxy.task.getTask(npcId, taskId);
			}
			else if(info.isDoing())
			{
				GameProxy.task.talkToNpc(npcId, taskId);
			}
			else if(info.isComplete())
			{
				GameProxy.task.endTask(npcId, taskId);
			}
		}
		
		private function viewTaskInfoHandler(evt:DataEvent):void
		{
			var info:TaskInfo = evt.data as TaskInfo;
			if(_taskModule && !_taskModule.isHide)
			{
				_taskModule.updateDesc(info);
			}
		}
		
		private var _lastIndex:int = -2;
		private function taskModuleTabChangeHandler(evt:DataEvent):void
		{
			if(_taskModule == null || _taskModule.isHide)
			{
				return;
			}
			var index:int = _taskModule.selectedIndex;
//			if(_lastIndex >= 0 && _lastIndex != index)
//			{
				_taskModule.resetList();
//			}
			_lastIndex = index;
			var headDatas:Array = [];
			var dataProviders:Array = [];
			var sourceData:Array;
			if(index == 0) // 进行中的任务
			{
				sourceData = cache.task.taskDoing;
			}
			else
			{
				sourceData = cache.task.taskCanGet;
			}
			
			cache.task.getCatogeryHeadDatas(sourceData, headDatas, dataProviders);
			_taskModule.initHeads(headDatas);
			// 假如这个栏目没东西，就清楚右边的TaskItemDesc
			if(headDatas.length == 0)
			{
				_taskModule.updateDesc(null);
			}
			for(var i:int = 0; i < dataProviders.length; i++)
			{
				_taskModule.setDataProvider(i, dataProviders[i] as DataProvider);
			}
			
//			CallLater.addCallBack(nextFrameTabChange);
//			function nextFrameTabChange():void
//			{
				_taskModule.expand(0);
//			}
		}
		
		private function initTaskCanGetHandler(obj:Object):void
		{
			if(_trackModule == null)
			{
				this.view.show();
			}
			_trackModule.taskCanGet.initList(cache.task.taskCanGet);
			if(_taskModule!= null && !_taskModule.isHide && _taskModule.selectedIndex == 1)
			{
				taskModuleTabChangeHandler(null);
			}
		}
		
		private function initTaskDoingHandler(obj:Object):void
		{
			_trackModule.taskDoing.initList(cache.task.taskDoing);
			if(_taskModule!= null && !_taskModule.isHide && _taskModule.selectedIndex == 0)
			{
				taskModuleTabChangeHandler(null);
			}
		}
		
		private function removeFromDoingHandler(obj:Object):void
		{
			var code:int = int(obj);
			_trackModule.taskDoing.removeItem(code);
			if(_taskModule!= null && !_taskModule.isHide && _taskModule.selectedIndex == 0)
			{
				taskModuleTabChangeHandler(null);
			}
		}
		
		private function taskDoingAddHandler(obj:Object):void
		{
			var code:int = int(obj);
			var info:TaskInfo = cache.task.getTaskByCode(code);
			_trackModule.taskDoing.addItem(info, true);
			if(_taskModule!= null && !_taskModule.isHide && _taskModule.selectedIndex == 0)
			{
				taskModuleTabChangeHandler(null);
			}
			// 如果是介绍任务，则显示介绍任务面板
			var arr:Array = GLinkTextDataParser.parseProcess(info.stask.processMap, info, true);
			if(arr.length > 0 && (arr[0] is TaskIntroduceData))
			{
				TaskIntroduce.instance.showIntroduces(arr);
			}
		}
		
		private function taskUpdateHandler(obj:Object):void
		{
			var arr:Array = obj as Array;
			for each(var update:SPlayerTaskUpdate in arr)
			{
				var info:TaskInfo = cache.task.getTaskByCode(update.taskCode);
				if(info != null)
				{
					_trackModule.taskDoing.updateItem(info, false);
				}
			}
			_trackModule.taskDoing.updateLayout();
			
			if(_taskModule != null && !_taskModule.isHide)
			{
				info = _taskModule.getCurDescInfo();
				if(info != null)
				{
					info = cache.task.getTaskByCode(info.stask.code);
					_taskModule.updateDesc(info);
				}
				
			}
		}
		
		private function gotoPointFinished(data:GLinkTextData):void
		{
			var info:TaskInfo = data.data as TaskInfo;
			var pro:SProcess = info.stask.processMap[info.curStep][0];
			if(pro == null)
			{
				return;
			}
			switch(pro.type)
			{
				case ETaskProcess._ETaskProcessTreasure:// 挖宝
					GameProxy.task.digTreasure();
					break;
				case ETaskProcess._ETaskProcessExplore:
					GameProxy.task.explore(); // 刺探
					break;
			}
		}
		
		private function showHideTaskModuleHandler(evt:DataEvent):void
		{
			if(_taskModule != null && !_taskModule.isHide)
			{
				_taskModule.hide();
			}
			else
			{
				if(_taskModule == null)
				{
					_taskModule = new TaskModule();
				}
				_taskModule.show();
			}
		}
	}
}