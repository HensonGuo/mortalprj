package extend.flash.flower
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene.player.entity.SpritePlayer;
	
	public class FlowerSpriteBlue999 extends FlowerSprite
	{
		public function FlowerSpriteBlue999()
		{
			super();
			_intervalNum = 1;
			_isAddStar = true;
		}
		
		override protected function initFlowerAry():void
		{
			_flowerAry = [GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue1),GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue2),GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue3),GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue4)];
		}
		
		override protected function getFlower():BitmapData
		{
			var i:int = random(0,_flowerAry.length - 1);
			return _flowerAry[i];
		}
		
		override protected function initFlowerType():void
		{
			_flowerRunType = FlowerRunType.getRandomType();
		}
	}
}