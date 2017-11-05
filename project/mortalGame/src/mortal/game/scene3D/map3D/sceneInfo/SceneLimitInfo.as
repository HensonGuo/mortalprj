/**
 * 2013-12-25
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.sceneInfo
{
	/**
	 * 参考场景编辑器里面的configData.xml
	 * 
	 */
	public class SceneLimitInfo
	{
		private var _limitValue:int = 0;
		public function SceneLimitInfo()
		{
		}

		public function get limitValue():int
		{
			return _limitValue;
		}

		public function set limitValue(value:int):void
		{
			_limitValue = value;
		}
		
		/**
		 * 可以保存 (玩家在此地图下线， 下次登录的时候会回到此地图的下线点)
		 * @return 
		 * 
		 */		
		public function canSave():Boolean
		{
			return ((_limitValue & 1) != 1);
		}
		
		/**
		 * 可以单人pk 
		 * @return 
		 * 
		 */		
		public function canSinglePK():Boolean
		{
			return ((_limitValue & 2) != 2);
		}
		
		/**
		 * 可以团队pk 
		 * @return 
		 * 
		 */		
		public function canTeamPK():Boolean
		{
			return ((_limitValue & 4) != 4);
		}
		
		/**
		 * 可以传送（小飞鞋) 
		 * @return 
		 * 
		 */		
		public function canPassTo():Boolean
		{
			return ((_limitValue & 8) != 8);
		}
		
		/**
		 * 坐骑 
		 * @return 
		 * 
		 */		
		public function canSingleMount():Boolean
		{
			return ((_limitValue & 16) != 16);
		}
		
		/**
		 * 可以使用宠物
		 * @return 
		 * 
		 */		
		public function canUsePet():Boolean
		{
			return((_limitValue & 32) != 32);
		}
		
		/**
		 * 可以变身 
		 * @return 
		 * 
		 */		
		public function canBianShen():Boolean
		{
			return((_limitValue & 64) != 64);
		}

		/**
		 * 可以切磋 
		 * @return 
		 * 
		 */		
		public function canBattle():Boolean
		{
			return((_limitValue & 128) != 128);
		}
		
		/**
		 * 可以飞行 
		 * @return 
		 * 
		 */		
		public function canFly():Boolean
		{
			return((_limitValue & 256) != 256);
		}
	}
}