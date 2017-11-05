package mortal.game.scene3D.map3D
{
	/**
	 * 
	 * @author huangliang
	 */
	public class MapNode
	{
		/**
		 *地形值 
		 */		
		public var value:int;
		
		/**
		 * 
		 */
		public function MapNode()
		{
		}
		/**
		 * 是否可走 
		 * @return 
		 * 
		 */		
		public function get isWalk():Boolean
		{
			return MapNodeType.isWalk(value);
		}
		/**
		 * 是否透明 
		 * @return 
		 * 
		 */		
		public function get isAlpha():Boolean
		{
			return MapNodeType.isAlpha(value);
		}
		/**
		 * 是否可攻击 
		 * @return 
		 * 
		 */		
		public function get isAttack():Boolean
		{
			return MapNodeType.isAttack(value);
		}
		/**
		 * 是否可飞 
		 * @return 
		 * 
		 */		
		public function get isFly():Boolean
		{
			return MapNodeType.isFly(value);
		}
	}
}