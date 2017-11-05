package mortal.common.net
{
	import Engine.RMI.RMIProxyObject;
	
	import Framework.MQ.MessageHead;

	public class RMIBase
	{
		protected var session:RMISession;
		
		public function RMIBase()
		{
			
		}
		
		public function set rmiSession( value:RMISession ):void
		{
			session = value;
			initProxy();
		}
		
		protected function initProxy():void
		{
			
		}
		
		/**
		 * 是否连接服务器 
		 * @return 
		 * 
		 */		
		public function get isConnected():Boolean
		{
			if( session && session.session && session.session.communicator )
			{
				return session.session.communicator.connected;
			}
			return false;
		}
	}
}