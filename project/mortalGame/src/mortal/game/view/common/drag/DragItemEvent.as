package mortal.game.view.common.drag
{
	import flash.events.Event;
	
	public class DragItemEvent extends Event
	{
		public static const StartDrag:String = "startDrag";
		public static const DragPositionChange:String = "dragPosition";
		
		private var _changeX:Number;
		private var _changeY:Number;
		
		public function DragItemEvent(type:String,changeX:Number = 0,changeY:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_changeX = changeX;
			_changeY = changeY;
			super(type, bubbles, cancelable);
		}

		public function get changeX():Number
		{
			return _changeX;
		}

		public function set changeX(value:Number):void
		{
			_changeX = value;
		}

		public function get changeY():Number
		{
			return _changeY;
		}

		public function set changeY(value:Number):void
		{
			_changeY = value;
		}
	}
}