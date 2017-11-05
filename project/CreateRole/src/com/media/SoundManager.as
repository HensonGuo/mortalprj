/**
 * @date 2011-10-21 下午05:36:30
 * @author  陈炯栩
 * 
 */ 
package com.media
{
	import com.media.core.play.MP3PlayCore;
	import com.media.core.play.MediaPlayCore;
	import com.media.core.play.NetStreamPlayCore;
	import com.media.events.MediaPlayEvent;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SoundManager
	{
		private static var _instance:SoundManager;
		
		/**
		 * 背景音乐
		 * */
		private var _backGroundMusic:MediaPlayCore;
		
		public function SoundManager()
		{
			if(_instance)
			{
				throw new Error("SoundManager 单例！");
			}
		}
		
		public static function get instance():SoundManager
		{
			if(!_instance)
			{
				_instance = new SoundManager();
			}
			return _instance;
		}
		
		/**
		 * 开始播放创号页背景音乐
		 * 
		 */		
		public function startBackgroundMusic(mainPath:String = ""):void
		{
			if(!_backGroundMusic)
			{
				_backGroundMusic = new MP3PlayCore(mainPath + "assets/musics/createRoleSound.mp3",1000,true,250,{onMediaEvent:onMediaEventHandler});
			}
			_backGroundMusic.play();
		}
		
		private var _timer:Timer;
		private function onMediaEventHandler(e:MediaPlayEvent):void
		{
			var type:String = e.type;
			switch (type) 
			{
				case MediaPlayEvent.PLAY_COMPLETE:	//播放完毕事件
					_timer = new Timer(100);
					_timer.addEventListener(TimerEvent.TIMER,onTimerComplete);
					_timer.start();
					break;
			}
		}
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER,onTimerComplete);
			_timer.stop();
			_timer = null;
			
			if(_backGroundMusic)
			{
				try
				{
					_backGroundMusic.play();
				}
				catch(e:Error){}
			}
		}
		
		/**
		 * 停止并销毁创号页背景音乐
		 * 
		 */		
		public function stopBackgroundMusic():void
		{
			if(_backGroundMusic)
			{
				_backGroundMusic.stop();
				_backGroundMusic.dispose();
				_backGroundMusic = null;
			}
		}
	}
}