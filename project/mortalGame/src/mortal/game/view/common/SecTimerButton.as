/**
 * @date 2013-6-9 下午01:10:41
 * @author chenriji
 */
package mortal.game.view.common
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.mui.controls.GButton;
	
	/**
	 * 倒计时按钮 
	 * @author Administrator
	 * 
	 */	
	public class SecTimerButton extends GButton
	{
		private var _secTimer:SecTimer;
		private var _callback:Function;
		private var _labelStr:String;
		public function SecTimerButton()
		{
			super();
		}
		
		public override function set label(arg0:String):void
		{
			super.label = arg0;
			_labelStr = arg0;
		}
		
		public function startCountdown(seconds:int, timeOut:Function=null, isStart:Boolean=true):void
		{
			if(_secTimer == null)
			{
				_secTimer = new SecTimer();
				_secTimer.addListener(TimerType.COMPLETE, onTimerCompleteHandler);
				_secTimer.addListener(TimerType.ENTERFRAME, onEnterFrameHandler);
			}
			else
			{
				_secTimer.reset();
			}
			_secTimer.repeatCount = seconds;
			if(isStart)
			{
				_secTimer.start();
			}
		}
		
		public function reset():void
		{
			if(_secTimer)
			{
				_secTimer.reset();
				_secTimer.repeatCount = 0;
			}
			if(_labelStr != null)
			{
				super.label = _labelStr;
			}
		}
		
		public function stop():void
		{
			if(_secTimer)
			{
				return _secTimer.stop();
			}
			
			if(_labelStr != null)
			{
				super.label = _labelStr;
			}
		}
		
		public function get running():Boolean
		{
			if(_secTimer)
			{
				return _secTimer.running;
			}
			return false;
		}
		
		public function set timeOutHandler(callback:Function):void
		{
			_callback = callback;
		}
		
		private function onTimerCompleteHandler(timer:SecTimer):void
		{
			if(_callback != null)
			{
				_callback.apply();
			}
			stop();
		}
		
		private function onEnterFrameHandler(timer:SecTimer):void
		{
			super.label = _labelStr + "(" + timer.repeatCount + ")";
			if(timer.repeatCount <= 0 && _labelStr != null)
			{
				super.label = _labelStr;
			}
		}
	}
}