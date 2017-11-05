package Framework.MQ
{
	import Framework.Serialize.SerializeStream;

	public class IMessageBase
	{
		public function __write( __os :SerializeStream ) : void
		{
		}
		
		public function __read( __is : SerializeStream ) : void
		{
		}
		
		public function getType() : int
		{
			return 0;
		}
		
		public function clone() : IMessageBase
		{
			return null;
		}
		
		public var msgEx:IMessageEx;
		
	}
}