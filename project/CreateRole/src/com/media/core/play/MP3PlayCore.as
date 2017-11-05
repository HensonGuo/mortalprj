package com.media.core.play
{
	import com.media.core.play.MediaPlayCore;
	import com.media.events.MediaPlayEvent;
	import com.media.interfaces.IMediaPlayCore;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ... MP3文件播放核心 ...
	 * 
	 * ************************************** 作者信息 *******************************************
	 * @author: 李振宇
	 * QQ: 39055299
	 * E-mail: cosmos53076@163.com
	 * Webpage: http://hi.baidu.com/cosmos53076
	 * 
	 * ************************************** 功能说明 *******************************************
	 * 播放、暂停、恢复、停止、进度搜索、进度百分比搜索
	 */
	public class MP3PlayCore extends MediaPlayCore implements IMediaPlayCore
	{
		/** @private 声音对象 */
		private var _sound:Sound;
		
		/** @private 声音对象 */
		private var _context:SoundLoaderContext;
		
		/** @private 声道对象 */
		private var _soundChanel:SoundChannel;
		
		/** @private 计时器对象 */
		private var _timer:Timer;
		
		/** @private 暂停位置所在时间，以毫秒为单位 */
		private var _pauseTime:Number = 0;
		
		/** @private 一个布尔值，媒体播放是否开始 */
		private var _isPlayStart:Boolean = false;
		
		/**
		 * 构造函数
		 * @param	url 媒体文件地址
		 * @param	bufferTime 缓冲时间
		 * @param	checkPolicyFile 策略文件加载标识
		 * @param	updateDelay 计时器的时间量，以毫秒为单位
		 * @param	callback 回调函数对象
		 */
		public function MP3PlayCore(url:String = null, bufferTime:Number = 1000, checkPolicyFile:Boolean = false, updateDelay:Number = 250, callback:Object = null)
		{
			super(url, bufferTime, callback);
			_timer = new Timer(updateDelay);
			_timer.addEventListener(TimerEvent.TIMER, playingStateTimerEventHandler);
			_context = new SoundLoaderContext(bufferTime, checkPolicyFile);
			_sound = new Sound();
			_sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
			_sound.addEventListener(Event.OPEN, openEventHandler);
			_sound.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
			_sound.addEventListener(Event.COMPLETE, completeEventHandler);
			_sound.addEventListener(Event.ID3, id3DataEventHandler);
			try {
				_sound.load(new URLRequest(url), _context);
			} catch (err:IOError) {
				trace("流加载IO错误：" + err.message);
			} catch (err:SecurityError) {
				trace("流加载安全性错误：" + err.message);
			}
		}
		
		/**
		 * **************************************** 魔术方法 *********************************************
		 */
		
		/** 设置音量 */
		override public function set volume(value:Number):void 
		{
			super.volume = value;
			if (_soundChanel) {
				var soundTransform:SoundTransform = _soundChanel.soundTransform;
				soundTransform.volume = _mute?0:value;
				_soundChanel.soundTransform = soundTransform;
			}
		}
		
		/**
		 * **************************************** 公共方法 *********************************************
		 */
		
		/**
		 * 重写播放方法
		 */
		override public function play():void 
		{
			if (!playing) {
				super.play();
				soundPlayAction();
			}
			else 
			{
				trace("声音正处于播放状态，无法重复进行播放动作！");
			}
		}
		
		/**
		 * 重写暂停方法
		 */
		override public function pause():void 
		{
			if (playing) {
				super.pause();
				soundStopAction();
				callbackFunction(MediaPlayEvent.PAUSE);
			}
			else {
				trace("声音正处于非播放状态，无法进行暂停播放动作！");
			}
		}
		
		/**
		 * 重写恢复方法
		 */
		override public function resume():void 
		{
			if (paused) {
				super.play();
				soundPlayAction(_pauseTime);
				callbackFunction(MediaPlayEvent.RESUME);
			}
			else {
				trace("声音正处于非暂停状态，无法进行暂停播放动作！");
			}
		}
		
		/**
		 * 重写停止方法
		 */
		override public function stop():void 
		{
			if (!stopped) {
				super.stop();
				soundStopAction(true);
				callbackFunction(MediaPlayEvent.STOP);
			}
			else {
				trace("声音正处于停止状态，无法重复进行停止播放动作！");
			}
		}
		
		/**
		 * 重写播放进度搜索方法
		 * @param	time:Number 播放时间（以秒为单位）
		 */
		override public function seek(time:Number = 0):void
		{
			if (!stopped) {
				time < 0?time = 0:null;
				time >= _totalTime?(time = _totalTime-0.001):null;
				var playingState:Boolean = playing;
				playingState?pause():null;
				_pauseTime = time * 1000;
				callbackFunction(MediaPlayEvent.SEEK);
				playingState?resume():null;
			}
			else {
				trace("声音正处于停止状态，无法进行播放进度搜索动作！");
			}
		}
		
		/**
		 * 重写播放进度百分比搜索方法
		 * @param	percent:Number 播放进度百分比，该百分比是介于 0 和 1 之间的数值。
		 */
		override public function seekPercent(percent:Number = 0):void
		{
			var time:Number = percent * _totalTime;
			seek(time);
		}
		
		/**
		 * 重写销毁方法
		 */
		override public function dispose():void 
		{
			if (_sound != null) {
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
				_sound.removeEventListener(Event.OPEN, openEventHandler);
				_sound.removeEventListener(ProgressEvent.PROGRESS, progressEventHandler);
				_sound.removeEventListener(Event.COMPLETE, completeEventHandler);
				_sound.removeEventListener(Event.ID3, id3DataEventHandler);
				_sound = null;
			}
			if (_timer != null) {
				_timer.removeEventListener(TimerEvent.TIMER, playingStateTimerEventHandler);
				_timer.stop();
				_timer = null;
			}
			if (_soundChanel != null) {
				_soundChanel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteEventHandler);
				_soundChanel = null;
			}
			super.dispose();
		}
		
		/**
		 * **************************************** 私有方法 *********************************************
		 */
		
		/**
		 * 声道播放操作
		 * @param	position:Number = 0 播放位置
		 */
		private function soundPlayAction(position:Number = 0):void
		{
			if(!_sound || !_timer)
			{
				return;
			}
			
			_timer.start();
			_soundChanel = _sound.play(position);
			_soundChanel ? _soundChanel.addEventListener(Event.SOUND_COMPLETE, soundCompleteEventHandler) : null;
			volume = _volume;
		}
		
		/**
		 * 声道停止播放操作
		 * @param	close 是否关闭流标识
		 */
		private function soundStopAction(close:Boolean = false):void
		{
			if(!_timer || !_soundChanel || !_sound)
			{
				return;
			}
			
			_timer.stop();
			_soundChanel.stop();
			_soundChanel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteEventHandler);
			if (close) {
				_pauseTime = 0;
				try {
					_sound.close();
				} catch (err:IOError) {
					//trace("关闭流错误：" + err.message);
				}
			} else {
				_pauseTime = _soundChanel.position;
			}
			_soundChanel = null;
		}
		
		/**
		 * IO错误事件处理方法
		 * @param	e
		 */
		private function ioErrorEventHandler(e:IOErrorEvent):void 
		{
			callbackFunction(MediaPlayEvent.IO_ERROR, e.text);
		}
		
		/**
		 * 开始加载事件处理方法
		 * @param	e
		 */
		private function openEventHandler(e:Event):void 
		{
			if(!_context)
			{
				return;
			}
			
			var total:Number = _totalTime * 1000;
			_context.bufferTime > total?_context.bufferTime = total:null;
			callbackFunction(MediaPlayEvent.OPEN);
		}
		
		/**
		 * 加载过程中事件处理方法
		 * @param	e
		 */
		private function progressEventHandler(e:ProgressEvent):void 
		{
			_loadPercentage = e.bytesLoaded / e.bytesTotal;
			callbackFunction(MediaPlayEvent.PROGRESS);
		}
		
		/**
		 * 加载完成事件处理方法
		 * @param	e
		 */
		private function completeEventHandler(e:Event):void 
		{
			callbackFunction(MediaPlayEvent.COMPLETE);
		}
		
		/**
		 * 获取到ID3数据事件处理方法
		 * @param	e
		 */
		private function id3DataEventHandler(e:Event):void 
		{
			if(!_sound || !_sound.id3)
			{
				return;
			}
			
			_mediaData = _sound.id3;
			_mediaData.type = "mp3";
			callbackFunction(MediaPlayEvent.INIT);
		}
		
		/**
		 * 播放状态中事件处理方法
		 * @param	e
		 */
		private function playingStateTimerEventHandler(e:TimerEvent):void 
		{
			if(!_sound || !_soundChanel)
			{
				return;
			}
			
			_buffering = _sound.isBuffering;													//设置缓冲标识
			_playheadTime = _soundChanel.position / 1000;										//设置播放头位置
			_totalTime = _sound.bytesTotal / (_sound.bytesLoaded / _sound.length) / 1000;		//设置播放总长度
			if (_buffering) {
				_bufferPercentage = _sound.length / (_soundChanel.position + _bufferTime);
				_bufferPercentage < 0?_bufferPercentage = 0:null;
				callbackFunction(MediaPlayEvent.BUFFERING);
			}
			else {
				if (!_isPlayStart && _playheadTime > 0) {
					_isPlayStart = true;
					callbackFunction(MediaPlayEvent.PLAY);
				}
				callbackFunction(MediaPlayEvent.PLAYING);
			}
		}
		
		/**
		 * 声音播放完毕事件处理方法
		 * @param	e
		 */
		private function soundCompleteEventHandler(e:Event):void 
		{
			stop();
			callbackFunction(MediaPlayEvent.PLAY_COMPLETE);
		}
	}
	
}