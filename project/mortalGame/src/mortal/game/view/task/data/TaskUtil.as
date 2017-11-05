/**
 * 2014-4-16
 * @author chenriji
 **/
package mortal.game.view.task.data
{
	import Message.Game.SProcess;
	import Message.Public.ETaskProcess;

	public class TaskUtil
	{
		public function TaskUtil()
		{
		}
		
		public static function isDramaStep(info:TaskInfo, step:int):Boolean
		{
			var arr:Array = info.stask.processMap[step] as Array;
			if(arr == null)
			{
				return false;
			}
			if(arr[0] == null)
			{
				return false;
			}
			var process:SProcess = arr[0] as SProcess;
			if(process.type == ETaskProcess._ETaskProcessDrama)
			{
				return true;
			}
			return false;
		}
	}
}