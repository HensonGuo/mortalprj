package extend.flash.flower
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene.player.entity.SpritePlayer;
	
	public class FlowerSpriteBlue99 extends FlowerSprite
	{
		public function FlowerSpriteBlue99()
		{
			super();
		}
		
		override protected function initFlowerAry():void
		{
			_flowerAry = [GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue1),GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue2),GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue3),GlobalClass.getBitmapData(ImagesConst.MarryFlowerBlue4)];
		}
		
		override protected function getFlower():BitmapData
		{
			return _flowerAry[3];
		}
	}
}