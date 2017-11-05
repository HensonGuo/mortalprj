package extend.flash.flower.marry
{
	import extend.flash.flower.FlowerManager;
	import extend.flash.flower.FlowerSprite;

	public class MarryFlowerManager extends FlowerManager
	{
		public function MarryFlowerManager()
		{
		}
		
		private static var _instance:MarryFlowerManager;
		
		public static function get instance():MarryFlowerManager
		{
			if(!_instance)
			{
				_instance = new MarryFlowerManager();
			}
			return _instance;
		}
		
		/**
		 * 通过类型获取播放的Sprite
		 * @param type
		 * @return 
		 * 
		 */
		override protected function getflowerSprite(type:int):FlowerSprite
		{
			var flowerSprite:FlowerSprite;
			switch( type )
			{
				case MarryFlowerType.FLOWER_1:
				{
					flowerSprite = new MarryFlowerSprite1();
					break;
				}
				case MarryFlowerType.FLOWER_2:
				{
					flowerSprite = new MarryFlowerSprite2();
					break;
				}
				case MarryFlowerType.FLOWER_3:
				{
					flowerSprite = new MarryFlowerSprite3();
					break;
				}
				case MarryFlowerType.FLOWER_4:
				{
					flowerSprite = new MarryFlowerSprite4();
					break;
				}
			}
			return flowerSprite;
		}
	}
}