package mortal.common.swfPlayer.data
{
	import com.gengine.debug.FPS;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mortal.common.swfPlayer.frames.SwfFrames;
	
	public class BitmapFrame
	{
		public static var PixleCount:Number = 0;
		
		private static const DefaultBitmapData:BitmapData = new BitmapData(1, 1, true, 0);
		
		protected var _frame:int;
		public var swf:SwfFrames;
		public var x:Number = 0;
		public var y:Number = 0;
		public var width:Number=0;
		public var height:Number=0;
		protected var offsetX:Number=200;
		protected var offsetY:Number=200;
		protected var _bitmapData:BitmapData;
		
		
		private var _turnX:Number = 0;
		private var _turnY:Number = 0;
		
		private var _pixleNum:Number = 0;
		
		public function BitmapFrame( frame:int )
		{
			_frame = frame;
		}

		public function get bitmapData():BitmapData
		{
			return getBitmapData();
		}
		
		private function getBitmapData():BitmapData
		{
			if( _bitmapData == null)
			{
				if( swf == null ) return _bitmapData;
				var movieClip:MovieClip = swf.movieClip;
				if( movieClip == null ) return _bitmapData;
				
				if( movieClip.totalFrames < _frame ) return null;
				movieClip.gotoAndStop(_frame);
				var rect:Rectangle = movieClip.getBounds(movieClip);
				if(rect.height==0 || rect.width==0)
				{
					_bitmapData = DefaultBitmapData;
					FPS.instance.countFrames ++;
				}
				else
				{
					try
					{
					
						_bitmapData=new BitmapData(rect.width, rect.height, true, 0);
						_bitmapData.draw(movieClip, new Matrix(1,0,0,1,-rect.x,-rect.y),null,null,null,false);
						x = rect.x - offsetX;
						y = rect.y - offsetY;
						_pixleNum = rect.width * rect.height * 4; //字节 1024 Byte = 1k
						PixleCount += _pixleNum;
						FPS.instance.countFrames ++;
						FPS.instance.pixleCount = PixleCount/1024/1024;
					}catch(e:Error)
					{
						_bitmapData = null;
					}
				}
			}
			return _bitmapData;
		}
		
//		private function getTurnBitmapData():BitmapData
//		{
//			if( _turnBitmapData == null )
//			{
//				_bitmapData = getBitmapData(  );
//				if( _bitmapData )
//				{
////					_matrix.a = -1;
////					_matrix.b = 0;
////					_matrix.c = 0;
////					_matrix.d = 1;
////					_matrix.tx = _bitmapData.width;
////					_matrix.ty = 0;
//					_turnBitmapData = new BitmapData(_bitmapData.width, _bitmapData.height,true,0);
//					_turnBitmapData.draw(_bitmapData, new Matrix(-1, 0, 0, 1, _bitmapData.width, 0 ));
//				}
//			}
//			return _turnBitmapData;
//		}

		public function dispose(isDisposeClip:Boolean = false):void
		{
			if(_bitmapData &&  _bitmapData != DefaultBitmapData)
			{
				_bitmapData.dispose();
				PixleCount -= _pixleNum;
				FPS.instance.countFrames --;
				FPS.instance.pixleCount = PixleCount/1024/1024;
			}
			_bitmapData = null;
		}
		
		public function clone():BitmapFrame
		{
			return new BitmapFrame(_frame);
		}
	}
}