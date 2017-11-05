package Engine.RMI
{
	import Framework.Util.Exception;

	public class UnkownException extends Exception
	{
		public function UnkownException()
		{
			super("UnkownException" , Exception.ExceptionCodeUnkown );
		}
	}
}