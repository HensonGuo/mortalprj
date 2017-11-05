package com.gengine.resource.info
{
	import com.gengine.debug.Log;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;

	public class ImageInfo extends ResourceInfo
	{
		protected var _bitmapData:BitmapData;
		
		public function ImageInfo(object:Object = null)
		{
			super(object);
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			loaderInfo = value as LoaderInfo;
			if(loaderInfo )
			{
				_bitmapData = Bitmap(loaderInfo.content).bitmapData as BitmapData;
			}else if(value is BitmapData)
			{
				_bitmapData=BitmapData(value);
			}
		}
		
		override public function dispose():void
		{
			isLoaded = false;
			isLoading = false;
			super.dispose();
		}
		
		override protected function unload(loaderInfo:LoaderInfo):void
		{
			Log.system("unloadedImage:"+path);
			if( _bitmapData  )
			{
				//trace("unloadedImage_dispose");
				_bitmapData.dispose();
				_bitmapData = null;
			}
			super.unload(loaderInfo);
		}
	}
}