package com.mui.events
{
	import flash.events.Event;
	
	public class MuiEvent extends Event
	{
		public static const GTABBAR_SELECTED_CHANGE:String = "GTabBarSelectedChange";
		public static const GLOADEDBUTTON_STYLE_COMPLETE:String = "GLoadedButton_style_complete";
		
		public var selectedIndex:int;
		
		public function MuiEvent(type:String, selectedIndex:int = -1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.selectedIndex = selectedIndex;
		}
	}
}