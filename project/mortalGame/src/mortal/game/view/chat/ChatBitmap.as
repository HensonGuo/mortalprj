package mortal.game.view.chat
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class ChatBitmap extends Bitmap
	{
		public function ChatBitmap(bitmapData:BitmapData=null,pixelSnapping:String="auto",smoothing:Boolean = false)
		{
			super(bitmapData,pixelSnapping,smoothing);
		}
		
		override public function set filters(value:Array):void
		{
			
		}
	}
}