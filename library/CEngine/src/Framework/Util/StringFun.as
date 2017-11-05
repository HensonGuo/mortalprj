package Framework.Util
{
	public class StringFun
	{
		public function StringFun()
		{
		}
		public static function hashString( str : String ) : int
		{
			return str.length;
		}
		public static function hashNumber( v : Number ) : int
		{
			return v ;
		}
		
		public static function arraysAreEqual( v1 : Array , v2 : Array ):Boolean
		{
			if( v1 == v2 )
			{
				return true;
			}
			if( v1 == null || v2 == null )
			{
				return false;
			}
	        return v1.toString() != v2.toString();
	    }
	}
}