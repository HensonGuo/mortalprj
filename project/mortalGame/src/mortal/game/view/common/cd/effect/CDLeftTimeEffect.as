package mortal.game.view.common.cd.effect
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.TextField;
	
	import mortal.game.view.common.cd.CDData;
	
	
	public class CDLeftTimeEffect extends TextField implements ICDEffect
	{
		private var _cdTime:CDData;
		
		private var _maskBitmap:Bitmap;
		
		private var _currentNumber:Number = 0;
		
		private var _registed:Boolean = false;
		
		public function CDLeftTimeEffect()
		{
			super();
			mouseEnabled = false;
		}
		
		public function set registed(value:Boolean):void
		{
			_registed = value;
		}
		
		public function get registed():Boolean
		{
			return _registed;
		}
		
		public function onTimer( leftSeconds:int ):void
		{
			if(leftSeconds <= 0)
			{
				reset();
				this.dispatchEvent( new Event(Event.COMPLETE));
			}
			else
			{
				if(leftSeconds != _currentNumber)
				{
					if(leftSeconds >= 60)
					{
						text = Math.floor(leftSeconds/60) + "m";
					}
					else
					{
						text = leftSeconds.toString();
					}
					_currentNumber = leftSeconds;
				}
			}
		}
		
		public function get cdEffectTimerType():String
		{
			return CDEffectTimerType.Second;
		}
		
		public function reset():void
		{
			text = "";
		}
	}
}