package chat.event
{
	import flash.events.Event;

	public class ChatPanelEvent extends Event
	{
		public static const CloseEvent:String = "CloseEvent";
		
		public function ChatPanelEvent( type:String )
		{
			super(type,true,false);
		}
	}
}