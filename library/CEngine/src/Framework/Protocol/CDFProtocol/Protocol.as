package Framework.Protocol.CDFProtocol
{
	import Framework.Protocol.IProtocol;
	import Framework.Util.IBusinessHandler;
	import Framework.Util.IIOHandler;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Endian;
	
	public class Protocol implements IProtocol
	{
		public function Protocol()
		{
			_readHead = false;
			_protocolHead = new ProtocolHead();
			_bytesBuffer = new ByteArray();
			_bytesBuffer.endian = Endian.LITTLE_ENDIAN;
		}
		
		/**
		 * to handle data
		 * */
	    public function handleData( 
			inBuf : ByteArray ,
			businessHandle:IBusinessHandler,
			ioHandle : IIOHandler,
			fatherHandler : IBusinessHandler
			) : int
		{//to handle data
			_bytesBuffer.position = _bytesBuffer.length;
			_bytesBuffer.writeBytes( inBuf, 0 , inBuf.length );
			_bytesBuffer.position = 0;
			while( true )
			{
				if( _readHead )
				{
					if( _bytesBuffer.length - _bytesBuffer.position 
						>= _protocolHead.messageSize )
					{
						var byteArray : ByteArray = new ByteArray();
						byteArray.endian = Endian.LITTLE_ENDIAN;
						_bytesBuffer.readBytes( byteArray , 0 , _protocolHead.messageSize );
						_readHead = false;
						//trace("compress:"+byteArray.length);
						if( _protocolHead.compressionStatus == 1 )
						{
							byteArray.uncompress();
							//trace("uncompress:"+byteArray.length);
						}
						if( !businessHandle.handlePacket( byteArray , fatherHandler ) )
						{
							return -1;
						}
					}
					else
					{
						break;
					}
				}
				else
				{
					if( _bytesBuffer.length - _bytesBuffer.position 
						< ProtocolHead.CDF_PROTOCOL_HEAD_SIZE )
					{
						break;
					}
					_protocolHead.__read( _bytesBuffer );
					_readHead = true;
					if( _protocolHead.messageSize > ProtocolHead.CDF_PROTOCOL_MAX_SIZE 
						|| _protocolHead.messageSize < 0 )
					{
						return -1;
					}
				}
			}
			if( _bytesBuffer.position != 0 )
			{
				var byteBuffer : ByteArray = new ByteArray();
				byteBuffer.writeBytes( _bytesBuffer , _bytesBuffer.position );
				_bytesBuffer = byteBuffer;
				_bytesBuffer.endian = Endian.LITTLE_ENDIAN;
			}
			return inBuf.length;
		}
		
		/**
		 * to out put data
		 * */
		public  function sendDataEncrypt( 
			outBuf : ByteArray ,
			ioHandle : IIOHandler
			) : Boolean
		{
			//to packed data
			if( outBuf.length > ProtocolHead.CDF_PROTOCOL_MAX_SIZE )
			{
				return false;
			}
			
			var byteArray : ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN ;
			
			var protocolHead : ProtocolHead = new ProtocolHead();
			protocolHead.messageSize = outBuf.length;
			protocolHead.__write( byteArray );
			
			byteArray.writeBytes( outBuf, 0 , outBuf.length );
			
			return ioHandle.sendData( byteArray ) != -1;
		}
		
		public function clear():void
		{
			_bytesBuffer.clear();
			_readHead = false;
		}
		
		private var _bytesBuffer : ByteArray; //the bytes buffer
		private var _readHead:Boolean;        //is read head
		private var _protocolHead : ProtocolHead;  //the protocol head last recv
	}
}