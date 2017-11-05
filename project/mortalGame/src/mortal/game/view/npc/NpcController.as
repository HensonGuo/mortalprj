/**
 * 2014-3-3
 * @author chenriji
 **/
package mortal.game.view.npc
{
	import com.mui.controls.Alert;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mortal.common.net.CallLater;
	import mortal.component.gconst.GameConst;
	import mortal.component.window.Window;
	import mortal.game.events.DataEvent;
	import mortal.game.model.NPCInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.NPCPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.npc.data.NpcFunctionData;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.data.TaskUtil;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class NpcController extends Controller
	{
		private var _taskDialog:NpcTaskDialogModule;
		private var _lastTaskList:Array; // 上一次点击npc的时候，当前npc携带的任务列表， 每nextStep一次删除一个
		private var _isAskNext:Boolean = false;
		private var _outToCloseWindows:Array;
		
		public function NpcController()
		{
			super();
		}
		
		protected override function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.TaskDoingDel, taskUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskUpdate, taskUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskCanGetRecv, taskUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.TaskDoingRecv, taskUpdateHandler);
			
			Dispatcher.addEventListener(EventName.NPC_ClickedHandler, clickNpcHandler);
			Dispatcher.addEventListener(EventName.NpcDialogShowTaskInfo, showTaskInfoHandler);
			Dispatcher.addEventListener(EventName.TaskAskNextStep, taskNextStepHandler);
			Dispatcher.addEventListener(EventName.NPC_ClickNpcFunction, npcFunctionHandler);
			
			// 监听远离npc事件
			RolePlayer.instance.addEventListener(PlayerEvent.GIRD_WALK_END, checkDistanceHandler);
//			RolePlayer.instance.addEventListener(PlayerEvent.WALK_END, checkDistanceHandler);
			NetDispatcher.addCmdListener(ServerCommand.MapPointUpdate, checkDistanceHandler);
			
			// 隐藏显示npc、boss、副本
			NetDispatcher.addCmdListener(ServerCommand.TaskNpcShowHideUpdate, taskShowHideHandler);
		}
		
		private function taskShowHideHandler(obj:Object):void
		{
			// npc隐藏
			var id:int;
			var dic:Dictionary = cache.npc.getHideNpc();
			for each(id in dic)
			{
				ThingUtil.npcUtil.updateNpcIsAddToStage(id, false);
			}
			// 显示npc
			dic = cache.npc.getShowNpc();
			for each(id in dic)
			{
				ThingUtil.npcUtil.updateNpcIsAddToStage(id, true);
			}
			
			// boss隐藏
			dic = cache.npc.getHideBoss();
			for each(id in dic)
			{
				ThingUtil.entityUtil.updateBossIsAddToStage(id, false);
			}
			// 显示boss
			dic = cache.npc.getShowBoss();
			for each(id in dic)
			{
				ThingUtil.entityUtil.updateBossIsAddToStage(id, true);
			}
			
			// 隐藏副本入口
			dic = cache.npc.getHideCopy();
			for each(id in dic)
			{
				ThingUtil.passUtil.updatePassIsAddToStage(id, false);
			}
			// 显示副本入口
			dic = cache.npc.getShowCopy();
			for each(id in dic)
			{
				ThingUtil.passUtil.updatePassIsAddToStage(id, true);
			}
		}
		
		private function npcFunctionHandler(evt:DataEvent):void
		{
			var data:NpcFunctionData = evt.data as NpcFunctionData;
			if(_taskDialog != null && !_taskDialog.isHide)
			{
				_taskDialog.hide();
			}
			dispatchNpcFuncEvent(data);
		}
		
		private function dispatchNpcFuncEvent(data:NpcFunctionData):void
		{
			if(data == null)
			{
				return;
			}
			addNpcFuncWinEventListener();
			switch(data.type)
			{
				case NpcFunctionData.Shop:
					Dispatcher.dispatchEvent(new DataEvent(EventName.NPC_OpenNpcShop, data));
					break;
				case NpcFunctionData.Copy:
					Dispatcher.dispatchEvent(new DataEvent(EventName.CopyClickCopyLink, data));
					break;
				case NpcFunctionData.Func:
					break;
				case NpcFunctionData.Activity:
					break;
			}
		}
		
		/**
		 * 监听点开的功能窗口， 并记录下来，远离当前npc的时候自动关闭窗口 
		 * 
		 */		
		private function addNpcFuncWinEventListener():void
		{
			_outToCloseWindows = [];
			Dispatcher.addEventListener(EventName.WindowShowed, npcFunctionWindowShowHandler);
			CallLater.addCallBack(nextFrameClickNpcFunc);
		}
		
		private function npcFunctionWindowShowHandler(evt:DataEvent):void
		{
			var win:Window = evt.data as Window;
			if(win == null)
			{
				return;
			}
			_outToCloseWindows.push(win);
		}
		
		private function nextFrameClickNpcFunc():void
		{
			Dispatcher.removeEventListener(EventName.WindowShowed, npcFunctionWindowShowHandler);
		}
		
		private function taskNextStepHandler(evt:DataEvent):void
		{
			if(_lastTaskList == null || _lastTaskList.length == 0)
			{
				hideDialog();
				return;
			}
			
			var arr:Array = evt.data as Array;
			if(arr == null)
			{
				hideDialog();
				return;
			}
			var info:TaskInfo = arr[0] as TaskInfo;
			var npcInfo:NPCInfo = arr[1] as NPCInfo;
			var npcId:int = npcInfo.tnpc.code;
			var taskId:int = info.stask.code;
			
			// 判断下一步是剧情任务就不显示下一个任务了
			if(TaskUtil.isDramaStep(info, info.curStep+1))
			{
				hideDialog();
				_isAskNext = false;
				return;
			}
			_isAskNext = true;
			return;
			
//			// 从lastList删除
//			for(var i:int = 0; i < _lastTaskList.length; i++)
//			{
//				info = _lastTaskList[i];
//				if(taskId == info.stask.code)
//				{
//					_lastTaskList.splice(i, 1);
//					break;
//				}
//			}
//			
//			info = _lastTaskList[0];
//			if(info == null)
//			{
//				hideDialog();
//				return;
//			}
//			
//			//  显示下一个任务
//			npcDialog.show();
//			npcDialog.showTaskInfo(info, npcInfo, cache.npc.getTaskTalk(info));
		}
		
		private function hideDialog():void
		{
			if(_taskDialog == null || _taskDialog.isHide)
			{
				return;
			}
			_taskDialog.hide();
		}
		
		private function taskUpdateHandler(obj:Object):void
		{
			if(_taskDialog && !_taskDialog.isHide && _taskDialog.showMode == NpcTaskDialogModule.ShowMode_TaskInfo)
			{
				return;
			}
			if(!_isAskNext)
			{
				return;
			}
			_isAskNext = false;
			var npc:NPCPlayer = cache.npc.selectedNpc;
			if(npc == null)
			{
				return;
			}
			_lastTaskList = cache.npc.getTaskListByNpcId(npc.npcInfo.tnpc.code);
			if(_lastTaskList == null || _lastTaskList.length == 0)
			{
				return;
			}
			var taskInfo:TaskInfo = _lastTaskList[0] as TaskInfo;
			npcDialog.show();
			npcDialog.showTaskInfo(taskInfo, npc.npcInfo, cache.npc.getTaskTalk(taskInfo));
		}
		
		private function showTaskInfoHandler(evt:DataEvent):void
		{
			var info:TaskInfo = evt.data as TaskInfo;
			var npc:NPCPlayer = cache.npc.selectedNpc;
			if(npc == null || npc.isDisposeToPool)
			{
				return;
			}
			
			npcDialog.show();
			npcDialog.showTaskInfo(info, npc.npcInfo, cache.npc.getTaskTalk(info));
		}
		
		private function clickNpcHandler(evt:DataEvent):void
		{
			var npc:NPCPlayer = evt.data as NPCPlayer;
			if(npc == null)
			{
				Alert.show("找不到场景中的npc");
				return;
			}
			cache.npc.selectedNpc = npc;
			// 获取当前npc的数据
			_lastTaskList = cache.npc.getTaskListByNpcId(npc.npcInfo.tnpc.code);
			if(_lastTaskList.length == 0)
			{
				showNpcFunctionList(npc.npcInfo);
			}
			else
			{
				showTaskList(_lastTaskList, npc.npcInfo);
			}
		}
		
		private function showTaskList(list:Array, info:NPCInfo):void
		{
			npcDialog.show();
			if(list.length == 1)
			{
				var taskInfo:TaskInfo = list[0];
				npcDialog.showTaskInfo(taskInfo, info, cache.npc.getTaskTalk(taskInfo));
			}
			else
			{
				var provider:DataProvider = new DataProvider();
				for(var i:int = 0; i < list.length; i++)
				{
					provider.addItem(list[i]);
				}
				npcDialog.showTaskList(provider, info, info.tnpc.talk);
			}
		}
		
		private function showNpcFunctionList(info:NPCInfo):void
		{
			var str:String = info.tnpc.effect;
			if(str == null || str == "")
			{
				// 显示默认对话
				npcDialog.show();
				npcDialog.showNpcDefaultTalk(info, info.tnpc.talk);
				return;
			}
			str = str.replace(/\[/g, "");
			var arr:Array = str.split("]");
			var provider:DataProvider = new DataProvider();
			for(var i:int = 0; i < arr.length; i++)
			{
				str = arr[i];
				if(str == null || str == "")
				{
					continue;
				}
				var data:NpcFunctionData = new NpcFunctionData();
				data.parse(str);
				data.npcId = info.snpc.npcId;
				provider.addItem(data);
			}
			// 只有1个npc功能列表， 而且是商店， 那么直接显示商店
			if(provider.length == 1 && data.type == NpcFunctionData.Shop)
			{
				dispatchNpcFuncEvent(data);
			}
			else
			{
				npcDialog.show();
				npcDialog.showNpcFunction(provider, info, info.tnpc.talk);
			}
		}
		
		public function get npcDialog():NpcTaskDialogModule
		{
			if(_taskDialog == null)
			{
				_taskDialog = new NpcTaskDialogModule();
			}
			return _taskDialog;
		}
		
		private function checkDistanceHandler(evt:*=null):void
		{
			if(cache.npc.selectedNpc == null)
			{
				return;
			}
			
			if(!isInDistance())
			{
				// 关闭当前窗口
				if(_taskDialog != null && !_taskDialog.isHide)
				{
					_taskDialog.hide();
				}
				// 离开npc窗口范围，那么清除npc的选择，并且清除npcPlayer的缓存
				if(ThingUtil.selectEntity == cache.npc.selectedNpc)
				{
					ThingUtil.selectEntity = null;
					cache.npc.selectedNpc = null;
				}
				
				if(_outToCloseWindows != null && _outToCloseWindows.length > 0)
				{
					for each(var win:Window in _outToCloseWindows)
					{
						if(win != null && !win.isHide)
						{
							win.hide();
						}
					}
					_outToCloseWindows = null;
				}
			}
		}
		
		public function isInDistance():Boolean
		{
			var distance:int = GeomUtil.calcDistance(RolePlayer.instance.x2d, RolePlayer.instance.y2d,
				cache.npc.selectedNpc.x2d, cache.npc.selectedNpc.y2d);
			if(distance >= GameConst.NpcOutDistance)
			{
				return false;
			}
			return true;
		}
		
	}
}