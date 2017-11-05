/**
 * @date	2011-4-18 上午10:50:38
 * @author  jianglang
 * 
 * 
 * 
 * 一个动作的 帧 和 方向
 */	

package mortal.common.swfPlayer.data
{
	import com.gengine.debug.Log;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import mortal.common.swfPlayer.frames.FrameArray;
	import mortal.common.swfPlayer.frames.SwfFrames;

	public class ActionInfo
	{
		public var swf:SwfFrames;
		public var action:int;
		public var startFrame:int;
		public var endFrame:int;
		public var frameRate:int;
		public var delay:int;
		public var dir:int;
		public var isInitEmptyFrames:Boolean = false;
		
		protected var _framesMap:Dictionary;
		
		private var _isCreateFrames:Boolean = false;
		
		public function ActionInfo( action:int, startFrame:int,endFrame:int,frameRate:int,delay:int,dir:int = 8)
		{
			this.action = action;
			this.startFrame = startFrame;
			this.endFrame = endFrame;
			this.frameRate = frameRate;
			this.delay = delay;
			this.dir = dir;
			_framesMap = new Dictionary();
		}
		
		public function get isCreateFrames():Boolean
		{
			return _isCreateFrames;
		}

		public function set movieClip( value:MovieClip ):void
		{
			//已经创建了帧
			if( value )
			{
				if( _isCreateFrames )
				{
					setActionMovieClip(value);
				}
				else
				{
					if( this.dir == 8 )
					{
						create8Action( value );
						_isCreateFrames = true;
					}
					else if( this.dir == 1 )
					{
						createOneDirAction(value);
						_isCreateFrames = true;
					}
					else
					{
						createXDirAction(value);
						_isCreateFrames = true;
					}
				}
			}
			else
			{
				if( _isCreateFrames == false )
				{
					if( this.dir == 8 )
					{
						create8Action( value );
						_isCreateFrames = true;
					}
					else if( this.dir == 1 )
					{
						createOneDirAction(value);
						_isCreateFrames = true;
					}
					else
					{
						createXDirAction(value);
						_isCreateFrames = true;
					}
				}
			}
		}
		
		public function getActionDir( dir:int ):FrameArray
		{
			return _framesMap[dir];
		}
		
		/**
		 * 跟一个动作赋值MC 位图
		 * @param action
		 * @param mc
		 * 
		 */		
		public function setActionMovieClip(mc:MovieClip ):void
		{
			var ary:FrameArray;
			if( this.dir == 8 )
			{
				for( var i:int =1;i<=8;i++ )
				{
					ary = _framesMap[i];
					if( ary )
					{
						for each( var bitmapFrame:BitmapFrame in ary  )
						{
							bitmapFrame.swf = swf;
						}
					}
				}
			}
			else if( this.dir == 1 )
			{
				ary = _framesMap[DirectionType.DefaultDir];
				if( ary )
				{
					for each( var bitmapFrame1:BitmapFrame in ary  )
					{
						bitmapFrame1.swf = swf;
					}
				}
			}
			
		}
		
		/**
		 * 创建一个动作的所有帧 
		 * @param action
		 * @param actionInfo
		 * @param mc
		 * 
		 */		
		protected function createAction( mc:MovieClip):void
		{
			
		}
		
		/**
		 * 创建一个方向面得动作 
		 * 默认方向是 北方向
		 */		
		private function createOneDirAction(mc:MovieClip):void
		{
			if( mc )
			{
				if( endFrame > mc.totalFrames )
				{
					endFrame = mc.totalFrames;
					if( startFrame > endFrame )
					{
						return;
					}
				}
			}
			var ary:FrameArray = new FrameArray(this);
			var bf:BitmapFrame;
			for( var i:int = startFrame;i<= endFrame ;i++)
			{
				bf = new BitmapFrame( i );
				bf.swf = swf;
				ary.push(bf);
			}
			_framesMap[DirectionType.DefaultDir] = ary;
		}
		
		/**
		 * 创建 8个方向面得动作 
		 * @param action
		 * @param actionInfo
		 * @param mc
		 * 
		 */		
		protected function create8Action(mc:MovieClip):void
		{
			var bitmapFrame:BitmapFrame;
			var ary:FrameArray;
			var dir:int;
			var tempdir:int = -1;
			for( var i:int = startFrame;i<= endFrame ;i++)
			{
				dir = Math.ceil((i-startFrame+1)/frameRate);
				if( dir != tempdir )
				{
					ary = _framesMap[dir];
					if( ary == null )
					{
						_framesMap[dir] = ary = new FrameArray( this );
					}
					else
					{
						Log.system("方向已经存在");
					}
					tempdir = dir;
				}
				bitmapFrame = new BitmapFrame(i);
				bitmapFrame.swf = swf;
				ary.push(bitmapFrame);
			}
			
			ary = _framesMap[DirectionType.SouthWest];
			ary = ary.clone();
			ary.isTurn = true;
			_framesMap[DirectionType.SouthEast] = ary;
			
			ary = _framesMap[DirectionType.West];
			ary = ary.clone();
			ary.isTurn = true;
			_framesMap[DirectionType.East] = ary;
			
			ary = _framesMap[DirectionType.NorthWest];
			ary = ary.clone();
			ary.isTurn = true;
			_framesMap[DirectionType.NorthEast] = ary;
		}

		/**
		 * 创建X个方向面得动作
		 * @param action
		 * @param actionInfo
		 * @param mc
		 * 
		 */		
		protected function createXDirAction(mc:MovieClip):void
		{
			var bitmapFrame:BitmapFrame;
			var ary:FrameArray;
			var dir:int;
			var tempdir:int = -1;
			var createDir:Array = [];
			for( var i:int = startFrame;i<= endFrame ;i++)
			{
				dir = Math.ceil((i-startFrame+1)/frameRate);
				if( dir != tempdir )
				{
					ary = _framesMap[dir];
					if( ary == null )
					{
						_framesMap[dir] = ary = new FrameArray( this );
					}
					else
					{
						Log.system("方向已经存在");
					}
					tempdir = dir;
					createDir.push(dir);
				}
				bitmapFrame = new BitmapFrame(i);
				bitmapFrame.swf = swf;
				ary.push(bitmapFrame);
			}
			
			var createXDir:Array = [];
			for each(dir in createDir)
			{
				tempdir = DirectionType.getXTurnDir(dir);
				
				if(tempdir != -1 && createDir.indexOf(tempdir) == -1)
				{
					ary = _framesMap[dir];
					ary = ary.clone();
					ary.isTurn = true;
					_framesMap[tempdir] = ary;
					createDir.push(tempdir);
					createXDir.push(tempdir);
				}
			}

			for each(dir in createDir)
			{
				tempdir = DirectionType.getYTurnDir(dir);
				
				if(tempdir != -1 && createDir.indexOf(tempdir) == -1)
				{
					ary = _framesMap[dir];
					ary = ary.clone();
					ary.isTurnY = true;
					_framesMap[tempdir] = ary;
					createDir.push(tempdir);
					
					if(createXDir.indexOf(dir) != -1)
					{
						ary.isTurn = true;
					}
				}
			}
		}
		
		public function clone():ActionInfo
		{
			var info:ActionInfo = new ActionInfo( action,startFrame,endFrame,frameRate,delay,dir );
//			if( isCreateFrames )
//			{
//				info.movieClip = null;
//			}
			return info;
		}
		
		public function dispose():void
		{
			var bitmapFrame:BitmapFrame;
			for each( var frames:FrameArray in _framesMap )
			{
				for( var i:int=0;i<frames.length;i++ )
				{
					bitmapFrame = frames[i];
					bitmapFrame.dispose( true );
				}
			}
		}
		
		public function getDirFrame( dir:int,frame:int=0 ):BitmapFrame
		{
			var ary:Array = _framesMap[dir] as Array;
			if( ary )
			{
				return ary[frame];
			}
			return null;
		}
	}
}
