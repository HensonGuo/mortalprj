package mortal.game.events
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public var isResult:Boolean = false;
		public var data:Object;
		public function DataEvent(type:String, data:Object = null,result:Boolean = false, bubbles:Boolean = false,cancelable:Boolean = false)
		{
			this.data = data;
			this.isResult = result;
			super(type,bubbles,cancelable);
		}
	}
}