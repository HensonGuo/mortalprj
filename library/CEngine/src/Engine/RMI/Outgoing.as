package Engine.RMI
{
	import Framework.Serialize.SerializeStream;
	import Framework.Util.Exception;
	
	public class Outgoing
	{
		public function Outgoing()
		{
		}
		
				/**
		* to invoke to the server
		*/
		public static function dispatch( 
			context : Context , 
			call : SRMIReturn ,
			os :SerializeStream ) : Boolean
		{
			if( !context._connection )
			{
				return false;	
			}
			var os1 :SerializeStream = new SerializeStream();
			ERMIMessageType.MessageTypeCallRet.__write( os1 );
			call.__write( os1 );
			os1.writeByteArray( os );
			return context._connection.send( os1.byteArray ) != -1;
		}
		/**
		 * to invoke
		 * */
		public static function invokeAsync( 
			context : Context , 
			call : SRMICall ,
			__os : SerializeStream ,
			backObject : RMIObject ): void
		{
			if(context._session.communicator == null)
			{
				var ex: Exception = new Exception("ExceptionCodeNotInstantiation",
									RMIException.ExceptionCodeNotInstantiation);
				backObject.cdeException( ex );
			    return;
			};
			var prepareCommandHandler : IRMIPrepareCommandHandler 
				= context._session.communicator.prepareCommandHandler;
			if( null != prepareCommandHandler )
			{
				if( !prepareCommandHandler.prepareCommand( call , context , backObject )  )
				{
					return;
				}
			}
			if( null == backObject )
			{
				invokeAsyncNoBack( context , call , __os );
			}
			else
			{
				invokeAsyncBack( context , call , __os , backObject );
			}
		}
		
		private static function invokeAsyncBack( 
			context : Context , 
			call : SRMICall ,
			__os : SerializeStream ,
			backObject : RMIObject ): void
		{
			var objectBind : RMIObjectBind = new RMIObjectBind();
			var ex : Exception;
			backObject.identity = call.identity;
			objectBind.messageId = context._session.addBackObject( objectBind , context._timeOut );
			objectBind.rmiObject = backObject;
			objectBind.outgoingStatus = RMIObjectBind.EOutGoingWaitToSend;
			objectBind.session = context._session;
						
			var __os1 : SerializeStream = new SerializeStream();
			
			ERMIMessageType.MessageTypeCall.__write( __os1 );
			
			call.callSynchType = ERMICallModel.CallModelAsync;
			call.messageId = objectBind.messageId;
			if( call.messageId <= 0 )
			{
				ex = new Exception(
					"Outgoing::context._session.addBackObject exception" ,
					 Exception.ExceptionCodeBase );
					 
				backObject.cdeException( ex );
			}
			
			call.__write( __os1 );
			
			__os1.writeByteArray( __os );
			
			if( context._connection == null )
			{
				context._connection = context._session.connection;
			}
			
			objectBind.buffer = __os1;
			if( context._connection == null )
			{
				if( context._session.communicator && !context._session.communicator.connecting )
				{
					if( context._session.communicator.connect() )
					{
						context._session.addMessage( objectBind );
						return;
					}
				}
				else
				{//to push message
					context._session.addMessage( objectBind );
				}
			}
			else
			{
				if( -1 == context._connection.send( __os1.byteArray ) )
				{
					context._session.findRemoveBackObject( call.messageId );
					ex = new RMIException("Outgoing::context._connection.send exception" , 
						RMIException.ExceptionCodeConnectionWrite );
					backObject.cdeException( ex );
				}
			}
		}
		
		public static function invokeAsyncNoBack( 
			context : Context , 
			call : SRMICall ,
			__os : SerializeStream ): void
		{//不需要关心返回值
			var objectBind : RMIObjectBind = new RMIObjectBind();
			
			objectBind.messageId = 0;
			objectBind.rmiObject = null;
			objectBind.outgoingStatus = RMIObjectBind.EOutGoingWaitToSend;
			
			var __os1 : SerializeStream = new SerializeStream();
			if( context._messageType &&
				context._messageType.equals( ERMIMessageType.MessageTypeMQ ) )
			{//如果是消息模式
				context._messageType.__write( __os1 );
			}
			else
			{//如果是异步模式
				ERMIMessageType.MessageTypeCall.__write( __os1 );
				call.messageId = 0;
				call.callSynchType = ERMICallModel.CallModelAsync;
				call.__write( __os1 );
			}
			__os1.writeByteArray( __os );
			
			if( context._connection == null )
			{
				context._connection = context._session.connection;
			}
			
			if( context._connection == null )
			{
				if( !context._session.communicator.connecting )
				{ 
					if( context._session.communicator.connect() )
					{
						objectBind.buffer = __os1;
						context._session.addMessage( objectBind );
						return;
					}
				}
			}
			else
			{
				context._connection.send( __os1.byteArray );
			}
		}
	}
}
