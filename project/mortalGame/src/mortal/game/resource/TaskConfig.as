package mortal.game.resource
{
	import Message.DB.Tables.TTask;
	import Message.DB.Tables.TTaskDialog;
	import Message.DB.Tables.TTaskDrama;
	import Message.DB.Tables.TTaskShow;
	
	import com.gengine.resource.ConfigManager;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;

	public class TaskConfig
	{
		private static var _instance:TaskConfig;
		
		private var _taskNames:Dictionary;
		private var _taskConfig:Dictionary;
		private var _taskDialog:Dictionary;
		private var _taskShow:Dictionary;
		private var _drama:Dictionary;
		
		public function TaskConfig()
		{
			initConfig();
		}
		
		public static function get instance():TaskConfig
		{
			if(_instance == null)
				_instance = new TaskConfig();
			return _instance;
		}
		
		/**
		 * 获取任务定义 
		 * @param code
		 * @return 
		 * 
		 */		
		public function getTaskConfigByCode(code:int):TTask
		{
			return _taskConfig[code];
		}
		
		public function getDialog(code:int):TTaskDialog
		{
			return _taskDialog[code] as TTaskDialog;
		}
		
		private function initConfig():void
		{
//			_taskNames = new Dictionary();
//			var objs:Object = ConfigManager.instance.getJSONByFileName("t_task_name.json");
//			for each(var obj:Object in objs)
//			{
//				var info:TTaskName  = new TTaskName();
//				copyValue(info, obj);
//				var key:String = info.taskCode.toString();
//				_taskNames[key] = info;
//			}
			
			_taskConfig = new Dictionary();
			var objs:Object = ConfigManager.instance.getJSONByFileName("t_task_config.json");
			for each(var obj:Object in objs)
			{
				var infox:TTask  = new TTask();
				copyValue(infox, obj);
				_taskConfig[infox.code] = infox;
			}
			
			_taskDialog = new Dictionary();
			objs = ConfigManager.instance.getJSONByFileName("t_task_dialog.json");
			for each (obj in objs)
			{
				var dialog:TTaskDialog = new TTaskDialog();
				copyValue(dialog, obj);
				_taskDialog[dialog.id] = dialog;
			}
			
			_taskShow = new Dictionary();
			objs = ConfigManager.instance.getJSONByFileName("t_task_show.json");
			for each (obj in objs)
			{
				var tshow:TTaskShow = new TTaskShow();
				copyValue(tshow, obj);
				_taskShow[tshow.id] = tshow;
			}
			
			_drama = new Dictionary();
			objs = ConfigManager.instance.getJSONByFileName("t_task_drama.json");
			for each (obj in objs)
			{
				var tDrama:TTaskDrama = new TTaskDrama();
				copyValue(tDrama, obj);
				_drama[getDramaKey(tDrama.dramaCode, tDrama.step)] = tDrama;
			}
		}
		private function getDramaKey(code:int, step:int):String
		{
			return code.toString() + "_" + step.toString();
		}
		
		public function getDrama(code:int, step:int):TTaskDrama
		{
			return _drama[getDramaKey(code, step)] as TTaskDrama;
		}
		
		public function getTaskShow(id:int):TTaskShow
		{
			return _taskShow[id];
		}
		
		private function copyValue(target:Object, data:Object):void
		{
			for(var key:Object in data)
			{
				target[key] = data[key];
			}
		}
	}
}