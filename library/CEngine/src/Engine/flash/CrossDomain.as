package Engine.flash
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	
	public class CrossDomain
	{ 
		public function CrossDomain()
		{
			
		}
		public static function connect(ip:String,port:int):void
		{ 
			var _socket:Socket = new Socket();
			_socket.addEventListener(Event.CONNECT, onConnectHandler);
			_socket.addEventListener(Event.CLOSE, onCloseHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			_socket.connect(ip,port);
		}
		
		private static function onConnectHandler(event:Event):void
		{
			var socket:Socket = event.target as Socket;
			socket.close();
		}
		
		private static function onIOErrorHandler(event:IOErrorEvent):void
		{
			log(event.text);
		}
		private static function onCloseHandler(event:Event):void
		{
			log("closed");
		}
		private static function onSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			log(event.text);
		}
		
		private static function log(str:String):void
		{
			trace("CrossDomain:"+str);
		}
	}
}