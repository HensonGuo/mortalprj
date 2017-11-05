/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import com.fyGame.fyMap.FyMapInfo;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.global.PathConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.info.GMapInfo;
	import mortal.game.resource.info.MapImgInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapImage extends GSprite
	{
		private var _bg:ScaleBitmap;
		private var _bitmapContainer:GSprite;
		private var _bitmap:GBitmap;
		private var _curMapId:int;
		private var _loading:Boolean = false;
		private var _loadingFileName:String;
		private var _smallMapScale:Number = 0.5;
		
		private var _myWidth:int = 500;
		private var _myHeight:int = 500;
		
		private var _mapInfo:FyMapInfo;
		private var _callback:Function;
		
		public function SmallMapImage()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.bg(0, 0, 500, 500, this);
			_bitmapContainer = new GSprite();
			this.addChild(_bitmapContainer);
			_bitmap = UIFactory.bitmap("", 0, 0, _bitmapContainer);
			
			// 监听事件
			_bitmapContainer.mouseEnabled = true;
			_bitmapContainer.doubleClickEnabled = true;
			_bitmapContainer.configEventListener(MouseEvent.CLICK, clickHandler);
			_bitmapContainer.configEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			_bitmapContainer.configEventListener(MouseEvent.DOUBLE_CLICK, flyToHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bg.dispose(isReuse);
			_bitmap.dispose(isReuse);
			
			_bg = null;
			_bitmap = null;
		}
		
		public function get myWidth():int
		{
			return _myWidth;
		}

		public function set myWidth(value:int):void
		{
			_myWidth = value;
		}

		public function get myHeight():int
		{
			return _myHeight;
		}

		public function set myHeight(value:int):void
		{
			_myHeight = value;
		}

		public function get smallMapScale():Number
		{
			return _smallMapScale;
		}

		public function load(info:FyMapInfo, callback:Function):void
		{
			_callback = callback;
			_mapInfo = info;
			if(_mapInfo.mapId != _curMapId)
			{
				if(_loading)
				{
					// 停止当前的
					stop();
				}
				// 重新加载
				loadMiniMap(_mapInfo.mapId);
			}
			else
			{
				if(!_loading)
				{
					if(callback != null)
					{
						callback.apply();
					}
				}
			}
		}
		
		private function loadMiniMap(mapId:int):void
		{
			var info:ResourceInfo= getImageInfo(_mapInfo);
			if(info)
			{
				_curMapId = mapId;
				_loading = true;
				_loadingFileName = info.name;
				LoaderManager.instance.loadInfo(info , onLoaded);
			}
		}
		
		public function stop():void
		{
			_loading = false;
			_loadingFileName = "";
			LoaderManager.instance.removeResourceEvent(_loadingFileName, onLoaded);
		}
		
		private function onLoaded( info:MapImgInfo = null ):void
		{
			_loading = false;
			_loadingFileName = "";
			if( info == null || info.mapID != _curMapId )
			{
				if(_callback != null)
				{
					_callback.apply();
				}
				return;
			}
			
			var bd:BitmapData = info.bitmapData;
			_smallMapScale = DisplayUtil.calculateFixedScale(_myWidth, _myHeight, bd.width, bd.height);
			
			_bitmap.bitmapData = bd;
			_bitmap.scaleX = _smallMapScale;
			_bitmap.scaleY = _smallMapScale;
			
			_bitmap.x = (500 - _bitmap.width)/2;
			_bitmap.y = (500 - _bitmap.height)/2;
			
			if(_callback != null)
			{
				_callback.apply();
			}
		}
		public function get bWidth():int
		{
			return _bitmap.width;// * _smallMapScale;
		}
		
		public function get bHeight():int
		{
			return _bitmap.height;// * _smallMapScale;
		}
		
		public function get dx():int
		{
			return _bitmap.x;
		}
		
		public function get dy():int
		{
			return _bitmap.y;
		}
		
		private function getImageInfo( mapInfo:FyMapInfo):ResourceInfo
		{
			var fileName:String = mapInfo.mapId.toString() + "_mini.abc";
			
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
			
			
			if( info )
			{
				return info;
			}
			else
			{
				var mapImgInfo:MapImgInfo = new MapImgInfo(); //{ name:name,type:".JPG",time:"1",path:path+name}
				mapImgInfo.name = fileName;
				mapImgInfo.mapID = mapInfo.mapId;
				
				var path:String = mapImgInfo.mapID  + "/" + fileName;
				var gMapInfo:GMapInfo = GameMapConfig.instance.getMapInfo(mapImgInfo.mapID);
				
				mapImgInfo.loaclPath = PathConst.mapLocalPath+path;
				mapImgInfo.time = gMapInfo.version;
				mapImgInfo.path= PathConst.mapPath + path+"?v="+mapImgInfo.time;
				mapImgInfo.type = ".abc";
				ResourceManager.addResource(mapImgInfo);
				return mapImgInfo;
				
			}
			return null;
		}
		
		private var _delayId:int;
		private function clickHandler(evt:MouseEvent):void
		{
			var gotoX:int = _bitmap.mouseX * _smallMapScale * (_mapInfo.gridWidth/_bitmap.width);
			var gotoY:int = _bitmap.mouseY * _smallMapScale *(_mapInfo.gridHeight/_bitmap.height);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapClick, {"x":gotoX, "y":gotoY, "mapInfo":_mapInfo}));
		}
		
		private function flyToHandler(evt:MouseEvent):void
		{
			var gotoX:int = _bitmap.mouseX * _smallMapScale * (_mapInfo.gridWidth/_bitmap.width);
			var gotoY:int = _bitmap.mouseY * _smallMapScale *(_mapInfo.gridHeight/_bitmap.height);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapDoubleClick, {"x":gotoX, "y":gotoY, "mapInfo":_mapInfo}));
		}
		
		private function moveHandler(evt:MouseEvent):void
		{
			var gotoX:int = _bitmap.mouseX * _smallMapScale * (_mapInfo.gridWidth/_bitmap.width);
			var gotoY:int = _bitmap.mouseY * _smallMapScale *(_mapInfo.gridHeight/_bitmap.height);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapShowCurPoint, {"x":gotoX, "y":gotoY}));
		}
	}
}