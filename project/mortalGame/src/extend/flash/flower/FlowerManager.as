package extend.flash.flower
{
	import com.gengine.utils.MathUitl;
	
	import flash.display.Sprite;
	import flash.utils.Timer;
	
	import mortal.common.display.LoaderHelp;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.PrizeFall.PrizeFallSprite;
	
	public class FlowerManager
	{
		private static var _instance:FlowerManager;
		public function FlowerManager()
		{
//			if(_instance != null)
//			{
//				throw new Error("FlowerManager 单例");
//			}
		}
		
		
		public static function get instance():FlowerManager
		{
			if(_instance == null)
			{
				_instance = new FlowerManager();
			}
			return _instance;
		}
		
		private var _isplay:Boolean = false;
		private var _flowerArray:Array = [];
		private var _currentFlowerPlayer:FlowerPlayer;
		private var _flowerSprite99:FlowerSprite99;
		private var _flowerSprite999:FlowerSprite999;
		public function addFlowerQueue( type:int , time:int = -1 ,res:String = "flowers"):void
		{
			LoaderHelp.addResCallBack(res,callBack);
			
			function callBack():void
			{
				if(time == -1)
				{
					time = FlowerConst.FLOWER_TIME;
				}
				
				var flowerSprite:FlowerSprite = getflowerSprite(type);
				
				_flowerArray.push( new FlowerPlayer( type,time ,flowerSprite) );
				if(_currentFlowerPlayer && _currentFlowerPlayer.isPlaying)
				{
					return ;
				}
				playNext();
			}
		}
			
		/**
		 * 通过类型获取播放的Sprite
		 * @param type
		 * @return 
		 * 
		 */
		protected function getflowerSprite(type:int):FlowerSprite
		{
			var flowerSprite:FlowerSprite;
			switch( type )
			{
				case FlowerType.FLOWER_9:
				{
					flowerSprite = new FlowerSprite99();
					break;
				}
				case FlowerType.FLOWER_99:
				{
					flowerSprite = new FlowerSprite99();
					break;
				}
				case FlowerType.FLOWER_999:
				{
					flowerSprite = new FlowerSprite999();
					break;
				}
				case FlowerType.FLOWERBLUE_99:
				{
					flowerSprite = new FlowerSpriteBlue99();
					break;
				}
				case FlowerType.FLOWERBLUE_999:
				{
					flowerSprite = new FlowerSpriteBlue999();
					break;
				}
				case FlowerType.FLOWERBLACK_99:
				{
					flowerSprite = new FlowerSpriteBlack99();
					break;
				}
				case FlowerType.FLOWERBLACK_999:
				{
					flowerSprite = new FlowerSpriteBlack999();
					break;
				}
				case FlowerType.BALLON:
				{
					flowerSprite = new BallonSprite();
					break;
				}
			    case FlowerType.PrizeFall:
				{
					flowerSprite = new PrizeFallSprite();
					break;
				}
			}
			return flowerSprite;
		}
		
		private var _flowerCanvas:Sprite;
		public function addFlowerToStage( flowerSprite:FlowerSprite ):void
		{
			if(_flowerCanvas == null)
			{
				_flowerCanvas = new Sprite();
				_flowerCanvas.mouseChildren = false;
				_flowerCanvas.mouseEnabled = false;
			}

			if(flowerSprite&&flowerSprite.parent == null)
			{
				_flowerCanvas.addChild( flowerSprite );
			}
			LayerManager.flowersLayer.addChild(_flowerCanvas);
		}
		
		private var _ary:Array = [ 99,999 ];
		
		public function flowerRandom():void
		{
			addFlowerQueue(_ary[MathUitl.random(0,1)])
		}
		
		/**
		 * 停止 
		 * 
		 */		
		public function stop():void
		{
			_flowerArray = [];
			if(_currentFlowerPlayer && _currentFlowerPlayer.isPlaying)
			{
				_currentFlowerPlayer.stop();
			}
		}
		
		/**
		 * 播放下一个 
		 * 
		 */		
		private function playNext():void
		{
			if(_flowerArray && _flowerArray.length > 0 )
			{
				_currentFlowerPlayer = _flowerArray.shift(); 
				_currentFlowerPlayer.play( playCallBack );
				if(_currentFlowerPlayer)
				{
					addFlowerToStage( _currentFlowerPlayer.flowerSprite  );
				}
			}
			else
			{
				_currentFlowerPlayer = null;
			}
		}
		
		private function playCallBack():void
		{
			playNext();
		}
	}
}
	import extend.flash.flower.FlowerSprite;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	

class FlowerPlayer
{
	public var type:int;
	public var time:int;
	public var flowerSprite:FlowerSprite;
	private var _timer:Timer;
	
	public function FlowerPlayer( type:int , time:int ,flowerSprite:extend.flash.flower.FlowerSprite = null):void
	{
		this.type = type;
		this.time = time;
		this.flowerSprite = flowerSprite;
	}
	private var _callback:Function;
	
	public function get isPlaying():Boolean
	{
		if(_timer)
		{
			return _timer.running;
		}
		return false;
	}
	
	public function play( callback:Function = null ):void
	{
		_callback = callback;
		if(_timer == null)
		{
			_timer = new Timer( time ,1);
		}
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
		_timer.start();
		if(flowerSprite)
		{
			flowerSprite.start();
		}
		else
		{
			onTimerCompleteHandler();
		}
	}
	
	private function onTimerCompleteHandler( event:TimerEvent=null ):void
	{
		stop();
	}
	
	/**
	 * 停止 
	 * 
	 */
	public function stop():void
	{
		_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
		_timer.stop();
		_timer = null;
		if(flowerSprite)
		{
			flowerSprite.addEventListener(FlowerSprite.PLAY_END,onPlayEndHandler);
			flowerSprite.stop();
		}
		if(_callback != null)
		{
			_callback();
		}
	}
	
	private function onPlayEndHandler( event:Event ):void
	{
		FlowerSprite(event.target).destroy();
	}
}