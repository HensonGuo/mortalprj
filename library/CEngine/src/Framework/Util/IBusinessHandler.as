package Framework.Util
{
	import flash.utils.ByteArray;
	
	public interface IBusinessHandler
	{
		function handlePacket( inBuf : ByteArray , handler : IBusinessHandler ) : Boolean;
	}
}