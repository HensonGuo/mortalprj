package Framework.Protocol.CDFProtocol
{
	import Framework.Protocol.IProtocol;
	import Framework.Serialize.SerializeStream;
	import Framework.Util.IBusinessHandler;
	import Framework.Util.IIOHandler;
	
	import flash.utils.ByteArray;
	
	public class GroupProtocol implements IProtocol,IBusinessHandler
	{
		public function GroupProtocol( buttonProtocol:IProtocol )
		{
			_buttonProtocol = buttonProtocol;
		}
		
		
		public function handleData( 
			inBuf : ByteArray ,
			businessHandle : IBusinessHandler,
			ioHandle : IIOHandler,
			fatherHandler : IBusinessHandler
		) : int
		{
			return _buttonProtocol.handleData( inBuf , this , ioHandle , businessHandle );
		}
		
		public function handlePacket( inBuf : ByteArray , handler :IBusinessHandler ):Boolean
		{
			while( inBuf.position < inBuf.length )
			{
				//CDF_GROUP_PROTOCOL_HEAD head;
				var size1: uint;
				var size: uint;
				size1 = inBuf.readUnsignedByte();
				if( size1 == 255 )
				{
					size = inBuf.readUnsignedInt();
				}
				else
				{
					size = size1;
				}
				var byteArray : ByteArray = new ByteArray();
				inBuf.readBytes( byteArray , 0 , size );
				handler.handlePacket( byteArray , null );
			}
			return true;
		}
		
		/**
		 * to out put data
		 * */
		public function sendDataEncrypt( 
			outBuf : ByteArray ,
			ioHandle : IIOHandler ) : Boolean
		{	
			var stream : SerializeStream = new SerializeStream();
			stream.writeSize( outBuf.length );
			stream.byteArray.writeBytes( outBuf, 0 , outBuf.length );
			stream.byteArray.position = 0;
			return _buttonProtocol.sendDataEncrypt( stream.byteArray , ioHandle );
		}
		
		public function clear():void
		{
			if( _buttonProtocol )
			{
				_buttonProtocol.clear();
			}
		}
		
		public function get buttonProtocol() : IProtocol
		{
			return _buttonProtocol;
		}
		
		public function set buttonProtocol( buttonProtocol : IProtocol ) : void
		{
			_buttonProtocol = buttonProtocol ;
		}
		private var _buttonProtocol : IProtocol;
	}
}