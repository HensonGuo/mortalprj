package com.gengine.core.frame
{
	import com.gengine.core.FrameUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * timer 时间计时帧  默认每 1秒一帧
	 * @author jianglang
	 * 
	 */	
	internal class TimerFrame extends Frame
	{
		private var _timer:Timer;
		
		private var _startTimer:int;
		
		private var _delayConst:int = 100;
		
		private var _accruedTime:int;//积累的时间
		
		public function TimerFrame($delay:Number = 1)
		{
			super($delay*1000);
			_timer = new Timer(_delayConst);
		}
		
		override public function play():void
		{
			super.play();
			_timer.addEventListener(TimerEvent.TIMER,onEnterFrameHandler);
			_startTimer = getTimer();
			_accruedTime = 0;
			_timer.start();
		}
		
		override protected function onEnterFrameHandler(event:Event=null):void
		{
			var nt:int = getTimer();
			_accruedTime += nt - _startTimer;
			
			if( _accruedTime >= delay )
			{
				renderer( _accruedTime );
				_accruedTime -= delay;
			}
			_startTimer = getTimer();
			
			//消息时间
			CONFIG::Debug
			{
				FrameUtil.timerProTimer += _startTimer - nt;
			}
		}
		

		override public function stop():void
		{
			super.stop();
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER,onEnterFrameHandler);			
		}
	}
}