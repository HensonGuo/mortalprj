package mortal.game.scene3D.layer3D
{
	import com.fyGame.fyMap.FyMapInfo;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import baseEngine.system.Device3D;
	
	import frEngine.shader.ShaderBase;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.game.Game;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.info.GMapInfo;
	import mortal.game.resource.info.MapImgInfo;
	import mortal.game.scene3D.layer3D.model.MapLayerType;
	import mortal.game.scene3D.map3D.MapBitmap3D;
	import mortal.game.scene3D.map3D.MapBitmap3DRender;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	
	public class MapLayer3D extends SLayer3D
	{
		//加载区域
		private var _mapRect:MapRect;
		//显示区域
		private var _drawRect:MapRect;
		
		private var _pieceBitmap:MapPiece3DDictionary = new MapPiece3DDictionary();
		
		//a代表地图，b代表背景图
		protected var mapType:String = "";
		
		//正在显示的图片块
		protected var _mapPieceDic:Dictionary = new Dictionary();
		
		private var _loadLevel:int;
		
		public function MapLayer3D($mapType:String,$loadLevel:int)
		{
			super("");
			_mapRect = new MapRect();
			_drawRect = new MapRect();
			mapType = $mapType;
			_loadLevel = $loadLevel;
		}
		public var offsetX:Number=0;
		public var offsetY:Number=0;
		private var _temp0:Vector3D = new Vector3D();
		
		public function updatePos(rec:Rectangle):void
		{
			this.x=-rec.x;
			this.y=-rec.y;
			resize();
		}
		
		public function resize():void
		{
			var _pos:Vector3D=this.getPosition(false,_temp0);
			offsetX=_pos.x;
			offsetY=_pos.y;
			
			
		}
		public function get mapID():int
		{
			return GameMapConfig.instance.getMapInfo(MapFileUtil.mapID).mapscene;
		}
		

		public override function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
		{
			
			if(this.curMap3dList.length>0)
			{
				if(scene.toTexture)
				{
					MapBitmap3DRender.instance.draw(this.curMap3dList,this.offsetX+scene.textureOffsetX,this.offsetY+scene.textureOffsetY);
				}else
				{
					MapBitmap3DRender.instance.draw(this.curMap3dList,this.offsetX,this.offsetY);
				}
				
			}
			
		}
		public function loadMapPiece( rectRange:Rectangle ,drawRectangle:Rectangle):void
		{		
			_mapRect.rect = rectRange;
			_drawRect.rect = drawRectangle;
			
			//			//添加当前区域的到地图
			//			for(var i:int = drawRectangle.left;i <= drawRectangle.right;i++)
			//			{
			//				for(var j:int = drawRectangle.top;j <= drawRectangle.bottom;j++)
			//				{
			//					addPiece(i,j);
			//				}
			//			}
			
			//加载未加载过的
			_mapRect.update( loadPiece,null);
			//删除之前在屏幕内的
			//			_drawRect.update(null,removePiece);
			_drawRect.update(addPiece,removePiece);
		}
		
		private function isNoNeedDraw(x:int,y:int):Boolean
		{
			return false;
			if(mapType == MapLayerType.MAPFAR)
			{
				return MapFileUtil.isBgNotNeedDraw(x,y);
			}
			else
			{
				return MapFileUtil.isTopPicBlank(x,y);
			}
		}
		
		public var curMap3dList:Vector.<MapBitmap3D>=new Vector.<MapBitmap3D>();
		
		public function removeMap3dFromStage( map3D:MapBitmap3D ):void
		{
			var index:int=curMap3dList.indexOf(map3D)
			if( index!=-1 )
			{
				curMap3dList.splice(index,1);
				map3D.disposeTime = getTimer() + MapBitmap3D.DisposeTime;
			}
			map3D.parentLayer=null;
		}
		
		public function addMap3dToStage(map3D:MapBitmap3D):void
		{
			var index:int=curMap3dList.indexOf(map3D)
			if( index==-1 )
			{
				map3D.upload(Device3D.scene);
				curMap3dList.push(map3D);
				map3D.disposeTime = -1;
				map3D.parentLayer=this;
			}
		}
		
		//添加显示地图
		private function addPiece(x:int,y:int):void
		{
			var mapBitmap3D:MapBitmap3D = _pieceBitmap.getPieceBitmap(mapID,x,y,mapType);
			if( mapBitmap3D)
			{
				if(!isNoNeedDraw(x,y))
				{
					if(!_mapPieceDic[x * 1000 + y])
					{
						//mapBitmap3D.addToStage(this);
						this.addMap3dToStage(mapBitmap3D);
						_mapPieceDic[x * 1000 + y] = mapBitmap3D;
					}
				}
				else
				{
					this.removeMap3dFromStage(mapBitmap3D);
					delete _mapPieceDic[x * 1000 + y];
				}
			}
		}
		
		//移除显示地图
		private function removePiece(x:int,y:int):void
		{
			var mapBitmap3D:MapBitmap3D = _pieceBitmap.getPieceBitmap(mapID,x,y,mapType);
			if( mapBitmap3D)
			{
				this.removeMap3dFromStage(mapBitmap3D);
				delete _mapPieceDic[x * 1000 + y];
			}
		}
		
		private function loadPiece(x:int,y:int):void
		{
			var mapBitmap3D:MapBitmap3D = _pieceBitmap.getPieceBitmap(mapID,x,y,mapType);
			if( mapBitmap3D == null )
			{
				var obj:Object = {x:x,y:y};
				var info:ResourceInfo= getImageInfo( Game.mapInfo,x,y);
				if( info )
				{
					LoaderManager.instance.loadInfo( info , onLoaded ,_loadLevel, obj);
				}
			}
		}
		
		/**
		 *  判断是否在当前地图内 
		 * @return 
		 * 
		 */		
		public static function isInMapByTitle(x:int,y:int ):Boolean
		{
			if( x < 0 || x > Game.mapInfo.gridXNum)
			{
				return false;
			}
			if( y < 0 || y > Game.mapInfo.gridYNum )
			{
				return false;
			}
			return true;
		}
		
		protected function getFileName(x:int,y:int):String
		{
			if(mapType == MapLayerType.MAPFAR)
			{
				return MapFileUtil.getPieceFarPath(x,y);
			}
			else
			{
				return MapFileUtil.getPiecePath(x,y);
			}
		}
		
		private function getImageInfo( mapInfo:FyMapInfo, x:int,y:int ):ResourceInfo
		{
			var fileName:String = getFileName(x,y);
			var fileType:String = ".abc";
			var fileFolderSplit:String = "/";
			if(ParamsConst.instance.isUseATF)
			{
				fileType = fileName.substr(fileName.length - 5,5);
				fileFolderSplit = "_cmp/";
			}
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
			
			
			if( info )
			{
				return info;
			}
			else
			{
				if( isInMapByTitle( x ,y ) )
				{
					var mapImgInfo:MapImgInfo = new MapImgInfo(); //{ name:name,type:".JPG",time:"1",path:path+name}
					mapImgInfo.name = fileName;
					mapImgInfo.mapID = mapID;
					
					var path:String = mapImgInfo.mapID  + fileFolderSplit + mapImgInfo.name;
					var gMapInfo:GMapInfo = GameMapConfig.instance.getMapInfo(mapImgInfo.mapID);
					if(mapType == MapLayerType.MAPFAR)
					{
						mapImgInfo.loaclPath = PathConst.mapBgLocalPath+path;
						mapImgInfo.time = gMapInfo.bgInfo.version;
						mapImgInfo.path= PathConst.mapBgLocalPath + gMapInfo.bgInfo.mapName + fileFolderSplit + mapImgInfo.name +"?v="+mapImgInfo.time;
					}
					else
					{
						mapImgInfo.loaclPath = PathConst.mapLocalPath+path;
						mapImgInfo.time = gMapInfo.version;
						mapImgInfo.path= PathConst.mapPath + path+"?v="+mapImgInfo.time;
					}
					mapImgInfo.type = fileType;//".abc";
					ResourceManager.addResource(mapImgInfo);
					return mapImgInfo;
				}
			}
			return null;
		}
		
		private function onLoaded( info:MapImgInfo = null ):void
		{
			if( info == null || info.mapID != mapID ) return;
			var x:int = info.extData.x;
			var y:int = info.extData.y;
			
			var bitmap:MapBitmap3D = _pieceBitmap.getPieceBitmap(mapID,x,y,mapType);
			if( bitmap == null )
			{
				bitmap = _pieceBitmap.getMapBitmap();
				bitmap.info = info;
				_pieceBitmap.addPiece(mapID,x,y,bitmap,mapType);
			}
			if(_drawRect.isInRect(x,y))
			{
				addPiece(x,y);
			}
		}
		
		public function clearMap():void
		{
			_pieceBitmap.clearMap();
			_mapPieceDic = new Dictionary();
			_drawRect.dispose();
			_mapRect.dispose();
		}
		
		public function disposeBitmap():void
		{
			
		}
	}
}

import flash.geom.Rectangle;

class MapRect
{
	
	//	private var _left:int;
	//	private var _right:int;
	//	private var _top:int;
	//	private var _bottom:int;
	//	/**
	//	 * 需要加载的 
	//	 */	
	//	private var _needLoadRect:Rect = new Rect();
	//	/**
	//	 * 需要删除 
	//	 */	
	//	private var _needRemoveRect:Rect = new Rect();
	/**
	 * 当前的 
	 */	
	private var _currentRect:Rect;
	
	private var _tempRect:Rect = new Rect();
	
	public function set rect( value:Rectangle ):void
	{
		_tempRect.left = value.left;
		_tempRect.right = value.right;
		_tempRect.top = value.top;
		_tempRect.bottom = value.bottom;
	}
	
	public function isInRect(x:int,y:int):Boolean
	{
		return _tempRect.contains(x,y);
	}
	
	public function update( loadFun:Function , unloadFun:Function):void
	{
		if( _currentRect == null )
		{
			for( var x:int = _tempRect.left; x<=_tempRect.right; x++ )
			{
				for( var y:int = _tempRect.top; y <= _tempRect.bottom; y++ )
				{
					if(loadFun != null)
					{
						loadFun(x,y);
					}
				}
			}
			_currentRect = new Rect();
			_currentRect.copy(_tempRect);
		}
		else
		{
			updateImpl( loadFun,unloadFun);
		}
	}
	
	private function updateImpl( loadFun:Function , unloadFun:Function):void
	{
		if( _currentRect.equals(_tempRect) )
		{
			return;
		}
		var rect:Rect = _currentRect.intersection( _tempRect );
		var _isEmpty:Boolean  = rect.isEmpty;
		var x:int;
		var y:int;
		var i:int;
		// 卸载
		if(unloadFun != null)
		{
			for( x = _currentRect.left; x<= _currentRect.right; x++ )
			{
				for( y = _currentRect.top; y <= _currentRect.bottom; y++ )
				{
					if( rect.contains(x,y) == false)
					{
						unloadFun(x,y);
					}
				}
			}
		}
		// 加载
		if(loadFun != null)
		{
			for( x = _tempRect.left; x<=_tempRect.right; x++ )
			{
				for( y = _tempRect.top; y <= _tempRect.bottom; y++ )
				{
					if( _isEmpty || rect.contains(x,y) == false)
					{
						loadFun(x,y);
					}
				}
			}
		}
		_currentRect.copy(_tempRect);
	}
	
	public function unloadAllPiece(unloadFun:Function,isDispose:Boolean = false):void
	{
		if( _tempRect == null || _tempRect.isEmpty ) return;
		for( var x:int = _tempRect.left; x<= _tempRect.right; x++ )
		{
			for( var y:int = _tempRect.top; y <= _tempRect.bottom; y++ )
			{
				unloadFun(x,y,isDispose);
			}
		}
		dispose();
	}
	
	public function isNeedAdd( x:int,y:int ):Boolean
	{
		return _tempRect.contains(x,y);
	}
	
	/**
	 * 是否不需要加载 
	 * @return  true 是不需要加载
	 * 
	 */	
	public function get isNoNeedLoad():Boolean
	{
		return _currentRect.containsRect(_tempRect);
	}
	
	public function dispose():void
	{
		_currentRect = null;
		_tempRect.setEmpty();
	}
}

class Rect
{
	public var left:int;
	public var right:int;
	public var top:int;
	public var bottom:int;
	
	/**
	 * 两矩形是否相等 
	 * @param rect
	 * @return 
	 * 
	 */	
	public function equals(rect:Rect):Boolean
	{
		if( left != rect.left || right != rect.right || top != rect.top || bottom != rect.bottom )
		{
			return false;
		}
		return true;
	}
	/**
	 * copy 矩形数据 
	 * @param rect
	 * 
	 */	
	public function copy( rect:Rect ):void
	{
		this.left = rect.left;
		this.right = rect.right;
		this.top = rect.top;
		this.bottom = rect.bottom;
	}
	
	public function clone():Rect
	{
		var rect:Rect = new Rect();
		rect.left = this.left;
		rect.right = this.right;
		rect.top = this.top;
		rect.bottom = this.bottom;
		return rect;
	}
	
	public function containsRect( rect:Rect ):Boolean
	{
		if( left > rect.left || right < rect.right || bottom < rect.bottom || top > rect.top  )	
		{
			return false;
		}
		return true;
	}
	
	public function setEmpty():void
	{
		this.left = 0;
		this.right = 0;
		this.top = 0;
		this.bottom = 0;
	}
	
	public function get isEmpty():Boolean
	{
		return left == 0 && right == 0 && top == 0 && bottom==0;
	}
	
	public function contains( x:int,y:int ):Boolean
	{
		if( x < left || x > right || y < top || y > bottom )
		{
			return false;
		}
		return true;
	}
	
	public function intersection( rect:Rect ):Rect
	{
		var reRect:Rect = new Rect();
		
		reRect.left = Math.max(left,rect.left);
		reRect.right = Math.min(right,rect.right);
		reRect.top = Math.max(top,rect.top);
		reRect.bottom = Math.min(bottom,rect.bottom);
		
		return reRect;
	}
	
	public function toString():String
	{
		return [left,right,top,bottom].join(",");
	}
}