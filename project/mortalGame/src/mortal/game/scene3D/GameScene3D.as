package mortal.game.scene3D
{
	import com.fyGame.fyMap.FyMapInfo;
	import com.gengine.core.FrameUtil;
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.debug.FPS;
	import com.gengine.debug.GameStatistical;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderPriority;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import Message.Public.SPoint;
	
	import baseEngine.basic.Viewer3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.util.DepthRenderUtil;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Npc3DManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.info.GMapBgInfo;
	import mortal.game.scene3D.display3d.blood.BloodFactory;
	import mortal.game.scene3D.display3d.icon3d.Icon3DFactory;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3DFactory;
	import mortal.game.scene3D.display3d.text3d.staticText3d.SText3DFactory;
	import mortal.game.scene3D.events.SceneEvent;
	import mortal.game.scene3D.fight.SkillEffectUtil;
	import mortal.game.scene3D.layer3D.BottomMapLayer;
	import mortal.game.scene3D.layer3D.MapExtendLayer;
	import mortal.game.scene3D.layer3D.MapLayer3D;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.layer3D.model.MapLayerType;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.MapBitmap3DRender;
	import mortal.game.scene3D.map3D.MapConst;
	import mortal.game.scene3D.map3D.MapLoader;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridToPixels;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridToTargetPoint;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.model.SceneGlobalPlayer;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.util.MoveUtil;
	import mortal.game.utils.BuffUtil;
	import mortal.mvc.core.Dispatcher;

	public class GameScene3D extends Viewer3D
	{


		private var _overlayerRenderEvent:Event=new Event(Engine3dEventName.OVERLAY_RENDER_EVENT);
		public static const OVERLAY_RENDER_EVENT_FLAG:int = (1 << 8);
		public var topMapLayer:MapLayer3D; //上面地图层
		public var bottomMapLayer:BottomMapLayer; //底部地图层
		public var playerLayer:PlayerLayer; //玩家层

		public var mapExtendLayer:MapExtendLayer; // 地图和玩家之间层

		//		private var _astar:AStar;

		public var gameCamera:GameCamera;

		public var rolePlayer:RolePlayer;

		private var _timer:FrameTimer;

		private var _isInitialize:Boolean = false;

		private var _isInLockScene:Boolean = false;

		private var _depthRenderUtil:DepthRenderUtil;

		private var _curSelectMesh:Mesh3D;

		public function GameScene3D(container:DisplayObjectContainer, smooth:Number = 1, speedFactor:Number = 0.5)
		{
			super(container, smooth, speedFactor);
			initCamera();
			initParams();
			initLayers();
			
			this.mouseEnabled = false;
			Rect3DManager.instance.init(this);
			Npc3DManager.instance.init(this);
			this.firstDrawFun=topMapLayer.draw;
		}

		public override function setViewport(_arg1:Number = 0, _arg2:Number = 0, _arg3:Number = 640, _arg4:Number = 480, _arg5:int = 0):void
		{
			super.setViewport(_arg1, _arg2, _arg3, _arg4, _arg5);
			Log.debug(_arg1, _arg2, _arg3, _arg4, _arg5);
			
		}

		override public function addEventListener(_arg1:String , _arg2:Function , _arg3:Boolean = false , _arg4:int = 0 , _arg5:Boolean = false):void
		{
			super.addEventListener(_arg1,_arg2,_arg3,_arg4,_arg5);
			switch (_arg1)
			{
				case Engine3dEventName.OVERLAY_RENDER_EVENT:
					this._eventFlags = (this._eventFlags | OVERLAY_RENDER_EVENT_FLAG);
					break;
			}
		}
		
		private function initCamera():void
		{
			gameCamera = new GameCamera("Default_Scene_Camera");
			
			//gameCamera.viewPort=_boundRect;
			Device3D.camera = gameCamera;
			this.camera = gameCamera;
			gameCamera.parent = this;
			gameCamera.updateProjectionMatrix();
		}

		public function resetViewPort():void
		{

			this.setViewport(0, 0, SceneRange.display.width, SceneRange.display.height);
			Scene3DUtil.gameCameraCopy.updateProjectionMatrix();
			Rect3DManager.instance.resize();
			Npc3DManager.instance.resize();
			topMapLayer.resize();
			bottomMapLayer.resize();
		}

		private function initParams():void
		{
			this.enableUpdateAndRender = false;
			this.checkEventPhase = true;
			this.backgroundColor = 0x333333;
			this.autoResize = false;

			//			_astar = new AStar();
			rolePlayer = RolePlayer.instance;
		}

		private function initLayers():void
		{
			bottomMapLayer = BottomMapLayer.instance;

			topMapLayer = new MapLayer3D(MapLayerType.MAPNORMAL, LoaderPriority.LevelA);

			mapExtendLayer = new MapExtendLayer("");

			playerLayer = new PlayerLayer("");

			this.addChild(bottomMapLayer);

			this.addChild(topMapLayer);
			
			this.addChild(mapExtendLayer);

			this.addChild(playerLayer);
			
			/*this.setLayerSortMode(Layer3DManager.modelLayer0);
			this.setLayerSortMode(Layer3DManager.AlphaLayer0);
			this.setLayerSortMode(Layer3DManager.AlphaLayer1);
			this.setLayerSortMode(Layer3DManager.AlphaLayer2);
			this.setLayerSortMode(Layer3DManager.particleLayer);*/
		}

		public function start():void
		{
			if (this.context)
			{
				startEnterframe();
			}
			else
			{
				this.addEventListener(Event.CONTEXT3D_CREATE, startEnterframe);
			}
		}

		private function startEnterframe(e:Event = null):void
		{
			if (!_depthRenderUtil)
			{
				_depthRenderUtil = new DepthRenderUtil(container);
			}

			_timer = new FrameTimer(1, int.MAX_VALUE, true);
			_timer.addListener(TimerType.ENTERFRAME, mainLoop);
			_timer.start();
			
			//			Global.stage.addEventListener(Event.ACTIVATE,onActivete);
			FrameUtil.driveInfo = this.context.driverInfo;
			
			BloodFactory.init(this);
			
			//ShadowFactory.init(this);
			
			Icon3DFactory.instance.init(this);
			
			Text3DFactory.instance.init(this);
			
			SText3DFactory.instance.init(this);
		}

		private function onActivete(e:Event):void
		{
			drawStage();
		}

		/**
		 * 主循环 如果最小化用补帧策略  非最小化用时间策略
		 * @param timer
		 *
		 */
		private function mainLoop(timer:FrameTimer = null):void
		{
			//mapGroundLayer.update();

			//topMapLayer.update();

			//补帧不需要绘制
			if (!timer.isRepair || !Global.isActivate)
			{
				CONFIG::Debug
				{
					GameStatistical.reset();
				}
//				Log.debug("update消耗开始时间",getTimer());
				this.update();
//				Log.debug("update消耗结束时间",getTimer());

				MoveUtil.updateEntityPos();

				if (!timer.isRepair)
				{
					if (timer.currentCount % 4 == 0)
					{
						var scenePoint:Point=Scene3DUtil.getSceneMousePostion(stage.mouseX,stage.mouseY,false);
						updateMouseOver(scenePoint.x, scenePoint.y);
					}
					Device3D.drawCalls2d=0;
					drawStage();
					GameStatistical.draw3dNum = Device3D.drawCalls3d;
					GameStatistical.drawTopMapNum = Device3D.drawCalls2d;
				}
			}
		}

		private var _addNum:int=0;
		
		private function drawStage():void
		{

			if(!rolePlayer.isMove)
			{
				SceneRange.bitmapSelfMoveX += SceneRange.bitmapSelfMoveXSpeed;
				if (SceneRange.bitmapSelfMoveX + SceneRange.bitmapFarXY.x > 0 && Game.mapInfo)
				{
					SceneRange.bitmapSelfMoveX -= Game.mapInfo.bgMapWidth;
				}
			}

			/*if(TimeControler.stageFrame%100==0)
			{
				shake(0.8);
			}*/
			if (!this.paused)
			{
				
				var _old:Boolean=this.toTexture;
				if(_isTweening)
				{
					this.toTexture=true;
				}else
				{ 
					this.toTexture=false;
				}
				
				if(FPS.instance.fpsNum>47)
				{
					_addNum++;
					if(_addNum>60 && this._antialias!=2)//间隔2秒钟切换渲染模式
					{
						this.antialias=2;
					}
				}else
				{
					this._antialias!=0 && (this.antialias=0);
					_addNum=0;
				}

				GameStatistical.drawType=String(this.antialias);
				
				this.render(this.gameCamera,null,false);
				
				if (this._eventFlags & OVERLAY_RENDER_EVENT_FLAG)
				{
					Device3D.setViewProj(Scene3DUtil.gameCameraCopy.viewProjection); //屏幕坐标系
					dispatchEvent(_overlayerRenderEvent);
				}
				
				bottomMapLayer.draw(false,null);
				
				this.endFrame();
				context.present();

			}
			
		}
		
		public function updateMouseOver(mx:Number, my:Number):void
		{
			if(_mouseEnabled)
			{
				ThingUtil.onMouseOver(mx,my);
			}
		}


		public function get isInitialize():Boolean
		{
			return _isInitialize;
		}

		/**
		 * 设置人物当前位置
		 * @param mapID
		 * @param x
		 * @param y
		 * x y 是 格子 X Y;
		 *
		 */
		public function setPlayerPoint(mapID:int, x:int, y:int):void
		{
			_isInitialize = false;
			var sp:SPoint = new SPoint();
			sp.x = x;
			sp.y = y;
			Cache.instance.role.entityInfo.points = [sp];
			loadMapData(mapID);
		}

		/**
		 * 加载地图数据
		 * @param mapID
		 *
		 */
		private function loadMapData(mapID:int):void
		{
			//rolePlayer.stopAiWalking();
			MapFileUtil.mapID = mapID; //初始化 文件规则
			MapLoader.instance.addEventListener(Event.COMPLETE, onLoadedHandler);
			MapLoader.instance.load();
		}

		/**
		 * 加载完地图 初始哈地图数据 和玩家数据
		 * @param info
		 *
		 */
		private function onLoadedHandler(event:Event):void
		{
			initMapData(Game.mapInfo);

			//			topMapLayer.loadMiniMap();

			//			topMapLayer.setWH(GameMapUtil.mapWidth,GameMapUtil.mapHeight);

			initPlayer();

			_isInitialize = true;

			dispatchEvent(new SceneEvent(SceneEvent.INIT));
			Dispatcher.dispatchEvent(new DataEvent(EventName.MapSwitchToNewMap, Game.mapInfo.mapId));
		}

		/**
		 * 初始化地图数据
		 * @param info
		 *
		 */
		private function initMapData(info:FyMapInfo):void
		{
			Game.mapInfo = info;
			var bgInfo:GMapBgInfo = GameMapConfig.instance.getMapInfo(info.mapId).bgInfo;
			if (bgInfo)
			{
				info.bgMapWidth = bgInfo.mapWidth;
				info.bgMapHeight = bgInfo.mapHeight;
			}

			// 赋值 地图属性
			GameMapUtil.init(info);
			// 赋值地图场景范围
			SceneRange.init(info);
			//地图静态数据
			MapConst.init(info);

			//			_astar.mapData = info.mapData;
			AstarAnyDirection.mapData = info.mapData;
			
			MapBitmap3DRender.instance.resetBgMapInfo();
		}

		/**
		 * 初始化主角
		 *
		 */
		public function initPlayer():void
		{
			var isSpaChange:Boolean;
			var entityInfo:EntityInfo = Cache.instance.role.roleEntityInfo;
			if (playerLayer.contains(RolePlayer.instance) == false)
			{
				RolePlayer.instance.addToLayer();
				RolePlayer.instance.updateInfo(entityInfo, true);
			}
			else
			{
				RolePlayer.instance.updateInfo(entityInfo, false);
			}

			RolePlayer.instance.stopMove();
			
			ThingUtil.entityUtil.addPlayers(RolePlayer.instance.entityInfo.entityInfo.entityId, RolePlayer.instance);
			ThingUtil.isMoveChange = true;
		}

		private var intRect:Rectangle = new Rectangle();

		/**
		 * 滚动场景 并操作加载地图
		 * @param value
		 *
		 */
		public function set scrollRect(value:Rectangle):void
		{
			SceneRange.display = value;
			topMapLayer.updatePos(SceneRange.displayInt);
			topMapLayer.loadMapPiece(SceneRange.loadMapRange, SceneRange.drawMapRange);
			LayerManager.entityTalkLayer.updateTalkPosition();
			//mapGroundLayer.updatePos(SceneRange.bitmapFarXYInt);
			//mapGroundLayer.loadMapPiece(SceneRange.loadMapFarRange, SceneRange.drawMapFarRange);

			gameCamera.setScreenPos(SceneRange.displayInt);
		}

		/**
		 * 移动角色
		 * @param endPoint 目标点位置
		 * @param skillId
		 *
		 */
		public function moveRole(endPoint:Point, skillId:int = 0):void
		{
			if(BuffUtil.isCanRoleWalk())
			{
				gotoPoint(endPoint);
			}
			else
			{
				MsgManager.showRollTipsMsg("当前状态不可移动");
			}
		}

		//		public function flyGotoPoint():void
		//		{
		//			if(rolePlayer.targetTilePoint.x !=_tempEndPoint.x && rolePlayer.targetTilePoint.y !=_tempEndPoint.y && _tempEndPoint.x > 0 && _tempEndPoint.y > 0 )
		//			{
		//				gotoPoint( _tempEndPoint );
		//			}
		//		}

		private var _tempEndPoint:Point = new Point();

		private function gotoPoint(endPoint:Point):void
		{
			_tempEndPoint.x = endPoint.x;
			_tempEndPoint.y = endPoint.y;
			var startPoint:Point = new Point(rolePlayer.x2d, rolePlayer.y2d);
		
			var isWalk:Boolean = true;

			var pathAry:Array = findPath(startPoint.x, startPoint.y, endPoint.x, endPoint.y, isWalk);
			
			if (pathAry)
			{
				moveRoleByPath(pathAry);
			}
		}

		public function moveRoleByPath(path:Array):void
		{
//			AiResultChecker.check(path);
			Dispatcher.dispatchEvent(new DataEvent(EventName.MapFindPath, path));
			if (path)
			{
				if (path.length == 0)
				{
					return;
				}
				rolePlayer.inServerMove = false;
				rolePlayer.walking(path);
			}
		}

		/**
		 * 输入的是像素点， 
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @param isWalk
		 * @return [AstarTurnPoint], 像素点
		 * 
		 */		
		public function findPath(sx:int, sy:int, ex:int, ey:int, isWalk:Boolean):Array
		{
			var start:int = getTimer();
			var sp:Point = GameMapUtil.getTilePoint(sx, sy);
			var ep:Point = GameMapUtil.getTilePoint(ex, ey);
			var res:Array = AstarAnyDirection.findPath(sp.x, sp.y, ep.x, ep.y, isWalk);
			if (res == null || res.length == 0)
			{
				Log.system("找不到有效路径");
				return [];
			}
			else
			{
				var tmp:Number;
				for (var i:int = 0; i < res.length; i++)
				{
					var p:AstarTurnPoint = res[i];
					tmp = p._x;
					p._x = p._y;
					p._y = tmp;
				}
			}
			res = MapGridToPixels.work(res);
			MapGridToTargetPoint.work(res, ex, ey);
			trace("寻路时间。。。。。。。。。。。。。。。。。。。。。。" + (getTimer() - start));
			return res;
		}

		public function addPointMark(x:int, y:int):void
		{
			if (mapExtendLayer.contains(pointMask) == false)
			{
				mapExtendLayer.addChild(pointMask);
			}
			pointMask.x2d = x;
			pointMask.y2d = y;
			pointMask.play(true);
		}

		public function removePointMark():void
		{
			if (mapExtendLayer.contains(pointMask))
			{
				pointMask.stop();
				mapExtendLayer.removeChild(pointMask);
			}
		}

		public function get pointMask():EffectPlayer
		{
			return SceneGlobalPlayer.pointMask;
		}

		/**
		 * 锁频 
		 * 
		 */		
		public function lockSceen():void
		{
			_isInLockScene = true;
		}
		
		/**
		 * 锁频 
		 * 
		 */		
		public function unLockSceen():void
		{
			_isInLockScene = false;
		}
		
		/**
		 * 锁屏 
		 * @param toX  格子坐标X
		 * @param toY
		 * @param time 时间
		 * 
		 */		
		public function tweenScrollRect(toCenterX:Number,toCenterY:Number,time:Number = 0.5,onCompl:Function = null):void
		{
			_isInLockScene = true;
			
			//当前屏幕
			var rec:Rectangle = new Rectangle(SceneRange.display.x,SceneRange.display.y,SceneRange.display.width,SceneRange.display.height);
			
			TweenMax.to(rec,time,{dynamicProps:{x:getX, y:getY},onUpdate:function():void
			{
				rec.width = Global.stage.stageWidth;
				rec.height = Global.stage.stageHeight;
				scrollRect = rec;
			},onComplete:function():void
			{
				ThingUtil.isEntitySort = true;
				ThingUtil.isMoveChange = true;
				if(onCompl != null)
				{
					onCompl.call();
				}
			}});
			
			function getX():Number
			{
				var sx:int = toCenterX - Global.stage.stageWidth/2;
				if(sx + Global.stage.stageWidth > SceneRange.map.right)
				{
					sx =  SceneRange.map.right - Global.stage.stageWidth;
				}
				sx = sx < 0?0:sx;
				return sx;
			}
			
			function getY():Number
			{
				var sy:int = toCenterY - Global.stage.stageHeight/2;
				if(sy + Global.stage.stageHeight > SceneRange.map.bottom)
				{
					sy =  SceneRange.map.bottom - Global.stage.stageHeight;
				}
				sy = sy < 0?0:sy;
				return sy;
			}
		}
		
		/**
		 * 取消锁屏
		 * 
		 */
		public function stopTweenScrollRect(time:Number = 1,onCompl:Function = null):void
		{
			tweenScrollRect(RolePlayer.instance.x2d,RolePlayer.instance.y2d,time,compl);
			
			function compl():void
			{
				_isInLockScene = false;
				RolePlayer.instance.setPixlePoint(RolePlayer.instance.x2d,RolePlayer.instance.y2d,false,false);
				if(onCompl != null)
				{
					onCompl.call();
				}
			}
		}
		
		public function get isInLockScene():Boolean
		{
			return _isInLockScene;
		}
		
		private var _mouseEnabled:Boolean = true;
		
		public function setMouseEnabled(value:Boolean):void
		{
			_mouseEnabled = value;
		}
		
		public function getMouseEnabled():Boolean
		{
			return _mouseEnabled;
		}
		
		public function set sceneScale(value:Number):void
		{
			this.noneQuad.textureScale=value;
			this._isTweening=value!=1;

		}
		public function get sceneScale():Number
		{
			return this.noneQuad.textureScale
		}
		private var _isTweening:Boolean = false;
		/**
		 * 抖屏 
		 * 
		 */		
		public function shake(totalTime:Number = 0.2):void
		{
			if(_isTweening)
			{
				return;
			}
			_isTweening = true;
			
			var timeLite:TimelineLite = new TimelineLite();

			timeLite.append( new TweenLite(this,0.14,{sceneScale:1.02}));
			for(var i:int = 0;i<int(totalTime/0.14);i++)
			{
				timeLite.append( new TweenLite(this,0.07,{sceneScale:1.01}));
				timeLite.append( new TweenLite(this,0.07,{sceneScale:1.02}));
			}
//			timeLite.append( new TweenLite(this.noneQuad,0.03,{sceneScale:1.04}));
//			timeLite.append( new TweenLite(this.noneQuad,0.03,{sceneScale:1.02}));
			timeLite.append( new TweenLite(this,0.14,{sceneScale:1,onComplete:function():void
			{
				GameScene3D(Device3D.scene)._isTweening = false;
				timeLite.stop();
				timeLite = null;
			}}));
			timeLite.play();
		}

		public function clearAll():void
		{
			_isInitialize = false; //设置场景未初始化
			ThingUtil.removeAll(); //清除所有怪物 NPC 传送阵
			topMapLayer.clearMap(); // 清理地图
			Cache.instance.entity.clearAll();//清理EntityCache
			LayerManager.entityTalkLayer.clear();//清理对话
			SkillEffectUtil.removeAllChildren();//清理剧情特效
			//mapGroundLayer.clearMap();
			//skillsLayer.removeAllChildren(); //清理技能特效
			//footLayer.removeAllChildren();//清理脚印
			_tempEndPoint.x = 0;
			_tempEndPoint.y = -1;
		}

	}
}
