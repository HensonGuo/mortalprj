package mortal.game.manager.mouse
{
	import com.gengine.core.call.Caller;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	public class MouseThreeClickRule implements IMouseRule
	{
		private var _target:InteractiveObject;
		
		private var _caller:Caller;
		
		private const callType:String = "MouseThreeClickCall";
		
		private const judgeTime:int = 1000;
		
		private var _downArray:Array = [];
		
		public function MouseThreeClickRule()
		{
			_caller = new Caller();
		}
		
		public function addCall(callBack:Function):void
		{
			_caller.addCall(callType,callBack);
		}

		public function startRule():void
		{
			if(!_target)
			{
				return;
			}
			_target.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}

		private function onMouseDown(e:MouseEvent):void
		{
			var nowDate:Date = new Date();
			_downArray.push(nowDate);
			
			if(_downArray.length > 3)
			{
				_downArray.shift();
			}
			
			if(_downArray.length == 3)
			{
				var lastDate:Date = _downArray[2] as Date;
				var firstDate:Date = _downArray[0] as Date;
				
				if(lastDate.time - firstDate.time < 1000)
				{
					_caller.call(callType);
					_downArray = [];
				}
			}
		}
		
		public function endRule():void
		{
			_target.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			_downArray = [];
			_target = null;
		}
		
		public function set target(obj:InteractiveObject):void
		{
			_target = obj;
		}
	}
}