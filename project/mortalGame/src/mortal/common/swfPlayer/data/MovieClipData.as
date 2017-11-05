package mortal.common.swfPlayer.data
{
	import com.gengine.resource.LoaderPriority;
	
	import mortal.common.swfPlayer.frames.FrameArray;
	import mortal.common.swfPlayer.frames.SwfFrames;
	import mortal.game.resource.FrameTypeConfig;
	import mortal.game.scene3D.player.info.IModelInfo;
	
	public class MovieClipData implements IMovieClipData
	{
//		protected var _bitmapFrameList:FrameArray;
		protected var _frames:SwfFrames;
		
		protected var _url:String;
		
		protected static const MAX_FRAME:int = 15; //最大帧数
		
		protected var framestype:String;  //帧的类型
		
		protected var _modelInfo:IModelInfo;
		
		private var _referenceCount:int = 0;  //引用数量
		
		private var _loadPriority:int = LoaderPriority.LevelC;
		
		public function MovieClipData( type:String )
		{
			framestype = type;
		}
		
		public function get pointY():Number
		{
			if( _frames )
			{
				return _frames.pointY;
			}
			return 0;
		}
		
		public function get modleType():int
		{
			if( _frames )
			{
				return _frames.modleType;
			}
			return 0;
		}
		
		public function get isSouthTop():Boolean
		{
			if( _frames )
			{
				return _frames.isSouthTop;
			}
			return false;
		}
		
		public function get isNorthTop():Boolean
		{
			if( _frames )
			{
				return _frames.isNorthTop;
			}
			return false;
		}
		
		public function get fireFrame():int
		{
			if( _frames )
			{
				return _frames.fireFrame;
			}
			return 0;
		}
		public function set modelInfo( info:IModelInfo ):void
		{
			_modelInfo = info;
//			setFrames( info.modelId );
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function removeReference():void
		{
			_referenceCount --;
			if( _frames )
			{
				_frames.removeReference();
			}
		}
		
		public function addReference():void
		{
			if( _referenceCount < 0 )
			{
				_referenceCount = 0;
			}
			_referenceCount ++;
//			_frames.addReference();
		}
		
		public function get referenceCount():int
		{
			return _referenceCount;
		}

		/**
		 * 创建帧数据 
		 * 所有动作帧的数据
		 */		
		protected function setFrames( modelId:String = null ):void
		{
//			if( modelId && modelId != "" )
//			{
//				_frames = ModleFrameConfig.instance.getFramesByName(modelId);
//			}
			if( _frames == null )
			{
				_frames = FrameTypeConfig.instance.getFramesByType(framestype).clone();
			}
			if( _frames )
			{
				_frames.movieClip = null;
			}
		}
		
		/**
		 * 获取一个动作 以及 方向的所有帧 
		 * @param action
		 * @param direction
		 * @return 
		 * 
		 */		
		public function getFrames( action:int , direction:int ):FrameArray
		{
			return _frames.getFrames(action,direction);
		}

//		public function set source(value:Object):void
//		{
//			if( value == null ) return;
//			
//			if( value is MovieClip )
//			{
//				_frames.movieClip = value as MovieClip;
//			}
//			else
//			{
//				throw new Error("数据不是MovieClip");
//			}
//		}
		
		public function getActionInfo( action:int ):ActionInfo
		{
			return _frames.getActionInfo(action) as ActionInfo;
		}
		
		/**
		 * 加载 SWF 动作文件 
		 * @param url
		 * @param onLoaded
		 * 
		 */		
		public function load(url:String,onLoaded:Function):void
		{
			_url = url;
			_frames = FramesData.getData(url);
		
			if( _frames == null)
			{
				if( _modelInfo == null )
				{
					setFrames( null );
				}
				else
				{
					setFrames( _modelInfo.modelId );
				}
				if( _frames )
				{
					FramesData.addData(url,_frames);
				}
			}
			if( _frames )
			{
				_frames.loadPriority = _loadPriority;
				_frames.load(url,onLoaded);
			}
		}
		
		
		public function get actionConut():int
		{
			if( _frames )
			{
				return _frames.actionConut;
			}
			return 0;
		}
		 /** 获取帧 
		 * @param frame
		 * @return 
		 * 
		 */		
		public function getFrame( frame:Object ):int
		{
			if(frame is Number)
			{
				return int(frame);
			}
			return -1;
		}
		
		public function isClear( value:Boolean ):void
		{
			if( _frames )
			{
				_frames.isClear = value;
			}
		}
		
		
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
//			if( _frames.isClear == false ) return;
			
			if( _frames.referenceCount <= 0 )
			{
				_frames.dispose();
			}
			_referenceCount = -1;
		}

		public function get loadPriority():int
		{
			return _loadPriority;
		}

		public function set loadPriority(value:int):void
		{
			_loadPriority = value;
		}

	}
}