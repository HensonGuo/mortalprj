package Engine.RMI
{
	import Engine.flash.EventSender;
	
	import Framework.Serialize.SerializeStream;
	import Framework.Util.Exception;
	
	public class RMIObject extends EventSender
	{
		public function RMIObject( response : Function = null , ex : Function = null )
		{
			_response = response;
			_ex = ex;
		}
		
		/*
		* on dispatch data
		*/
		public virtual function __dispatch( 
			context : Context , 
			rmiCall : SRMICall ,
			isStream : SerializeStream ,
			outStream : SerializeStream ) : ERMIDispatchStatus
		{
			return ERMIDispatchStatus.DispatchOK;
		}
		
		/**
		 * on response data
		 * */
		public virtual function __response( stream : SerializeStream ) : void
		{
		}
		
		public virtual function cdeException( ex : Exception ) : void
		{
			if( null != _ex )
			{
				_ex.call( this , ex  );
				return;
			}
			
			ex.method = "";
			if(_identity)
			{
				ex.method = _identity.name + ":";
			}else
			{
				trace("method:"+ex.method+" callFunction:"+_callFunction);
			}
			ex.method +=  _callFunction;
			RMIDispatcher.getInstance().dispatchErrorEvent( ex );
		}
		
		public function get identity() : SIdentity
		{
			return _identity;
		}
		public function set identity( v : SIdentity ): void
		{
			if(_identity == null)
			{
				_identity = new SIdentity();
			}
			_identity.name = v.name;
		}
		
		public function set name(value:String):void
		{
			if(_identity == null)
			{
				_identity = new SIdentity();
			}
			_identity.name = value;
		}
		public function get name():String
		{
			if(_identity)
			{
				return _identity.name;
			}
			return null;
		}
		public function set callFunction(value:String):void
		{
			_callFunction = value;
		}
		public function get usedTimer():Number
		{
			return _usedTimer;
		}
		public function set usedTimer( num : Number ):void
		{
			_usedTimer = num;
		}
		public function get callFunction():String
		{
			return _callFunction;
		}
		//the identity
		protected var _response : Function;
		protected var _ex : Function;
		private var _identity : SIdentity;
		private var _callFunction : String;
		private var _usedTimer: Number;
		public var userObject:Object;
	}
}