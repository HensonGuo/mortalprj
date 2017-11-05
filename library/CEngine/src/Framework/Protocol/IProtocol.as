package Framework.Protocol
{
	import Framework.Util.IBusinessHandler;
	import Framework.Util.IIOHandler;
	
	import flash.utils.ByteArray;
	
	public interface IProtocol
	{
		/**
		 * to handle data
		 * */
		function handleData( 
			inBuf : ByteArray ,
			businessHandle:IBusinessHandler,
			ioHandle : IIOHandler,
			fatherHandler : IBusinessHandler
			) : int ;
		
		/**
		 * to out put data
		 * */
		function sendDataEncrypt( 
			outBuf : ByteArray ,
			ioHandle : IIOHandler
			) : Boolean
			
			
		function clear():void;
	}
}