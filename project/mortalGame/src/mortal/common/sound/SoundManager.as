/**
 * @date	2011-4-30 上午11:15:18
 * @author  cjx
 * 
 */	

package mortal.common.sound
{
	import com.gengine.media.core.play.MP3PlayCore;
	import com.gengine.media.core.play.MediaPlayCore;
	import com.gengine.media.core.play.NetStreamPlayCore;
	import com.gengine.media.events.MediaPlayEvent;
	import com.greensock.TweenLite;
	
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mortal.game.resource.MusicsAndSoundsConfig;
	import mortal.game.resource.ResConfig;
	import mortal.game.scene3D.map3D.util.MapFileUtil;

	public class SoundManager
	{
		private static var _instance:SoundManager = null;
		
		/** 音量设置，值为 0 - 1 之间	*/
		private var _musicVolume:Number = 0.5;
		private var _effectSoundVolune:Number = 0.5;
		
		/**
		 * 已加载声音素材
		 * */
		private var _soundLoaded:Dictionary = new Dictionary();
		
		/**
		 * 已加载音效素材
		 */		
		private var _soundEffectLoaded:Dictionary = new Dictionary();
		
		/**
		 * 统计同一个音效同时播放的次数
		 * */
		private var _soundPlaying:Dictionary = new Dictionary();
		
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
		 * 播放背景音乐
		 * 区别于播放一次的声音，背景音乐有且只有一个当前播放
		 * 
		 * @param	mapId 地图ID，根据地图ID播放相应背景音乐
		 * 
		 * */
		public function setBackGroundMusic(mapId:int,sceneName:String=""):void
		{
			var name:String = MusicsAndSoundsConfig.instance.getMusicFileNameByMapId(mapId,sceneName);
			if(_times == -1)
			{
				musicPlay(name);
			}
		}
		
		/**
		 * 播放音乐 
		 * @param name
		 * @param times
		 * 
		 */		
		private var _times:int = -1;
		public function musicPlay(name:String, times:int = -1):void
		{
			if(!Capabilities.hasAudio)
			{
				trace("系统没有音频功能！");
				return;
			}
			
			//trace("切换场景音乐：" + (Game.mapInfo ? Game.mapInfo.mapId : "null") + ":" + (Game.sceneInfo ? Game.sceneInfo.sMapDefine.name : "null") + ";" + mapId + "--" + name);
			_times = times;
			if(name && _soundLoaded[name])
			{
				if(_backGroundMusic && _backGroundMusic.url == (_soundLoaded[name] as MediaPlayCore).url)
				{
					if(_backGroundMusic.stopped)
					{
						fadeStart(_backGroundMusic,musicVolume);
					}
					return;
				}
				else if(_backGroundMusic && !_backGroundMusic.stopped)
				{
					fadeStop(_backGroundMusic);
				}
				
				_backGroundMusic = _soundLoaded[name] as MediaPlayCore;
				if(!_backGroundMusic.stopped)
					_backGroundMusic.stop();
				fadeStart(_backGroundMusic,musicVolume);
			}
			else
			{
				if(_backGroundMusic && !_backGroundMusic.stopped)
				{
					fadeStop(_backGroundMusic);
				}
				
				var sound:MediaPlayCore;
				var type:String = getMediaType(name);
				switch(type)
				{
					case "mp3":
						sound = new MP3PlayCore(getUrlByName(name),1000,false,250,{onMediaEvent:onMediaEventHandler});
						break;
					
					case "flv":
					case "f4v":
					case "mp4":
					case "m4a":
					case "mov":
					case "mp4v":
					case "aac":
					case "aa":
					case "3gp":
					case "3g2":
						sound = new NetStreamPlayCore(getUrlByName(name),1000,true,250,{onMediaEvent:onMediaEventHandler});
						break;
					
					default:
						trace("暂不支持该媒体文件格式或文件格式出错！");
						return;
				}
				fadeStart(sound,musicVolume);
				_backGroundMusic = sound;
				_soundLoaded[name] = sound;
			}
		}
		
		/**
		 * 停止播放背景音乐
		 * 
		 * */
		private function stopBackgroundMusic():void
		{
			if(_backGroundMusic && !_backGroundMusic.stopped)
			{
				//_backGroundMusic.stop();
				fadeStop(_backGroundMusic);
			}
		}
		
		/**
		 * 重新开始播放背景音乐
		 * 
		 * */
		private function startBackgroundMusic():void
		{
			if(_backGroundMusic && _backGroundMusic.stopped)
			{
				fadeStart(_backGroundMusic,musicVolume);
			}
		}
		
		/**
		 * 媒体播放核心事件处理
		 * 循环播放背景音乐
		 * @param	e:MediaPlayEvent MediaPlayEvent事件对象
		 */
		private var _timer:Timer = new Timer(100);
		private function onMediaEventHandler(e:MediaPlayEvent):void
		{
			var type:String = e.type;
			switch (type) 
			{
				case MediaPlayEvent.PLAY_COMPLETE:												//播放完毕事件
					_timer.addEventListener(TimerEvent.TIMER,onTimerComplete);
					_timer.start();
					break;
			}
		}
		private function onTimerComplete(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER,onTimerComplete);
			_timer.stop();
			_timer.reset();
			
			if(_times == -1)
			{
				fadeStart(_backGroundMusic,musicVolume);
			}
			else if(_times > 1)
			{
				_times -= 1;
				fadeStart(_backGroundMusic,musicVolume);
			}
			else
			{
				//需要设置_times = -1
				_times = -1;
				setBackGroundMusic(MapFileUtil.mapID);
			}
		}
		
		/**	获取资源路径	*/
		public function getUrlByName(name:String):String
		{
			if(name)
			{
				var url:String = ResConfig.instance.getUrlByName(name);
				
				var index:int = url.indexOf("?v=");
				if(index != -1)
				{
					url = url.substring(0,index);
				}
				
				return url;
			}
			return "";
		}
		
		/**	根据资源路径获取文件名	*/
		private function getNameByUrl(url:String):String
		{
			if(url)
			{
				var name:String = url.substring(url.lastIndexOf("/")+1);
				
				return name;
			}
			return "";
		}
		
		/**
		 * 音效播放，播放一次
		 * @param	type 音效类型，在SoundTypeConst类里面定义
		 * */
		public function soundPlay(type:String):void
		{
			return;
			if(!Capabilities.hasAudio)
			{
				trace("系统没有音频功能！");
				return;
			}
			
			var name:String = MusicsAndSoundsConfig.instance.getSoundFileNameByType(type);
			
			if( name == null || name == "" || effectSoundVolune == 0) return;
			
			//改用对象池,模仿对象池
			var sound:MediaPlayCore;// = _soundLoaded[name] as MediaPlayCore;
			var soundPool:Array = getSoundPool(name);
			
			if(soundPool.length <= 0)
			{
				type = getMediaType(name);
				switch(type)
				{
					case "mp3":
						sound = new MP3PlayCore(getUrlByName(name),1000,false,250,{onMediaEvent:onMediaPlayerCompleteHandler});
						break;
					case "flv":
					case "f4v":
					case "mp4":
					case "m4a":
					case "mov":
					case "mp4v":
					case "aac":
					case "aa":
					case "3gp":
					case "3g2":
						sound = new NetStreamPlayCore(getUrlByName(name),1000,false,250,{onMediaEvent:onMediaPlayerCompleteHandler});
						break;
					default:
						trace("暂不支持该媒体文件格式！");
						return;
				}
			}
			else
			{
				sound = soundPool.pop() as MediaPlayCore;
			}
			
			//解决一次最多只可以使用32个通道的问题
			try
			{
				sound.volume = effectSoundVolune;
				sound.play();
			}
			catch(e:Error)
			{
				//sound.dispose();
			}
		}
		
		private function onMediaPlayerCompleteHandler(e:MediaPlayEvent):void
		{
			switch( e.type )
			{
				case MediaPlayEvent.PLAY_COMPLETE:									//播放完毕事件
					var name:String = getNameByUrl((e.target as MediaPlayCore).url);
					disposeSound(e.target,name)
					break;
			}
		}
		
		private function getSoundPool(name:String):Array
		{
			var pool:Array = _soundEffectLoaded[name] as Array;
			if(pool)
			{
				return pool;
			}
			else
			{
				_soundEffectLoaded[name] = [];
				return _soundEffectLoaded[name];
			}
		}
		private function disposeSound(obj:*,name:String):void
		{
			var pool:Array = getSoundPool(name);
			pool.push(obj);
		}
		
		
		/**
		 * 获取媒体文件类型
		 * @param	url 媒体文件路径
		 * @return  返回媒体文件格式后缀名
		 */
		private function getMediaType(url:String = null):String
		{
			if(url)
			{
				var strArr:Array = url.split(".");
				var len:int = strArr.length;
				var suffix:String = strArr[len - 1];
				return suffix.toLowerCase();
			}
			return "";
		}
		
		/**
		 * 声音渐变
		 * @param sound
		 * @param volume 声音渐变到此值
		 * */
		private var _fadingStart:Boolean = false;
		private function fadeStart(sound:MediaPlayCore,volume:Number):void
		{
			try
			{
				sound.volume = 0;
				sound.play();
				
				_fadingStart = true;
				TweenLite.to(sound,3,{volume:volume,onComplete:onStartCompleteHandler});
			}
			catch(e:Error)
			{
				
			}
		}
		private function onStartCompleteHandler():void
		{
			_fadingStart = false;
		}
		
		private var _fadingStop:Boolean = false;
		private function fadeStop(sound:MediaPlayCore):void
		{
			_fadingStop = true;
			TweenLite.to(sound,2,{volume:0,onComplete:onStopCompleteHandler});
			
			function onStopCompleteHandler():void
			{
				if(!sound.stopped)
				{
					sound.stop();
				}
				_fadingStop = false;
			}
		}
		

		public function get musicVolume():Number
		{
			return _musicVolume;
		}

		/**
		 * @param value 音量， 0 - 1 之间
		 */
		public function set musicVolume(value:Number):void
		{
			_musicVolume = value;
			if(_backGroundMusic)
			{
				if(_fadingStart)
				{
					TweenLite.killTweensOf(_backGroundMusic);
				}
				_backGroundMusic.volume = value;
			}
		}

		public function get effectSoundVolune():Number
		{
			return _effectSoundVolune;
		}

		/**
		 * @param value 音量， 0 - 1 之间
		 */
		public function set effectSoundVolune(value:Number):void
		{
			_effectSoundVolune = value;
		}

		/**
		 * 背景音乐
		 * */
		public function get backGroundMusic():MediaPlayCore
		{
			return _backGroundMusic;
		}

		/**
		 * @private
		 */
		public function set backGroundMusic(value:MediaPlayCore):void
		{
			_backGroundMusic = value;
		}


	}
}