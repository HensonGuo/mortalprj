package frEngine.loaders.resource.encryption
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class EncryptUtils
	{
		public static const JPG:String="jpg";
		public static const SWF:String="swf";
		public static const PNG:String="png";
		public static const ATF:String="atf";
		public static const DDS:String="dds";
		public static const TGA:String="tga";
		public static const NULL:String="null";
		public static const MEGER:String="meger";
		
		public static const extensionName:String="abc";
		
		public static const extensionCompress:String="cmp0";
		public static const extensionCompress_alpha:String="cmp1";
		public static const extensionCompress_bgra:String="cmp2";
		
		public static const normalJpgValue:int=-520103681;
		public static const normalJpgValue2:int=-503326465;
		public static const normalPngValue:int=1196314761;
		public static const normalDDSValue:int=542327876;
		public static const normalTGAValue:int=131072;
		
		private static const baseNum:int=10000;
		/**
		 * 10000-20000 为abc
		 * 20000-30000为jpg 
		 * 30000-40000为png
		 * 40000-50000为swf 
		 * 50000-60000为dds
		 * 60000-70000为tga
		 * 70000-80000为atf
		 * 80000-90000为meger
		 */		
		public static function getExtensionByValue(value:int):String
		{
			if(value<baseNum)
			{
				if(value==normalJpgValue || value==normalJpgValue2)
				{
					return JPG;
				}else
				{
					return NULL;
				}
			}else if(value<2*baseNum)
			{
				return EncryptUtils.extensionName;
			}else if(value<3*baseNum )
			{
				return JPG;
			}else if(value<4*baseNum || value==normalPngValue)
			{
				return PNG;
			}else if(value<5*baseNum || checkIsSwf(value))
			{
				return SWF;
			}else if(value<6*baseNum || value==normalDDSValue)
			{
				return DDS;
			}else if(value<7*baseNum || value==normalTGAValue)
			{
				return TGA;
			}else if(value<8*baseNum || isATF(value))
			{
				return ATF;
			}else if(value<9*baseNum)
			{
				return MEGER;
			}else
			{
				return NULL;
			}
		}
		public static function getContentExtension():String
		{
			return null;
		}
		private static function checkIsSwf(value:int):Boolean
		{
			
			var value0:int=value&0x000000ff;
			var value1:int=value&0x0000ff00;
			var value2:int=value&0x00ff0000;
			if(value1==0x00005700 && (value0==0x00000046||value0==0x00000043) && value2==0x00530000)
			{
				return true;
			}
			return false;
		}
		private static function isATF(value:int):Boolean
		{
			var value0:int=value&0x00ffffff;
			if(value0==4609089)
			{
				return true;
			}
			return false;
		}
		public static function encodeAndMegerStream(jpgBytes:ByteArray,pngBytes:ByteArray):ByteArray
		{
			var bytes:ByteArray=new ByteArray();
			bytes.endian=Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(getTypeValueByExtension(EncryptUtils.extensionName));
			
			bytes.writeInt(getTypeValueByExtension(EncryptUtils.MEGER));
			
			bytes.writeUnsignedInt(jpgBytes.bytesAvailable);
			
			bytes.writeBytes(jpgBytes);
			
			bytes.writeUnsignedInt(pngBytes.bytesAvailable);
			
			bytes.writeBytes(pngBytes);
			
			return bytes;
			
		}
		public static function encodeStream(info:EncryptionInfo):ByteArray
		{
			var bytes:ByteArray=new ByteArray();
			bytes.endian=Endian.LITTLE_ENDIAN;
			if(info.encryptType==null)
			{
				bytes.writeInt(getTypeValueByExtension(EncryptUtils.extensionName));
			}else
			{
				bytes.writeInt(getTypeValueByExtension(info.encryptType));
			}
			
			bytes.writeInt(getTypeValueByExtension(info.contentType));
			bytes.writeBytes(info.contentBytes);
			return bytes;
		}
		public static function decodeStream(bytes:ByteArray):EncryptionInfo
		{
			var contentBytes:ByteArray;
			
			var encryptValue:int;
			var encryptType:String;
			var contentType:String;
			bytes.endian=Endian.LITTLE_ENDIAN;
			bytes.position=0;
			encryptValue=bytes.readInt();
			var isNormalFile:Boolean=checkIsNormalFile(encryptValue);
			var otherBytes:ByteArray;
			if(isNormalFile)
			{
				contentType=getExtensionByValue(encryptValue);
				encryptType=null;
				contentBytes=bytes;
			}else if(encryptValue<8*baseNum && encryptValue>=baseNum)
			{
				encryptType=getExtensionByValue(encryptValue);
				contentType=getExtensionByValue(bytes.readInt());
				if(contentType==MEGER)
				{
					var jpgBytesLen:uint=bytes.readUnsignedInt();
					var jpgBytes:ByteArray=new ByteArray();
					jpgBytes.endian=Endian.LITTLE_ENDIAN;
					bytes.readBytes(jpgBytes,0,jpgBytesLen);
					
					var pngBytesLen:uint=bytes.readUnsignedInt();
					var pngBytes:ByteArray=new ByteArray();
					pngBytes.endian=Endian.LITTLE_ENDIAN;
					bytes.readBytes(pngBytes,0,pngBytesLen);
					
					contentBytes=jpgBytes
					otherBytes=pngBytes;
				}else
				{
					contentBytes=new ByteArray();
					contentBytes.endian=Endian.LITTLE_ENDIAN;
					bytes.readBytes(contentBytes,0,bytes.bytesAvailable);
				}
				
			}else
			{
				throw new Error("不合法类型文件,如是"+EncryptUtils.extensionName+"文件，请重新加密！");
			}
			return new EncryptionInfo(encryptType,contentBytes,contentType,otherBytes);
		}
		public static function checkIsNormalFile(typeValue:int):Boolean
		{
			if(typeValue==normalJpgValue || typeValue==normalJpgValue2 || typeValue==normalPngValue)
			{
				return true;
			}else if(typeValue==normalDDSValue || typeValue==normalTGAValue || isATF(typeValue) || checkIsSwf(typeValue))
			{
				return true;
			}else
			{
				return false;
			}
			
		}
		/**
		 * 10000-20000 为abc
		 * 20000-30000为jpg 
		 * 30000-40000为png
		 * 40000-50000为swf 
		 * 50000-60000为dds
		 * 60000-70000为tga
		 * 70000-80000为atf
		 */		
		public static function getTypeValueByExtension(value:String):int
		{
			value=value.toLowerCase();
			var resutl:int=Math.random()*baseNum;
			if(value==EncryptUtils.extensionName)
			{
				return resutl+baseNum;
			}else if(value==JPG)
			{
				return resutl+baseNum*2;
			}else if(value==PNG)
			{
				return resutl+baseNum*3;
			}else if(value==SWF)
			{
				return resutl+baseNum*4;
			}else if(value==DDS)
			{
				return resutl+baseNum*5;
			}else if(value==TGA)
			{
				return resutl+baseNum*6;
			}else if(value==ATF)
			{
				return resutl+baseNum*7;
			}else if(value==MEGER)
			{
				return resutl+baseNum*8;
			}else
			{
				throw new Error("扩展名称有误！");
			}
		}
	}
}

