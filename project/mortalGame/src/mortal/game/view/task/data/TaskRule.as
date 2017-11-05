package mortal.game.view.task.data
{
	import Message.Public.ETaskGroup;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.task.data.TaskInfo;

	public class TaskRule
	{
		private static var _taskGroupFullName:Dictionary;							// 分组名字全称
		private static var _taskGroupShortName:Dictionary;                        // 分组名字简称
		private static var _taskGroupTitle:Array;								//任务分组标题列表
		private static var _taskGroupSortNormalRule:Array;					//任务分组默认排序规则
		private static var _taskGroupSortCompletedRule:Array;					//任务分组已完成的排序规则
		private static var _taskGroupSortNotCompletedRule:Array;				//任务分组未完成的排序规则
		
		public function TaskRule()
		{
		}
		
		/**
		 * 初始化任务分组映射 
		 * 
		 */
		private static function initGroupFullName():void
		{
			_taskGroupFullName = new Dictionary();
			_taskGroupFullName[ETaskGroup._ETaskGroupMain] = Language.getString(20126);
			_taskGroupFullName[ETaskGroup._ETaskGroupBranch] = Language.getString(20127);
			_taskGroupFullName[ETaskGroup._ETaskGroupLoop] = Language.getString(20128);
			_taskGroupFullName[ETaskGroup._ETaskGroupEscort] = Language.getString(20129);
			_taskGroupFullName[ETaskGroup._ETaskGroupAlliance] = Language.getString(20130);
			_taskGroupFullName[ETaskGroup._ETaskGroupTreasure] = Language.getString(20131);
			_taskGroupFullName[ETaskGroup._ETaskGroupCopy] = Language.getString(20132);
			_taskGroupFullName[ETaskGroup._ETaskGroupRomance] = Language.getString(20133);
			_taskGroupFullName[ETaskGroup._ETaskGroupSpy] = Language.getString(20134);
			_taskGroupFullName[ETaskGroup._ETaskGroupCross] = Language.getString(20135);
		}
		/**
		 * 初始化任务分组映射 
		 * 
		 */
		private static function initGroupShortName():void
		{
			var arr:Array = Language.getString(20145).split(",");
			_taskGroupShortName = new Dictionary();
			_taskGroupShortName[ETaskGroup._ETaskGroupMain] = arr[0];
			_taskGroupShortName[ETaskGroup._ETaskGroupBranch] = arr[1];
			_taskGroupShortName[ETaskGroup._ETaskGroupLoop] = arr[2];
			_taskGroupShortName[ETaskGroup._ETaskGroupEscort] = arr[3];
			_taskGroupShortName[ETaskGroup._ETaskGroupAlliance] = arr[4];
			_taskGroupShortName[ETaskGroup._ETaskGroupTreasure] = arr[5];
			_taskGroupShortName[ETaskGroup._ETaskGroupCopy] = arr[6];
			_taskGroupShortName[ETaskGroup._ETaskGroupRomance] = arr[7];
			_taskGroupShortName[ETaskGroup._ETaskGroupSpy] = arr[8];
			_taskGroupShortName[ETaskGroup._ETaskGroupCross] = arr[9];
		}
		
		/**
		 * 任务分组标题列表 
		 * @return 
		 * 
		 */
		public static function getTaskGroupTitleMap():Array
		{
			if(!_taskGroupTitle)
			{
				_taskGroupTitle = [
					{label:Language.getString(20126),type:ETaskGroup._ETaskGroupMain},    //主线任务
					{label:Language.getString(20127),type:ETaskGroup._ETaskGroupBranch},  //支线任务
					{label:Language.getString(20128),type:ETaskGroup._ETaskGroupLoop},    //循环任务
					{label:Language.getString(20129),type:ETaskGroup._ETaskGroupEscort},  //灵兽护送任务
					{label:Language.getString(20130),type:ETaskGroup._ETaskGroupAlliance},    //仙盟任务
					{label:Language.getString(20131),type:ETaskGroup._ETaskGroupTreasure},//国家宝藏
					{label:Language.getString(20132),type:ETaskGroup._ETaskGroupCopy},    //副本任务
					{label:Language.getString(20133),type:ETaskGroup._ETaskGroupRomance}, //情缘任务
					{label:Language.getString(20134),type:ETaskGroup._ETaskGroupSpy},     //刺探任务
					{label:Language.getString(20135),type:ETaskGroup._ETaskGroupCross}    //跨服任务
				];
			}
			return _taskGroupTitle;
		}
		
		/**
		 * 任务分组默认排序规则 
		 * @return 
		 * 
		 */
		public static function getTaskGroupSortNormalRule():Array
		{
			if(!_taskGroupSortNormalRule)
			{
				_taskGroupSortNormalRule = [
					ETaskGroup._ETaskGroupMain,		//主线
					ETaskGroup._ETaskGroupRomance,	//情缘
					ETaskGroup._ETaskGroupEscort,	//运镖
					ETaskGroup._ETaskGroupLoop,		//循环
					ETaskGroup._ETaskGroupTreasure,	//国家宝藏
					ETaskGroup._ETaskGroupBranch,	//支线
					ETaskGroup._ETaskGroupAlliance,		//仙盟任务
					ETaskGroup._ETaskGroupSpy,		//刺探
					ETaskGroup._ETaskGroupCopy,		//副本
					ETaskGroup._ETaskGroupCross 	//跨服任务
				];
			}
			return _taskGroupSortNormalRule;
		}
		

		/**
		 * 任务分组已完成的排序规则 
		 * @return 
		 * 
		 */
		public static function getTaskGroupSortCompletedRule():Array
		{
			if(!_taskGroupSortCompletedRule)
			{
				_taskGroupSortCompletedRule = [
					ETaskGroup._ETaskGroupMain,		//主线
					ETaskGroup._ETaskGroupRomance,	//情缘
					ETaskGroup._ETaskGroupEscort,	//运镖
					ETaskGroup._ETaskGroupLoop,		//循环
					ETaskGroup._ETaskGroupTreasure,	//国家宝藏
					ETaskGroup._ETaskGroupBranch,	//支线
					ETaskGroup._ETaskGroupAlliance,		//仙盟任务
					ETaskGroup._ETaskGroupSpy,		//刺探
					ETaskGroup._ETaskGroupCopy,		//副本
					ETaskGroup._ETaskGroupCross 	//跨服任务
				];
			}
			return _taskGroupSortCompletedRule;
		}
		
		public static function sortTask(a:TaskInfo, b:TaskInfo):int
		{
			if(_taskGroupSortNormalRule == null)
			{
				getTaskGroupSortNormalRule();
			}
			if(a.isComplete())
			{
				return -1;
			}
			if(b.isComplete())
			{
				return 1;
			}
			
			if(_taskGroupSortNormalRule.indexOf(a.stask.group) <= _taskGroupSortNormalRule.indexOf(b.stask.group))
			{
				return -1;
			}
			if(a.stask.code < b.stask.code)
			{
				return -1;
			}
			return 1;
		}

		/**
		 * 任务分组未完成的排序规则 
		 * @return 
		 * 
		 */
		public static function getTaskGroupSortNotCompletedRule():Array
		{
			if(!_taskGroupSortNotCompletedRule)
			{
				_taskGroupSortNotCompletedRule = [
					ETaskGroup._ETaskGroupMain,		//主线
					ETaskGroup._ETaskGroupRomance,	//情缘
					ETaskGroup._ETaskGroupEscort,	//运镖
					ETaskGroup._ETaskGroupLoop,		//循环
					ETaskGroup._ETaskGroupTreasure,	//国家宝藏
					ETaskGroup._ETaskGroupBranch,	//支线
					ETaskGroup._ETaskGroupAlliance,		//仙盟任务
					ETaskGroup._ETaskGroupSpy,		//刺探
					ETaskGroup._ETaskGroupCopy,		//副本
					ETaskGroup._ETaskGroupCross 	//跨服任务
				];
			}
			return _taskGroupSortNotCompletedRule;
		}
		
		/**
		 * 返回分组名字简称 
		 * @param group
		 * @return 
		 * 
		 */		
		public static function getGroupShortName(group:int):String
		{
			if(!_taskGroupShortName)
			{
				initGroupShortName();
			}
			return _taskGroupShortName[group];
		}
		
		/**
		 * 返回分组名字全称 
		 * @param group
		 * @return 
		 * 
		 */		
		public static function getGroupFullName(group:int):String
		{
			if(!_taskGroupFullName)
			{
				initGroupFullName();
			}
			return _taskGroupFullName[group];
		}
		
	}
}