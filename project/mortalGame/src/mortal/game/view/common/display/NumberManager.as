/**
 * @heartspeak
 * 2014-3-17 
 */   	

package mortal.game.view.common.display
{
	import com.gengine.debug.Log;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ImageInfo;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	
	public class NumberManager
	{
		//对应嵌入的7种颜色
		public static const COLOR1:int = 1;
		public static const COLOR2:int = 2;
		public static const COLOR3:int = 3;
		public static const COLOR4:int = 4;
		public static const COLOR5:int = 5;
		public static const COLOR6:int = 6;
		public static const COLOR7:int = 7;
		
		public static var _bitmapDataMap:Dictionary = new Dictionary();
		
		public static var _textArray:Array = ["0","1","2","3","4","5","6","7","8","9","-","+"];
		public static var _colorArray:Array = [1,2,3,4,5,6,7];
		
		public function NumberManager()
		{
			
		}
		
		public static function getBitmapData(type:int,text:String):BitmapData
		{
//			return new BitmapData(21,25,true,0xFFFF0000);
			text = text.charAt(0);
			var imageInfo:ImageInfo = ResourceManager.getInfoByName("fightNumbers.png") as ImageInfo;
			//图片未加载完毕
			if(!imageInfo.bitmapData)
			{
				Log.error("嵌入数字资源未加载");
				return null;
			}
			else
			{
				var key:String = type + "_" + text;
				if(_bitmapDataMap[key])
				{
					return _bitmapDataMap[key];
				}
				else
				{
					var bitmapData:BitmapData = new BitmapData(21,25,true,0x00FFFFFF);
					var x:Number = _textArray.indexOf(text) * 512/24;
					var y:Number = _colorArray.indexOf(type) * 256/10;
					bitmapData.draw(imageInfo.bitmapData,new Matrix(1,0,0,1,-x,-y),null,null);
					_bitmapDataMap[key] = bitmapData;
					return bitmapData;
				}
			}
		}

	}
}