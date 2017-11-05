/**
 * @date 2013-9-3 上午11:27:16
 * @author cjx
 */
package com.gengine.core
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.utils.getTimer;

	public class FrameUtil
	{
		
		public static var isOpen:Boolean = true;
		
		private static var _frameStartTime:int;
		
		public static var frameProTimer:int;    //帧定时器处理时间
		public static var timerProTimer:int;    //时间定时器处理时间
		public static var messageProTimer:int;  //消息处理时间
		public static var sortProTimer:int;     //深度排序处理时间
		public static var driveInfo:String=""     //显卡信息
		
		public static const FrameMaxInterval:int = 12;
		
		public function FrameUtil()
		{
		}
		
		public static function set frameStartTime(value:int):void
		{
			_frameStartTime = value;
			_flag = true;
		}
		
		/**
		 * 程序执行时间是否已超时
		 * @return 
		 * 
		 */		
		private static var _flag:Boolean = true;
		private static var _passtimes:int;
		public static function canOperate():Boolean
		{
			if(!isOpen)
			{
				return true;
			}
			if(_flag == false)
			{
				return false;
			}
			
			_flag = (getTimer() - _frameStartTime) < FrameMaxInterval;
			
//			if(_flag == false)
//			{
//				_passtimes += 1;
//				Log.error("跳过："+_passtimes);
//			}
			
			return _flag;
		}
		
	}
}