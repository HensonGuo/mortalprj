package extend.flash.flower
{
	import com.gengine.utils.MathUitl;
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	
	public class FlowerSprite999 extends FlowerSprite
	{
		public function FlowerSprite999()
		{
			super();
			_intervalNum = 1;
			_isAddStar = true;
		}
		
		override protected function getFlower():BitmapData
		{
			var i:int = random(0,3);
			return _flowerAry[i];
		}
		
		override protected function initFlowerType():void
		{
			_flowerRunType = FlowerRunType.getRandomType();
		}
	}
}