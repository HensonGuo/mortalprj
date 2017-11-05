package com.gengine.media.events
{
	import flash.events.Event;
	
	/**
	 * ... 媒体播放事件 ...
	 * @author Jerry Lee
	 */
	public class MediaPlayEvent extends Event
	{
		/** 当媒体加载遇到IO错误时触发 */
		public static const IO_ERROR:String = "ioError";
		
		/** 当媒体播放核心遇到错误时触发 */
		public static const ERROR:String = "error";
		
		/** 当媒体开始加载时触发 */
		public static const OPEN:String = "open";
		
		/** 当媒体加载过程时触发 */
		public static const PROGRESS:String = "progress";
		
		/** 当媒体加载完成时触发 */
		public static const COMPLETE:String = "complete";
		
		/** 当媒体获取到信息时触发 */
		public static const INIT:String = "init";
		
		/** 当媒体开始播放时触发 */
		public static const PLAY:String = "play";
		
		/** 当媒体开始搜索进度时触发 */
		public static const SEEK:String = "seek";
		
		/** 当媒体暂停时触发 */
		public static const PAUSE:String = "pause";
		
		/** 当媒体恢复播放时触发 */
		public static const RESUME:String = "resume";
		
		/** 当媒体停止时触发 */
		public static const STOP:String = "stop";
		
		/** 当媒体缓冲时触发 */
		public static const BUFFERING:String = "buffering";
		
		/** 当媒体播放中时触发 */
		public static const PLAYING:String = "playing";
		
		/** 当媒体播放完成时触发 */
		public static const PLAY_COMPLETE:String = "playComplete";
		
		/** 事件文本对象 */
		public var text:String;
		
		/** @private 事件对象 */
		protected var _target:Object;
		
		/** @private **/
//		protected var _ready:Boolean;
		
		public function MediaPlayEvent(type:String, target:Object, text:String)
		{
			super(type, false, false);
			_target = target;
			this.text = text;
		}
		
		/** @inheritDoc **/
		override public function clone():Event{
			return new MediaPlayEvent(this.type, _target, text);
		}
		
		/**
		 * 重写获取对象方法
		 */
		override public function get target():Object {
//			if (_ready) {
				return _target;
//			} else {
//				_ready = true;
//			}
//			return null;
		}
		
		/**
		 * 设置对象方法
		 */
		public function set target(value:Object):void 
		{
			_target = value;
		}
	}

}