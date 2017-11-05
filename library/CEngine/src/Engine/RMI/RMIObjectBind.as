package Engine.RMI
{
	import Framework.Serialize.SerializeStream;
	import Framework.Util.Exception;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class RMIObjectBind
	{
		public static const EOutGoingWaitToSend : int = 0;
		public static const EOutGoingTimeOut : int = 1;
		public static const EOutGoingComplate : int = 2;
		
		public function RMIObjectBind()
		{
			_outgoingStatus = EOutGoingWaitToSend;
			_createTimer = getTimer();
		}
		public function initTimer( timeOut : int ) : void
		{
			//assert( _timer );
			if( timeOut >=0 )
			{
				_timer = new Timer( timeOut , 1 );
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, this.onComplete );
				_timer.start();
			}
		}
		
		public function resertTimer() : void
		{
			if( _timer )
			{
				_timer.reset();
				_timer = null;
			}
		}
		
				
		private function onComplete( ev : TimerEvent ):void
		{
			//if( _outgoingStatus == EOutGoingComplate )
			//{
			//	return;
			//}
			_session.removeBackObject( this.messageId );
			if( null != _timer )
			{
				_timer.reset();
			}
			_outgoingStatus = EOutGoingTimeOut ;
			if( _rmiObject != null )
			{
				var ex : TimeoutException = new TimeoutException() ;
				if( _session.communicator.prepareCommandHandler )
				{
					_rmiObject.usedTimer = getTimer() - this._createTimer;
					_session.communicator.prepareCommandHandler.prepareBackException( 
																					_rmiObject ,
																					ex 
						 														);
				}
				_rmiObject.cdeException( ex )
			}
		}
		
		public function __back( context : Context ,  stream : SerializeStream ) : void
		{
			_outgoingStatus = EOutGoingComplate;
			if( context._dispachStatus.equals( ERMIDispatchStatus.DispatchOK ) )
			{
				if( _session.communicator.prepareCommandHandler )
				{
					_rmiObject.usedTimer = getTimer() - this._createTimer;
					_session.communicator.prepareCommandHandler.prepareBackCommand( _rmiObject );
				}
				rmiObject.__response( stream );
			}
			else if(  context._dispachStatus.equals( ERMIDispatchStatus.DispatchException ) )
			{
				var ex : Exception = new Exception();
				stream.readException( ex );
				if( _session.communicator.prepareCommandHandler )
				{
					_rmiObject.usedTimer = getTimer() - this._createTimer;
					_session.communicator.prepareCommandHandler.prepareBackException( 
																					_rmiObject ,
																					ex 
						 														);
				}
				_rmiObject.cdeException( ex );
			}
		}
		/**
		* out data
		*/
		public function __response( dispatchStatus : ERMIDispatchStatus , __os : SerializeStream ) : void
		{
			if( _messageId == 0 )
			{
				return;
			}
			
			var back : SRMIReturn = new SRMIReturn();
			back.messageId = _messageId;
			back.dispatchStatus = dispatchStatus;
			
			var context : Context = new Context();
			context._session = session;
			context._connection = session.connection;
			
			Outgoing.dispatch( context , back , __os );
			
		}
		
		/**
		* out data
		*/
		public function __exception( ex : Exception ) : void
		{
			if( _messageId == 0 )
			{
				return;
			}
			
			var back : SRMIReturn = new SRMIReturn();
			back.messageId = _messageId;
			back.dispatchStatus = ERMIDispatchStatus.DispatchException ;
			
			var context : Context = new Context();
			context._session = session;
			context._connection = session.connection;
			
			var __os : SerializeStream = new SerializeStream();
			__os.writeException( ex );
			
			Outgoing.dispatch( context , back , __os );
		}
		
		public function set session( v : Session ) : void 
		{
			_session = v ;
		}
		
		public function get session() : Session 
		{
			return _session;
		}
		
		//the user object
		public function set rmiObject( rmiObject : RMIObject ): void
		{
			_rmiObject = rmiObject;
		}
		public function get rmiObject() : RMIObject
		{
			return _rmiObject;
		}
		
		//the buffer
		public function set buffer( buff : SerializeStream ): void
		{
			_buffer = buff;
		}
		public function get buffer() : SerializeStream
		{
			return _buffer;
		}
		
		//the out going status
		public function set outgoingStatus( v : int ): void
		{
			_outgoingStatus = v;
		}
		public function get outgoingStatus() : int
		{
			return _outgoingStatus;
		}
		
		//the message id
		public function set messageId( v : int ): void
		{
			_messageId = v;
		}
		public function get messageId() : int
		{
			return _messageId;
		}
		private var _session : Session;
		//private var _rmiCallModel : ERMICallModel;       //the call model
		private var _rmiObject : RMIObject;              //the rmi object
		private var _buffer : SerializeStream;           //the buffer to write and read
		//private var _dispatchStatus : ERMIDispatchStatus ;     //the dispatch status
		private var _outgoingStatus : int;     //the out going status
		private var _messageId : int;          //the message id
		private var _timer : Timer;
		private var _createTimer : Number ;
	}
}