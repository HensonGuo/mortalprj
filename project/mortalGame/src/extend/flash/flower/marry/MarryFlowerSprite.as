package extend.flash.flower.marry
{
	import com.mui.core.GlobalClass;
	
	import extend.flash.flower.FlowerSprite;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	
	public class MarryFlowerSprite extends FlowerSprite
	{
		public function MarryFlowerSprite()
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_flowerAry = flowerAry;
			_intervalNum = 16;
		}
		
		override protected function initFlowerAry():void
		{
			_flowerAry = [];
		}
		
		protected function get flowerAry():Array
		{
			return [];
		}
		
		override protected function getFlower():BitmapData
		{
			var i:int = random(0,_flowerAry.length - 1);
			return GlobalClass.getBitmapData(_flowerAry[i]);
		}
	}
}