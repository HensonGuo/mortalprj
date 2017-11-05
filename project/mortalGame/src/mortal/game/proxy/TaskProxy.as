/**
 * 2014-3-3
 * @author chenriji
 **/
package mortal.game.proxy
{
	import Message.Game.AMI_ITask_cancelTask;
	import Message.Game.AMI_ITask_digTreasure;
	import Message.Game.AMI_ITask_dramaStep;
	import Message.Game.AMI_ITask_endTask;
	import Message.Game.AMI_ITask_explore;
	import Message.Game.AMI_ITask_getTask;
	import Message.Game.AMI_ITask_quickCompleteTask;
	import Message.Game.AMI_ITask_talkToNpc;
	import Message.Game.SPlayerTask;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.rmi.GameRMI;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;

	public class TaskProxy extends Proxy
	{
		public function TaskProxy()
		{
		}
		
		/**
		 * 领取任务 
		 * @param npcId
		 * @param taskId
		 * @param choose
		 * 
		 */		
		public function getTask(npcId:int, taskId:int, choose:int=0):void
		{
			GameRMI.instance.iTask.getTask_async(new AMI_ITask_getTask(getTaskSucess, null, taskId), npcId, taskId, choose);
		}
		private function getTaskSucess(obj:AMI_ITask_getTask):void
		{
			NetDispatcher.dispatchCmd(ServerCommand.TaskGetSucess, obj.userObject);
		}
		
		/**
		 * 跟Npc对话完成 
		 * @param npcId
		 * @param taskId
		 * @param choose
		 * 
		 */		
		public function talkToNpc(npcId:int, taskId:int, choose:int=0):void
		{
			GameRMI.instance.iTask.talkToNpc_async(new AMI_ITask_talkToNpc(), taskId, npcId, choose);
		}
		
		/**
		 * 提交任务 
		 * @param npcId
		 * @param taskId
		 * @param choose
		 * 
		 */		
		public function endTask(npcId:int, taskId:int, choose:int=0):void
		{
			GameRMI.instance.iTask.endTask_async(new AMI_ITask_endTask(), npcId, taskId, choose);
		}
		
		/**
		 * 放弃任务 
		 * @param taskId
		 * 
		 */		
		public function cancelTask(taskId:int):void
		{
			GameRMI.instance.iTask.cancelTask_async(new AMI_ITask_cancelTask(), taskId); 
		}
		
		/**
		 * 挖宝任务 
		 * 
		 */		
		public function digTreasure():void
		{
			GameRMI.instance.iTask.digTreasure_async(new AMI_ITask_digTreasure());
		}
		
		/**
		 * 刺探任务 
		 * 
		 */		
		public function explore():void
		{
			GameRMI.instance.iTask.explore_async(new AMI_ITask_explore());
		}
		
		/**
		 * 快速完成任务 
		 * @param taskId
		 * 
		 */		
		public function quickComplete(taskId:int):void
		{
			GameRMI.instance.iTask.quickCompleteTask_async(new AMI_ITask_quickCompleteTask(), taskId);
		}
		
		/**
		 * 下一步剧情 
		 * @param step
		 * 
		 */		
		public function finishDramaStep(step:int):void
		{
			GameRMI.instance.iTask.dramaStep_async(new AMI_ITask_dramaStep(), step);
		}
	}
}