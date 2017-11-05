/**
 * @date	2011-3-16 下午09:07:45
 * @author  jianglang
 * 
 * 毫秒
 */	

package com.gengine.core.frame
{
	public class MSecTimer extends BaseTimer
	{
		
		public function MSecTimer(delay:Number=1,repeatCount:Number=int.MAX_VALUE)
		{
			super(delay,repeatCount);
		}
	
		override public  function start():void
		{
			super.start();
			if( !isTimerQueue )
			{
				isTimerQueue = true;
				FrameManager.mTimerFrame.addTimer(this);
			}
		}
	}
}
