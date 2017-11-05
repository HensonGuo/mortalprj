/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.view.task.data
{
	import Message.DB.Tables.TTask;
	import Message.Game.SConditon;
	import Message.Game.SNpcTask;
	import Message.Game.SPlayerTask;
	import Message.Game.SPlayerTaskUpdate;
	import Message.Game.SProcess;
	import Message.Game.STask;
	import Message.Public.ETaskCompleteCondition;
	import Message.Public.ETaskProcess;
	import Message.Public.ETaskStatus;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.proxy.SceneProxy;

	public class TaskInfo
	{
		// canGet
		public var stask:STask;
		// doing
		public var playerTask:SPlayerTask;
		// 点击npc发来的
		public var npcTask:SNpcTask;
		private var _totalStep:int = -1;
		// 任务当前的状态
		public var status:int = ETaskStatus._ETaskStatusCanGet;
		
		public function TaskInfo()
		{
		}
		
		public function get curStep():int
		{
			if(isCanget())
			{
				return 0;
			}
			if(isComplete())
			{
				return totalStep - 1; 
			}
			return playerTask.currentStep;
		}
		
		public function get totalStep():int
		{
			if(_totalStep < 0)
			{
				var dic:Dictionary = stask.processMap;
				_totalStep = 2; // 领取、完成的不在里面
				for each(var obj:Array in dic)
				{
					var pro:SProcess = obj[0] as SProcess;
					if(pro != null && pro.type == ETaskProcess._ETaskProcessIntroduce)
					{
						continue;
					}
					_totalStep++;
				}
			}
			return _totalStep;
		}
		
		public function getTargetX(processStep:int, subStep:int=0):int
		{
			var arr:Array = stask.processMap[processStep];
			if(arr == null)
			{
				return 0;
			}
			var process:SProcess = arr[subStep];
			if(process == null)
			{
				return 0;
			}
			var len:int = process.contents.length;
			return int(process.contents[len - 2]);
		}
		
		public function getTargetY(processStep:int, subStep:int=0):int
		{
			var arr:Array = stask.processMap[processStep];
			if(arr == null)
			{
				return 0;
			}
			var process:SProcess = arr[subStep];
			if(process == null)
			{
				return 0;
			}
			var len:int = process.contents.length;
			return int(process.contents[len - 1]);
		}
		
		public function isCanget():Boolean
		{
			return this.status == ETaskStatus._ETaskStatusCanGet;
		}
		
		public function isDoing():Boolean
		{
			return this.status == ETaskStatus._ETaskStatusNotComplete;
		}
		
		/**
		 *  是否完成了未提交
		 * @return 
		 * 
		 */		
		public function isComplete():Boolean
		{
			return this.status == ETaskStatus._ETaskStatusHadComplete || isCanNotEnd();
		}
		
		/**
		 * 已经完成但是由于等级达到不能提交 
		 * @return 
		 * 
		 */		
		public function isCanNotEnd():Boolean
		{
			return this.status == ETaskStatus._ETaskStatusCantEnd;
		}
		
		/**
		 * 完成并且提交了 
		 * @return 
		 * 
		 */		
		public function isCompleted():Boolean
		{
			return this.status == ETaskStatus._ETaskStatusHadEnd;
		}
		
		public function isFail():Boolean
		{
			return this.status == ETaskStatus._ETaskStatusHadFail;
		}
		
		/**
		 * 是否是限时完成的任务 
		 * @return 
		 * 
		 */		
		public function isTimeLimitTask():Boolean
		{
			var arr:Array = stask.completeConditions;
			if(arr == null || arr.length == 0)
			{
				return false;
			}
			for each(var condition:SConditon in arr)
			{
				if(condition.type == ETaskCompleteCondition._ETaskCompleteConditionTime)
				{
					return true;
				}
			}
			return false;
		}
		
		public function update(data:SPlayerTaskUpdate):void
		{
			playerTask.currentStep = data.currentSetp;
			playerTask.status = data.status;
			playerTask.stepRecords = data.stepRecords;
			this.status = data.status;
		}
		
		/**
		 * 任务名字 + (进行中、已完成) 
		 * @param isNeedStatus
		 * @return 
		 * 
		 */		
		public function getName(isNeedStatus:Boolean=true, isNeedShort:Boolean=false):String
		{
			var res:String = "";
			if(stask == null)
			{
				return res;
			}
			res = stask.name;
			if(isNeedShort)
			{
				res = "<font color='#FF73AB'>[" + TaskRule.getGroupShortName(stask.group) + "]</font>" + res; 
			}
			if(isNeedStatus)
			{
				var color:String = GlobalStyle.colorHuang;
				var code:int = 20157;
				if(isCanget())
				{
					code = 20158;
					color = GlobalStyle.colorLv
				}
				else if(isDoing())
				{
					color = GlobalStyle.colorPutong;
					code = 20156;
				}
				res += "<font color='" + color + "'>(" + Language.getString(code) + ")</font>";
			}
			return res;
		}
		
		public function getStatusName(isHtml:Boolean=true):String
		{
			var res:String = "";
			var color:String = GlobalStyle.colorHuang;
			var code:int = 20157;
			if(isCanget())
			{
				code = 20158;
				color = GlobalStyle.colorLv
			}
			else if(isDoing())
			{
				color = GlobalStyle.colorPutong;
				code = 20156;
			}
			else if(isFail())
			{
				color = GlobalStyle.colorHong;
				code = 20170;
			}
			if(isHtml)
			{
				res += "<font color='" + color + "'>(" + Language.getString(code) + ")</font>";
			}
			else
			{
				res += "(" + Language.getString(code) + ")";
			}
			return res;
		}
		
		/**
		 int code;               //编码
		 string name;            //名字
		 int group;              //分组
		 int loopType;           //循环类型
		 int executeCount;       //可执行次数
		 int canQuickComplete;   //快速完成提交（1 快速完成 2 快速提交 4 快速完成提交）
		 int getNpc;             //接任务NPC
		 int getDistance;        //接任务距离 （0 按照默认距离  1 可以直接接取）
		 int endNpc;             //交任务NPC
		 int endDistance;
		 int getTalkId;          //接任务对话ID
		 int endTalkId;          //交任务对话ID
		 int notCompletedTalkId; //未完成任务对话ID
		 int getChoose;          //接任务选择
		 int context;            //任务描述
		 int endChoose;          //交任务选择
		 int guide;              //指引类型
		 int guideCompleted;     //指引类型
		 int failTalkId;         //任务失败对话ID
		 
		 DictSeqProcess              processMap;         //任务内容[步骤，步骤内进程]
		 
		 STaskEffect                 effect;             //特殊效果
		 SeqConditon                 getConditions;	    //前置条件集合
		 Message::Public::DictIntInt getGiveItemDict;    //接任务后马上给予的物品列表
		 SeqConditon                 completeConditions; //完成条件集合
		 Message::Public::DictIntInt endChooseItemDict;  //结束任务需要选择的物品
		 SeqTaskReward               rewards;            //奖励集合
		 **/
	}
}