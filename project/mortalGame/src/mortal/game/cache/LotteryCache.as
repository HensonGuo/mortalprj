package mortal.game.cache
{
	import Message.Public.SLotteryHistory;
	
	import flash.utils.Dictionary;

	public class LotteryCache
	{
		private var _map:Dictionary = new Dictionary();
		
		public function LotteryCache()
		{
		}
		
		public function syncRecordList(arr:Array):void
		{
			for (var i:int = 0; i < arr.length; i++)
			{
				var record:SLotteryHistory = arr[i];
				addRecord(record);
			}
		}
		
		
		public function addRecord(record:SLotteryHistory):void
		{
			if (_map[record.type] == null)
			{
				_map[record.type] = new Vector.<SLotteryHistory>();
			}
			var list:Vector.<SLotteryHistory> = _map[record.type];
			list.push(record);
		}
		
		
		public function getRecordList(type:int):Vector.<SLotteryHistory>
		{
			return _map[type];
		}
	}
}