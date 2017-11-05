package com.gengine.core.frame
{
	import com.gengine.core.FrameUtil;
	import com.gengine.global.Global;
	import com.mui.controls.GLabel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * flash帧频计时 默认 24帧一秒
	 * @author jianglang
	 * 
	 */	
	public class FlashFrame extends Frame implements IFlashFrame
	{
		private var _sprite:Sprite;
		
		private var _isBrowserAvailable:Boolean = false;//是否浏览器可用
		
		public static var AverageTime:int = 1000/60;
		
		private var _renderCount:int=0;
		private var _accruedTime:Number;
		private var _startTime:Number;
		
		private var _frameMap60:Dictionary; //60帧队列
		
		public function FlashFrame(delay:Number = 24)
		{
			super(delay);
			_frameMap60 = new Dictionary();
			_sprite = new Sprite();
		}
		
		override public function play():void
		{
			super.play();
			_sprite.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			_renderCount = 0;
			_startTime = getTimer();
		}
		
		override public function stop():void
		{
			super.stop();
			_sprite.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);		
		}
		
		//上次帧执行时间点
		private var _prevTime:int = 0;
		//上次帧理论执行时间点
		private var _prevTheoryTime:Number = 0;
		
		private static const FrameTheoryInterval:Number = 1000/60;//每帧理论执行时间

		
		/**
		 * 添加60zhen
		 * @param value
		 * 
		 */		
		public function addTimer60( value:IBaseTimer ):void
		{
			if( !_isPlay )
			{
				play();
			}
			if( value.delay == 1 )
			{
				_frameMap60[value.id] = value;
			}
			_count ++;
		}
		
		private function recoupFrames( count:uint=1,interval:Number=17 ):void
		{
			var isRepair:Boolean = true;
			for( var i:int=0; i < count; i++ )
			{
				if(i == count - 1)
				{
					isRepair = false;
				}
				renderer( interval,isRepair);
			}
		}
		
		//场景改成60帧数，要2次才执行一次
		protected var _rendererCount:int = 0;
		protected var lastInterval:int = 0;
		
		override protected function renderer(interval:int,isRepair:Boolean = false):void
		{
			_rendererCount++;
			_prevTheoryTime += FrameTheoryInterval;
			
			//处理60帧Render
			var tempframe:IBaseTimer;
			// 帧频为 1 的情况
			for each( tempframe in _frameMap60  )
			{
				if( tempframe.isDelete )
				{
					_count --;
					delete _frameMap60[tempframe.id];
				}
				else
				{
					if(tempframe.running)
					{
						tempframe.interval = interval;
						tempframe.renderer(_rendererCount,isRepair);
					}
				}
			}
			
			//30帧
			if(_rendererCount%2)
			{
				lastInterval = interval;
			}
			else
			{
				super.renderer(lastInterval + interval);
			}
		}
		
		override protected function onEnterFrameHandler(event:Event=null):void
		{
			var nextTime:int = getTimer();
			FrameUtil.frameStartTime = nextTime;
			
			var interval:int;
			if( _prevTime == 0 )
			{
				interval = 0;
				_prevTheoryTime = nextTime;
			}
			else
			{
				interval = nextTime - _prevTime;
//				trace("间隔时间",interval)
				var realFrameTime:int = (nextTime - _prevTheoryTime)/FrameTheoryInterval;
				//大于两帧理论时间
				if(realFrameTime < 2)
				{
					renderer( interval );
				}
				else
				{
					recoupFrames(realFrameTime,interval/realFrameTime);
				}
//注释以前的计算方法
//				var trealFrame:uint = uint(1000 / interval);//上一帧的实际帧频
//				if( trealFrame >= RealFrameRate  )
//				{
//					renderer( interval );
//				}
//				else
//				{
//					recoupFrames( int(RealFrameRate/trealFrame) )
//				}
			}
			_prevTime = nextTime;
			
			//下面的代码为调试辅助
			//消息时间
			CONFIG::Debug
			{
				FrameUtil.frameProTimer += (getTimer() - nextTime);
			}
			
			_renderCount ++;
			if( _renderCount == 100 )
			{
				var tempTime:int = getTimer();
				AverageTime = (tempTime - _startTime)/_renderCount;
				_renderCount = 0;
				_startTime = tempTime;
			}
		}

		public function get rendererCount():int
		{
			return _rendererCount;
		}
	}
}