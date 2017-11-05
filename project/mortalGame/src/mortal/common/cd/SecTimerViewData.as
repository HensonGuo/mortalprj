package mortal.common.cd
{
	import com.gengine.core.IClean;
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;

	/**
	 * 倒计时的显示数据类 
	 * @author hexiaoming
	 * 
	 */	
	public class SecTimerViewData
	{
		private var _secTimer:SecTimer;
		private var _leftTime:int;
		private var _timerOutCallBack:Function;
		
		public function SecTimerViewData()
		{
		}
		
		private const Second:int = 60;
		private const Minute:int = 60;
		private const Hour:int = 24;
		
		private var _parserList:Array = 
			[
				{fun:dd,str:"dd"},		//含有前导零日期
				{fun:d,str:"d"},		//不含有前导零日期
				{fun:HH,str:"HH"},		//含有前导零总小时数量
				{fun:hh,str:"hh"},		//含有前导零小时
				{fun:h,str:"h"},		//不含有前导零小时
				{fun:mm,str:"mm"},		//含有前导零分钟
				{fun:m,str:"m"},		//不含有前导零分钟
				{fun:sss,str:"sss"},      //直接显示多少秒
				{fun:ss,str:"ss"},		//含有前导零秒钟
				{fun:s,str:"s"} 		//不含有前导零秒钟
				
			];
		
		private function dd():String
		{
			return (getDate()< 10 ? "0" : "") + getDate();
		}
		
		private function d():String
		{
			return getDate().toString();
		}
		
		private function HH():String
		{
			var hours:int = getDate() * 24 + getHours();
			return (hours < 10 ? "0" : "") + hours;
		}
		
		private function hh():String
		{
			return (getHours()< 10 ? "0" : "") + getHours();
		}
		
		private function h():String
		{
			return getHours().toString();
		}
		
		private function mm():String
		{
			return (getMinutes()< 10 ? "0" : "") + getMinutes();
		}
		
		private function m():String
		{
			return getMinutes().toString();
		}
		
		private function sss():String
		{
			return _leftTime.toString();
		}
		
		private function ss():String
		{
			return (getSeconds()< 10 ? "0" : "") + getSeconds();
		}
		
		private function s():String
		{
			return getSeconds().toString();
		}
		
		private function getDate():int
		{
			return Math.floor(_leftTime/(Second * Minute * Hour));
		}
		
		private function getHours():int
		{
			return Math.floor(_leftTime%(Second * Minute * Hour)/(Minute * Second));
		}
		
		private function getMinutes():int
		{
			return Math.floor(_leftTime%(Second * Minute)/Second);
		}
		
		private function getSeconds():int
		{
			return _leftTime%Second;
		}
		
		private function onTimeChange(timer:SecTimer):void
		{
			_leftTime = timer.repeatCount >= 0 ? timer.repeatCount : 0;
			if(_call != null)
			{
				_call.call();
			}
		}
		
		private function onTimerComHandler(timer:SecTimer):void
		{
			if(_timerOutCallBack != null)
			{
				_timerOutCallBack.call();
			}
		}
		
		/**
		 * 获取当前剩余时间 单位为秒 
		 * 
		 */		
		public function get leftTime():int
		{
			return _leftTime;
		}
		
		/**
		 * 在SecTimerCountView中需要用到， 来显示累积时间 
		 * @param value
		 * 
		 */		
		public function tempChangeLeftTime(value:int):void
		{
			_leftTime = value;
		}
		
		public function setLeftTime(value:int,isStart:Boolean = true):void
		{
			_leftTime = value;
			if(_leftTime < 0)
			{
				return;
			}
			if(!_secTimer)
			{
				_secTimer = new SecTimer(1,value);
			}
			else
			{
				_secTimer.reset();
				_secTimer.repeatCount = value;
			}
			if(isStart)
			{
				this.start();
			}
		}
		
		public function parse(str:String):String
		{
			for(var i:int = 0;i<_parserList.length;i++)
			{
				var obj:Object = _parserList[i];
				str = str.replace(obj.str,(obj.fun as Function).call());
			}
			return str;
		}
		
		private var _call:Function;
		public function set caller(call:Function):void
		{
			_call = call;
		}
		
		public function stop():void
		{
			if(_secTimer)
			{
				_secTimer.stop();
			}
		}
		
		public function start():void
		{
			if(_secTimer)
			{
				_secTimer.start();
				_secTimer.addListener(TimerType.ENTERFRAME,onTimeChange);
				_secTimer.addListener(TimerType.COMPLETE,onTimerComHandler);
			}
		}
		
		public function dispose():void
		{
			stop();
			_secTimer.dispose();
			_call = null;
			_timerOutCallBack = null;
		}
		
		public function set timeOutCaller(call:Function):void
		{
			_timerOutCallBack = call;
		}
		
		public function get running():Boolean
		{
			return _secTimer && _secTimer.running;
		}
	}
}