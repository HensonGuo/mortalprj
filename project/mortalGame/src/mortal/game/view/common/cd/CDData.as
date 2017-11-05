package mortal.game.view.common.cd
{
	import com.gengine.core.call.Caller;
	import com.gengine.core.frame.BaseTimer;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	
	import flash.utils.getTimer;
	
	import mortal.game.view.common.cd.effect.CDEffectTimerType;
	import mortal.game.view.common.cd.effect.CDFreezingEffect;
	import mortal.game.view.common.cd.effect.ICDEffect;
	
	
	/**
	 * 设置beginTime，totalTime便可开始使用， beginTime不设置的话是在startCoolDown的时候获取系统当前时间的
	 * 可以添加转圈圈效果、在中间显示倒计时秒数的效果 
	 * @author hdkiller
	 * 
	 */	
	public class CDData implements ICDData
	{
		protected var _isCoolDown:Boolean = false;
		protected var _timer:FrameTimer;
		
		protected var _caller:Caller;
			
		protected var _beginTime:Number = 0;
		protected var _totalTime:Number = 0;
		
		protected var _lastFrame:int = 0;
		protected var _lastSecond:int = 0;
		protected var _lastPercentage:int = 0;
		
		// 临时变量
		protected var _percentage:int;
		protected var _second:int;
		
		public function CDData()
		{
			_caller = new Caller();
			_timer = new FrameTimer(1);
			_timer.addListener(TimerType.ENTERFRAME, onEnterFrameHandler);
		}
		
		public function addEffect(effect:ICDEffect):void
		{
			if(effect.registed)
			{
				return;
			}
			_caller.addCall(effect.cdEffectTimerType, effect.onTimer);
			effect.registed = true;
			if(_isCoolDown)
			{
				resetLastTime();
				onEnterFrameHandler(null);
			}
		}
		
		public function removeEffect(effect:ICDEffect):void
		{
			if(!effect.registed)
			{
				return;
			}
			_caller.removeCall(effect.cdEffectTimerType, effect.onTimer);
			effect.registed = false;
		}
		
		public function addFinishCallback(value:Function):void
		{
			_caller.addCall(CDEffectTimerType.FinishedCallback, value);
			if(_isCoolDown) // 立马刷新显示
			{
				resetLastTime();
				onEnterFrameHandler(null);
			}
		}
		
		public function removeFinishCallback(value:Function):void
		{
			_caller.removeCall(CDEffectTimerType.FinishedCallback, value);
		}
		
		public function addFrameUpdate(value:Function):void
		{
			_caller.addCall(CDEffectTimerType.FrameUpdateCallback, value);
		}
		
		public function removeFrameUpdate(value:Function):void
		{
			_caller.removeCall(CDEffectTimerType.FrameUpdateCallback, value);
		}
		
		public function addStartCallback(value:Function):void
		{
			_caller.addCall(CDEffectTimerType.StartCallback, value);
		}
		
		public function removeStartCallback(value:Function):void
		{
			_caller.removeCall(CDEffectTimerType.StartCallback, value);
		}
		
		public function startCoolDown():void
		{
			if(_isCoolDown) 
			{
				return;
			}
			_isCoolDown = true;
			_usedTime = 0;
			resetLastTime();
			
			if( beginTime == 0 )
			{
				beginTime = getTimer();
			}
			_timer.start();
			_caller.call(CDEffectTimerType.StartCallback);
		}
		
		protected function resetLastTime():void
		{
			_lastFrame = -1;
			_lastSecond = -1;
			_lastPercentage = -1;
		}
		
		public function stopCoolDown():void
		{
			setViewToEnd();
			resetLastTime();
			beginTime = 0;
			_usedTime = 0;
			_isCoolDown = false;
			_timer.stop();
		}
		
		public function get beginTime():Number
		{
			return _beginTime;
		}

		public function set beginTime(value:Number):void
		{
			_beginTime = value;
		}
		
		public function set totalTime(value:Number):void
		{
			_totalTime = value;
		}

		public function get totalTime():Number
		{
			return _totalTime;
		}

		public function get isCoolDown():Boolean
		{
			return _isCoolDown;
		}
		
		public function set isCoolDown(value:Boolean):void
		{
			_isCoolDown = value;
		}
		
		public function get caller():Caller
		{
			return _caller;
		}
		
		public function get leftTime():int
		{
			return _totalTime - _usedTime;
		}
		
		public function get usedTime():int
		{
			return _usedTime;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		protected var _usedTime:int = 0;
		protected function onEnterFrameHandler( event:BaseTimer ):void
		{
			_usedTime = getTimer() - beginTime + 1;
			if(_usedTime > totalTime)
			{
				_timer.stop();
				_timer.reset();
				stopCoolDown();
				_caller.call(CDEffectTimerType.FinishedCallback);
				return;
			}
			callPercentage(_usedTime);
			callFrame(_usedTime);
			callSecond(_usedTime);
			_caller.call(CDEffectTimerType.FrameUpdateCallback);
		}
		
		protected function callPercentage(usedTime:int):void
		{
			_percentage = Math.ceil((usedTime/totalTime*100));
			if(_percentage != _lastPercentage)
			{
				_lastPercentage = _percentage;
				_caller.call(CDEffectTimerType.Percentage, _percentage);
			}
		}
		
		protected function callFrame(usedTime:int):void
		{
			_lastFrame++;
			_caller.call(CDEffectTimerType.Frame, _lastFrame);
		}
		
		protected function callSecond(usedTime:int):void
		{
			_second = Math.ceil((totalTime - usedTime)/1000);
			if(_second != _lastSecond)
			{
				_lastSecond = _second;
				_caller.call(CDEffectTimerType.Second, _second);
			}
			
		}
		
		protected function setViewToEnd():void
		{
			if( _caller )
			{
				_caller.call(CDEffectTimerType.Percentage, 101);
				_caller.call(CDEffectTimerType.Second, 0);
				_caller.call(CDEffectTimerType.Frame, 0);
			}
		}
		
	}
}