package Engine.flash
{
	import flash.events.EventDispatcher;
	
	public class EventSender extends EventDispatcher
	{
		protected var sender:EventDispatcher = ServerSender.instance;
		public function EventSender()
		{
			super();
		}
	}
}