package Framework.MQ
{
	import Framework.Serialize.SerializeStream;

	public class IMessageEx
	{
		public function __write( __os :SerializeStream ) : void
		{
			__os.writeInt(ex1);
			__os.writeInt(ex2);
		}
		
		public function __read( __is : SerializeStream ) : void
		{
			ex1 = __is.readInt();
			ex2 = __is.readInt();
		}
		
		public var ex1:int;
		public var ex2:int;
	}
}