package com.gengine.core.frame
{
	/**
	 * frame 计时器  每帧运行一次
	 * @author jianglang
	 * 
	 */	
	public class FrameTimer extends BaseTimer
	{
		private var _isFrame60:Boolean = false;
		public function FrameTimer(delay:Number=1,repeatCount:Number=int.MAX_VALUE,isFrame60:Boolean = false)
		{
			_isFrame60 = isFrame60;
			super(delay,repeatCount);
		}
		
		override public  function start():void
		{
			super.start();
			if( !isTimerQueue )
			{
				isTimerQueue = true;
				
				if(!_isFrame60)
				{
					//30帧定时器
					FrameManager.flashFrame.addTimer(this);
				}
				else
				{
					//60帧定时器
					FrameManager.flashFrame.addTimer60(this);
				}
			}
		}
	}
}