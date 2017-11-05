package mortal.game.model
{
	public class RollRadioInfo
	{
		public var totalCount:int;			//需要滚动的总次数
		public var count:int;				//已经滚过的次数
		public var speed:int = 2;			//滚屏速度参数 像素/每帧
		public var str:String;				//需要滚动的文字
		
		public function RollRadioInfo()
		{
		}
	}
}