package mortal.common.swfPlayer
{
	import flash.geom.Point;
	
	import mortal.common.swfPlayer.data.ActionType;
	import mortal.common.swfPlayer.data.DirectionType;
	import mortal.common.swfPlayer.data.IMovieClipData;
	import mortal.common.swfPlayer.data.ModelData;
	import mortal.common.swfPlayer.data.ModelType;
	import mortal.common.swfPlayer.frames.SwfFrames;
	import mortal.game.scene3D.player.info.IModelInfo;

	/**
	 * 游戏 
	 * @author jianglang
	 * 
	 */	
	
	public class GPlayer extends BitmapPlayer
	{
		protected var _url:String;
		
		//private var movieClipData:FyModelInfo;
		
		private var _currentDirection:int = -1;
		private var _currentAction:int = -1;
		private var _currentFrame:int = 0;
		
		private var _fireFrame:int = 2;
		
		private var _firePoint:Point = new Point();
		
		private var _isRealTimeUpdate:Boolean = false;
		
		private var _direction:int;
		
//		private var _modelType:SwfFrames;
		
		private var _isloadComplete:Boolean = false;
		
		private var _isUpdateFrames:Boolean = true;
		
		private var _movieClipData:IMovieClipData;
		
		public var index:int;
		
		public function get isloadComplete():Boolean
		{
			return _isloadComplete;
		}
		
		public function set isloadComplete( value:Boolean ):void
		{
			_isloadComplete = value;
		}
//		public function get modelType():Frames
//		{
//			return _modelType;
//		}
//
//		public function set modelType(value:Frames):void
//		{
//			_modelType = value;
//			movieClipData.modelType = value;
//		}

		public function get firePoint():Point
		{
			return _firePoint;
		}

		public function get fireFrame():int
		{
			return _fireFrame;
		}
		
		public function set fireFrame( value:int ):void
		{
			_fireFrame = value;
		}
		
		public function get isRealTimeUpdate():Boolean
		{
			return _isRealTimeUpdate;
		}

		public function set isRealTimeUpdate(value:Boolean):void
		{
			_isRealTimeUpdate = value;
		}

		public var loadComplete:Function;
		
		public function GPlayer()
		{
			super();
			
		}

		public function get currentAction():int
		{
			return _currentAction==-1?ActionType.DefaultAction:_currentAction;
		}
		
		public function updateAction( value:int ):void
		{
			_currentAction = value;
		}
		
		public function set currentAction(value:int):void
		{
			if( _currentAction != value )
			{
				_currentAction = value;
				_isUpdateFrames = true;
				//updateFrame(_currentAction,_currentDirection);
			}
		}

		public function get currentDirection():int
		{
			return _currentDirection==-1?DirectionType.DefaultDir:_currentDirection;
		}

		public function set currentDirection(value:int):void
		{
			if( value != _currentDirection )
			{
				_currentDirection = value;
				_isUpdateFrames = true;
				//updateFrame(_currentAction,_currentDirection);
			}
		}

//		public function set modleInfo(value:IMovieClipData):void
//		{
//			_movieClipData = value;
//		}
		
		public function get movieClipData():IMovieClipData
		{
			return _movieClipData;
		}

		public function get url():String
		{
			return _url;
		}

		public function load(url:String,modelType:ModelType,info:IModelInfo,loadPriority:int = 2):void
		{
			_url = url;
			var data:IMovieClipData = ModelData.getData(url);
			if( data == null )
			{
				_movieClipData = modelType.getMovieClipData();
				_movieClipData.modelInfo = info;
				_movieClipData.addReference();
				
				ModelData.addData(url,_movieClipData); 
			}
			else
			{
				_movieClipData = data;
				_movieClipData.addReference();
			}
			_movieClipData.loadPriority = loadPriority;
			_movieClipData.load(url,onLoaded);
		}
		
		protected function onLoaded( info:SwfFrames ):void
		{
			if( info )
			{
				this.fireFrame = info.fireFrame
			}
			onDataComplete();
		}
		
		private function onDataComplete():void
		{
			_isloadComplete = true;
			if( loadComplete is Function )
			{
				loadComplete.call(null,this);
			}
		}
		
		public function get actionConut():int
		{
			if( _movieClipData )
			{
				return _movieClipData.actionConut;
			}
			return 0;
		}
		
		public function updateFrame(action:int,direction:int,isForeUpdate:Boolean = true):void
		{
			currentAction = action;
			currentDirection = direction;
			if( isForeUpdate )
			{
				_isUpdateFrames = isForeUpdate;
			}
			if( _isUpdateFrames && _movieClipData)
			{
				source = _movieClipData.getFrames(action,direction);
				_isUpdateFrames  = false;
			}
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			clear();
			rotation = 0;
			if( _movieClipData != null )
			{
				_movieClipData.removeReference();
				_movieClipData = null;
			}
			_currentAction = -1;
			_currentDirection = -1;
			_isloadComplete = false;
			loadComplete = null;
		}
	}
}