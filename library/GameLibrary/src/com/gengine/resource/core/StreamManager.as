/**
 * @heartspeak
 * 2013-12-30 
 */   	

package com.gengine.resource.core
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;

	public class StreamManager
	{
		
		//单帧 加载byteArray的最大数量   为了避免单帧过卡
		public static var frameLoadByteArrayNum:int = 1;
		public static var frameLoadedNum:int = 0;
		
		public static var streamLoaderVect:Vector.<StreamLoader> = new Vector.<StreamLoader>();
		
		public static var timer:FrameTimer;
		
		public static var _isStart:Boolean = false;
		
		public static function init():void
		{
			if(!_isStart)
			{
				timer = new FrameTimer(1,int.MAX_VALUE,true);
				timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
				timer.start();
				_isStart = true;
			}
		}
		
		private static function onEnterFrame(time:FrameTimer):void
		{
			frameLoadedNum = 0;
			//处理分帧
			frameLoadByteArrayNum = Math.max(streamLoaderVect.length/10,1);
			while(streamLoaderVect.length > 0 && frameLoadedNum < frameLoadByteArrayNum)
			{
				frameLoadedNum ++;
				var streamLoader:StreamLoader = streamLoaderVect[0];
				loadStream(streamLoader);
				removeOut(streamLoader);
			}
		}
		
		private static function loadStream(streamLoader:StreamLoader):void
		{
			streamLoader.loadByteArray();
		}
		
		private static function removeOut(streamLoader:StreamLoader):void
		{
			var index:int = streamLoaderVect.indexOf(streamLoader);
			if(index >= 0)
			{
				streamLoaderVect.splice(index,1);
			}
		}
		
		public static function pushIn(streamLoader:StreamLoader):void
		{
			if(!_isStart)
			{
				loadStream(streamLoader);
			}
			else if(frameLoadedNum < frameLoadByteArrayNum)
			{
				loadStream(streamLoader);
				frameLoadedNum++;
			}
			else
			{
				streamLoaderVect.push(streamLoader);
			}
		}
	}
}