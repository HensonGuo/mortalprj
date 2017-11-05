package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class GBitmap extends Bitmap implements IDispose
	{
		public function GBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			this.x = 0;
			this.y = 0;
			this.bitmapData = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(isReuse)
			{
				UICompomentPool.disposeUICompoment(this);
			}
		}
	}
}