package Engine.RMI
{
	public final class Context
	{
		public function Context()
		{
		}
		
		/**
		 * the session
		 * */
		public var _session : Session;
		
		/**
		 * the connection
		 * */
		public var _connection : RMIConnection;
		
		/**
		 * the messageid
		 * */
		public var _messageId : int;
		
		/**
		 * the dispachStatus
		 * */
		public var _dispachStatus : ERMIDispatchStatus;
		
		/**
		 * 超时时间
		 * */
		public var _timeOut : int;
		
		/***
		 * 消息类型
		 * */
		public var _messageType : ERMIMessageType;
	}
}