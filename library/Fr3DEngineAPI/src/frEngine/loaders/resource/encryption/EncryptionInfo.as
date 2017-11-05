package frEngine.loaders.resource.encryption
{
	import flash.utils.ByteArray;
	
	public class EncryptionInfo
	{
		public var encryptType:String;
		public var contentType:String;
		public var contentBytes:ByteArray;
		public var otherBytes:ByteArray;
		private var _extensionName:String;
		public function EncryptionInfo($encryptType:String,$contentBytes:ByteArray,$contentType:String,$otherBytes:ByteArray=null)
		{
			encryptType=$encryptType;
			contentBytes=$contentBytes;
			otherBytes=$otherBytes;
			contentType=$contentType;
			_extensionName=encryptType!=null?encryptType:contentType;
			_extensionName=_extensionName.toLowerCase();
			
			
		}
		public function get extensionName():String
		{
			return _extensionName;
		}
		public function get fileExtention():String
		{
			var targetNewExtentionName:String=EncryptUtils.extensionName;
			if(contentType==EncryptUtils.ATF)
			{
				contentBytes.position=6;
				var _local3:uint=contentBytes.readUnsignedByte();
				var cubemap:uint=(_local3 >> 7);
				var format:uint=(_local3 & 127);
				if(format<=1)
				{
					targetNewExtentionName=EncryptUtils.extensionCompress_bgra;
				}else if(format<=3)
				{
					targetNewExtentionName=EncryptUtils.extensionCompress;
				}else 
				{
					targetNewExtentionName=EncryptUtils.extensionCompress_alpha;
				}
			}
			return targetNewExtentionName;
		}
	}
}

