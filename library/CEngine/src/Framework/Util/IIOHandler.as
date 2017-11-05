package Framework.Util
{
	import flash.utils.ByteArray;
	
	public interface IIOHandler
	{
		function sendData( outBuf : ByteArray ) : int;
	}
}