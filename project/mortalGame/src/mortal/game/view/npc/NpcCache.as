/**
 * 2014-3-3
 * @author chenriji
 **/
package mortal.game.view.npc
{
	import Message.DB.Tables.TTaskShow;
	import Message.Game.SProcess;
	import Message.Game.STaskShowMsg;
	import Message.Public.ETaskProcess;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.net.command.task.TaskDoingRecvCommand;
	import mortal.game.resource.TaskConfig;
	import mortal.game.scene3D.player.entity.NPCPlayer;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.data.TaskRule;
	
	import mx.utils.StringUtil;

	public class NpcCache
	{
		private var _selectedNpc:NPCPlayer;
		private var _shows:Dictionary = new Dictionary(); // 显示、隐藏npc等
		private var _showNpc:Dictionary = new Dictionary();
		private var _hideNpc:Dictionary = new Dictionary();
		private var _showBoss:Dictionary = new Dictionary();
		private var _hideBoss:Dictionary = new Dictionary();
		private var _showCopy:Dictionary = new Dictionary();
		private var _hideCopy:Dictionary = new Dictionary();
		
		public function NpcCache()
		{
		}
		
		public function updateShows(msg:STaskShowMsg):void
		{
			var arr:Array;
			var id:int;
			arr = msg.addIds;
			var info:TTaskShow;
			if(arr != null)
			{
				for(var i:int = 0; i < arr.length; i++)
				{
					id = arr[i];
					info = TaskConfig.instance.getTaskShow(id);
					parseTaskShow(info, true);
				}
			}
			arr = msg.delIds;
			if(arr != null)
			{
				for(i = 0; i < arr.length; i++)
				{
					id = arr[i];
					info = TaskConfig.instance.getTaskShow(id);
					parseTaskShow(info, false);
				}
			}
		}
		
		private function parseTaskShow(info:TTaskShow, isAdd:Boolean):void
		{
			var arr:Array;
			if(info.hideBossList != null && info.hideBossList != "")
			{
				arr = info.hideBossList.split("#");
				addIds(_hideBoss, arr, isAdd);
			}
			
			if(info.showBossList != null && info.showBossList != "")
			{
				arr = info.showBossList.split("#");
				addIds(_showBoss, arr, isAdd);
			}
			
			if(info.hideCopyList != null && info.hideCopyList != "")
			{
				arr = info.hideCopyList.split("#");
				addIds(_hideCopy, arr, isAdd);
			}
			
			if(info.showCopyList != null && info.showCopyList != "")
			{
				arr = info.showCopyList.split("#");
				addIds(_showCopy, arr, isAdd);
			}
			
			if(info.hideNpcList != null && info.hideNpcList != "")
			{
				arr = info.hideNpcList.split("#");
				addIds(_hideNpc, arr, isAdd);
			}
			
			if(info.showNpcList != null && info.showNpcList != "")
			{
				arr = info.showNpcList.split("#");
				addIds(_showNpc, arr, isAdd);
			}
		}
		
		private function addIds(dic:Dictionary, ids:Array, isAdd:Boolean):void
		{
			if(isAdd)
			{
				for(var i:int = 0; i < ids.length; i++)
				{
					var id:int = int(ids[i]);
					dic[id] = id;
				}
			}
			else
			{
				for(i = 0; i < ids.length; i++)
				{
					id = int(ids[i]);
					delete dic[id];
				}
			}
		}
		
		public function getShowNpc():Dictionary
		{
			return _showNpc;
		}
		
		public function getHideNpc():Dictionary
		{
			return _hideNpc;
		}
		
		public function getShowBoss():Dictionary
		{
			return _showBoss;
		}
		
		public function getHideBoss():Dictionary
		{
			return _hideBoss;
		}
		
		public function getShowCopy():Dictionary
		{
			return _showCopy;
		}
		
		public  function getHideCopy():Dictionary
		{
			return _hideCopy;
		}
		
		/**
		 *  当前选中的npcPlayer 
		 */
		public function get selectedNpc():NPCPlayer
		{
			return _selectedNpc;
		}

		/**
		 * @private
		 */
		public function set selectedNpc(value:NPCPlayer):void
		{
			_selectedNpc = value;
		}

		/**
		 * 获取对应NPC的可接任务、进行中任务列表 
		 * @param npcId
		 * @return 
		 * 
		 */		
		public function getTaskListByNpcId(npcId:int):Array
		{
			var arr:Array = Cache.instance.task.taskCanGet;
			var res:Array = [];
			for(var i:int = 0; i < arr.length; i++)
			{
				var info:TaskInfo = arr[i];
				if(info.stask.getNpc == npcId)
				{
					res.push(info);
				}
			}
			arr = Cache.instance.task.taskDoing;
			for(i = 0; i < arr.length; i++)
			{
				info = arr[i];
				// 完成了可提交
				if(info.isComplete())
				{
					if(npcId == info.stask.endNpc)
					{
						res.push(info)
					}
					continue;
				}
				var curStep:int = info.curStep;
				var processes:Dictionary = info.stask.processMap;
				if(processes == null || curStep < 0 || processes[curStep] == null)
				{
					continue;
				}
				var pro:SProcess = processes[curStep][0];
				if(pro == null || 
					(pro.type != ETaskProcess._ETaskProcessDialog 
						&& pro.type != ETaskProcess._ETaskProcessDeliver))
				{
					continue;
				}
				var contents:Array = pro.contents;
				// [编号，类型#npcid,对话id,地图id]			
				var tNpcId:int = contents[0];
				if(tNpcId != npcId)
				{
					continue;
				}
				res.push(info);
			}
			res.sort(TaskRule.sortTask);
			
			return res;
		}
		
		/**
		 * 根据TaskInfo获取当前步骤的对话内容 
		 * @param info
		 * @return 
		 * 
		 */		
		public function getTaskTalk(info:TaskInfo):String
		{
			var dialogId:int = info.stask.getTalkId;
			if(info.isDoing())
			{
				var curStep:int = info.playerTask.currentStep;
				var process:SProcess = info.stask.processMap[curStep][0];
				switch(process.type)
				{
					case ETaskProcess._ETaskProcessDeliver:
						dialogId = process.contents[3];
						break;
					case ETaskProcess._ETaskProcessDialog:
						dialogId = process.contents[1];
						break;
				}
			}
			else if(info.isComplete())
			{
				dialogId = info.stask.endTalkId;
			}
		
			if(dialogId <= 0)
			{
				return "";
			}
			return TaskConfig.instance.getDialog(dialogId).talkStr;
		}
	}
}