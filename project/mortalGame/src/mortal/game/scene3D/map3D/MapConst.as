package mortal.game.scene3D.map3D
{
	import com.fyGame.fyMap.FyMapInfo;

	/**
	 * 地图相关静态变量 
	 * @author jianglang
	 * 
	 */	
	public class MapConst
	{	
		/**
		 * 地图块X Y 的个数 
		 */		
		public static var mapPieceXNum:Number; 
		public static var mapPieceYNum:Number;
		/**
		 *  地图切块的图片宽高
		 */		
		public static const pieceWidth:int = 256;
		public static const pieceHeight:int = 256;
		
		/**
		 * 地图马赛克小图片宽高  
		 */
		public static const mosaicsWidth:int = 5000; 
		public static const mosaicsHeight:int = 5000;
		
		public function MapConst()
		{
		}
		
		public static function init( info:FyMapInfo ):void
		{
			mapPieceXNum = Math.ceil( info.gridWidth/pieceWidth );
			mapPieceYNum = Math.ceil( info.gridHeight/pieceHeight );
		}
	}
}