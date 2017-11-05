package Framework.MQ
{
	public class MessageBlock
	{
		import Framework.Serialize.SerializeStream;
		
		public function MessageBlock()
		{
			_messageHead = new MessageHead();
		}
		
		
		public function __write( __os :SerializeStream ) : void
		{
			__writeHead( __os );
			__writeBody( __os );
		}
		
		public function __writeHead( __os :SerializeStream ) : void
		{
			_messageHead.__write( __os );
		}
		
		public function __writeBody( __os :SerializeStream ) : void
		{
			if( _messageBase )
			{
				__os.writeSize( _messageBase.getType() );
				_messageBase.__write( __os );
				if ( _messageBase.msgEx )
				{
					__os.writeByte( 1 );
					_messageBase.msgEx.__write( __os );
				}
				else
				{
					__os.writeByte( 0 );
				}
			}
			else
			{
				__os.writeSize( 0 );
			}
		}
		
		public function __read( __is : SerializeStream ) : void
		{
			__readHead( __is );
			__readBody( __is );
		}
		
		public function __readHead( __is : SerializeStream ) : void
		{
			_messageHead.__read( __is );
		}
		
		public function __readBody( __is : SerializeStream ) : void
		{
			var type : int = __is.readSize();
			if( type != 0 )
			{
				_messageBase = MessageManager.instance().createMessage( type );
//				if(!_messageBase)
//				{
//					return;
//				}
				_messageBase.__read( __is );
				var msgEx : int = __is.readByte();
				if ( msgEx != 0 )
				{
					_messageBase.msgEx = new IMessageEx();
					_messageBase.msgEx.__read(__is);
				}
			}
		}
		
		public function get messageHead() : MessageHead
		{
			return _messageHead;
		}
		public function set messageHead( messageHead : MessageHead ) : void
		{
			this._messageHead = messageHead;
		}
		
		public function get messageBase() : IMessageBase
		{
			return _messageBase;
		}
		public function set messageBase( messageBase : IMessageBase ) : void
		{
			this._messageBase = messageBase;
		}
		
		private var _messageHead:MessageHead;
		private var _messageBase:IMessageBase;
	}
}