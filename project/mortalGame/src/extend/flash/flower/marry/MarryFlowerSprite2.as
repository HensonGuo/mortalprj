package extend.flash.flower.marry
{
	import mortal.game.resource.ImagesConst;

	public class MarryFlowerSprite2 extends MarryFlowerSprite
	{
		public function MarryFlowerSprite2()
		{
			super();
			_intervalNum = 64;
		}
		
		override protected function get flowerAry():Array
		{
			return [ImagesConst.MarryFlowerPink1,ImagesConst.MarryFlowerPink2,ImagesConst.MarryFlowerPink3,ImagesConst.MarryFlowerRed1,ImagesConst.MarryFlowerRed2];
		}
	}
}