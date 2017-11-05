package mortal.common.pools
{
	import flash.display.BitmapData;

	public class BitmapDataItem
	{
		public var bitmapData:BitmapData;
		public var x:Number = 0;
		public var y:Number = 0;
		
		public function BitmapDataItem( bitmapData:BitmapData=null,x:Number=0,y:Number=0 )
		{
			this.bitmapData = bitmapData;
			this.x = x;
			this.y = y;
		}
	}
}