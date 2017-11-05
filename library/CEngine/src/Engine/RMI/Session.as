package Engine.RMI
{
	import Framework.Holder.ArrayHolder;
	import Framework.MQ.IMessageHandler;
	import Framework.MQ.MessageBlock;
	import Framework.Serialize.SerializeStream;
	import Framework.Util.IDMap;
	
	public class Session
	{
		public function Session()
		{
			_messageWaitToSend = new Array();
			_bindingObject = new Array();
			_messageMap = new IDMap();
			_keepActivePrx = new IKeepActivePrxHelper();
			_keepActivePrx.bindingSession( this );
		}
		
		public function get keepActivePrx() : IKeepActivePrx
		{
			return _keepActivePrx;
		}
		
		public function get connection() : RMIConnection
		{
			return _connection;
		}
		
		public function set connection( v : RMIConnection ) : void
		{
			_connection = v ;
		}
		
		public function get communicator() : Communicator
		{
			return _communicator;
		}
		
		public function set communicator( v : Communicator ) : void
		{
			_communicator = v ;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		public function set name( v : String ) : void
		{
			_name = v ;
		}
		
		public function get messageHandler() : IMessageHandler
		{
			return _messageHandler;
		}
		
		public function set messageHandler( messageHandler : IMessageHandler ) : void
		{
			_messageHandler = messageHandler;
		}
		
		public function bindCommunicator( v : Communicator ) : void
		{
			if( this._connection != null )
			{
				this._connection.close();				
				this._connection = null;
			}
			communicator = v;
			communicator.session = this;
		}
		
		/**
		 * to remove back object
		 * */
		public function removeBackObject( messageId : int ) : Boolean
		{
			return _messageMap.remove( messageId );
		}
		
		/**
		 * to find and remove back object amd remove timer
		 * */
		public function findRemoveBackObject( messageId : int  ) : RMIObjectBind
		{
			var objectBind : RMIObjectBind = _messageMap.findAndRemove( messageId ) as RMIObjectBind;
			if( null != objectBind )
			{
				objectBind.resertTimer();
			}
			return objectBind;
		}
		
		/**
		 * to add back object and add timer
		 * */
		public function addBackObject( rmiObject : RMIObjectBind , timerOut : int ) : int
		{
			//return 
			var messageId : int =  _messageMap.insert( rmiObject );
			if( messageId > 0 )
			{
				rmiObject.initTimer( timerOut );
			}
			return messageId;
		}
		
		
		public function findObject( identity : SIdentity ) : RMIObject
		{
			var objectTemp : RMIObject
			for( var i : int = 0 ; i < _bindingObject.length ; i ++ )
			{
				objectTemp = _bindingObject[i] as RMIObject;
				if( objectTemp.identity.name == identity.name )
				{
					return objectTemp;
				}
			}
			return null;
		}
		/***
		 * to binding object
		 * */
		public function bindingObject( identity : SIdentity , rmiObject : RMIObject ) : Boolean
		{
			var objectTemp : RMIObject;
			for( var i : int = 0 ; i < _bindingObject.length ; i ++ )
			{
				objectTemp = _bindingObject[i] as RMIObject;
				if( objectTemp.identity.name == identity.name )
				{
					return false;
				}
			}
			rmiObject.identity = identity;
			_bindingObject.push( rmiObject );
			return true;
		}
		
		/***
		 * to remove object
		 * */
		public function remove( identity : SIdentity ) : Boolean
		{
			var objectTemp : RMIObject;
			//to func object
			for(  var i : int = 0 ; i < _bindingObject.size() ; i ++ )
			{
				objectTemp = _bindingObject[i] as RMIObject;
				if( objectTemp.identity.name == identity.name )
				{
					_bindingObject.splice( i, 1 );
					return true;
				}
			}
			return false;
		}
		
		//to push out message
		public function pushMessage( mb : MessageBlock ):void
		{
			var os : SerializeStream = new SerializeStream();
			var context : Context = new Context;
			context._session = this;
			context._connection = this.connection;
			context._messageId = 0;
			context._dispachStatus = ERMIDispatchStatus.DispatchAsync;
			context._messageType = ERMIMessageType.MessageTypeMQ;
			mb.__write( os );
			Outgoing.invokeAsyncNoBack( context , null , os );
		}
		
		//pink messages
		public function pinkMessage( v : ArrayHolder ):void
		{
			v.value = _messageWaitToSend;
			_messageWaitToSend = new Array();
		}
		//pink messages
		public function pinkRemoveMessage( v : ArrayHolder ):void
		{
			v.value = new Array() ;
			var j : int = 0;
			for( var i : int = 0 ; i < _messageWaitToSend.length ; i ++ )
			{
				var objectBind : RMIObjectBind = findRemoveBackObject( (_messageWaitToSend[i] as RMIObjectBind).messageId );
				if( null != objectBind )
				{
					objectBind.resertTimer();
					v.value[ j++ ] = objectBind ;
				}
			}
			_messageWaitToSend = new Array();
		}
		
		//push message
		public function addMessage( v : RMIObjectBind ):void
		{
			_messageWaitToSend.push( v );
		}
		
		//abandon
		public function abandon():void
		{
			if( this._connection != null )
			{
				this._connection.close();				
				this._connection = null;
			}
			
			_messageMap = new IDMap();
			_messageWaitToSend = new Array();
			_bindingObject = new Array();
		}
		
		//the comminicator
		private var _communicator : Communicator;
		
		//the connecton of the object
		private var _connection:RMIConnection;
		
		//the message send Map
		private var _messageMap:IDMap;
		
		//the send object
		private var _messageWaitToSend : Array;
		
		//the send object
		private var _bindingObject : Array;
		
		//the keep active prx
		private var _keepActivePrx : IKeepActivePrxHelper;
		
		//the name
		private var _name : String;
		
		//the message handler
		private var _messageHandler : IMessageHandler;
	}
}