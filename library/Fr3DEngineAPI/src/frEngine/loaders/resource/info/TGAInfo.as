package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.ImageInfo;
	
	import flash.utils.ByteArray;
	
	import frEngine.loaders.resource.info.image.TgaParser;

	public class TGAInfo extends ImageInfo
	{
		public function TGAInfo(object:Object=null)
		{
			super(object);
		}
		override public function set data(value:Object):void
		{
			super.data = value;
			var tga:TgaParser=new TgaParser(ByteArray(value));
			this._bitmapData=tga.getImage();
		}
	}
}