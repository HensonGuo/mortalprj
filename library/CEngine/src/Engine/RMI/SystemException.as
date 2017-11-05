package Engine.RMI
{
	import Framework.Util.Exception;

	public class SystemException extends Exception
	{
		public function SystemException()
		{
			super("SystemException");
		}
	}
}