/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap
{
	import Message.Public.SCustomPoint;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.fyGame.fyMap.FyMapInfo;
	
	import flash.geom.Point;
	
	import mortal.game.Game;
	import mortal.game.control.subControl.Scene3DClickProcessor;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.MapLoader;
	import mortal.game.scene3D.map3D.MapNodeType;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapWorldRegionData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class SmallMapController extends Controller
	{
		private var _module:SmallMapModule;
		private var _mapIdLoader:MapLoader;
		
		public function SmallMapController()
		{
			super();
		}
		
		protected override function initServer():void
		{
			Dispatcher.addEventListener(EventName.SmallMapChangeTab, tabChangeHandler);
			Dispatcher.addEventListener(EventName.SMallMapImgLoaded, mapLoadedHandler);
			
			Dispatcher.addEventListener(EventName.StageResize, stageResizeHandler);
			Dispatcher.addEventListener(EventName.SmallMapShowHide, smallMapShowHideHandler);
			Dispatcher.addEventListener(EventName.SmallMapClick, smallMapClickHandler);
			Dispatcher.addEventListener(EventName.SmallMapDoubleClick, smallMapDoubleClickHandler);
			Dispatcher.addEventListener(EventName.SmallMapFlybootReq, smallMapFlybootReqHandler);
			Dispatcher.addEventListener(EventName.SmallMapShowCurPoint, showCurPointHandler);
			
			Dispatcher.addEventListener(EventName.SmallMapShowTypeChange, showTypeChangeHandler); // 勾选显示哪些
			
			Dispatcher.addEventListener(EventName.SmallMapShowCustomMapPoinWin, showCustomMapPointWinHandler);
			Dispatcher.addEventListener(EventName.SmallMapSaveCustomPoint, saveCustomPointHandler);
			Dispatcher.addEventListener(EventName.FlyBoot, flyReqHandler);
			
			Dispatcher.addEventListener(EventName.AI_FlyBootCalled, flyBootCalledHandler);
			
			// 获得保存的地图点信息
			NetDispatcher.addCmdListener(ServerCommand.SmallMapCustomMapPointGot, customMapPointGotHandler);
			// 例如传送之后更新目前的位置
			NetDispatcher.addCmdListener(ServerCommand.MapPointUpdate, mapPointUpdateHandler);
			// 传送失败
			NetDispatcher.addCmdListener(ServerCommand.AI_FlyBootFail, flyBootFailHandler);
			
			// 监听角色
			Dispatcher.addEventListener(EventName.MapFindPath, moveStartHandler);
			RolePlayer.instance.addEventListener(PlayerEvent.GIRD_WALK_END, roleWalkGridEndHandler, false, 0, true);
			RolePlayer.instance.addEventListener(PlayerEvent.WALK_END, moveEndHandler, false, 0, true);
			RolePlayer.instance.addEventListener(PlayerEvent.ENTITY_DEAD, moveEndHandler, false, 0, true);
//			Dispatcher.addEventListener(EventName.AI_MoveEnd, moveEndHandler);
			
			// 监听切换地图
			Dispatcher.addEventListener(EventName.MapSwitchToNewMap, mapSwitchHandler);
			// 监听用户点击世界、区域地图上的各个地图
			Dispatcher.addEventListener(EventName.SmallMapClickWorldRegion, clickWorldRegionHandler);
		}
		
		private function clickWorldRegionHandler(evt:DataEvent):void
		{
			var data:SmallMapWorldRegionData = evt.data as SmallMapWorldRegionData;
			if(data.type == SmallMapWorldRegionData.World)
			{
				// 在世界区域中点击， 那么跳到区域地图
				var datas:Array = cache.smallmap[data.value];
				_module.changeToRegion(datas);
			}
			else if(data.type == SmallMapWorldRegionData.Region)
			{
				// 在区域地图中点击，那么跳到具体的地图中
				var mapId:int = parseInt(data.value.substr(9));
				MapLoader.instance.loadMapData(mapId, onMapIdLoadedHandler);
			}
		}
		
		private function onMapIdLoadedHandler(mapInfo:FyMapInfo):void
		{
			if(_module && !_module.isHide)
			{
				_module.changeToCur();
				_module.updateToMap(mapInfo);
			}
		}
		
		private function mapSwitchHandler(evt:DataEvent):void
		{
			if(_module == null || _module.isHide)
			{
				return;
			}
			_module.updateToMap(Game.mapInfo);
//			_module.typeShower.showFlyBoot(false);
//			_module.typeShower.showTargetPoint(false);
//			cache.
//			_module.clearPaths();
			moveEndHandler(null);
		}
		
		
		private function showCustomMapPointWinHandler(evt:DataEvent):void
		{
			if(_module && cache.smallmap.customMapPointArr != null)
			{
				_module.showHideCustomXYWin(cache.smallmap.customMapPointArr);
			}
		}
		
		private function saveCustomPointHandler(evt:DataEvent):void
		{
			var data:SCustomPoint = evt.data as SCustomPoint;
			if(data == null)
			{
				return;
			}
			
			cache.smallmap.addCustomMapPoint(data);
			GameProxy.sceneProxy.saveCustomMapPoint(data.index, data.name, data.mapId, data.point);
			
			if(_module != null && !_module.isHide)
			{
				_module.rightDown.updateDatas(cache.smallmap.customMapPointData);
			}
		}
		
		private function flyReqHandler(evt:DataEvent):void
		{
			var pt:SPassTo = evt.data as SPassTo;
			AIManager.onAIControl(AIType.FlyBoot, pt);
		}
		
		private function customMapPointGotHandler(obj:Object):void
		{
			if(_module != null && !_module.isHide)
			{
				_module.rightDown.updateDatas(cache.smallmap.customMapPointData);
			}
		}
		
		private function mapPointUpdateHandler(passTo:SPassTo):void
		{
			var p:Point = RolePlayer.instance.getTilePoint();
			if(_module && !_module.isHide)
			{
				_module.updateSelfXY(p.x, p.y);
				_module.clearPaths();
			}
		}
		
		/**
		 * 传送失败， 那么启动走路AI 
		 * @param p
		 * 
		 */		
		private function flyBootFailHandler(pt:SPassTo):void
		{
			var p:Point = new Point(pt.toPoint.x, pt.toPoint.y);
			if(pt.mapId == Game.mapInfo.mapId)
			{
				Scene3DClickProcessor.gotoPoint(p);
			}
			else // 不同地图 
			{
				pt.mapId;
			}
		}
		
		private function flyBootCalledHandler(evt:DataEvent):void
		{
			if(_module && !_module.isHide)
			{
				_module.clearPaths();
				_module.typeShower.showFlyBoot(false);
				_module.typeShower.showTargetPoint(false);
			}
		}
		
		protected override function initView():IView
		{
			if(_module == null)
			{
				_module = new SmallMapModule();
			}
			return _module;
		}
		
		private function tabChangeHandler(evt:DataEvent):void
		{
			var index:int = int(evt.data);
			switch(index)
			{
				case 0:
					_module.changeToWorld(cache.smallmap.worldDatas);
					break;
				case 1:
					_module.changeToRegion(cache.smallmap.getRegionDataByMapId(Game.mapInfo.mapId));
					break;
				case 2:
					_module.changeToCur();
					_module.updateToMap(Game.mapInfo);
					break;
			}
		}
		
		private function mapLoadedHandler(evt:DataEvent):void
		{
			var info:FyMapInfo = evt.data as FyMapInfo;
			
			if(_module == null || _module.isHide)
			{
				return;
			}
			updateSmallMapAll(info.mapId);
//			CallLater.addCallBack(nextFrameAfterMapLoaded);
		}
		private function nextFrameAfterMapLoaded():void
		{
			updateSmallMapAll(Game.mapInfo.mapId);
		}
		
		private var _isCurMap:Boolean = true;
		private function updateSmallMapAll(mapId:int):void
		{
			_isCurMap = (mapId == Game.mapInfo.mapId);
			if(_module == null || _module.isHide)
			{
				return;
			}
			// 右上角
			_module.rightTop.updateItems(cache.smallmap.showTypes);
			
			// 当前地图点
			roleWalkGridEndHandler(null);
			
			// 更新正在进行的地图点
			if(_isCurMap)
			{
				var arr:Array = cache.smallmap.paths;
				if(arr.length > 1)
				{
					_module.showPathPoints(arr);
				}
				_module.pathShower.visible = true;
			}
			else
			{
				_module.clearPaths();
				// 把自己当前的坐标也隐藏
//				_module.pathShower.showHideSelfIcon(false);
				_module.pathShower.visible = false;
				_module.typeShower.showTargetPoint(false);
				_module.typeShower.showFlyBoot(false);
			}
			
			// 更新地图中的NPC、Boss、队友的小图标
			for(var i:int = 0; i < cache.smallmap.showTypes.length; i++)
			{
				var obj:Object = cache.smallmap.showTypes[i];
				updateMapPointTypeShow(obj, mapId);
			}
			
			// 左边的tips
//			_module.leftTips.updateItems(cache.smallmap.tipsTypes);
			
			// 更新右下角的自定义坐标信息
			if(cache.smallmap.customMapPointArr == null)
			{
				GameProxy.sceneProxy.getCustomMapPoint();
			}
			else
			{
				_module.rightDown.updateDatas(cache.smallmap.customMapPointData);
			}
		}
		
		private function updateMapPointTypeShow(obj:Object, mapId:int):void
		{
			if(!_module || _module.isHide)
			{
				return;
			}
			var scale:Number = _module.mapScale;
			var type:int = obj["type"];
			var isShow:Boolean = !ClientSetting.local.getIsDone(type);
			if(isShow)
			{
				var datas:Array = cache.smallmap.getDataByType(type, mapId);
				_module.typeShower.updateTypeShow(type, scale, datas);
			}
			else
			{
				_module.typeShower.updateTypeShow(type, scale, []);
			}
		}
		
		private function moveStartHandler(evt:DataEvent):void
		{
			var path:Array = evt.data as Array;
			cache.smallmap.paths = path;
			showMoveTarges();
		}
		
		private function showMoveTarges():void
		{
			if(!_isCurMap)
			{
				return;
			}
			var path:Array = cache.smallmap.paths;
			if(path == null || path.length == 0)
			{
				return;
			}
			if(_module == null || _module.isHide)
			{
				return;
			}
			var p:Point = path[path.length - 1] as Point;
			var test:Point = AstarAnyDirection.findNearestWalkablePoint(p.x, p.y);
			var tx:int = (test.y + 0.5) * Game.mapInfo.pieceWidth * _module.mapScale;
			var ty:int = (test.x + 0.5) * Game.mapInfo.pieceHeight * _module.mapScale;
			_module.typeShower.showTargetPoint(true, tx, ty);
			_module.typeShower.showFlyBoot(true, tx, ty);
		}
		
		private function moveEndHandler(evt:*=null):void
		{
			cache.smallmap.paths = [];
			if(_module)
			{
				_module.typeShower.showTargetPoint(false);
				_module.typeShower.showFlyBoot(false);
				_module.clearPaths();
			}
		}
		
		private function roleWalkGridEndHandler(evt:PlayerEvent):void
		{
			var p:Point = RolePlayer.instance.getTilePoint();
			cache.smallmap.removePathPoint(p);
			if(_module && !_module.isHide)
			{
				_module.updateSelfXY(p.x, p.y);
				_module.showPathPoints(cache.smallmap.paths);
			}
		}
		
		private function stageResizeHandler(evt:DataEvent):void
		{
			
		}
		
		private function smallMapShowHideHandler(evt:DataEvent):void
		{
			if(_module == null)
			{
				_module = view as SmallMapModule;
			}
			if(evt.data == null || evt.data["isShow"] == null)
			{
				if(_module.isHide)
				{
					_module.show();
				}
				else
				{
					_module.hide();
					return;
				}
			}
			else if(evt.data != null)
			{
				if(evt.data["isShow"])
				{
					_module.show();
				}
				else
				{
					_module.hide();
					return;
				}
			}
			
			_module.changeToTab(2);
		}
		
		/**
		 * x、y像素坐标 
		 * @param evt
		 * 
		 */		
		private function smallMapClickHandler(evt:DataEvent):void
		{
			var info:FyMapInfo = evt.data["mapInfo"];
			if(info == null)
			{
				info = _module.getShowingMapInfo();
			}
			var x:int = evt.data["x"];///info.pieceWidth;
			var y:int = evt.data["y"];///info.pieceHeight;
			
			if(info == null || info.mapId == Game.mapInfo.mapId)
			{
				Scene3DClickProcessor.gotoPoint(new Point(x, y), true, 0);
			}
//			var res:Vector.<SPassPoint> = MapPathSearcher.findMapPath(Game.mapInfo.mapId, info.mapId);
			else
			{
				var pt:Point = new Point();//GameMapUtil.getPixelPoint(test.y + 0.5, test.x + 0.5);;
//				if(test.y == x && test.x == y)
//				{
					pt.x = evt.data["x"];
					pt.y = evt.data["y"];
//				}
				AIManager.onAIControl(AIType.GoToOtherMap, Game.mapInfo.mapId, info.mapId, pt);
				
				_module.typeShower.showTargetPoint(true, pt.x * _module.mapScale, pt.y * _module.mapScale);
				_module.typeShower.showFlyBoot(true, pt.x * _module.mapScale, pt.y * _module.mapScale);
			}
		}
		
		/**
		 * 双击传送， x、y像素坐标 
		 * @param evt
		 * 
		 */		
		private function smallMapDoubleClickHandler(evt:DataEvent):void
		{
			var x:int = evt.data["x"];
			var y:int = evt.data["y"];
			var info:FyMapInfo = evt.data["mapInfo"];
			if(info == null)
			{
				info = _module.getShowingMapInfo();
			}
			
			var gx:int = x/Game.mapInfo.pieceWidth;
			var gy:int = y/Game.mapInfo.pieceHeight;
			
			var pt:SPassTo = new SPassTo();
			pt.mapId = info.mapId;
			var p:SPoint = new SPoint();
			pt.toPoint = p;
			
			if(MapNodeType.isWalk(GameMapUtil.getPointValue(gx, gy)))
			{
				pt.toPoint.x = x;
				pt.toPoint.y = y;
			}
			else
			{
				var test:Point = AstarAnyDirection.findNearestWalkablePoint(gx, gy);
				p.x = (test.y + 0.5) * info.pieceWidth;
				p.y = (test.x + 0.5) * info.pieceHeight;
			}
			
			_module.typeShower.showTargetPoint(false);
			_module.typeShower.showFlyBoot(false);
			AIManager.onAIControl(AIType.FlyBoot, pt);
		
		}
		
		private function smallMapFlybootReqHandler(evt:DataEvent):void
		{
			var p:SPoint = evt.data as SPoint;
			
			var mapId:int = Game.mapInfo.mapId;
			p.x = (p.x)/_module.mapScale;
			p.y = (p.y) / _module.mapScale;
			var info:FyMapInfo = _module.getShowingMapInfo();
			
			_module.typeShower.showTargetPoint(false);
			_module.typeShower.showFlyBoot(false);
			
			var pt:SPassTo = new SPassTo();
			pt.mapId = info.mapId;
			pt.toPoint = p;
			AIManager.onAIControl(AIType.FlyBoot, pt);
		}
		
		private function showCurPointHandler(evt:DataEvent):void
		{
			var x:int = evt.data["x"];
			var y:int = evt.data["y"];
//			Scene3DClickProcessor.gotoPoint(new Point(x, y));
			if(_module != null)
			{
				_module.rightDown.updateMouseXY(x, y);
			}
		}
		
		private function showTypeChangeHandler(evt:DataEvent):void
		{
			var type:uint = evt.data["type"];
			var value:Boolean = evt.data["value"];
			ClientSetting.local.setIsDone(value, type);
//			SystemSetting.save();
			
			var obj:Object;
			for(var i:int = 0; i < cache.smallmap.showTypes.length; i++)
			{
				if(cache.smallmap.showTypes[i]["type"] == type)
				{
					obj = cache.smallmap.showTypes[i];
					break;
				}
			}
			if(obj != null)
			{
				updateMapPointTypeShow(obj, Game.mapInfo.mapId);
			}
		}
		
		
	}
}