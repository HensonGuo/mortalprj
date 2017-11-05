package com.gengine.keyBoard
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class KeyEvent extends Event
	{
		public static const KEY_DOWN:String = "key_down";
		public static const KEY_UP:String = "key_up";
		
		public var keyEvent:KeyboardEvent;
		private var _keyData:KeyData;
		public function KeyEvent(type:String,$keyData:KeyData,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			_keyData = $keyData;
		}
		
		public function get keyData():KeyData
		{
			return _keyData;
		}
	}
}