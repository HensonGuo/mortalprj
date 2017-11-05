package frEngine.util
{
	import flash.utils.Dictionary;

	public class HelpUtils
	{
		private static const idMap:Dictionary=new Dictionary(false);
		private static var _id:uint=0;
		public function HelpUtils()
		{
		}
		public static function getSortIdByName($name:String):int
		{
			var id:uint=idMap[$name]
			if(id==0)
			{
				idMap[$name]=id=++_id;
			}
			return id;
		}
	}
}