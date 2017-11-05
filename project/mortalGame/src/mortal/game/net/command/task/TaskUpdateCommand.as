/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.game.net.command.task
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SPlayerTaskUpdate;
	import Message.Game.SProcess;
	import Message.Game.SSeqPlayerTaskUpdate;
	import Message.Public.ETaskProcess;
	
	import extend.language.Language;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.manager.msgTip.MsgType;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.tableConfig.BossConfig;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.mvc.core.NetDispatcher;
	
	public class TaskUpdateCommand extends BroadCastCall
	{
		public function TaskUpdateCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var tasks:SSeqPlayerTaskUpdate = mb.messageBase as SSeqPlayerTaskUpdate;
			// 提示任务进度
			for each(var newTask:SPlayerTaskUpdate in tasks.updates)
			{
				var info:TaskInfo = Cache.instance.task.getTaskByCode(newTask.taskCode);
				if(info == null || info.playerTask.currentStep != newTask.currentSetp)// 新任务，或则到下一步不提示进度
				{
					continue;
				}
				// 判断当前进程的类型
				var arr:Array = info.stask.processMap[info.curStep];
				for(var i:int = 0; i < arr.length; i++)
				{
					var process:SProcess = arr[i];
					if(process == null)
					{
						continue;
					}
					
					var languageCode:int = -1;
					var targetName:String = "";
					var totalNum:int = 1;
					var curNum:int = newTask.stepRecords[i];
					var oldNum:int = info.playerTask.stepRecords[i];
					if(curNum == oldNum)
					{
						continue;
					}
					switch(process.type)
					{
						case ETaskProcess._ETaskProcessCollect:
							targetName = BossConfig.instance.getInfoByCode(process.contents[0]).name;
							totalNum = process.contents[3];
							languageCode = 20258;
							break;
						case ETaskProcess._ETaskProcessKill:
							targetName = BossConfig.instance.getInfoByCode(process.contents[0]).name;
							totalNum = process.contents[2];
							languageCode = 20257;
							break;
						case ETaskProcess._ETaskProcessDrop:
							targetName = ItemConfig.instance.getConfig(process.contents[1]).htmlName;
							totalNum = process.contents[3];
							languageCode = 20256;
							break;
					}
					if(languageCode > 0)
					{
						MsgManager.addTipText(Language.getStringByParam(languageCode, targetName, curNum, totalNum), 
							MsgHistoryType.TaskMsg);
					}
				}
			}
			Cache.instance.task.updateTask(tasks.updates);
			NetDispatcher.dispatchCmd(ServerCommand.TaskUpdate, tasks.updates);
		}
	}
}