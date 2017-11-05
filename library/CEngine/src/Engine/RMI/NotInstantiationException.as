package Engine.RMI
{
	import Framework.Util.Exception;

	public class NotInstantiationException extends RMIException
	{
		public function NotInstantiationException()
		{
			super("NotInstantiationException", RMIException.ExceptionCodeNotInstantiation );
		}
	}
}