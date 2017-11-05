/**
 * 2014-3-5
 * @author chenriji
 **/
package mortal.game.view.npc.data
{
	import Message.DB.Tables.TCopy;
	
	import mortal.game.cache.Cache;
	import mortal.game.resource.CopyConfig;

	public class NpcFunctionData
	{
		public static const Shop:int = 1;
		public static const Copy:int = 2;
		public static const Func:int = 3;
		public static const Activity:int = 4;
		
		public function NpcFunctionData()
		{
		}
		
		public function parse(str:String):void
		{
			var arr:Array = str.split("#");
			type = int(arr[0]);
			value = int(arr[1]);
			desc = String(arr[2]);
			if(type == Copy) // 副本需要添加次数，等级等要求
			{
				var info:TCopy = CopyConfig.instance.getCopyInfoByCode(value);
				if(info == null)
				{
					return;
				}
				var curNum:int = Cache.instance.copy.getTodayEnterTimes(value);
				var totalNum:int = info.dayNum;
				var enterLv:int = info.enterMinLevel;
				var numStr:String;
				if(curNum >= totalNum)
				{
					numStr = "<font color='#ff0000'>(" + curNum + "/" + totalNum + ")</font>";
				}
				else
				{
					numStr = "(" + curNum + "/" + totalNum + ")";
				}
				desc += numStr;
			}
		}
		
		public var npcId:int;
		public var type:int;
		public var value:int;
		public var desc:String;
	}
}