package extend.flash.flower
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene.player.entity.SpritePlayer;
	
	public class FlowerSprite99 extends FlowerSprite
	{
		public function FlowerSprite99()
		{
			super();
		}
		
		override protected function getFlower():BitmapData
		{
			return _flowerAry[0];
		}
	}
}