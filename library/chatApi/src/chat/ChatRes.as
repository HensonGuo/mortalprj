package chat
{
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class ChatRes
	{
		public function ChatRes()
		{
		}
		
		public static function getBitmap(cls:Class):Bitmap
		{
			return new Bitmap(new cls(0,0) as BitmapData);
		}
		
		public static function getScaleBitmap( cls:Class ,scale9Grid:Rectangle=null):ScaleBitmap
		{
			var bmd:BitmapData = new cls(0,0) as BitmapData;
			if(bmd != null)
			{
				var sb:ScaleBitmap = new ScaleBitmap(bmd.clone());
				sb.scale9Grid = scale9Grid;
				return sb;
			}
			return null;
		}
	}
}