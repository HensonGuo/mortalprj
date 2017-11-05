package Engine.RMI
{
	import Engine.flash.EventSender;
	
	import Framework.Protocol.CDFProtocol.Protocol;
	import Framework.Protocol.IProtocol;
	
	public class Communicator extends EventSender
	{
		public function Communicator( protocol : IProtocol )
		{
			_connecting = false;
			_connected = false;
			_connection = new RMIConnection( protocol );
		}
		
		public function connect() : Boolean
		{
			_connecting = true;
			try
			{
				_connection.session = this.session;
				var array : Array = url.split( ":" );
				var ip : String ;
				var port : int ;
				if( array.length == 2 )
				{
					ip = array[0];
					port = parseInt( array[1] );
				}
				else
				{
					return false;
				}
				this.connection.connect( ip , port );
				return true;
			}
			catch( ex : Error )
			{
				_connecting = false;
				trace( "Communicator::connect.connect error" );
			}
			return false;
		}
		
		public function set connecting( v : Boolean ) : void
		{
			_connecting = v;
		}
		public function get connecting() : Boolean
		{
			return _connecting;
		}
		
		public function set connected( v : Boolean ) : void
		{
			_connected = v;
		}
		public function get connected() : Boolean
		{
			return _connected;
		}
		
		public function set url( v : String ) : void
		{
			_url = v;
		}
		public function get url() : String
		{
			return _url;
		}
		
		
		public function get connection() : RMIConnection
		{
			return _connection;
		}
		
		public function set session( v : Session ) : void
		{
			_session = v;
		}
		public function get session() : Session
		{
			return _session;
		}
		
		public function set sessionEvent( v : IRMISessionEvent ) : void
		{
			_sessionEvent = v;
		}
		
		public function get sessionEvent() : IRMISessionEvent
		{
			return _sessionEvent;
		}
		
		public function set prepareCommandHandler( v : IRMIPrepareCommandHandler ) : void
		{
			_prepareCommandHandler = v;
		}
		
		public function get prepareCommandHandler() : IRMIPrepareCommandHandler
		{
			return _prepareCommandHandler;
		}
		
		private var _connecting : Boolean;
		private var _connected : Boolean;
		private var _url : String;
		private var _connection : RMIConnection;
		private var _session : Session;	
		private var _sessionEvent : IRMISessionEvent;	
		private var _prepareCommandHandler : IRMIPrepareCommandHandler;
}
}