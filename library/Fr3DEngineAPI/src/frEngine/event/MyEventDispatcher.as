package frEngine.event
{
	import flash.events.EventDispatcher;

	public class MyEventDispatcher extends EventDispatcher
	{
		public static const instance:MyEventDispatcher=new MyEventDispatcher();
		public function MyEventDispatcher()
		{
			super();
		}
	}
}