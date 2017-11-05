package model
{
//	import utils.JSON;

	public class FriendDataReader
	{
		public function FriendDataReader()
		{
		}
		
		public static function parserJson(jsonStr:String):Array
		{
			var obj:Object = JSON.parse(jsonStr);
			if(obj.hasOwnProperty("result"))
			{
				if(obj.result == "false")
				{
					return [];
				}
			}
			var result:Array = [];
			var jsonObj:Object;
			var info:FriendInfo;
			for(var key:String in obj)
			{
				jsonObj = obj[key];
				info = new FriendInfo();
				info.id = jsonObj.user_id;
				info.name = jsonObj.user_name;
				info.img = jsonObj.user_img;
				result.push(info);
			}
			return result;
		}
	}
}