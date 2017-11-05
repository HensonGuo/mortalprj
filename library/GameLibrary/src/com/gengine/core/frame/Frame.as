package com.gengine.core.frame
{
	import com.gengine.FConfig;
	import com.gengine.debug.Log;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.osmf.utils.Version;
	
	/**
	 * 帧基类 模板 不能直接实例化 
	 * @author jianglang
	 * 
	 */	
	public class Frame implements IFrame
	{
	
		protected var _count:int;
		
		private var _frameSortMap:Dictionary;//保存大于一帧的队列
		
		private var _frameCount:int=0; //帧频数
		
		protected var _isPlay:Boolean;
		
		protected var delay:Number;
		
		private var _lastFrameCount : int = -1; 
		private var _lastAry : Vector.<IBaseTimer>;
		
		private var _oneFrameMap:Dictionary; //保存一帧的队列		
		public function Frame(delay:Number)
		{
			_frameSortMap = new Dictionary(true);
			_isPlay = false;
			this.delay = delay;	
			_oneFrameMap = new Dictionary();
		}
		
		public function dispatchEvent():void
		{
			
		}
		
		public function play():void
		{
			_isPlay = true;
		}
		
		public function stop():void
		{
			_isPlay = false;
		}
		
		/**
		 * 添加帧 
		 * @param value
		 * 
		 */		
		public function addTimer( value:IBaseTimer ):void
		{
			if( !_isPlay )
			{
				play();
			}
			if( value.delay == 1 )
			{
				_oneFrameMap[value.id] = value;
			}
			else
			{
				pushFrameSort(value);
			}
			_count ++;
		}
		
		private function pushFrameSort( value:IBaseTimer ):void
		{
			var frameCount:int = _frameCount + value.delay;
			var tempAry:Vector.<IBaseTimer> = null;
			if( _lastFrameCount == frameCount )
			{
				tempAry = _lastAry;
			}
			else
			{
				tempAry = _frameSortMap[frameCount] as Vector.<IBaseTimer>;
			}
			if(tempAry)
			{
				tempAry[tempAry.length] =  value ; 
			}
			else
			{
				tempAry = new Vector.<IBaseTimer>(0,false);
				tempAry[0] = value;
				_frameSortMap[frameCount] = tempAry;
			}
			_lastFrameCount = frameCount;
			_lastAry = tempAry;
		}
		
		private var _prevTime:int = 0;
		protected function onEnterFrameHandler( event:Event = null ):void
		{
			var nextTime:int = getTimer();
			var interval:int;
			if( _prevTime == 0 )
			{
				interval = 0;
			}
			else
			{
				interval = nextTime - _prevTime;
				renderer( interval );
			}
			_prevTime = nextTime;
		}
		
		/**
		 * 帧循环 
		 * 
		 */		
		protected function renderer(interval:int,isRepair:Boolean = false):void
		{
			_frameCount++;
			var frameSortAry:Vector.<IBaseTimer> = _frameSortMap[_frameCount] as Vector.<IBaseTimer>;
			
//			var stime:int = getTimer();
			
			EnterFrameFor(frameSortAry,interval,isRepair);
//			if( Log.isSystem )
//			{
//				var etimer:int = getTimer() - stime;
//				_totalTime += etimer;
//				Log.system("cuttentTimer："+ etimer+"->argTimer:"+ int(_totalTime/_frameCount));
//			}
		}
		/**
		 *  处理每帧需要处理的事件
		 * @param frameSortAry
		 * 
		 */		
		private function EnterFrameFor( frameSortAry:Vector.<IBaseTimer> ,interval:int,isRepair:Boolean = false):void
		{
			var tempframe:IBaseTimer;
			// 帧频为 1 的情况
			for each( tempframe in _oneFrameMap  )
			{
				if( tempframe.isDelete )
				{
					_count --;
					delete _oneFrameMap[tempframe.id];
//					tempframe.dispose();
				}
				else
				{
					if(tempframe.running)
					{
						tempframe.interval = interval;
						tempframe.renderer(_frameCount,isRepair);
						//trace(_frameCount);
					}
				}
			}
			// 帧频为多帧的情况  >2
			if( frameSortAry )
			{
				for each( tempframe in frameSortAry)
				{
					if( tempframe.isDelete )
					{
						_count --;
						tempframe.dispose();
					}
					else
					{
						if(tempframe.running)
						{
							tempframe.interval = interval;
							tempframe.renderer(_frameCount);
						}
						pushFrameSort( tempframe );
					}
				}
				frameSortAry.length = 0;
				delete _frameSortMap[_frameCount];
			}
		}
		
		private var _totalTime:int = 0;
	}
}