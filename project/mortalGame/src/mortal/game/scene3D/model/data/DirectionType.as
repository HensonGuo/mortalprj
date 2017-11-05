package mortal.game.scene3D.model.data
{
	/**
	 * 方向类型 
	 * @author jianglang
	 * 
	 *  南    西南   西    西北    北	东北   东  东南
 	 *  1 	   2	 3		4	   5     6     7    8
	 */	
	public class DirectionType
	{
		private static var _directionMap:Object = {"1":"南","2":"西南","3":"西","4":"西北","5":"北","6":"东北","7":"东","8":"东南"};
		
		private static var _sideMap:Object = {"1":"下","2":"左下","3":"左","4":"左上","5":"上","6":"右上","7":"右","8":"右下"};
		
		private static var _directionRotation:Object = {"1":180,"2":-135,"3":-90,"4":-45,"5":0,"6":45,"7":90,"8":135};
		
		private static var _dirXTurn:Object = {"1":-1,"2":8,"3":7,"4":6,"5":-1,"6":4,"7":3,"8":2};
		
		private static var _dirYTurn:Object = {"1":5,"2":4,"3":-1,"4":2,"5":1,"6":8,"7":-1,"8":6};
		
		public static const South:int = 1; 	// 南1
		public static const SouthWest:int = 2;  	// 西南
		public static const West:int = 3;  	// 西
		public static const NorthWest:int = 4;  	// 西北
		public static const North:int = 5;  	//北
		public static const NorthEast:int = 6;  // 东北
		public static const East:int = 7;	// 东
		public static const SouthEast:int = 8;	// 东南
		
		public static const DefaultDir:int = South;
		
		/**
		 * 是否是正面 
		 * @param dir
		 * @return 
		 * 
		 */		
		public static function isPositive( dir:int ):Boolean
		{
			return dir< 3 || dir == SouthEast;
		}
		
		public function DirectionType()
		{
			
		}
		
		public static function getDirction( dirction:int ):String
		{
			return _directionMap[dirction];
		}
		
		public static function getSide(dirction:int):String
		{
			return _sideMap[dirction];
		}
		
		public static function getRotation( dirction:int ):int
		{
			return _directionRotation[dirction];
		}
		
		/**
		 * 返回X的镜像
		 * @param dir
		 * @return 
		 * 
		 */
		public static function getXTurnDir(dir:int):int
		{
			return _dirXTurn[dir];
		}
		
		/**
		 * 返回Y的镜像 
		 * @param dir
		 * @return 
		 * 
		 */
		public static function getYTurnDir(dir:int):int
		{
			return _dirYTurn[dir];
		}
		
		/**
		 * 左转 
		 * @param dirction
		 * @return 
		 * 
		 */
		public static function turnLeft(dirction:int):int
		{
			dirction += 1;
			if(dirction > 8)
			{
				dirction = South;
			}
			return dirction;
		}
		
		/**
		 * 右转 
		 * @param dirction
		 * @return 
		 * 
		 */
		public static function turnRight(dirction:int):int
		{
			dirction -= 1;
			if(dirction <= 0)
			{
				dirction = SouthEast;
			}
			return dirction;
		}
	}
}