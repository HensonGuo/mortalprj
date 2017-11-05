package mortal.game.scene3D.map3D
{
	import Message.Public.SPoint;
	
	import com.fyGame.fyMap.FyMapInfo;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.game.Game;

	public class SceneRange
	{
	
		/**
		 * 最大水平分辨率 
		 */
		public static var screenResolutionX:Number = 1360;
		
		/**
		 * 最大垂直分辨率 
		 */
		public static var screenResolutionY:Number = 768;
		
		private static var _entityRange:Rectangle = new Rectangle();
		
		private static const EntityPadding:int = 300;
		//加载顶图区域
		public static var loadMapRange:Rectangle = new Rectangle();
		//绘制顶图区域
		public static var drawMapRange:Rectangle = new Rectangle();
		
		/**
		 *  整个地图场景范围 
		 */		
		public static var map:Rectangle = new Rectangle(); 
		
		private static var _display:Rectangle = new Rectangle(0,0,1000,580);
		
		//双层地图背景层需要加载的格子的范围
		private static var _mapBg:Rectangle = new Rectangle();
		private static var _xFarPer:Number = 0.5;
		private static var _yFarPer:Number = 0.5;
		public static var bitmapFarXY:Rectangle = new Rectangle(0,0,1000,580);
		public static var bitmapSelfMoveX:Number = 0;
		public static var bitmapSelfMoveXSpeed:Number = 0.3;
		
		public static var displayInt:Rectangle = new Rectangle(0,0,1000,580);
		public static var bitmapFarXYInt:Rectangle = new Rectangle(0,0,1000,580);
		
		//加载底图区域
		public static var loadMapFarRange:Rectangle = new Rectangle();
		//绘制底图区域
		public static var drawMapFarRange:Rectangle = new Rectangle();
		
		//预加载区域超过屏幕外的像素
		public static const loadExtendSize:int = 100;
		
		/**
		 * 人物移动是需要移动地图的范围 
		 */
		public static var moveMap:Rectangle = new Rectangle( );
		
		public static var noMoveMap:Rectangle = new Rectangle(0,0,250,100);
		
		
		public function SceneRange()
		{
			
		}
		
		public static function randomBgSpeed():void
		{
			bitmapSelfMoveXSpeed = Math.random() > 0.5?0.3:-0.3;
		}
		
		/**
		 *  跟stage场景一样大小
		 */
		public static function get display():Rectangle
		{
			return _display;
		}
		
		/**
		 * 获取鼠标相对舞台的像素点坐标 
		 * @return 
		 * 
		 */		
		public static function getMousePoint():SPoint
		{
			var res:SPoint = new SPoint();
			res.x = Global.stage.mouseX + SceneRange.display.x;
			res.y = Global.stage.mouseY + SceneRange.display.y;
			return res;
		}

		/**
		 * @private
		 */
		public static function set display(value:Rectangle):void
		{
			_display = value;
			
			_entityRange.top = _display.top- EntityPadding;
			_entityRange.left = _display.left - EntityPadding;
			_entityRange.width = _display.width;
			_entityRange.height = _display.height;
			_entityRange.bottom = _display.bottom + EntityPadding;
			_entityRange.right = _display.right + EntityPadding;
			
			//底图矩形区域
			//bitmapFarXY.width = _display.width;
			//bitmapFarXY.height = _display.height;
			bitmapFarXY.x = _xFarPer * _display.x;
			bitmapFarXY.y = _yFarPer * _display.y;
			
			displayInt.x = int(_display.x);
			displayInt.y = int(_display.y);
			displayInt.width = int(_display.width);
			displayInt.height = int(_display.height);
			
			
			//bitmapFarXYInt.x = int(bitmapFarXY.x);
			//bitmapFarXYInt.y = int(bitmapFarXY.y);
			//bitmapFarXYInt.width = int(bitmapFarXY.width);
			//bitmapFarXYInt.height = int(bitmapFarXY.height);
			
			updateBitmapAngle(display,loadMapRange,drawMapRange,map);
			//updateBitmapAngle(bitmapFarXY,loadMapFarRange,drawMapFarRange,_mapBg);
			
			updateNoMoveXY();
		}

		private static var loadMapRec:Rectangle = new Rectangle();
		
		public static function updateBitmapAngle(areaRec:Rectangle,loadRec:Rectangle,drawRec:Rectangle,mapRec:Rectangle):void
		{
			//计算加载区域
			loadMapRec.left = areaRec.left - loadExtendSize;
			loadMapRec.right = areaRec.right + loadExtendSize;
			loadMapRec.top = areaRec.top - loadExtendSize;
			loadMapRec.bottom = areaRec.bottom + loadExtendSize;
			
			if(loadMapRec.left < 0)
			{
				loadMapRec.left = 0;
			}
			if(loadMapRec.right > mapRec.right)
			{
				loadMapRec.right = mapRec.right;
			}
			if(loadMapRec.top < 0)
			{
				loadMapRec.top = 0;
			}
			if(loadMapRec.bottom > mapRec.bottom)
			{
				loadMapRec.bottom = mapRec.bottom;
			}
			
			if( areaRec.left <= 0 )
			{
				areaRec.left = 0;
				loadRec.left = 0;
				drawRec.left = 0;
			}
			else
			{
				loadRec.left = int(loadMapRec.left/MapConst.pieceWidth);
				drawRec.left = int(areaRec.left/MapConst.pieceWidth);
			}
			if( display.top <= 0 )
			{
				areaRec.top = 0;
				loadRec.top = 0;
				loadRec.top = 0;
			}
			else
			{
				loadRec.top = int(loadMapRec.top/MapConst.pieceHeight);
				drawRec.top = int(areaRec.top/MapConst.pieceHeight);
			}
			loadRec.right = int(loadMapRec.right/MapConst.pieceWidth);
			loadRec.bottom = int(loadMapRec.bottom/MapConst.pieceHeight);
			
			drawRec.right = int(areaRec.right/MapConst.pieceWidth);
			drawRec.bottom = int(areaRec.bottom/MapConst.pieceHeight);
		}
		
		/**
		 * 初始化范围 
		 * @param info
		 * 
		 */		
		public static function init( info:FyMapInfo = null ):void
		{
			if( info )
			{
				map.width = info.gridWidth;
				map.height = info.gridHeight;
				_mapBg.width = info.bgMapWidth;
				_mapBg.height = info.bgMapHeight;
				
				updateAngle();
				updateFarPer();
			}
		}
		
		private static function updateFarPer():void
		{
			_xFarPer = (_mapBg.width - _display.width)/(map.width - _display.width);
			_yFarPer = (_mapBg.height - _display.height)/(map.height - _display.height);
		}
		
		/**
		 * 更新地图缓冲区 X Y 坐标
		 * 
		 */		
		public static function updateNoMoveXY():void
		{
//			noMoveMap.x = _display.x + int((_display.width - noMoveMap.width)*0.5);
//			noMoveMap.y = _display.y + int((_display.height - noMoveMap.height)*0.5);
		}
		
		/**
		 * 更新地图缓冲区 宽高
		 * 
		 */	
		private static function updateNoMoveWH():void
		{
//			noMoveMap.width = 0;
//			noMoveMap.height = 0;
			noMoveMap.width =  int(_display.width*0.4); 
			noMoveMap.height = int(_display.height*0.4);
		}
		
		public static function cancelNoMoveWH(isCancel:Boolean = false):void
		{
			if(isCancel)
			{
				noMoveMap.width = 0;
				noMoveMap.height = 0;
			}
			else
			{
				noMoveMap.width = 250;
				noMoveMap.height = 100;
			}
		}
		
		/**
		 * 更新场景范围 
		 * 
		 */		
		public static function updateAngle():void
		{
			if( Game.mapInfo )
			{
				moveMap.width = Game.mapInfo.gridWidth - _display.width; 
				moveMap.height = Game.mapInfo.gridHeight - _display.height;
				moveMap.x = int(_display.width*0.5);
				moveMap.y = int(_display.height*0.5);
				
				updateNoMoveWH();
				updateNoMoveXY();
			}
			
			
//			var hnum:Number = _display.height/MapConst.pieceHeight;
//			if( hnum % 1 == 0 )
//			{
//				hnum += 1;
//			}
//			else
//			{
//				hnum = Math.ceil(hnum);
//			}
//			var wnum:Number = _display.width/MapConst.pieceWidth;
//			if( wnum % 1 == 0 )
//			{
//				wnum += 1;
//			}
//			else
//			{
//				wnum = Math.ceil(wnum);
//			}
//			loadMapRange.width = wnum;
//			loadMapRange.height = hnum;
//			
//			loadMapFarRange.width = wnum;
//			loadMapFarRange.height = hnum;
		}
		
		public static function isInSceneByXY(x:Number,y:Number):Boolean
		{
			return _entityRange.contains(x,y);
		}
		
		/**
		 * 是否在场景内 
		 * @param displayObject
		 * @return 
		 * 
		 */		
		public static function isInScene( x:int,y:int ):Boolean
		{
			return display.contains(x,y);
		}
		
		public static function isInEffectRange(x:int,y:int):Boolean
		{
			return _entityRange.contains(x,y);
		}
		
		public static function isInEntityRange(x:int,y:int,entityWidth:Number,entityHeight:Number):Boolean
		{
			if(display.left - entityWidth/2 > x 
				|| display.right + entityWidth/2 < x
				|| display.top > y	
				|| display.bottom + entityHeight < y )
			{
				return false;
			}
			return true;
		}
		
		public static function resize():void
		{
			
		}
	}
}