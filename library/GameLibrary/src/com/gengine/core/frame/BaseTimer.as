package com.gengine.core.frame
{
	import flash.utils.Dictionary;
	/**
	 * 定时器模板类  继承类有  TimerRenderer FrameRenderer
	 * @author jianglang
	 * 
	 */
	public class BaseTimer implements IBaseTimer
	{
		private var _isTimerQueue:Boolean = false;
		
		private static var _baseID:int = 0; //创建类的唯一标识 ID 的 开始编号
		
		private var _running:Boolean = false;//是否渲染
		
		private var _id:int=0;//对象编号
		
		private var _isDelete:Boolean;//是否删除计时器
		
		private var _delay:Number;//时间间隔
		
		private var _repeatCountCache:Number ;//缓存的重复次数
		private var _repeatCount:Number;//重复次数
		
		public var currentCount:int //当前数量
		
		private var _interval:int;//每帧时间间隔
		
		private var _isRepair:Boolean = false;//是否是补帧

		public function get isRepair():Boolean
		{
			return _isRepair;
		}

		public function set isRepair(value:Boolean):void
		{
			_isRepair = value;
		}

		public function get isTimerQueue():Boolean
		{
			return _isTimerQueue;
		}

		public function set isTimerQueue(value:Boolean):void
		{
			_isTimerQueue = value;
		}

		private var _enterFrameHandler:Function;//每帧触发的方法
		
		private var _completeHandler:Function;//完成时触发的方法
		
		public function BaseTimer($delay:Number,$repeatCount:Number)
		{
			_id = ++_baseID;
			this.delay = $delay;
			this.repeatCount = $repeatCount;
			this._repeatCountCache = $repeatCount;
		}
		
		
		public function set repeatCountCache(value:int):void
		{
			_repeatCountCache = value;
		}
		
		public function get repeatCountCache():int
		{
			return _repeatCountCache;
		}
		
		public function get type():String
		{
			return "";
		}
		
		public function get id():int
		{
			return _id;
		}
		
		/**
		 * type 为 timerType 
		 * @param type
		 * @param callback
		 * 
		 */		
		public function addListener(type:String,callback:Function):void
		{
			if( type == TimerType.COMPLETE )
			{
				_completeHandler = callback;
			}
			else if( type == TimerType.ENTERFRAME )
			{
				_enterFrameHandler = callback;
			}
		}
		
		/**
		 * 每次定时器执行的方法 
		 * @param currentFrame
		 * 
		 */		
		public function renderer(currentFrame:int,isRepair:Boolean = false):void
		{
			currentCount ++;
			repeatCount--;
			_isRepair = isRepair;
			if( _enterFrameHandler is Function)
			{
				_enterFrameHandler(this);
			}
			if(repeatCount <= 0 )
			{
				_isDelete = true;
				isTimerQueue = false;
				if( _completeHandler is Function )
				{
					_completeHandler(this);
				}
			}
			
		}
		
		
		public function get interval():int
		{
			return _interval;
		}
		public function set interval( value:int ):void
		{
			_interval = value;
		}
		
		public function start():void
		{
			_running = true;
			//FrameManager
		}
		
		public function stop():void
		{
			_running = false;
			currentCount = 0;
		}
		
		public function set isDelete(value:Boolean):void
		{
			_isDelete = value;
		}
		public function get isDelete():Boolean
		{
			return _isDelete;
		}

		public function get running():Boolean
		{
			return _running;
		}
		
		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(value:Number):void
		{
			_delay = value;
		}

		public function get repeatCount():Number
		{
			return _repeatCount;
		}

		public function set repeatCount(value:Number):void
		{
			_repeatCount = value;
		}
		
		public function reset():void
		{
			repeatCount = _repeatCountCache; 
			currentCount = 0;
			isDelete = false;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_completeHandler = null;
			_enterFrameHandler = null;
			_isDelete = true;
			_running = false;
			_repeatCount = 0;
			isTimerQueue = false;
			currentCount = 0;
			_isRepair = false;
		}
		
	}
}