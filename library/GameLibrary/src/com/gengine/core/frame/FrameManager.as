package com.gengine.core.frame
{
	import com.gengine.global.Global;
	
	import flash.events.Event;

	/**
	 * 所有帧的管理  也有叫心跳 管理
	 * @author jianglang
	 * 
	 */	
	public class FrameManager
	{
		private static var _flashFrame:IFlashFrame;
		private static var _timerFrame:IFrame;
		private static var _mTimerFrame:IFrame;
		
		public function FrameManager()
		{
			
		}
		
		public static function get flashFrame( ):IFlashFrame
		{
			if( _flashFrame == null )
			{
				_flashFrame = new FlashFrame( 24 );
			}
			return _flashFrame;
		}
		
		public static function get timerFrame( ):IFrame
		{
			if( _timerFrame == null )
			{
				_timerFrame = new TimerFrame( );
			}
			return _timerFrame;
		}
		
		public static function get mTimerFrame( ):IFrame
		{
			if( _mTimerFrame == null )
			{
				_mTimerFrame = new MTimerFrame();
			}
			return _mTimerFrame;
		}
		
	}
}