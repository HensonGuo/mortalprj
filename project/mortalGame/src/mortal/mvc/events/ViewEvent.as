package mortal.mvc.events
{
	import flash.events.Event;

	public class ViewEvent extends Event
	{
		public static const Hide:String = "viewHide";
		public static const Show:String = "viewShow";
		
		public function ViewEvent( type:String,bubbles:Boolean=false,cancelable:Boolean=false )
		{
			super(type,bubbles,cancelable);
		}
	}
}