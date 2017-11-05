package mortal.game.scene3D.map3D.util
{
	import com.fyGame.fyMap.MapPicType;
	import com.gengine.game.MapConfig;
	
	import flash.geom.Rectangle;
	
	import mortal.common.global.ParamsConst;
	import mortal.game.Game;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ResConfig;
	import mortal.game.scene3D.map3D.MapConst;
	import mortal.game.scene3D.map3D.SceneRange;

	public class MapFileUtil
	{
		private static var _mapID:int;
		
		private static var _proxyID:int;
		private static var _serverID:int;
		
		private static var _currentMapPath:String;
		
		private static var _mapDataPath:String;  //地图数据路径
		private static var _sceneDataPath:String; // 场景数据路径
		
		private static const CONNECT:String = "_";
		private static const PNG:String = ".png";
		private static const JPG:String = ".jpg";
		private static const BG:String = "bg";
		private static const ABC:String = ".ABC";
		private static const CMP0:String = ".CMP0";
		private static const CMP1:String = ".CMP1";
		
		public function MapFileUtil()
		{
			
		}
		
		
		public static function get mapID():int
		{
			return _mapID;
		}

		public static function get sceneDataPath():String
		{
			return _sceneDataPath;
		}

		public static function get mapDataPath():String
		{
			return _mapDataPath;
		}

		public static function set mapID( value:int ):void
		{
			_mapID = value;
			_currentMapPath = MapConfig.mapPath + ""+_mapID;
			
			_mapDataPath = getMapDataPathByMapId(_mapID);
//			_sceneDataPath = ResConfig.instance.getUrlByName(_mapID+"_scene.json");
		}
		
		public static function set proxyID(value:int):void
		{
			_proxyID = value;
		}
		public static function get proxyID():int
		{
			return _proxyID;
		}
		
		public static function set serverID(value:int):void
		{
			_serverID = value;
		}
		public static function get serverID():int
		{
			return _serverID;
		}
		
		/**
		 * 地图块的命名规则 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function getPiecePath(x:int,y:int):String
		{
//			return _mapID + CONNECT + y + CONNECT + x + ABC;
			if(ParamsConst.instance.isUseATF)
			{
				var isJPG:Boolean = Game.mapInfo.getPicType(x,y) == MapPicType.JPG
				if(isJPG)
				{
					return _mapID + CONNECT + y + CONNECT + x + CMP0;
				}
				else
				{
					return _mapID + CONNECT + y + CONNECT + x + CMP1;
				}
			}
			else
			{
				return _mapID + CONNECT + y + CONNECT + x + ABC;
			}
		}
		
		/**
		 * 背景地图的路径 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function getPieceFarPath(x:int,y:int):String
		{
			if(ParamsConst.instance.isUseATF)
			{
				return _mapID + CONNECT + y + CONNECT + x + CONNECT + BG + CMP0;
			}
			else
			{
				return _mapID + CONNECT + y + CONNECT + x + CONNECT + BG + ABC;
			}
			
		}
		
		/**
		 *  
		 * @param id
		 * @return 
		 * 
		 */		
		public static function getJtaPath(id:Object):String
		{
			return id+"_fr.jta";
		}
		
		/**
		 * 地图数据资源路径
		 * @param mapId 
		 */		
		public static function getMapDataPathByMapId(mapId:int):String
		{
			return ResConfig.instance.getUrlByName(mapId+"_map.mpt");
		}
		
		public static function getModelPath( id:Object ):String
		{
			return id+"";
		}
		
		public static function getMiniMapPath( ):String
		{
			return _mapID+"_mini.jpg";
		}
		
		public static function getMiniMapPathByMap(mapId:int):String
		{
			return mapId + "_mini.jpg";
		}
		
		/**
		 * 上层图片是否是空图 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function isTopPicBlank(x:int,y:int):Boolean
		{
			return Game.mapInfo.getPicType(x,y) == MapPicType.BLANK;
		}
		
		/**
		 * 底层图片是否不需要渲染  如果四个顶点所在的顶图都是JPG则不需要渲染
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */
		public static function isBgNotNeedDraw(x:int,y:int):Boolean
		{
			//需要优化，如果四个点对应的图片不在屏幕则不需要判断
			var bgSceenX:int = x * MapConst.pieceWidth - SceneRange.bitmapFarXY.left;
			var bgSceenY:int = y * MapConst.pieceHeight - SceneRange.bitmapFarXY.top;
			var topX:int;
			var topY:int;
			//判断四个顶点所在区域是否全都是JPG
			topX = int((bgSceenX + SceneRange.display.left)/MapConst.pieceWidth);
			topY = int((bgSceenY + SceneRange.display.top)/MapConst.pieceHeight);
			var tempRect:Rectangle = new Rectangle(topX * MapConst.pieceWidth,topY * MapConst.pieceHeight,MapConst.pieceWidth,MapConst.pieceHeight);
			
			if(!SceneRange.display.intersection(tempRect).isEmpty() && Game.mapInfo.getPicType(topX,topY) != MapPicType.JPG)
			{
				return false;
			}
			
			topX = int((bgSceenX + SceneRange.display.left + MapConst.pieceWidth - 1)/MapConst.pieceWidth);
			topY = int((bgSceenY + SceneRange.display.top)/MapConst.pieceHeight);
			tempRect = new Rectangle(topX * MapConst.pieceWidth,topY * MapConst.pieceHeight,MapConst.pieceWidth,MapConst.pieceHeight);
			if(!SceneRange.display.intersection(tempRect).isEmpty() && Game.mapInfo.getPicType(topX,topY) != MapPicType.JPG)
			{
				return false;
			}
			
			topX = int((bgSceenX + SceneRange.display.left)/MapConst.pieceWidth);
			topY = int((bgSceenY + SceneRange.display.top + MapConst.pieceHeight - 1)/MapConst.pieceHeight);
			tempRect = new Rectangle(topX * MapConst.pieceWidth,topY * MapConst.pieceHeight,MapConst.pieceWidth,MapConst.pieceHeight);
			if(!SceneRange.display.intersection(tempRect).isEmpty() && Game.mapInfo.getPicType(topX,topY) != MapPicType.JPG)
			{
				return false;
			}
			
			topX = int((bgSceenX + SceneRange.display.left + MapConst.pieceWidth - 1)/MapConst.pieceWidth);
			topY = int((bgSceenY + SceneRange.display.top + MapConst.pieceHeight - 1)/MapConst.pieceHeight);
			tempRect = new Rectangle(topX * MapConst.pieceWidth,topY * MapConst.pieceHeight,MapConst.pieceWidth,MapConst.pieceHeight);
			if(!SceneRange.display.intersection(tempRect).isEmpty() && Game.mapInfo.getPicType(topX,topY) != MapPicType.JPG)
			{
				return false;
			}
			return true;
		}
	}
}