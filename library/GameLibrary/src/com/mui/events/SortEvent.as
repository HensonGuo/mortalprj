package com.mui.events
{
	import flash.events.Event;
	
	public class SortEvent extends Event
	{
		public static const DESCENDING:String = "DESCENDING";//降序
		public static const ASCENDING:String = "ASCENDING";//升序
		
		public function SortEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new SortEvent( type, bubbles, cancelable );
		}
	}
}