/**
 * @date 2011-3-11 下午02:45:05
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.selectPanel
{
	import flash.display.Sprite;

	public class CallSprite extends Sprite
	{
		protected var _callVector:Vector.<Function>;
		
		public function CallSprite()
		{
			super();
			_callVector = new Vector.<Function>();
		}
		
		public function addCall(fun:Function):void
		{
			_callVector.push(fun);
		}
		
		public function removeCall(fun:Function):void
		{
			if(_callVector.indexOf(fun)>=0)
			{
				_callVector.splice(_callVector.indexOf(fun),1);
			}
		}
		
		public function removeAllCall():void
		{
			_callVector = new Vector.<Function>();
		}
		
		protected function callAll(obj:Object):void
		{
			for each(var fun:Function in _callVector)
			{
				fun.call(null,obj);
			}
		}
	}
}