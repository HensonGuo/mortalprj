package com.media.core.play
{
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import com.media.events.MediaPlayEvent;
	import com.media.interfaces.IMediaPlayCore;
	
	/**
	 * ... NetStream流文件播放核心 ...
	 * 
	 * ************************************** 作者信息 *******************************************
	 * @author: 李振宇
	 * QQ: 39055299
	 * E-mail: cosmos53076@163.com
	 * Webpage: http://hi.baidu.com/cosmos53076
	 * 
	 * ************************************** 功能说明 *******************************************
	 * 1. 支持的文件格式：FLV、F4V、MP4、M4A、MOV、MP4V、AAC、AA、3GP 和 3G2
	 */
	public class NetStreamPlayCore extends MediaPlayCore implements IMediaPlayCore
	{
		/** @private 远程连接对象 */
		private var _nc:NetConnection;
		
		/** @private 远程数据流 */
		private var _ns:NetStream;
		
		/** @private 计时器 */
		private var _timer:Timer;
		
		/** @private 开始播放标识 */
		private var _startPlay:Boolean = false;
		
		/** @pivate 搜索暂停标识 */
		private var _seekPause:Boolean = false;
		
		/** @pivate 搜索时间 */
		private var _seekTime:Number = 0;
		
		/**
		 * 构造函数
		 * @param	url 数据流路径
		 * @param	bufferTime
		 * @param	checkPolicyFile
		 * @param	updateDelay
		 * @param	callback
		 */
		public function NetStreamPlayCore(url:String = null, bufferTime:Number = 1000, checkPolicyFile:Boolean = false, updateDelay:Number = 250, callback:Object = null)
		{
			super(url, bufferTime, callback);
			_timer = new Timer(updateDelay);
			_timer.addEventListener(TimerEvent.TIMER, playingStateTimerEventHandler);
			_nc = new NetConnection();
			_nc.connect(null);
			_nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
			_ns = new NetStream(_nc);
			_ns.bufferTime = bufferTime / 1000;
			_ns.checkPolicyFile = checkPolicyFile;
			_ns.client = { onMetaData:onMetaDataHandler, onCuePoint:onCuePointHandler };
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
			_ns.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
		}
		
		/**
		 * **************************************** 魔术方法 *********************************************
		 */
		
		/** 设置音量 */
		override public function set volume(value:Number):void 
		{
			super.volume = value;
			if (_ns) {
				var soundTransform:SoundTransform = _ns.soundTransform;
				soundTransform.volume = _mute?0:value;
				_ns.soundTransform = soundTransform;
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
				if (_ns) {
					_timer.start();
					try {
						_ns.play(url);
					} catch (err:SecurityError)
					{
						trace("流播放安全性错误：" + err.message);
					}
					callbackFunction(MediaPlayEvent.OPEN);
				}
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
				_ns.pause();
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
				_seekPause = false;
				super.play();
				_ns.resume();
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
				_ns.pause();
				_timer.stop();
				try {
					_ns.close();
				} catch (err:Error) {
					trace("数据流关闭错误“" + err.message);
				}
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
				_seekTime = time;
				_seekPause = paused;
				_ns.seek(time);
				callbackFunction(MediaPlayEvent.SEEK);
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
			if (_ns != null) {
				_ns.removeEventListener(NetStatusEvent.NET_STATUS, netStatusEventHandler);
				_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
				_ns.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
//				_ns.client = null;
				_ns = null;
			}
			if (_timer != null) {
				_timer.removeEventListener(TimerEvent.TIMER, playingStateTimerEventHandler);
				_timer = null;
			}
			if (_nc != null) {
				_nc.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorEventHandler);
				_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorEventHandler);
				_nc = null;
			}
			super.dispose();
		}
		
		/**
		 * **************************************** 私有方法 *********************************************
		 */
		
		/**
		 * 安全性错误处理事件
		 * @param	e
		 */
		private function securityErrorEventHandler(e:SecurityErrorEvent):void 
		{
			callbackFunction(MediaPlayEvent.ERROR, e.text);
		}
		
		/**
		 * 异步异常错误处理事件
		 * @param	e
		 */
		private function asyncErrorEventHandler(e:AsyncErrorEvent):void 
		{
			callbackFunction(MediaPlayEvent.ERROR, e.text);
		}
		
		/**
		 * IO错误处理事件
		 * @param	e
		 */
		private function ioErrorEventHandler(e:IOErrorEvent):void 
		{
			callbackFunction(MediaPlayEvent.IO_ERROR, e.text);
		}
		
		/**
		 * 网络状态事件处理方法
		 * @param	e
		 */
		private function netStatusEventHandler(e:NetStatusEvent):void 
		{
			var code:String = e.info.code;
			//trace(code);
			switch (code) 
			{
				case "NetStream.Play.Start":
					_startPlay = true;
					callbackFunction(MediaPlayEvent.PLAY);
					break;
					
				case "NetStream.Play.Stop":
					stop();
					callbackFunction(MediaPlayEvent.PLAY_COMPLETE);
					break;
					
				case "NetStream.Buffer.Empty":
				case "NetStream.Seek.Notify":
					_buffering = true;
					break;
					
				case "NetStream.Buffer.Full":
					_buffering = false;
					break;
					
				case "NetStream.Seek.InvalidTime":
					var time:Number = e.info.message.details as Number;	
					seek(time);
					break;
					
				case "NetStream.Play.StreamNotFound":
				case "NetConnection.Connect.Failed":
				case "NetStream.Play.Failed":
				case "NetStream.Play.FileStructureInvalid":
				case "The MP4 doesn't contain any supported tracks":
					callbackFunction(MediaPlayEvent.ERROR, code);
					break;
			}
		}
		
		/**
		 * 接收到描述性信息时事件处理方法
		 * @private
		 * @param	info
		 */
		private function onMetaDataHandler(info:Object):void
		{
			_mediaData = info;
			callbackFunction(MediaPlayEvent.INIT);
			_totalTime = info.duration;
			if (_ns.bufferTime > info.duration) {
				_buffering = _ns.bufferTime = info.duration;
			}
		}
		
		/**
		 * 在到达嵌入点时事件处理方法
		 * @param	info
		 */
		private function onCuePointHandler(info:Object):void
		{
			
		}
		
		/**
		 * 播放过程中事件处理方法
		 * @param	e
		 */
		private function playingStateTimerEventHandler(e:TimerEvent):void 
		{
			var prog:Number = 0;
			//加载进度
			if (_ns.bytesLoaded == _ns.bytesTotal) {
				callbackFunction(MediaPlayEvent.COMPLETE);
			} else {
				_loadPercentage = _ns.bytesLoaded / _ns.bytesTotal;
				callbackFunction(MediaPlayEvent.PROGRESS);
			}
			
			//缓冲
			if (_buffering) {
				prog = _ns.bufferLength / _ns.bufferTime;
				_bufferPercentage = (prog > 1) ? 1 : prog;
				callbackFunction(MediaPlayEvent.BUFFERING);
			} else {
				//播放进度
				if (_startPlay) {
					_playheadTime = _seekPause?_seekTime:_ns.time;
					callbackFunction(MediaPlayEvent.PLAYING);
				}
			}
		}
	}

}