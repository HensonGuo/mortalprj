package Engine.RMI
{
	import Framework.Util.Exception;

	public class MarshalException extends Exception
	{
		public function MarshalException()
		{
			super("MarshalException" , Exception.ExceptionCodeSerialize );
		}
	}
}