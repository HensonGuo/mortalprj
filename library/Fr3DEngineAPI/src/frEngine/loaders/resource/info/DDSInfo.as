package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.ImageInfo;
	
	import flash.utils.ByteArray;
	
	import frEngine.loaders.resource.info.image.DDSParser;

	public class DDSInfo extends ImageInfo
	{
		public function DDSInfo(object:Object)
		{
			super(object);
		}
		override public function set data(value:Object):void
		{
			super.data = value;
			var dds:DDSParser=new DDSParser(ByteArray(value));
			dds.proceedParsing();
			this._bitmapData=dds.getResultLevelImg(0);
		}
	}
}