package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.ImageInfo;
	
	import flash.utils.ByteArray;
	
	import baseEngine.core.Texture3D;
	
	import frEngine.loaders.resource.encryption.EncryptUtils;
	import frEngine.loaders.resource.encryption.EncryptionInfo;
	import frEngine.loaders.resource.info.image.DDSParser;
	import frEngine.loaders.resource.info.image.TgaParser;

	public class ABCInfo extends ImageInfo
	{

		private var _isATF:Boolean;
		
		private var _ATFByteArray:ByteArray;
		
		public var bmpWidth:int=-1;
		
		public var bmpHeight:int=-1;

		
		public function ABCInfo(object:Object)
		{
			super(object);
		}

		public function get isATF():Boolean
		{
			return _isATF;
		}
		
		public function get format():int
		{
			switch(this.type.toLowerCase())
			{
				case ".cmp0": return Texture3D.FORMAT_COMPRESSED;
				case ".cmp1": return Texture3D.FORMAT_COMPRESSED_ALPHA;
				case ".cmp2": return Texture3D.FORMAT_COMPRESSED_BGRA;
				default:return Texture3D.FORMAT_RGBA
			}
		}
		public override function dispose():void
		{
			if(_bitmapData)
			{
				_bitmapData.dispose();
				_bitmapData=null;
			}
			_ATFByteArray=null;
			bmpWidth=-1;
			bmpHeight=-1;
			super.dispose();
			
		}
		public function get ATFByteArray():ByteArray
		{
			return _ATFByteArray;
		}
		override public function set data(value:Object):void
		{
			super.data=value;
			if(value is EncryptionInfo)
			{
				var curBytesInfo:EncryptionInfo=value as EncryptionInfo;
				_isATF=(curBytesInfo.contentType==EncryptUtils.ATF);
				switch(curBytesInfo.contentType)
				{
					case EncryptUtils.TGA:
						var tga:TgaParser=new TgaParser(curBytesInfo.contentBytes);
						_bitmapData=tga.getImage();
						break;
					case EncryptUtils.DDS:
						var dds:DDSParser=new DDSParser(curBytesInfo.contentBytes);
						dds.proceedParsing();
						_bitmapData=dds.getResultLevelImg(0);
						break
					case EncryptUtils.ATF:
						_ATFByteArray=curBytesInfo.contentBytes;
						break;
				}
			}
			if(_bitmapData)
			{
				bmpWidth=_bitmapData.width;
				bmpHeight=_bitmapData.height;
			}
			if(_ATFByteArray)
			{
				bmpWidth = Math.pow(2, _ATFByteArray[7]);
				bmpHeight = Math.pow(2, _ATFByteArray[8]);
			}
		}
	}
}

