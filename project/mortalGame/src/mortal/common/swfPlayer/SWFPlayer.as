package mortal.common.swfPlayer
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.swfPlayer.data.DirectionType;
	import mortal.common.swfPlayer.frames.SwfFrames;

	public class SWFPlayer extends GPlayer
	{
		private var _timer:FrameTimer;
		private var _ramdomDaily:int;
		private var _timerKey:uint;
		private var _playNum:int = 0;
		private var _currentPlayNum:int = 0;

		public var actionPlayCompleteHandler:Function;
		private var _loadedPlay:Boolean = true;
		
		public function SWFPlayer()
		{
			super();
			if(!_timer)
			{
				_timer = new FrameTimer(_defaultTimeRate);
			}
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		public function get playNum():int
		{
			return _playNum;
		}
		
		public function set playNum(value:int):void
		{
			_playNum = value;
		}
		
		/**
		 * 添加到舞台 
		 * @param e
		 * 
		 */		
		protected function onAddToStage(e:Event):void
		{
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			play();
		}
		
		/**
		 * 移除舞台 
		 * @param e
		 * 
		 */		
		protected function onRemoveFromStage(e:Event):void
		{
			stop();
		}
		
		public function set ramdomDaily(value:int):void
		{
			_ramdomDaily = value;
		}
		
		/**
		 * 先设置timeRate再调用load
		 * @param rate
		 * 
		 */		
		public function set timeRate(rate:int):void
		{
			if(_timeRate != rate)
			{
				_timeRate = rate;
				if(_timer)
				{
					_timer.delay = rate;
				}
			}
		}
		
		/**
		 * 是否下载完播放 
		 * @param value
		 * 
		 */
		public function set loadedPlay(value:Boolean):void
		{
			_loadedPlay = value;
		}
		
		private function onEnterFrame(timer:FrameTimer):void
		{
			nextFrame();
			updateCurrentFrame(currentFrame);
		}
		
		override protected function framesPlayerComplete():void
		{
			super.framesPlayerComplete();
			_currentPlayNum ++;
			if(  _playNum == 0  )
			{
				
			}
			else if( _currentPlayNum >= _playNum )
			{
				stop();
				actionPlayComplete();
			}
		}
		
		protected function actionPlayComplete():void
		{
			if( actionPlayCompleteHandler is Function )
			{
				actionPlayCompleteHandler();
			}
		}
		
		private function playDaily():void
		{
			super.play();
			_timer.start();
			currentFrame = 0;
		}
		
		override public function play():void
		{
			clearTimeout(_timerKey);
			
			if(_ramdomDaily > 0)
			{
				_timerKey = setTimeout(playDaily,_ramdomDaily * Math.random());
			}
			else
			{
				super.play();
				_timer.start();
				currentFrame = 0;
			}
		}
		
		override public function stop():void
		{
			super.stop();
			_timer.stop();
			clearTimeout(_timerKey);
		}
		
		public function playAction( action:int, direction:int,playNum:int=1 ):void
		{
			_playNum = playNum;
			_currentPlayNum = 0;
			updateFrame(action,direction,true);
			play();
		}
		
		
		override protected function onLoaded(info:SwfFrames):void
		{
			if( this.currentDirection < 1 )
			{
				this.currentDirection = DirectionType.DefaultDir;
			}
			updateFrame(this.currentAction,this.currentDirection);
			updateCurrentFrame(0);
			super.onLoaded(info);
			if(_loadedPlay)
			{
				play();
			}
		}
		
		override public function updateFrame(action:int, direction:int, isForeUpdate:Boolean=true):void
		{
			super.updateFrame(action,direction,isForeUpdate);
			_timer.delay = this.timeRate;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			stop();
			_currentPlayNum = 0;
			_ramdomDaily = 0;
			_timer.dispose();
			transform.matrix = new Matrix();
			this.scaleX = 1;
			this.scaleY = 1;
			rotation = 0;
			super.dispose();
			if( this.parent )
			{
				this.parent.removeChild(this);
			}
			_loadedPlay = true;
			actionPlayCompleteHandler = null;
			_url = "";
			ObjectPool.disposeObject(this);
		}
	}
}