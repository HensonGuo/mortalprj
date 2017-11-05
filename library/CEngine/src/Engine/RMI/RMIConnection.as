package Engine.RMI
{
	import Engine.flash.EventSender;
	
	import Framework.Holder.ArrayHolder;
	import Framework.MQ.MessageBlock;
	import Framework.MQ.MessageManager;
	import Framework.Protocol.CDFProtocol.EncryptProtocol;
	import Framework.Protocol.CDFProtocol.Protocol;
	import Framework.Protocol.IProtocol;
	import Framework.Serialize.SerializeStream;
	import Framework.Util.Exception;
	import Framework.Util.IBusinessHandler;
	import Framework.Util.IIOHandler;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class RMIConnection extends EventSender
		implements IIOHandler , IBusinessHandler 
	{
		public function RMIConnection( protocol : IProtocol )
		{
			if( null == protocol )
			{
				_protocol = new Protocol();
			}
			else
			{
				_protocol = protocol;
			}
			_socket = new Socket();
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			_timer = new Timer(_delay);
			_timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
			_timeOutCount = 0;
			_keepActionBack = new AMI_IKeepActive_keepActive();
		}
		
		private function onTimerHandler(event:TimerEvent):void
		{
			//trace("心跳  "+ _timeOutCount);
			if( _session && _session.communicator && _session.communicator.connected )
			{
				//trace("_socket.connected "+_socket.connected);
				if( ++ _timeOutCount == 2 )
				{
					_session.keepActivePrx.keepActive_async(_keepActionBack);
					//trace("keepActivePrx 心跳");
				}
			}
		}
		
		public function get session() : Session
		{
			return _session;
		}
		public function set session( v : Session ) : void
		{
			this._session = v;
		}
		
		private function ioErrorHandler( evt:IOErrorEvent ):void
		{
//			trace(evt.toString());
			var text:String = evt.text;
			close();
			if( _session.communicator.sessionEvent )
			{
				_session.communicator.sessionEvent.onAbandon( _session );
			}
			processException( text , RMIException.ExceptionCodeConnectionWrite );
			
		}
		private function connectHandler(evt:Event):void
		{
			_timer.start();
			_timeOutCount = 0;
			dispatchEvent(new Event(Event.CONNECT));
			_session.connection = this;
			_session.communicator.connecting = false;
			_session.communicator.connected = true;
			var holder : ArrayHolder = new ArrayHolder();
			_session.pinkMessage( holder );
			for( var i : int = 0 ; i < holder.value.length ; i ++ )
			{
				var v : RMIObjectBind = holder.value[i] as RMIObjectBind;
				if( v.outgoingStatus == RMIObjectBind.EOutGoingWaitToSend )
				{
					if( -1 == send( v.buffer.byteArray ) )
					{						
						if( v.rmiObject )
						{
							_session.removeBackObject( v.messageId );
							
							var ex : Exception = new RMIException("RMIConnection:send fail" , 
									RMIException.ExceptionCodeConnectionWrite );
									
							v.rmiObject.cdeException( ex );
						}
					}
				}
			}
		}
		
		private function closeHandler(evt:Event):void
		{
			dispatchEvent(new Event(Event.CLOSE));
			trace("RMIConnection closeHandler");
			close();
			if( _session.communicator.sessionEvent )
			{
				_session.communicator.sessionEvent.onAbandon( _session );
			}
			processException( "Connected Close" , RMIException.ExceptionCodeConnectionClosed );
			this._protocol.clear();
		}
		
		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			trace("RMIConnection:"+evt.text);
			var text:String = _session.communicator.url +":"+ evt.text;
			
			_session.connection = null;
			_session.communicator.connecting = false;
			_session.communicator.connected = false;
			
			if( _session.communicator.sessionEvent )
			{
				_session.communicator.sessionEvent.onAbandon( _session );
			}
			processException( text , RMIException.ExceptionCodeConnectionNotConnect );
		}
		/***
		 * the byte array
		 * */
		private function socketDataHandler(evt:ProgressEvent):void
		{
//			trace("收到数据包",getTimer());
			var time:int = getTimer();
			/* if(_socket.bytesAvailable)
			{ */
				var bytesArray:ByteArray = new ByteArray();
				_socket.readBytes(bytesArray);
				if( -1 == _protocol.handleData( bytesArray , this , this , null ) )
				{
					throw new Error("网络数据处理失败");
				}
			//}
//			this.dispatchEvent(new DataEvent("网络数据处理时间",false,true,time.toString()));
		}
		
		public function connect(host:String, port:int):void
		{
			_session.communicator.connecting = true;
			_socket.connect(host, port);
		}
		
		public function close():void
		{
			_socket.close();
			_timer.removeEventListener(TimerEvent.TIMER,onTimerHandler);
			_timer.stop();
			_session.connection = null;
			_session.communicator.connecting = false;
			_session.communicator.connected = false;
			_timeOutCount = 0;
		}
		
		
		/***
		 * to send
		 * */
		public function send( outBuf : ByteArray ) : int
		{
			return _protocol.sendDataEncrypt( outBuf , this ) ? 0 : -1 ;
		}
		
		/***
		 * to send data
		 * */
		public function sendData( inBuf : ByteArray ) : int
		{
//			trace("发送数据包",getTimer());
			try
			{
				_timeOutCount = 0;
				_socket.writeBytes( inBuf, 0, inBuf.length );
				_socket.flush();
			}
			catch( ex : Error )
			{
				return -1;
			}
			return 0;
		}
		
		/***
		 * if the net message return
		 * */
		public function handlePacket( inBuf : ByteArray , handler : IBusinessHandler ) : Boolean
		{
//			trace("处理数据包",getTimer());
			//CSerializeStream is;
			//is.append( buf , length ); 
			var isStream : SerializeStream = new SerializeStream();
			isStream.byteArray = inBuf;
			var messageType : ERMIMessageType = ERMIMessageType.__read( isStream );
			if( messageType.equals( ERMIMessageType.MessageTypeCall ) )
			{//if is call
				var call : SRMICall = new SRMICall;
				call.__read( isStream );
				
				var rmiObject : RMIObject 
					= _session.findObject( call.identity );
				
				if( null == rmiObject )
				{//if not find the object
					trace( call.identity.name + " object not find" );
					return true;
				}
				var context : Context  = new Context();
				context._session = _session;
				context._connection = this;
				context._messageId = call.messageId;
				context._dispachStatus = ERMIDispatchStatus.DispatchOK;
				
				var outStream : SerializeStream = new SerializeStream();
				var dispatchStatus : ERMIDispatchStatus ;
				try
				{
					dispatchStatus = rmiObject.__dispatch( context , call , isStream , outStream );
				}
				catch( ex : Exception )
				{
					trace( ex.message );
					outStream.clear();
					outStream.writeException( ex );
					dispatchStatus = ERMIDispatchStatus.DispatchException;
				}
				if( call.messageId == 0 || dispatchStatus.equals( ERMIDispatchStatus.DispatchAsync ) )
				{
					return true;
				}
				
				var __os : SerializeStream = new SerializeStream();
				ERMIMessageType.MessageTypeCallRet.__write( __os );
				
				var callRet : SRMIReturn = new SRMIReturn;
				callRet.messageId = call.messageId;
				callRet.dispatchStatus = dispatchStatus;
				callRet.__write( __os );
				__os.writeByteArray( outStream );
				
				return send( __os.byteArray ) != -1;
			}
			else if( messageType.equals( ERMIMessageType.MessageTypeCallRet ) )
			{//if is call ret
				var callRet1 : SRMIReturn = new SRMIReturn;
				callRet1.__read( isStream );
				
				var rmiObjectBind : RMIObjectBind = _session.findRemoveBackObject( callRet1.messageId );
				if( rmiObjectBind == null )
				{
					trace( callRet1.messageId + " message id not find" );
					return true;
				}
				
				var context1 : Context  = new Context();
				context1._session = _session;
				context1._connection = this;
				context1._messageId = callRet1.messageId;
				context1._dispachStatus = callRet1.dispatchStatus;
				rmiObjectBind.__back( context1 , isStream );
			
			}
			else if( messageType.equals( ERMIMessageType.MessageTypeMQ ) )
			{//if is the message
				var mb:MessageBlock  = new MessageBlock;
				mb.__read( isStream );
				if( _session.messageHandler )
				{
					_session.messageHandler.onMessage( mb );
				}
			}
			return true;
		}
		
		private function processException(errorStr:String,code:int):void
		{
			var messageList : ArrayHolder = new ArrayHolder();
			_session.pinkRemoveMessage( messageList );
			var ex : Exception = new Exception(errorStr ,code);
			for( var i : int = 0 ; i < messageList.value.length ; i ++ )
			{
				var rmiObjectBind : RMIObjectBind = messageList.value[i] as RMIObjectBind;
				if( rmiObjectBind != null )
				{
					if( _session.communicator.prepareCommandHandler )
					{
						_session.communicator.prepareCommandHandler.prepareBackException( 
																					rmiObjectBind.rmiObject ,
																					ex 
						 														);
					}
					rmiObjectBind.rmiObject.cdeException( ex );
				}
			}
		}
		
		private var _socket : Socket ;
		private var _protocol : IProtocol;
		private var _session : Session;
		private var _timeOutCount : int;
		private var _timer:Timer;
		private var _delay:int = 10*1000;
		private var _keepActionBack:AMI_IKeepActive_keepActive;
	}
}