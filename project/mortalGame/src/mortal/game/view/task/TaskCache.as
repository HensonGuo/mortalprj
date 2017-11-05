/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.view.task
{
	import Message.Game.SPlayerTask;
	import Message.Game.SPlayerTaskUpdate;
	import Message.Public.ETaskStatus;
	
	import fl.data.DataProvider;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.data.TaskRule;
	

	public class TaskCache
	{
		private var _taskDoing:Dictionary;
		private var _taskCanGet:Dictionary;
		
		public function TaskCache()
		{
		}
		
		public function initTaskCanGet(list:Array):void
		{
			_taskCanGet = new Dictionary();
			addTaskCanGets(list);
		}
		
		public function addTaskCanGets(list:Array):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var info:TaskInfo = new TaskInfo();
				info.stask = list[i];
				info.status = ETaskStatus._ETaskStatusCanGet;
				_taskCanGet[info.stask.code] = info;
			}
		}
		
		public function delTaskCanGet(taskId:int):void
		{
			delete _taskCanGet[taskId];
		}
		
		public function get taskCanGet():Array
		{
			var res:Array = [];
			for each(var info:TaskInfo in _taskCanGet)
			{
				res.push(info);
			}
			res.sort(TaskRule.sortTask);
			return res;
		}
		
		public function initTaskDoing(list:Array):void
		{
			_taskDoing = new Dictionary();
			for(var i:int = 0; i < list.length; i++)
			{
				var info:TaskInfo = new TaskInfo();
				var task:SPlayerTask = list[i];
				info.playerTask = task;
				info.stask = task.task;
				info.status = task.status;
				_taskDoing[info.stask.code] = info;
			}
		}
		
		public function addTaskDoing(task:SPlayerTask):void
		{
			var code:int = task.task.code;
			var info:TaskInfo = _taskDoing[code] as TaskInfo;
			if(info == null)
			{
				info = new TaskInfo();
				_taskDoing[code] = info;
			}
			info.stask = task.task;
			info.playerTask = task;
			info.status = task.status;
		}
		
		public function delTaskDoing(taskId:int):void
		{
			delete _taskDoing[taskId];
		}
		
		public function get taskDoing():Array
		{
			var res:Array = [];
			for each(var info:TaskInfo in _taskDoing)
			{
				res.push(info);
			}
			res.sort(TaskRule.sortTask);
			return res;
		}
		
		public function updateTask(list:Array):void
		{
			for(var i:int = 0; i < list.length; i++)
			{
				var update:SPlayerTaskUpdate = list[i];
				var info:TaskInfo = getTaskByCode(update.taskCode);
				if(info != null)
				{
					info.update(update);
				}
			}
		}
		
		public function getTaskByCode(code:int):TaskInfo
		{
			var res:TaskInfo = _taskDoing[code];
			if(res == null)
			{
				res = _taskCanGet[code];
			}
			return res;
		}
		
		public function getCatogeryHeadDatas(tasks:Array, heads:Array, dataProviders:Array):void
		{
			var headCounts:Dictionary = new Dictionary();
			var temp:Array = [];
			for(var i:int = 0; i < tasks.length; i++)
			{
				var info:TaskInfo = tasks[i];
				var group:int = info.stask.group;
				var provider:DataProvider = temp[group];
				if(provider == null)
				{
					provider = new DataProvider();
					temp[group] = provider;
				}
				provider.addItem(info);
				
				if(headCounts.hasOwnProperty(group.toString()))
				{
					headCounts[group] += 1;
				}
				else
				{
					headCounts[group] = 1;
				}
			}
			
			for(i = 1; i < 20; i++)
			{
				if(!headCounts.hasOwnProperty(i.toString()))
				{
					continue;
				}
				var str:String = TaskRule.getGroupFullName(i) + "(" + headCounts[i].toString() + ")";
				heads.push(str);
				if(temp[i] != null)
				{
					dataProviders.push(temp[i]);
				}
			}
		}
		
		public function getTrackDatas(tasks:Array):DataProvider
		{
			var res:DataProvider = new DataProvider();
			for(var i:int = 0; i < tasks.length; i++)
			{
				res.addItem(tasks[i]);
			}
			return res;
		}
	}
}