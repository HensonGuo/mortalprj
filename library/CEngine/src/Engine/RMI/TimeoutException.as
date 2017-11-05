package Engine.RMI
{
	import Framework.Util.Exception;

	public class TimeoutException extends RMIException
	{
		public function TimeoutException()
		{
			super("TimeoutException" , RMIException.ExceptionCodeTimeOut );
		}
	}
}