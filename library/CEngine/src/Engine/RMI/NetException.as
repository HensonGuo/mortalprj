package Engine.RMI
{
	import Framework.Util.Exception;

	public class NetException extends Exception
	{
		public function NetException()
		{
			super("NetException");
		}
	}
}