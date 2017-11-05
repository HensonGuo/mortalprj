package mortal.common.swfPlayer
{
	import com.gengine.core.IDispose;
	
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mortal.common.swfPlayer.data.BitmapFrame;
	import mortal.common.swfPlayer.frames.FrameArray;

	/**
	 * 位图序列播放器 
	 * @author jianglang
	 * 
	 */	
	public class BitmapPlayer extends Bitmap implements IDispose
	{
		// 位图序列
		private var _source:FrameArray;
		//总帧数
		private var _totalFrames:int;
		//当前帧		
		private var _currentFrame:int;
		
		// 位图播放的速率  》0 生效
		protected var _timeRate:int = 0;
		
		// 默认帧率
		protected var _defaultTimeRate:int = 6;
		
		// 帧的数据
		protected var _bitmapFrame:BitmapFrame;
		
		private var _frameScript:Dictionary;
		
		protected var _isUpdate:Boolean = false;
		
		public var framesPlayerCompleteHandler:Function;
		
		private var _sceneX:Number = 0;
		private var _sceneY:Number = 0;
		
		protected var _isTurn:Boolean  = false;
		
		//策划用模型工具，因为位置不对
		public var useByModelShowTool:Boolean = false;
		
		public function BitmapPlayer( )
		{
			super();
			_frameScript = new Dictionary();
		}
		
		public function get timeRate():int
		{
			if(_timeRate > 0)
			{
				return _timeRate;
			}
			else if( _source )
			{
				return _source.delay;
			}
			return _defaultTimeRate;
		}

		public function addFrameScript( frame:int , callback:Function ):void
		{
			if( frame >= 0 )
			{
				_frameScript[frame] = callback;
			}
		}
		
		public function removeFrameScripte(  frame:int ):void
		{
			_frameScript[frame] = null;
			delete _frameScript[frame];
		}
		
		/**
		 * 当前位图序列中的某一个位图单位 
		 */
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		public function set currentFrame(value:int):void
		{
			_currentFrame = value;
		}
		/**
		 * 位图序列切割的总个数 
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}

		/**
		 * 位图序列数组 
		 */
		public function set source(value:FrameArray):void
		{
			_source = value;
			if( _source )
			{
				_totalFrames = _source.length;
				_isTurn = _source.isTurn;
			}
			else
			{
				_isTurn = false;
			}
		}
		
		public function get source():FrameArray
		{
			return _source;
		}
		
		/**
		 * 下一帧 
		 * 
		 */		
		public function nextFrame():void
		{
			if (_totalFrames > 0)
			{
				_currentFrame = _currentFrame + 1;
				
				if ( _currentFrame > _totalFrames - 1)
				{
					_currentFrame = 0;
				}
			}
		}
		
		/**
		 * 上一帧 
		 * 
		 */		
		public function preFrame():void
		{
			if (_totalFrames > 0)
			{
				_currentFrame = _currentFrame - 1;
				
				if ( _currentFrame < 0)
				{
					_currentFrame = _totalFrames-1;
				}
			}
		}
	
		public function clear():void
		{
			bitmapData = null;
			_currentFrame = 0;
			_totalFrames = 0;
			_source = null;
			_sceneX = 0;
			_sceneY =  0;
			_timeRate = 0;
		}
		
		protected function framesPlayerComplete():void
		{
			if( framesPlayerCompleteHandler is Function )
			{
				framesPlayerCompleteHandler.call(null,this);
			}
		}
		
		/**
		 * 更新屏幕 
		 * 
		 */		
		public function updateCurrentFrame( frame:int ):void
		{
			if( _source )
			{
				_bitmapFrame = _source[ frame ];
				
				if( _bitmapFrame)
				{
					if( _bitmapFrame.bitmapData )
					{
						if( bitmapData != _bitmapFrame.bitmapData )
						{
							bitmapData = _bitmapFrame.bitmapData
						}
						if( _isTurn )
						{
							this.scaleX = -1;
							setBitmapXY(-_bitmapFrame.x,_bitmapFrame.y);
						}
						else
						{
							this.scaleX = 1;
							setBitmapXY(_bitmapFrame.x,_bitmapFrame.y);
						}
					}
					else
					{
						if( bitmapData != null )
						{
							bitmapData = null;
						}
						
//						trace("nullFrame:"+frame);
					}
				}
				else
				{
					return;
					//bitmapData = null;
					//trace("nullFrame:"+frame);
				}
				
				if( _currentFrame+1 == _totalFrames )
				{
					framesPlayerComplete();
				}
				
				if( _frameScript[_currentFrame] is Function )
				{
					_frameScript[_currentFrame].apply(null);
				}
			}
			else
			{
				this.bitmapData = null;
			}
		}
		
		
		public function gotoAndStop( frame:int = 0 ):void
		{
			if( _source )
			{
				_bitmapFrame = _source[ frame ];
				
				if( _bitmapFrame)
				{
					if( _bitmapFrame.bitmapData )
					{
						if( bitmapData != _bitmapFrame.bitmapData )
						{
							bitmapData = _bitmapFrame.bitmapData
						}
						if( _isTurn )
						{
							this.scaleX = -1;
							setBitmapXY(-_bitmapFrame.x,_bitmapFrame.y);
						}
						else
						{
							this.scaleX = 1;
							setBitmapXY(_bitmapFrame.x,_bitmapFrame.y);
						}
					}
					else
					{
						if( bitmapData != null )
						{
							bitmapData = null;
						}
						
						//						trace("nullFrame:"+frame);
					}
				}
				else
				{
					return;
					//bitmapData = null;
					//trace("nullFrame:"+frame);
				}
				
			}
			else
			{
				this.bitmapData = null;
			}
		}
		
		protected function setBitmapXY(xx:Number,yy:Number):void
		{
			if( useByModelShowTool )
			{
				this.x = _sceneX;
				this.y = _sceneY;
			}
			else
			{
				this.x = xx + _sceneX;
				this.y = yy + _sceneY;
			}
			
			if(rotation != 0 && _bitmapFrame)
			{
				var correctPoint:Point = getCorrectPoint(-1 * _bitmapFrame.x,-1 * _bitmapFrame.y);
				var realyPoint:Point = getCorrectPoint(0,0);
				this.x += correctPoint.x - realyPoint.x;
				this.y += correctPoint.y - realyPoint.y;
			}
			
//			if( this is SkillsPlayer )
//			{
//				trace("skillsXY:", _currentFrame+":",this.x,this.y )
//			}
		}
		
		private function getCorrectPoint(x:Number,y:Number):Point
		{
			var m:Matrix = new Matrix();
			var p:Point = new Point(x,y);
			//p = m.transformPoint(p);
			m.tx -= p.x;
			m.ty -= p.y;
			if (rotation % 360 != 0) {
				m.rotate(rotation * Math.PI / 180);
			}
			m.tx += p.x;
			m.ty += p.y;
			return new Point(m.tx,m.ty);
		}
		
		public function get sceneX():Number
		{
			return _sceneX;
		}
		public function set sceneX(value:Number):void
		{
			_sceneX = value;
		}
		public function get sceneY():Number
		{
			return _sceneY;
		}
		public function set sceneY(value:Number):void
		{
			_sceneY = value;
		}
		
		/**
		 * 先调用move 再调用load 
		 * @param xx
		 * @param yy
		 * 
		 */		
		public function move(xx:Number,yy:Number):void
		{
			_sceneX = xx;
			_sceneY = yy;
//			updateCurrentFrame(_currentFrame);
		}
		
		public function play():void
		{
			
		}
		
		public function stop():void
		{
			
		}
		
		public function getMaxY():Number  ////获取y的顶点值
		{
			var rect:Rectangle=this.getBounds(this);
			return Math.abs(rect.y);
		}

		
		public function dispose(isReuse:Boolean=true):void
		{
		}
		
	}
}