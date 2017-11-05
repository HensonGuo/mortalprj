/**
 * @date	2011-4-12 下午01:23:00
 * @author  jianglang
 * 
 */	

package mortal.common.swfPlayer.data
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class ModelData
	{
		private static var _dataMap:Dictionary = new Dictionary();
		
		public static var Shadow:BitmapData = GlobalClass.getBitmapData("Shadow");
		
		public function ModelData()
		{
			
		}
		
		public static function addData( url:String , data:IMovieClipData ):void
		{
			_dataMap[url] = data;
		}
		
		public static function getData( url:String ):IMovieClipData
		{
			return _dataMap[url];
		}
		
		public static function dispose():void
		{
			for each( var data:IMovieClipData in _dataMap  )
			{
				if( data.referenceCount == 0 )
				{
					data.dispose();
				}
			}
		}
	}
}
