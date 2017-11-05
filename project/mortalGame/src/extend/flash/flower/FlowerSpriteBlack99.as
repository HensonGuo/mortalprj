package extend.flash.flower
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene.player.entity.SpritePlayer;
	
	public class FlowerSpriteBlack99 extends FlowerSprite
	{
		public function FlowerSpriteBlack99()
		{
			super();
		}
		
		override protected function initFlowerAry():void
		{
			_flowerAry = [GlobalClass.getBitmapData(ImagesConst.FlowerBlack1),GlobalClass.getBitmapData(ImagesConst.FlowerBlack2),GlobalClass.getBitmapData(ImagesConst.FlowerBlack3),GlobalClass.getBitmapData(ImagesConst.FlowerBlack4)];
		}
		
		override protected function getFlower():BitmapData
		{
			return _flowerAry[2];
		}
	}
}