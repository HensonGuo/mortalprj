package mortal.common.pools
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class BitmapDataPool
	{
		public function BitmapDataPool()
		{
			
		}
		
		private static var _matrix:Matrix = new Matrix();
		public static function drawBitmapData(movieClip:MovieClip,frame:int=1):BitmapData
		{
			if( movieClip.totalFrames < frame ) return null;
			movieClip.gotoAndStop(frame);
			var rect:Rectangle = movieClip.getBounds(movieClip);
			if(rect.height==0 || rect.width==0)
			{
				//_bitmapFrameList[frame] = null);
			}
			else
			{
				var bitmapData:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
				bitmapData.draw(movieClip, null,null,null,null,false);
				return bitmapData;
			}
			return null;
		}
		
		private static var _bitmapDataPool:Dictionary = new Dictionary();
		/**
		 * 用来设置遮罩的bitmapdata 
		 * @param w
		 * @param h
		 * 
		 */		
		public static function getMaskBitmapData( w:Number=0,h:Number=0 ):BitmapData
		{
			if( w == 0 ){ w = 1 };
			if( h == 0 ){ h = 1 };
			var key:String = w+"_"+h;
			var bmd:BitmapData = _bitmapDataPool[key];
			if( bmd == null )
			{
				bmd = _bitmapDataPool[key] = new BitmapData(w,h);
			}
			return bmd;
		}
		
	}
}