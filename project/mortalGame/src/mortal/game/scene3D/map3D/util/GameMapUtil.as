package mortal.game.scene3D.map3D.util
{
	import Message.Public.ECamp;
	import Message.Public.EForce;
	import Message.Public.EMapBelong;
	import Message.Public.EMapInstanceType;
	import Message.Public.SEntityId;
	import Message.Public.SPoint;
	
	import com.fyGame.fyMap.FyMapInfo;
	import com.gengine.debug.Log;
	import com.gengine.debug.ThrowError;
	import com.gengine.utils.MathUitl;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.MapLoader;
	import mortal.game.scene3D.map3D.MapNodeType;
	import mortal.game.scene3D.map3D.MapState;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.model.data.DirectionType;
	import mortal.game.scene3D.player.entity.IEntity;

	/**
	 * 计算网格等数据 角度转换等 
	 * @author jianglang
	 * 
	 */	
	public class GameMapUtil
	{
		
		/**
		 * 攻击距离 
		 */		
		
		
		
		/**
		 * 地图高宽 
		 */		
		public static var mapWidth:int; 
		
		public static var mapHeight:int;
		
		/**
		 * 格子高宽 
		 */		
		public static var tileWidth:int;
		
		public static var tileHeight:int;
		
		/**
		 * 当前地图状态 
		 */		
		private static var _curMapState:MapState;
		
		public function GameMapUtil()
		{
		}
		
		public static function get curMapState():MapState
		{
			return _curMapState || (_curMapState = new MapState());
		}
		private static var _directionMap:Dictionary = new Dictionary();
		
		public static function init( info:FyMapInfo ):void
		{
			mapHeight = info.gridHeight;
			mapWidth = info.gridWidth;
			tileHeight = info.pieceHeight;
			tileWidth = info.pieceWidth;
			
			info.gridYNum = mapHeight/tileHeight;
			info.gridXNum = mapWidth / tileWidth;
		}
		
		/**
		 * 获取两点间的方向 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		public static function getDirectionByPoint( p1:Point , p2:Point ):int
		{
			return getDirectionByXY(p1.x , p1.y , p2.x , p2.y);
		}

		/**
		 * 获取两点间的方向 
		 * @param p1
		 * @param p2
		 * @return 
		 * 
		 */		
		public static function getDirectionBySPoint( p1:SPoint , p2:SPoint ):int
		{
			return getDirectionByXY(p1.x , p1.y , p2.x , p2.y);
		}
		/**
		 * 根据两个点得到方向 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDirectionByXY(x1:int,y1:int,x2:int,y2:int):int
		{
			return getDirectionByRadians( MathUitl.getRadiansByXY(x1,y1,x2,y2) );
		}
		/**
		 * 根据弧度得到方向 
		 * @param radians
		 * @return 
		 * 
		 */		
		public static function getDirectionByRadians( radians:Number ):int
		{
			var angle:int =  MathUitl.getAngle(radians);
			return _directionMap[ angle ];
		}
		/**
		 * 获取格子坐标 
		 * @return 
		 * 
		 */		
		public static function getTilePoint(x:int,y:int):Point
		{
			var point:Point = new Point();
//			point.x = Math.ceil((x+2*y)/tileWidth);
//			point.y = Math.ceil((mapWidth - x + 2*y)/tileWidth);
			point.x = int(x/tileWidth);
			point.y = int(y/tileHeight);
			return point;
		}
		
		public static function getPixelPointArray( tilePoint:Array ):Array
		{
			var ary:Array = [];
			var point:Point;
			var obj:Object;
			for( var i:int=0 ; i < tilePoint.length; i++   )
			{
				obj = tilePoint[i];
				point = getPixelPoint(obj.x,obj.y);
				ary.push(point);
			}
			return ary;
		}
		
		/**
		 * 获取像素坐标 
		 * @return 
		 * 
		 */		
		public static function getPixelPoint(x:int,y:int):Point
		{
			var point:Point = new Point();
			
//			point.x = int((mapWidth - tileWidth*(y-x))/2);
//			point.y = int((tileWidth*(x+y)-mapWidth)/4 - tileHeight/2);
			point.x = int( x*tileWidth + tileWidth*0.5 );
			point.y = int( y*tileHeight + tileHeight*0.5 );
			
			return point;
		}
		
		public static function isPointEquals( point:SPoint , point1:SPoint ):Boolean
		{
			return (point.x != point1.x || point.y != point1.y);
		}
		
		
		public static function getPixelPointValue(x:int,y:int):int
		{
			var p:Point = getTilePoint(x,y);
			return getPointValue(p.x,p.y);
		}
		
		public static function getPointValue( x:int , y:int ):int
		{
			var aryX:Array = Game.mapInfo.mapData[x];
			if( aryX )
			{
				if( aryX.length > y )
				{
					return aryX[y];
				}
			}
			else
			{
				ThrowError.show( "没有"+x+","+y+"坐标" );
			}
			return -1;
		}
		
		/**
		 * 获得某张地图点数据
		 * @param mapId
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function getPointValueByMapId( mapId:int, x:int , y:int ):int
		{
			var mapInfo:FyMapInfo = MapLoader.instance.getMapData(mapId);
			if(mapInfo == null)
			{
				return -1;
			}
			
			var aryX:Array = mapInfo.mapData[x];
			if( aryX )
			{
				if( aryX.length > y )
				{
					return aryX[y];
				}
			}
			return 0;
		}
		
		/**
		 * 返回两点间距离的平方 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */
		public static function getDistancePow( x1:int,y1:int,x2:int,y2:int ):int
		{
			return Math.pow(x2 - x1,2) + Math.pow( y2 - y1,2);
		}
		
		/**
		 * 返回两点间距离 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */
		public static function getDistance( x1:int,y1:int,x2:int,y2:int ):int
		{
			return Math.sqrt(getDistancePow(x1,y1,x2,y2));
		}
		
		/**
		 * 格子坐标转换成本地坐标 
		 * @param px 格子x坐标
		 * @param py 格子y坐标
		 * @param scaleX 水平缩放比例
		 * @param scaleY 垂直缩放比例
		 * 
		 */
		public static function tilePointToLocal(px:int,py:int,scaleX:Number,scaleY:Number):Point
		{
			var pix:Point = getPixelPoint(px,py);
			return pixPointToLocal(pix.x,pix.y,scaleX,scaleY);
		}
		
		/**
		 * 像素坐标转换成本地坐标 
		 * @param px 像素x坐标
		 * @param py 像素y坐标
		 * @param scale 缩放比例
		 * 
		 */
		public static function pixPointToLocal(px:int,py:int,scaleX:Number,scaleY:Number):Point
		{
			return new Point(px * scaleX,py * scaleY);
		}
		
		/**
		 * 本地像素坐标转换成地图像素坐标 
		 * @param px
		 * @param py
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function localToPixPoint(px:int,py:int,scaleX:Number,scaleY:Number):Point
		{
			return new Point(px * scaleX,py * scaleY);
		}
		
		/**
		 * 本地像素坐标转换成地图格子坐标 
		 * @param px
		 * @param py
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function localToTilePoint(px:int,py:int,scaleX:Number,scaleY:Number):Point
		{
			var pixPoint:Point = localToPixPoint(px,py,scaleX,scaleY);
			return getTilePoint(pixPoint.x,pixPoint.y);
		}
		
		/**
		 * 是否地图安全区  是否跨服
		 * @param info
		 * 
		 */
		public static function isMapPeaceArea(entityId:SEntityId,isAllServer:Boolean = false):Boolean
		{
			var entity:IEntity = ThingUtil.entityUtil.getEntity(entityId);
			if(entity)
			{
				var tilePoint:Point = GameMapUtil.getTilePoint(entity.x2d,entity.y2d);
				var mapValue:int = GameMapUtil.getPointValue(tilePoint.x,tilePoint.y);
				if(MapNodeType.isAllServerSafe(mapValue) || (!isAllServer && MapNodeType.isSameServerSafe(mapValue)))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			return false;
		}
		
		/**
		 * 根据mapid判断是否副本地图 
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isCopyMap(mapId:int=-1):Boolean
		{
			if(mapId == -1)
			{
				mapId = MapFileUtil.mapID;
			}
			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			if(mapInfo)
			{
				switch(mapInfo.sMapDefine.instanceType.__value)
				{
					case EMapInstanceType._EMapInstanceTypeCopy:
//					case EMapInstanceType._EMapInstanceTypeCrossDefense:
//					case EMapInstanceType._EMapInstanceTypeCrossSecret:
//					case EMapInstanceType._EMapInstanceTypeDirectionDrop:
//					case EMapInstanceType._EMapInstanceTypeRobCityTwo:
//					case EMapInstanceType._EMapInstanceTypeRobCityThree:
//					case EMapInstanceType._EMapInstanceTypeKingChampionship:
//					case EMapInstanceType._EMapInstanceTypeCrossSea:
//					case EMapInstanceType._EMapInstanceTypeGuildElite:
//					case EMapInstanceType._EMapInstanceTypeFireMonsterIsland:
						return true;
				}
			}
			return false;
		}
		
		/**
		 * 根据mapid判断是否跨服副本地图 
		 * @param mapId
		 * @return 
		 * 
		 */		
		public static function isCrossCopyMap(mapId:int=-1):Boolean
		{
			return false;
		}

		/**
		 * 根据mapid判断是否战场 
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isFightWar(mapId:int=-1):Boolean
		{
			return false;
		}

		/**
		 * 根据mapid判断是否仙盟战 
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isGuildWar(mapId:int=-1):Boolean
		{
			return false;
		}
		
		/**
		 * 根据mapid判断是否竞技场
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isArena(mapId:int=-1):Boolean
		{
			return false;
		}
		
		/**
		 * 根据mapid判断是否跨服竞技场
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isArenaCross(mapId:int=-1):Boolean
		{
			return false;
		}
		
		/**
		 * 根据mapid判断是否在天神战场里面
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isNewBattlefield(mapId:int=-1):Boolean
		{
			return false;
		} 
		
		/**
		 * 根据mapid判断是否在跨服战场里面
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isCrossBossField(mapId:int=-1):Boolean
		{
			return false;
		} 
		
		
		
		/**
		 * 是否在和平BOSS 
		 * @param mapId
		 * @return 
		 * 
		 */		
		public static function isPeaceField(mapId:int = -1):Boolean
		{
			return false;
		}
		
		/**
		 * 是否仙盟领地 
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isGuildMap(mapId:int=-1):Boolean
		{
			if(mapId == -1)
			{
				mapId = MapFileUtil.mapID;
			}
			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			return false;
//			return mapInfo && mapInfo.sMapDefine.instanceType.__value == EMapInstanceType._EMapInstanceTypeGuild;
		}
		
		/**
		 * 是否VIP地图
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isVIPHook(mapId:int):Boolean
		{
			return false;
		}
		
		/**
		 * 是否boss洞 
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isBossMap(mapId:int = -1):Boolean
		{
			if(mapId == -1)
			{
				mapId = MapFileUtil.mapID;
			}
			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			return mapInfo && mapInfo.sMapDefine.belong.__value == EMapBelong._EMapBelongNo;
		}
		
		/**
		 * 是否普通地图 
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isUniqueMap(mapId:int = -1):Boolean
		{
			if(mapId == -1)
			{
				mapId = MapFileUtil.mapID;
			}
			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			return mapInfo && mapInfo.sMapDefine.instanceType.__value == EMapInstanceType._EMapInstanceTypeNormal;
		}
		
		/**
		 * 是否强制切换为战斗模式的地图 
		 * @param mapId
		 * @return 
		 * 
		 */		
		public static function isSetFightModeMap(mapId:int=-1):Boolean
		{
//			if(mapId == -1)
//			{
//				mapId = MapFileUtil.mapID;
//			}
//			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
//			if(!mapInfo)
//			{
//				return false;
//			}
//			
//			//限制PK的地图不能切换为杀戮模式
//			if(mapInfo.sMapDefine.restrictionType & EMapRestrictionType._EMapRestrictionTypePK)
//			{
//				return false;
//			}
//			return isEnemyMapByInfo(mapInfo);
			return false;
		}
		
		/**
		 * 是否敌对阵营的地图
		 * 满足：1、非中立 2、非副本 3、非玩家阵营
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isEnemyMap(mapId:int=-1):Boolean
		{
			if(mapId == -1)
			{
				mapId = MapFileUtil.mapID;
			}
			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			return isEnemyMapByInfo(mapInfo);
		}
		
		/**
		 * 是否敌对阵营的地图 
		 * @param sceneInfo
		 * @return 
		 * 
		 */
		public static function isEnemyMapByInfo(sceneInfo:SceneInfo):Boolean
		{
			return false;
//			return sceneInfo && (sceneInfo.sMapDefine.campType.__value == EForce._EForceNormal
//				||  sceneInfo.sMapDefine.instanceType.__value != EMapInstanceType._EMapInstanceTypeCopy
//					&& sceneInfo.sMapDefine.campType.__value != EForce._EForceNeutral
//					&& sceneInfo.sMapDefine.campType.__value != Cache.instance.role.entityInfo.camp);
		}
		
		/**
		 * 地图是否可以传送 
		 * @param mapId
		 * @return 
		 * 
		 */		
		public static function isMapSend( mapId:int ):Boolean
		{
			return true;
		}
		
		/**
		 * 是否在某张地图
		 * @param mapId
		 * @return 
		 * 
		 */		
		public static function isMapById(mapId:int):Boolean
		{
			return Game.sceneInfo.sMapDefine.mapId == mapId;
		}
		
		/**
		 * 是否在某张地图  
		 * @param code 副本code
		 * @return 
		 * 
		 */
		public static function isMapByCopyCode(code:int):Boolean
		{
			return false;
		}
		
		/**
		 * 是否可以切磋
		 * @param mapId
		 * @return 
		 * 
		 */
		public static function isCanBattle(mapId:int = -1):Boolean
		{
			return false;
		}
		
		/**
		 * 当前地图是否可跨服组队 
		 * @return 
		 * 
		 */		
		public static function isCrossGroupMap():Boolean
		{
			return false;
		}
		
		/**
		 *是否天神战场，封魔战场，跨服BOSS，洞BOSS。 
		 * @return 
		 * 
		 */		
		public static function isSpecialMap():Boolean
		{
			return false;
		}
		
		/**
		 * 是否人数较多的场景 
		 * @return 
		 * 
		 */		
		public static function isHightNumberPeopleMap():Boolean
		{
			return false;
		}
		
		/**
		 * 是否显示仙盟名的地图 
		 * @return 
		 * 
		 */		
		public static function isShowGuildNameMap():Boolean
		{
			return false;
		}
		
		/**
		 * 是否显示称号 
		 * @return 
		 * 
		 */		
		public static function isShowMainTitleMap( value:Object ):Boolean
		{
			return false;
		}
		
		/**
		 * 是否隐藏人物技能特效
		 * @return 
		 * 
		 */		
		public static function isHidePlayerSkillEffectMap():Boolean
		{
			return false;
		}
		
		/**
		 * 是否显示法宝模型 
		 * @return 
		 * 
		 */		
		public static function isShowFaBaoMap():Boolean
		{
			return true;
		}
		
		/**
		 * 是否能上坐骑的地图 
		 * @return 
		 * 
		 */		
		public static function isCanCallMount():Boolean
		{
			return true;
		}
		
	}
}