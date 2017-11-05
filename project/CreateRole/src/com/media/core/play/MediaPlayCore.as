package com.media.core.play
{
	import com.media.events.MediaPlayEvent;
	import com.media.interfaces.IMediaPlayCore;
	
	/**
	 * ... 媒体播放核心 ...
	 * 
	 * ************************************** 作者信息 *******************************************
	 * @author: 李振宇
	 * QQ: 39055299
	 * E-mail: cosmos53076@163.com
	 * Webpage: http://hi.baidu.com/cosmos53076
	 * 
	 * ************************************** 功能说明 *******************************************
	 */
	public class MediaPlayCore implements IMediaPlayCore
	{
		/** @private 媒体文件是否处于暂停状态 */
		protected var _paused:Boolean = false;
		
		/** @private 媒体文件是否处于播放状态 */
		protected var _playing:Boolean = false;
		
		/** @private 媒体文件是否处于停止状态 */
		protected var _stopped:Boolean = true;
		
		/** @private 媒体文件路径 */
		protected var _url:String;
		
		/** @private 媒体文件信息 */
		protected var _mediaData:Object;
		
		/** @private 音量控制设置 */
		protected var _volume:Number = 1;
		
		/** @private 静音控制设置 */
		protected var _mute:Boolean = false;
		
		/** @private 缓冲时间控制设置 */
		protected var _bufferTime:Number = 1000;
		
		/** @private 是否处于缓冲状态中 */
		protected var _buffering:Boolean = false;
		
		/** @private 缓冲百分比进度 */
		protected var _bufferPercentage:Number = 0;
		
		/** @private 加载百分比进度 */
		protected var _loadPercentage:Number = 0;
		
		/** @private 当前播放头的时间或位置（以秒为单位） */
		protected var _playheadTime:Number = 0;
		
		/** @private 总播放时间（以秒为单位） */
		protected var _totalTime:Number = 0;
		
		/** @private 回调函数对象 */
		protected var _callback:Object;
		
		/**
		 * 构造函数
		 * @param	url:String 媒体文件路径
		 * @param	bufferTime:Number 媒体文件加载缓冲时间
		 * @param	callback:Object 回调函数对象
		 */
		public function MediaPlayCore(url:String = null, bufferTime:Number = 1000, callback:Object = null)
		{
			_url = url;
			_bufferTime = bufferTime;
			_callback = callback;
		}
		
		/**
		 * **************************************** 魔术方法 *********************************************
		 */
		
		/** 一个布尔值，如果媒体文件处于暂停状态，则为 true。 */
		public function get paused():Boolean { return _paused; }
		
		/** 一个布尔值，如果媒体文件处于播放状态，则为 true。 */
		public function get playing():Boolean { return _playing; }
		
		/** 一个布尔值，如果媒体文件处于停止状态，则为 true。 */
		public function get stopped():Boolean { return _stopped; }
		
		/** 一个字符串，返回媒体文件的URL */
		public function get url():String { return _url; }
		
		/** 一个对象，返回媒体文件信息数据 */
		public function get mediaData():Object { return _mediaData; }
		
		/** 一个数字，介于 0 到 1 的范围内，返回音量控制设置。 */
		public function get volume():Number { return _volume; }
		
		/** 一个数字，介于 0 到 1 的范围内，指示音量控制设置。 */
		public function set volume(value:Number):void 
		{
			_volume = value;
		}
		
		/** 一个布尔值，如果处于静音状态，则为 true。 */
		public function get mute():Boolean { return _mute; }
		
		/** 一个数字，指定开始播放视频流前要在内存中缓冲的秒数。 */
		public function get bufferTime():Number { return _bufferTime; }
		
		/** 一个数字，返回当前的缓冲进度的百分比。 */
		public function get bufferPercentage():Number { return _bufferPercentage; }
		
		/** 一个数字，返回当前的加载进度的百分比。 */
		public function get loadPercentage():Number { return _loadPercentage; }
		
		/** 一个数字，表示当前播放头的时间或位置（以秒为单位计算），可以是小数值。 */
		public function get playheadTime():Number { return _playheadTime; }
		
		/** 一个数字，表示视频的总播放时间（以秒为单位计算）。 */
		public function get totalTime():Number { return _totalTime; }
		
		/** 一个数字，将当前的 playheadTime 指定为 totalTime 属性的百分比。 */
		public function get playheadPercentage():Number { return totalTime == 0?0:(playheadTime / totalTime); }
		
		/** 一个布尔值，获取当前媒体文件是否处于缓冲状态。 */
		public function get buffering():Boolean { return _buffering; }
		
		/**
		 * ***************************************** 虚方法 **********************************************
		 */
		
		/**
		 * 播放
		 */
		public function play():void 
		{
			_playing = true;
			_paused = _stopped = !_playing;
		}
		
		/**
		 * 暂停
		 */
		public function pause():void 
		{
			_paused = true;
			_playing = _stopped = !_paused;
		}
		
		/**
		 * 恢复
		 */
		public function resume():void 
		{
			
		}
		
		/**
		 * 停止
		 */
		public function stop():void 
		{
			_stopped = true;
			_playing = _paused = !_stopped;
		}
		
		/**
		 * 在文件中搜索到给定时间，以秒为单位。
		 * @param	time:Number 一个数字，指定放置播放头的时间，以秒为单位。
		 */
		public function seek(time:Number = 0):void
		{
			
		}
		
		/**
		 * 搜索到文件的某个百分比处并将播放头放置在那里。 该百分比是介于 0 和 1 之间的数值。
		 * @param	percent:Number 一个数字，指定放置播放头的媒体文件长度的百分比。
		 */
		public function seekPercent(percent:Number = 0):void
		{
			
		}
		
		/**
		 * 销毁方法
		 */
		public function dispose():void 
		{
			if(_callback)
			{
				if(_callback.hasOwnProperty("onMediaEvent"))
				{
					_callback.onMediaEvent = null;
				}
				_callback = null;
			}
		}
		
		/**
		 * *************************************** 保护方法 ********************************************
		 */
		
		/**
		 * 回调方法
		 * @param	type 事件类型
		 * @param	text 事件文本
		 */
		protected function callbackFunction(type:String, text:String = null):void
		{
			if(_callback)
				_callback.onMediaEvent?_callback.onMediaEvent(new MediaPlayEvent(type, this, text)):null;
		}
	}

}