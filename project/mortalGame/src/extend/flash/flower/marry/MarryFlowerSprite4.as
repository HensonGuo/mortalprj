package extend.flash.flower.marry
{
	import mortal.game.resource.ImagesConst;

	public class MarryFlowerSprite4 extends MarryFlowerSprite
	{
		public function MarryFlowerSprite4()
		{
			super();
			_intervalNum = 16;
		}
		
		override protected function get flowerAry():Array
		{
			return [ImagesConst.MarryFlowerPink1,ImagesConst.MarryFlowerPink2,ImagesConst.MarryFlowerPink3,ImagesConst.MarryFlowerPink4,ImagesConst.MarryFlowerRed1,ImagesConst.MarryFlowerRed2,ImagesConst.MarryFlowerRed3];
		}
	}
}