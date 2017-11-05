package mortal.game.events
{
	import flash.events.Event;

	public class TimeEvent extends Event
	{
		public static const DateChange:String = "dateChange"; //每天24点时间更新
		public static const ServerOpenDayChange:String = "ServerOpenDayChange"; //开服天数改变
		
		public function TimeEvent( type:String  )
		{
			super(type,false,false);
		}
	}
}