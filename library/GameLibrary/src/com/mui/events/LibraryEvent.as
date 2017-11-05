
package com.mui.events
{
	
	import flash.events.Event;

	public class LibraryEvent extends Event
	{
		private var _data:Object;
		public static var EMBED_COMPLETE		: String = "embedComplete";
		public static var LOAD_COMPLETE			: String = "loadComplete";
		public static var SINGLELOAD_COMPLETE	: String = "singleLoadComplete";
		
		public function LibraryEvent( type:String, paramData:Object = null,bubbles:Boolean=false, cancelable:Boolean=false )
		{
			_data = paramData;
			super( type,bubbles,cancelable );
		}
		
		public override function clone():Event
		{
			return new LibraryEvent( type,_data, bubbles, cancelable );
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
	
}