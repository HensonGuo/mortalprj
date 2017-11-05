/**
 * 2014-1-7
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap
{
	import com.fyGame.fyMap.FyMapInfo;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.net.CallLater;
	import mortal.component.window.BaseWindow;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.SmallMapCustomMapPointWin;
	import mortal.game.view.mainUI.smallMap.view.SmallMapImage;
	import mortal.game.view.mainUI.smallMap.view.SmallMapPathShower;
	import mortal.game.view.mainUI.smallMap.view.SmallMapRightDown;
	import mortal.game.view.mainUI.smallMap.view.SmallMapRightTop;
	import mortal.game.view.mainUI.smallMap.view.SmallMapTypeShower;
	import mortal.game.view.mainUI.smallMap.view.SmallMapWorldRegion;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapModule extends BaseWindow
	{
		private var _mapInfo:FyMapInfo;
		
		// 切换各种地图的tab
		private var _tab:GTabBar;
		
		// 世界地图、区域地图、当前地图
		private var _curMapContainer:GSprite;
		private var _world:SmallMapWorldRegion;
		private var _region:SmallMapWorldRegion;
		
		// 当前地图的组件
		private var _image:SmallMapImage;
		private var _rightBg:ScaleBitmap;
		private var _rightTop:SmallMapRightTop;
		private var _rightDown:SmallMapRightDown;
		private var _pathShower:SmallMapPathShower;
		private var _typeShower:SmallMapTypeShower;
//		private var _leftTips:SmallMapLeftTips;
		private var _customWin:SmallMapCustomMapPointWin;
		
		private var _curXYBg:ScaleBitmap;
		private var _xy:GTextFiled;
		private var _mapName:String = "";
		private var _curScale:Number;
		
		/// tab 数据
		private var _tabData:Array = [
			{"name":0, "label":Language.getString(20123)},
			{"name":1, "label":Language.getString(20124)},
			{"name":2, "label":Language.getString(20125)},
		]
	
		public function SmallMapModule()
		{
			super();
			setSize(726, 579);
			this.title = Language.getString(20023);
			this.titleHeight = 60;
			isHideDispose = false;
//			this.setWindowCenter();
		}
		
		public function changeToWorld(datas:Array):void
		{
			if(_tab.selectedIndex != 0)
			{
				_tab.selectedIndex = 0;
			}
			DisplayUtil.removeMe(_curMapContainer);
			DisplayUtil.removeMe(_region);
			this.addChild(_world);
			_world.updateAll(datas);
		}
		
		public function changeToRegion(datas:Array):void
		{
			if(_tab.selectedIndex != 1)
			{
				_tab.selectedIndex = 1;
			}
			DisplayUtil.removeMe(_world);
			DisplayUtil.removeMe(_curMapContainer);
			this.addChild(_region);
			_region.updateAll(datas);
		}
		
		public function changeToCur():void
		{
			if(_tab.selectedIndex != 2)
			{
				_tab.selectedIndex = 2;
			}
			DisplayUtil.removeMe(_world);
			DisplayUtil.removeMe(_region);
			this.addChild(_curMapContainer);
		}
		
		/**
		 * 右上角的控制显示、不显示NPC、Boss等 
		 * @return 
		 * 
		 */		
		public function get rightTop():SmallMapRightTop
		{
			return _rightTop;
		}
		
		public function get rightDown():SmallMapRightDown
		{
			return _rightDown;
		}
		
		/**
		 * 左边的图标说明 
		 * @return 
		 * 
		 */		
//		public function get leftTips():SmallMapLeftTips
//		{
//			return _leftTips;
//		}
		
		/**
		 * 地图中的npc、boss等图标的显示 
		 * @return 
		 * 
		 */		
		public function get typeShower():SmallMapTypeShower
		{
			return _typeShower;
		}
		
		public function get pathShower():SmallMapPathShower
		{
			return _pathShower;
		}
		
		private var _tobeIndex:int = 0;
		public function changeToTab(index:int=2):void
		{
			_tobeIndex = index;
			CallLater.addCallBack(nextFrame);
		}
		private function nextFrame():void
		{
			_tab.selectedIndex = _tobeIndex;
			tabBarChangeHandler(null);
		}
		
		public function updateSelfXY(xx:int, yy:int):void
		{
			xx *= _mapInfo.pieceWidth;
			yy *= _mapInfo.pieceHeight;
			_xy.text = _mapName + " (" + xx.toString() + ", " + yy.toString() + ")";
			_pathShower.updateSelfPlace(xx * _curScale, yy * _curScale);
		}
		
		public function showHideCustomXYWin(data:Array):void
		{
			if(_customWin != null && !_customWin.isHide)
			{
				_customWin.hide();
				return;
			}
			if(_customWin == null)
			{
				_customWin = new SmallMapCustomMapPointWin();
				_customWin.layer = this;
				_customWin.x = 715;
				_customWin.y = 165;
			}
		
			_customWin.show(715, 165);
			_customWin.updateData(data);
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tab = UIFactory.gTabBar(16, 37, _tabData, 85, 24, this, tabBarChangeHandler);
			
			// 世界地图
			_world = new SmallMapWorldRegion();
			
			// 区域地图
			_region = new SmallMapWorldRegion();
			
			// 当前地图的东西
			_curMapContainer = new GSprite();
			this.addChild(_curMapContainer);
			
			_image = new SmallMapImage();
			_image.x = 16;
			_image.y = 65;
			_curMapContainer.addChild(_image);
			
			_rightBg = UIFactory.bg(_image.x + _image.width + 2, _image.y, 195, 500, _curMapContainer);
			_rightTop = new SmallMapRightTop();
			_rightTop.x = _rightBg.x;
			_rightTop.y = _rightBg.y;
			_curMapContainer.addChild(_rightTop);
			
			_rightDown = new SmallMapRightDown();
			_rightDown.x = _rightTop.x;
			_rightDown.y = _rightTop.y + 244;
			_curMapContainer.addChild(_rightDown);
			
			_pathShower = new SmallMapPathShower();
			_pathShower.x = _image.x;
			_pathShower.y = _image.y;
			_curMapContainer.addChild(_pathShower);
			
			_typeShower = new SmallMapTypeShower();
			_typeShower.x = _pathShower.x;
			_typeShower.y = _pathShower.y;
			_curMapContainer.addChild(_typeShower);
			
			_curXYBg = UIFactory.bg(_image.x + 10, _image.y + 6, 158, 24, _curMapContainer, ImagesConst.TextBgDisable);
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.align = TextFormatAlign.CENTER;
			_xy = UIFactory.gTextField("", _image.x, _image.y + 8, _curXYBg.width + 48, 20, _curMapContainer, tf);
			
//			_leftTips = new SmallMapLeftTips();
//			_leftTips.x = -125;
//			_leftTips.y = 120;
//			_curMapContainer.addChild(_leftTips);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_world.dispose(isReuse);
			_world = null;
			
			_region.dispose(isReuse);
			_region = null;
			
			_rightBg.dispose(isReuse);
			_image.dispose(isReuse);
			_pathShower.dispose(isReuse);
			_rightTop.dispose(isReuse);
			_rightDown.dispose(isReuse);
			_curXYBg.dispose(isReuse);
			_xy.dispose(isReuse);
			_typeShower.dispose(isReuse);
//			_leftTips.dispose(isReuse);
			
			_image = null;
			_rightBg = null;
			_pathShower = null;
			_rightTop = null;
			_rightDown = null;
			_curXYBg = null;
			_xy = null;
			_typeShower = null;
//			_leftTips = null;
		}
		
		/**
		 * 显示模块 
		 * 
		 */		
		public override function show(x:int=0, y:int=0):void
		{
			super.show();
			updateToMap(Game.mapInfo);
		}
		
		public function getShowingMapInfo():FyMapInfo
		{
			return _mapInfo;
		}
		
		/**
		 * 切换地图的时候，更新到新的小地图 
		 * 
		 */		
		public function updateToMap(info:FyMapInfo):void
		{
			_mapInfo = info;
			if(_mapInfo == null)
			{
				return;
			}
			updateCurScale();
			_mapName = GameMapConfig.instance.getMapInfo(_mapInfo.mapId).name;
			_image.load(_mapInfo, onLoaded);
		}
		
		private function updateCurScale():void
		{
			_curScale = DisplayUtil.calculateFixedScale(_image.bWidth, _image.bHeight, _mapInfo.gridWidth, _mapInfo.gridHeight)
		}
		
		private function onLoaded():void
		{
//			_image.x = (this.width - _image.width)/2;
//			_image.y = (this.height - _image.height)/2;
			// 将shower的坐标设置为地图位图的坐标
			_pathShower.x = _image.x + _image.dx;
			_pathShower.y = _image.y + _image.dy; 
			_typeShower.x = _pathShower.x;
			_typeShower.y = _pathShower.y;
			updateCurScale();
//			_curScale = DisplayUtil.calculateFixedScale(_image.bWidth, _image.bHeight, _mapInfo.gridWidth, _mapInfo.gridHeight);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SMallMapImgLoaded, _mapInfo));
		}
		
		/**
		 * 小地图相对于大地图的比例 
		 * @return 
		 * 
		 */		
		public function get mapScale():Number
		{
			return _curScale;
		}
		
		/**
		 * 显示寻路路径 
		 * @param arr [AstarTurnPoint]
		 * 
		 */		
		public function showPathPoints(arr:Array):void
		{
			_pathShower.showPath(arr, _curScale);
		}
		
		public function clearPaths():void
		{
			_pathShower.clearPaths();
		}
		
		public override function set width(value:Number):void
		{
			_image.myWidth = value;
		}
		
		public override function set height(value:Number):void
		{
			_image.myHeight = value;
		}
	
		
		private function tabBarChangeHandler(evt:*):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapChangeTab, _tab.selectedIndex));
		}
	}
}