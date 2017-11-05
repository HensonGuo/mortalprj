package Framework.Protocol.CDFProtocol
{
	import flash.utils.ByteArray;
	
	public class ProtocolHead
	{
		public static const CDF_PROTOCOL_INT_VERSION : int = 1;
		public static const CDF_ENCODING_INT_VERSION : int = 1;
		
		public static const CDF_PROTOCOL_HEAD_SIZE : int = 24;
		
		public static const CDF_PROTOCOL_MAX_SIZE : int = (1024 * 500);
		
		public function ProtocolHead()
		{
			magic1 = String("C").charCodeAt();
			magic2 = String("D").charCodeAt();
			magic3 = String("E").charCodeAt();
			magic4 = String("!").charCodeAt();
			messageType = 0;
			compressionStatus = 0;
			this.reserve1 = 0;
			this.reserve2 = 0;
			protocol = CDF_PROTOCOL_INT_VERSION;
			encoding = CDF_ENCODING_INT_VERSION;
			messageSize = 0;
			verifyResult = 0;
			encryptStatus = 0;
			encryptAddLength = 0;
		}
		
		public function __read( v : ByteArray ):void
		{//to read data
			magic1 = v.readByte();
			magic2 = v.readByte();
			magic3 = v.readByte();
			magic4 = v.readByte();
			
			protocol = v.readByte();
			encoding = v.readByte();
			
			reserve1 = v.readByte();
			reserve2 = v.readByte();
			
			messageSize = v.readInt();
			verifyResult = v.readInt();
			
			messageType = v.readByte();
			compressionStatus = v.readByte();
			
			encryptStatus = v.readByte();
			encryptAddLength = v.readByte();
		}
		
		//to write head to array
		public function __write( v : ByteArray ):void
		{//to read data
			v.writeByte( magic1 );
			v.writeByte( magic2 );
			v.writeByte( magic3 );
			v.writeByte( magic4 );
			
			v.writeByte( protocol );
			v.writeByte( encoding );
			
			v.writeByte( reserve1 );
			v.writeByte( reserve2 );
			
			v.writeInt( messageSize );
			v.writeInt( verifyResult );
			
			v.writeByte( messageType );
			v.writeByte( compressionStatus );
			v.writeByte( encryptStatus );
			v.writeByte( encryptAddLength );
		}
		
		public var magic1 : int ;  //byte
		public var magic2 : int ;  //byte
		public var magic3 : int ;  //byte
		public var magic4 : int ;  //byte
		public var protocol : int ;   //int
		public var encoding : int ;   //int
		public var reserve1 : int ;   //int
		public var reserve2 : int ;   //int
		public var messageSize : int ; //int
		public var verifyResult : int ; //int
		public var messageType : int ; //byte
		public var compressionStatus : int ; //byte
		public var encryptStatus: int ;   //byte
		public var encryptAddLength: int ;   //byte
	}
}