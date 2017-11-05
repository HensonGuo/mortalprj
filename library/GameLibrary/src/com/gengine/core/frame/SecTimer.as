package com.gengine.core.frame
{
	/**
	 * 秒计时器  每秒运行一次
	 * @author jianglang
	 * 
	 */	
	public class SecTimer extends BaseTimer
	{
		/**
		 * 用于reset的保存总次数 
		 */		
		
		public function SecTimer(delay:Number=1,repeatCount:Number=int.MAX_VALUE)
		{
			super(delay,repeatCount);
		}
		
		override public  function start():void
		{
			super.start();
			if( !isTimerQueue )
			{
				isTimerQueue = true;
				FrameManager.timerFrame.addTimer(this);
			}
		}
	}
}