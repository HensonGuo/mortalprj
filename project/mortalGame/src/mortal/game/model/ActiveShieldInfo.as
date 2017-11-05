package mortal.game.model
{
	import mortal.common.tools.DateParser;

	public class ActiveShieldInfo
	{
		public var startTime:String;
		public var endTime:String;
		
		public var npcId:int;
		public var effectId:int;
		
		private var _startDate:Date;
		private var _endDate:Date;
		
		public function ActiveShieldInfo()
		{
		}
		
		public function updateData():void
		{
			//解析时间格式
			_startDate = DateParser.strToDateNormal(startTime + " 00:00:00.000");
			_endDate = DateParser.strToDateNormal(endTime + " 00:00:00.000");
		}
		
		public function get startDate():Date
		{
			return _startDate;
		}
	}
}