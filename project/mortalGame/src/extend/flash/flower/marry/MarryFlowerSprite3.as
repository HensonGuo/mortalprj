package extend.flash.flower.marry
{
	import mortal.game.resource.ImagesConst;

	public class MarryFlowerSprite3 extends MarryFlowerSprite
	{
		public function MarryFlowerSprite3()
		{
			super();
			_intervalNum = 32;
		}
		
		override protected function get flowerAry():Array
		{
			return [ImagesConst.MarryFlowerPink1,ImagesConst.MarryFlowerPink2,ImagesConst.MarryFlowerPink3,ImagesConst.MarryFlowerPink4,ImagesConst.MarryFlowerRed1,ImagesConst.MarryFlowerRed2];
		}
	}
}