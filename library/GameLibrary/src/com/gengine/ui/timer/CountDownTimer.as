package com.gengine.ui.timer
{
	public class CountDownTimer
	{
		
		public static const DATE:int = 3600*24;
		public static const HOURS:int = 3600;
		public static const MINUTES:int = 60;
		
		private var _date:int; 	// 日
		private var _hours:int; 	// 小时
		private var _minutes:int; 	// 分钟
		private var _seconds:int; 	//秒
		
		private var _time:int;   //秒
		
		public function CountDownTimer()
		{
			
		}
		
		public function get time():int
		{
			return _time;
		}

		public function set time(value:int):void
		{
			_time = value;
		}
		
		private function parseTimer( time:int ):void
		{
			_date = time / DATE;
			_hours = time / HOURS;
			_minutes = time % MINUTES;
		}
		
	}
}