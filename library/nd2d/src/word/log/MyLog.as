package word.log
{
	import flash.display.Sprite;


	public class MyLog
	{
		private static var logInfo:String="";
		public static var alertLogInfoEnabled:Boolean=false;
		private static var logView:*//MyLogViewer=new MyLogViewer();
		public static function clearLog(alertInfoEnabled:Boolean=true):void
		{
			logInfo="";
		}
		public static function hasLogInfo():Boolean
		{
			return logInfo.length>0;
		}
		public static function logE(info:String):void
		{
			logInfo+="time:"+getLogTime()+" --> "+info+"\n\n";
			if(alertLogInfoEnabled)
			{
				logView.textAreaText=logInfo;
				logView.show();
			}else
			{
				trace("mylog:"+info);
			}
		}
		public static function show(title:String=null,flags:int=4,parent:Sprite=null):void
		{
			logView.textAreaText=logInfo;
			logView.show();
			
		}
		public static function getLogTime():String
		{
			var date:Date=new Date();
			return ""+date.hours+":"+date.minutes+":"+date.seconds;
		}
	}
}