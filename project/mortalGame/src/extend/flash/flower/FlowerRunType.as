package extend.flash.flower
{
	import com.gengine.utils.MathUitl;

	public class FlowerRunType
	{
		//普通飘花
		public static const NORMAL:int = 0;
		//速度增加
		public static const SPEEDADD:int = 1;
		//加速度增加
		public static const SPEEDACCEL:int = 2;
		
		public function FlowerRunType()
		{
		}
		
		public static function getRandomType():int
		{
			return MathUitl.random(0,2);
		}
	}
}