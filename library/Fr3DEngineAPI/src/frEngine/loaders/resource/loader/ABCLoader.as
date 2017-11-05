package frEngine.loaders.resource.loader
{
	import com.gengine.resource.core.StreamLoader;
	import com.gengine.resource.core.StreamManager;
	import com.gengine.resource.loader.ImageLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import frEngine.loaders.resource.encryption.EncryptUtils;
	import frEngine.loaders.resource.encryption.EncryptionInfo;



	public class ABCLoader extends ImageLoader
	{
		private var _bytesInfo:EncryptionInfo;
		private var _jpgBitmapData:BitmapData;
		public function ABCLoader()
		{
			super();
		}
		
		override public function getClass():Class
		{
			return ABCLoader;
		}
		
		public override function initialize(data:*):void
		{
			_bytesInfo=EncryptUtils.decodeStream(data);
			if(_bytesInfo.contentType==EncryptUtils.JPG || _bytesInfo.contentType==EncryptUtils.PNG)
			{
				super.initialize(_bytesInfo.contentBytes);
				return;
			}
			if(_bytesInfo.contentType==EncryptUtils.MEGER)
			{
				StreamManager.pushIn(this);
			}
			else
			{
				resourceInfo && (resourceInfo.data = _bytesInfo);
				onLoadCompleteHandler();
			}
		}
		
		override public function loadByteArray():void
		{
			if(_bytesInfo.contentType == EncryptUtils.JPG || _bytesInfo.contentType==EncryptUtils.PNG)
			{
				super.loadByteArray();
			}
			else if(_bytesInfo.contentType == EncryptUtils.MEGER)
			{
				loadBytesImg(_bytesInfo.contentBytes,loadJpgCompleteHander);
			}
		}
		
		override protected function onLoadCompleteHandler():void
		{
			_bytesInfo=null;
			if(_jpgBitmapData)
			{
				_jpgBitmapData.dispose();
				_jpgBitmapData=null;
			}
			super.onLoadCompleteHandler();
		}
		
		private function loadJpgCompleteHander(e:Event):void
		{
			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loadJpgCompleteHander);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onChangeIOErrorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangeIOErrorHandler);
			_jpgBitmapData=Bitmap(loaderInfo.content).bitmapData;
			loadBytesImg(_bytesInfo.otherBytes,loadPngCompleteHander);
		}
		
		private function loadPngCompleteHander(e:Event):void
		{
			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, loadPngCompleteHander);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onChangeIOErrorHandler);
			loaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangeIOErrorHandler);
			var pngBitmap:BitmapData=Bitmap(loaderInfo.content).bitmapData;
			pngBitmap.copyPixels(_jpgBitmapData,_jpgBitmapData.rect,new Point,pngBitmap);
			resourceInfo && (resourceInfo.data = pngBitmap)
			onLoadCompleteHandler();
		}
		
		private function loadBytesImg(bytes:ByteArray,callBack:Function):void
		{
			//通过loder 转换成资源 
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callBack);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onChangeIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onChangeIOErrorHandler);
			loader.loadBytes(bytes);
		}
		
		override protected function onContentReady(content:*):Boolean
		{
			if( resourceInfo && loaderInfo)
			{
				resourceInfo.data = loaderInfo;
			}
			return true;
		}

	}
}