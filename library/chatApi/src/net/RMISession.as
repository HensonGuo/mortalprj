package net
{
	import Engine.RMI.Communicator;
	import Engine.RMI.CommunicatorManager;
	import Engine.RMI.RMIProxyObject;
	import Engine.RMI.Session;
	
	import Framework.Protocol.CDFProtocol.GroupProtocol;
	import Framework.Protocol.CDFProtocol.Protocol;

	public class RMISession
	{
		private var _session:Session;
		private var _url:String;
		private var _comm:Communicator;
		
		public function RMISession()
		{
			
		}
		
		public function get session():Session
		{
			return _session;
		}

		public function set url( value:String ):void
		{
			if( _url != value )
			{
				_url = value;
				_session = new Session();
				createCommunicator();
				_session.bindCommunicator(_comm);
			}
		}
		public function get url():String
		{
			return _url;
		}
		
		
		protected function createCommunicator():Communicator
		{
			_comm = CommunicatorManager.getInstance().createCommunicator( _url, new GroupProtocol( new Protocol() ) );
			//comm.sessionEvent = new RMISessionEvent();
			//comm.prepareCommandHandler = new PrepareCommand();
			return _comm;
		}
		
		public function registerProxy( proxy:RMIProxyObject ):void
		{
			proxy.bindingSession(_session);
		}
	}
}