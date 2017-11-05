package mortal.common.swfPlayer.data
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mortal.common.swfPlayer.frames.SwfFrames;

	public class FramesData
	{
		private static var _dataMap:Dictionary = new Dictionary();
		
		public function FramesData()
		{
			
		}
		
		public static function setData():void
		{
//			var myShareObject:SharedObject = SharedObject.getLocal("framesData");
//			myShareObject.data[ "framesData" ] = _dataMap;
//			myShareObject.flush(1000000000);
		}
		
		
		public static function addData( url:String , data:SwfFrames ):void
		{
			_dataMap[url] = data;
		}
		
		public static function getData( url:String ):SwfFrames
		{
			return _dataMap[url];
		}
		
		public static function clearReference():void
		{
			for each( var frame:SwfFrames in _dataMap  )
			{
				if( frame.referenceCount > 0 )
				{
					frame.clearReferenceCount();
				}
			}
		}
		
		public static function dispose():void
		{
//			trace("空闲内存："+ System.freeMemory/1024 + "  总内存："+System.totalMemory/1024);
			
			var time:Number = getTimer();
			var isUpdate:Boolean = false;
			for each( var frame:SwfFrames in _dataMap  )
			{
				if( frame.referenceCount == 0 )
				{
					if( frame.disposeTime <= time )
					{
						frame.dispose();
						isUpdate = true;
					}
//					else
//					{
//						Log.debug( "销毁时间未到 路径："+frame.url + "：referenceCount=="+frame.referenceCount);
//					}
				}
//				else if( frame.referenceCount < 0 )
//				{
//					//trace( "已经销毁 路径："+frame.url + "：referenceCount=="+frame.referenceCount);
//				}
//				else
//				{
//					Log.debug( "没有销毁 路径："+frame.url + "：referenceCount=="+frame.referenceCount);
//				}
			}
//			if( SwfFrames.isDispose(frame.url) )
//			{
//				Log.debug( "===确认销毁==" + frame.url);
////				trace("空闲内存："+ System.freeMemory/1024 + "  总内存："+System.totalMemory/1024);
//			}
		}
	}
}