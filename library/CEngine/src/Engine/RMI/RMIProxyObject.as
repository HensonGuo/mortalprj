package Engine.RMI
{
	import Framework.Serialize.SerializeStream;
	import Framework.Util.Exception;
	
	public class RMIProxyObject extends RMIObject 
	{	
		
			
		public function RMIProxyObject()
		{
			
		}		
		
		public function get session() : Session
		{
			return _session;
		}
		
		public function bindingSession( v : Session ): void
		{
			_session = v;
		}
		
		public function set timeOut( v : int ) : void
		{
			_timeOut = v;
		}
		
		public function get timeOut() : int
		{
			return _timeOut;
		}
		
		public function  makeContext( session:Session ):Context
		{
			var __context:Context = new Context();
        	__context._session = session;
        	__context._connection = session.connection;
        	__context._timeOut = _timeOut;
        	return __context;
		}
		

		public function makeCall(operation:String):SRMICall
		{
			var __call : SRMICall = new SRMICall();
       		__call.identity = identity;
       		__call.operation = operation;
       		return __call;
		}
		
		
		
		//the session
		private var _session : Session;
		private var _timeOut : int = RMIConfig.DefultTimeOut;
	}
}