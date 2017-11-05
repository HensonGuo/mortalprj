package mortal.game.model
{
	import mortal.common.tools.DateParser;
	import mortal.game.manager.ClockManager;

	public class ActiveIconChangeInfo
	{
		public var index:int;
		public var fileName:String;
		public var timeStr:String;
		public var titleStr:String;
		
		public var timeDate:Date;
		
		public function ActiveIconChangeInfo()
		{
		}
		
		/**
		 * 更新 
		 * @param fileName
		 * @param time
		 * @param title
		 * 
		 */
		public function updateData(id:int,file:String,time:String,title:String):void
		{
			index = id;
			fileName = file;
			timeStr = time;
			titleStr = title;
			
			timeDate = DateParser.strToDateNormal(timeStr);
		}
		
		/**
		 * 是否在活动时间 
		 * @return 
		 * 
		 */
		public function inTime():Boolean
		{
			if(timeDate.time <= ClockManager.instance.nowDate.time)//已经过了开始时间
			{
				return true;
			}
			return false;
		}
	}
}