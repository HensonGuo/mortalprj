package mortal.game.scene3D.fight.dramaEffect.data
{
	public class DramaMoveData
	{
		//开始位置  格子坐标
		public var startX:int;
		
		public var startY:int;
		
		public var endX:int;
		
		public var endY:int;
		
		public var startScale:Number;
		
		public var endScale:Number;
		
		//移动类型   缓动或者匀速移动
		public var moveType:int;
		//移动消耗时间  单位秒
		public var moveTime:int;
		
		public function DramaMoveData()
		{
		}
	}
}