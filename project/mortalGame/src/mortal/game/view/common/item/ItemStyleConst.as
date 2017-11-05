package mortal.game.view.common.item
{
	public class ItemStyleConst
	{
		private static var _small:int = 36;
		
		private static var _big:int = 60;
		
		public function ItemStyleConst()
		{
		}
		
		public static function get Small():int
		{
			return _small;
		}
		
		public static function get Big():int
		{
			return _big;
		}
	}
}