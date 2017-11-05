package baseEngine.basic
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.TextureBase;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import baseEngine.collisions.CollisionInfo;
	import baseEngine.collisions.MouseCollision;
	import baseEngine.core.Camera3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.events.MouseEvent3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	import baseEngine.system.Input3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	import frEngine.core.DefaultSunLight;
	import frEngine.core.FrSurface3D;
	import frEngine.core.PerspectiveCamera3D;
	import frEngine.shader.ShaderBase;

	public class Scene3D extends Pivot3D
	{

		public static const RENDER_EVENT:String = "render";
		public static const PAUSED_EVENT:String = "paused";
		public static const POSTRENDER_EVENT:String = "postRender";
		public static const COMPLETE_EVENT:String = "complete";
		public static const PROGRESS_EVENT:String = "progress";
		public static const SORT_NONE:int = 0;
		public static const SORT_FRONT_TO_BACK:int = 1;
		public static const SORT_BACK_TO_FRONT:int = 2;
		public var defaultSunLight:DefaultSunLight;
		
		private var _temp:Vector3D = new Vector3D();
		private static var _stages3d:int;

		protected var _prEvent:Event;
		private var _pausedEvent:Event;
		private var _renderEvent:Event;
		private var _container:DisplayObjectContainer;
		private var _renderCount:int;
		private var _updateCount:int;
		private var _rendersPerSecond:int;
		private var _updatesPerSecond:int;
		private var _renderTime:int;
		private var _timer:int;
		private var _profile:String;
		private var _stageIndex:int;
		private var _paused:Boolean;
		private var _camera:Camera3D;
		public var context:Context3D;
		private var _stage3D:Stage3D;
		private var _viewPort:Rectangle;
		protected var _antialias:int = 2; 
		private var _showMenu:Boolean = true;
		private var _autoResize:Boolean = false;
		private var _clipped:Boolean = false;

		private var _updateIndex:int;
		private var _interactive:MouseCollision;
		private var _enableUpdateAndRender:Boolean = true;
		
		public static const textureWidth:int=2048;
		public static const textureHeight:int=1024;
		
		public var textureOffsetX:int=0;
		public var textureOffsetY:int=0;
		
		public var staticRect:Rectangle=new Rectangle(0,0,textureWidth,textureHeight);
		

		public var firstDrawFun:Function; 
		public var clearColor:Vector3D;

		public var renderLayerList:RenderList=new RenderList();
		
		public var materials:Vector.<Material3D>;
		public var surfaces:Vector.<FrSurface3D>;
		public var textures:Vector.<Texture3D>;
		private var _secondTargetTexture:Texture3D;
		private var _targetTexture:Texture3D;
		private var _targetMaterial:Material3D;
		public var targetFilters:Vector.<Material3D>;
		private var _currTime:Number;
		private var _time:Number;
		private var _tick:Number;
		private var _updated:Boolean;
		private var _startTime:Number;
		private var _frameRate:Number;

		public var ignoreInvisibleUnderMouse:Boolean = true;
		private var _fist:*;
		private var _mouseEnabled:Boolean = false;
		private var _info:CollisionInfo;
		private var _last:CollisionInfo;
		private var _down:Mesh3D;
		private var _stage:Stage;
		protected var _curSelectObjects:Dictionary = new Dictionary(false);
		public var selectIsEmpty:Boolean=true;
		protected var noneQuad:SceneDepthQuad;
		
		//protected var alphaQuad:TargetQuad;
		//protected var lightQuad:TargetQuad;
		//private var writeDepth:WriteDepthFilter;
		//private var checkDepth:CheckDepthFilter;
		public function Scene3D(_arg1:DisplayObjectContainer)
		{


			this._prEvent = new Event("postRender");
			this._pausedEvent = new Event("paused");
			this._renderEvent = new Event("render", false, true);
			this._interactive = new MouseCollision();
			this.clearColor = new Vector3D(0.25, 0.25, 0.25, 1);
			this.materials = new Vector.<Material3D>();
			this.surfaces = new Vector.<FrSurface3D>();
			this.textures = new Vector.<Texture3D>();
			this.targetFilters = new Vector.<Material3D>();

			this._last = new CollisionInfo();

			super("Scene");

			this.profile = Device3D.profile;
			this._camera = new PerspectiveCamera3D("Default_Scene_Camera");
			this._camera.parent = this;
			Device3D.scene = this;
			Device3D.camera = this.camera;

			noneQuad=new SceneDepthQuad(true,"none",Material3D.BLEND_NONE);
			//alphaQuad=new TargetQuad(true,"alpha",Material3D.BLEND_ALPHA0);
			//lightQuad=new TargetQuad(false,"light",Material3D.BLEND_LIGHT);
			//writeDepth=new WriteDepthFilter();
			//checkDepth=new CheckDepthFilter(noneQuad.texture3d);
			
			this.frameRate = 45;
			this._container = _arg1;

			if (this._container.stage)
			{
				this.addedToStageEvent();
			}
			else
			{
				this._container.addEventListener(Event.ADDED_TO_STAGE, this.addedToStageEvent, false, 0, true);
			}

			this.defaultSunLight=new DefaultSunLight();
		}

		public function addSelectObject(value:Mesh3D, sendEvent:Boolean):void
		{
			if (value)
			{
				_curSelectObjects[value] = value;
				selectIsEmpty=false;
			}

		}

		public function removeSelectObject(value:Mesh3D, sendEvent:Boolean):void
		{
			if (value)
			{
				delete _curSelectObjects[value];
				selectIsEmpty=true;
				for each(var p:Mesh3D in _curSelectObjects)
				{
					selectIsEmpty=false;
					break;
				}
				
			}

		}

		public function get selectObjects():Vector.<Mesh3D>
		{
			var arr:Vector.<Mesh3D> = new Vector.<Mesh3D>();
			for each (var p:Mesh3D in _curSelectObjects)
			{
				arr.push(p);
			}
			return arr;
		}

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		/*public function set enabled(value:Boolean):void
		{
			if(value)
			{
				Input3D.initialize(container.stage);
				Device3D.scene=this;
			}else
			{
				Input3D.dispose(container.stage);
				Device3D.scene=null;
			}
		}*/
		

		override public function dispose(isReuse:Boolean = true):void
		{
			this.freeMemory();
			super.dispose(isReuse);
			if (Device3D.scene == this)
			{
				Device3D.scene = null;
			}

			if (Device3D.camera == this.camera)
			{
				Device3D.camera = null;
			}

			this.camera = null;
			if (stage)
			{
				this.autoResize = false;
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);
				stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveEvent);
				stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelEvent);
				_stage = null;
			}

			if (this._showMenu)
			{
				this._container.contextMenu = null;
			}

			this._container.removeEventListener(Event.ENTER_FRAME, this.enterFrameEvent);
			this._container.removeEventListener(Event.ADDED_TO_STAGE, addedToStageEvent);
			this._container = null;
			this._stage3D.removeEventListener(Event.CONTEXT3D_CREATE, this.stageContextEvent);
			this._stage3D = null;

			if (this.context)
			{
				this.context.dispose();
				this.context = null;
			}

			this._info = null;
			this._last = null;
			this._down = null;

			this._interactive.dispose();
			this._interactive = null;
			this._prEvent = null;
			this._pausedEvent = null;
			this._container = null;
			this._viewPort = null;
			this._fist = null;
			_stages3d = (_stages3d - (1 << this._stageIndex));
			Mouse.cursor = MouseCursor.AUTO;
		}

		public function get stage():Stage
		{
			if (_stage)
			{
				return _stage;
			}
			else if (_container)
			{
				return _container.stage;
			}
			else
			{
				return null;
			}

		}

		private function addedToStageEvent(_arg1:Event = null):void
		{
			_stage = this._container.stage;
			this._container.removeEventListener(Event.ADDED_TO_STAGE, this.addedToStageEvent);
			if (_stages3d == 0)
			{
				Input3D.initialize(stage);
			}


			Input3D.stage = stage;
			this._container.addEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageEvent, false, 0, true);
			this._stageIndex = -1;
			if ((_stages3d & 1) == 0)
			{
				this._stageIndex = 0;
			}
			else
			{
				if ((_stages3d & 2) == 0)
				{
					this._stageIndex = 1;
				}
				else
				{
					if ((_stages3d & 4) == 0)
					{
						this._stageIndex = 2;
					}
					else
					{
						if ((_stages3d & 8) == 0)
						{
							this._stageIndex = 3;
						}

					}

				}

			}

			if (this._stageIndex >= 0)
			{
				_stages3d = (_stages3d | (1 << this._stageIndex));
			}
			else
			{
				throw(new Error("No more Stage3D's availables."));
			}

			this._stage3D = stage.stage3Ds[this._stageIndex];

			if (context)
			{
				stageContextEvent(new Event(Event.CONTEXT3D_CREATE));
			}
			else
			{
				this._stage3D.addEventListener(Event.CONTEXT3D_CREATE, this.stageContextEvent, false, 0, true);
				try
				{
					this._stage3D.requestContext3D.call(this, Context3DRenderMode.AUTO); //, this.profile);
				}
				catch (e:ErrorEvent)
				{
					_stage3D.requestContext3D(Context3DRenderMode.AUTO);
				}

			}

			this.autoResize = this._autoResize;
		}

		private function removedFromStageEvent(_arg1:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this.removedFromStageEvent);
			if (_stage)
			{
				_stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownEvent);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, this.mouseUpEvent);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveEvent);
				_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.mouseWheelEvent);
				_stage = null;
			}


		}

		private function stageContextEvent(_arg1:Event):void
		{

			if (((((this._showMenu) && (this._container))) && ((this.context == null))))
			{
				try
				{
					if (!this._container.contextMenu)
					{
						this._container.contextMenu = new ContextMenu();
					}

					DisplayObjectContainer(this._container.root).contextMenu["customItems"].push(new ContextMenuItem("Fr3D 1.0"));
				}
				catch (e:Error)
				{
				}

			}

			this.context = this._stage3D.context3D;
			if (this.context.driverInfo== "OpenGL")
			{
				Device3D.isOpenGL = true;
			}

			if (!this._viewPort)
			{
				this.setViewport(0, 0, stage.stageWidth, stage.stageHeight, this._antialias);
			}
			else
			{
				this._stage3D.x = this._viewPort.x;
				this._stage3D.y = this._viewPort.y;
				this.context.configureBackBuffer(this._viewPort.width, this._viewPort.height, this._antialias, true);
			}

			if (this._enableUpdateAndRender)
			{
				this._container.addEventListener(Event.ENTER_FRAME, this.enterFrameEvent);
			}

			defaultSunLight.init();
			Device3D.uploadGlobleParams();
			noneQuad.texture3d && noneQuad.texture3d.upload(this,false);
			//lightQuad.texture3d && lightQuad.texture3d.upload(this);
			dispatchEvent(_arg1);
		}

		public function set backgroundColor(_arg1:int):void
		{
			this.clearColor.z = ((_arg1 & 0xFF) / 0xFF);
			this.clearColor.y = (((_arg1 >> 8) & 0xFF) / 0xFF);
			this.clearColor.x = (((_arg1 >> 16) & 0xFF) / 0xFF);
		}

		public function get backgroundColor():int
		{
			return ((((int((this.clearColor.x * 0xFF)) << 16) | (int((this.clearColor.y * 0xFF)) << 8)) | int((this.clearColor.z * 0xFF))));
		}

		public function setViewport(_arg1:Number = 0, _arg2:Number = 0, _arg3:Number = 640, _arg4:Number = 480, _arg5:int = 0):void
		{
			if (_arg3 < 50)
			{
				_arg3 = 50;
			}

			if (_arg4 < 50)
			{
				_arg4 = 50;
			}

			if (((this.context) && (!((this.context.driverInfo.indexOf("Software") == -1)))))
			{
				if (_arg3 > 0x0800)
				{
					_arg3 = 0x0800;
				}

				if (_arg4 > 0x0800)
				{
					_arg4 = 0x0800;
				}

			}

			if (((((((((((this._viewPort) && ((this._viewPort.x == _arg1)))) && ((this._viewPort.y == _arg2)))) && ((this._viewPort.width == _arg3)))) && ((this._viewPort.height == _arg4)))) && ((this._antialias == _arg5))))
			{
				return;
			}

			if (!this._viewPort)
			{
				this._viewPort = new Rectangle();
			}

			this._viewPort.x = _arg1;
			this._viewPort.y = _arg2;
			this._viewPort.width = _arg3;
			this._viewPort.height = _arg4;

			if (this._camera)
			{
				this._camera.updateProjectionMatrix();
			}

			if (((this._stage3D) && (context)))
			{
				this._stage3D.x = this._viewPort.x;
				this._stage3D.y = this._viewPort.y;
				this.context.configureBackBuffer(this._viewPort.width, this._viewPort.height, this._antialias, true);
			}
			
			Device3D.setViewPortRect(this._viewPort.width,this._viewPort.height);
			
			noneQuad.resize(_viewPort)

			textureOffsetX=(textureWidth-this._viewPort.width)*0.5;
			textureOffsetY=(textureHeight-this._viewPort.height)*0.5;


			this.dispatchEvent(new Event(Engine3dEventName.SCENE_VIEWPORT_CHANGE, false, true));
		}

		public function get camera():Camera3D
		{
			return (this._camera);
		}

		public function set camera(_arg1:Camera3D):void
		{
			var _old:Camera3D = this._camera;
			this._camera = _arg1;
			if (_old != _arg1)
			{
				this.dispatchEvent(new Event(Engine3dEventName.CHANGE_CAMERA));
			}

		}

		protected function enterFrameEvent(_arg1:Event):void
		{
			var _local2:int;
			var _local3:TextureBase;
			var _local4:TextureBase;
			var _local5:int;
			this._currTime = getTimer();
			if (((context) && (this._updated)))
			{
				this._updated = false;
				if (!this._paused)
				{
					this._renderCount++;
					this._renderTime = getTimer();
					this.render(this._camera, this.targetTexture);
					this.dispatchEvent(this._prEvent);
					if (this.targetTexture)
					{

						_local2 = this.targetFilters.length;
						if ((((_local2 > 1)) && (!(this._secondTargetTexture))))
						{
							this._secondTargetTexture = new Texture3D((this._targetTexture.request as Point), Texture3D.MIP_LINEAR);
							this._secondTargetTexture.mipMode = this._targetTexture.mipMode;
							this._secondTargetTexture.filterMode = this._targetTexture.filterMode;
							this._secondTargetTexture.bias = this._targetTexture.bias;
							this._secondTargetTexture.upload(this,false);
						}

						_local3 = this._targetTexture.texture;
						_local4 = ((this._secondTargetTexture) ? this._secondTargetTexture.texture : null);
						_local5 = 0;
						while (_local5 < _local2)
						{
							if ((_local5 % 2) == 0)
							{
								this._targetTexture.texture = _local3;
								if (_local5 == (_local2 - 1))
								{
									this.context.setRenderToBackBuffer();
								}
								else
								{
									this.context.setRenderToTexture(_local4);
								}

								this.context.clear();
							}
							else
							{
								this._targetTexture.texture = _local4;
								if (_local5 == (_local2 - 1))
								{
									this.context.setRenderToBackBuffer();
								}
								else
								{
									this.context.setRenderToTexture(_local3);
								}

								this.context.clear();
							}

							_local5++;
						}

						this._targetTexture.texture = _local3;
					}

					context.present();
					this._renderTime = (getTimer() - this._renderTime);
				}
				else
				{
					dispatchEvent(this._renderEvent);
				}

			}

			Device3D.camera = this.camera;
			Device3D.cameraGlobal.copyFrom(Device3D.camera.world);
			Device3D.setViewProj(Device3D.camera.viewProjection);
			Device3D.proj.copyFrom(Device3D.camera.projection);
			Device3D.view.copyFrom(Device3D.camera.view);
			Device3D.scene = this;



			if (!this._paused)
			{
				Input3D.update();
				this.update();
			}
			else
			{
				dispatchEvent(this._pausedEvent);
			}
			this._updated = true;
		}


		public override function update():void
		{
			
			var _t:Number = getTimer();
			TimeControler.upDateTime(_t);
			
			super.update();
		}

		public function set clipped(value:Boolean):void
		{
			_clipped = value;
		}

		public function setupFrame(_arg1:Camera3D = null):void
		{
			Device3D.camera = ((_arg1) || (this._camera));
			Device3D.cameraGlobal.copyFrom(Device3D.camera.world);
			Device3D.setViewProj(Device3D.camera.viewProjection); //屏幕坐标系
			Device3D.proj.copyFrom(Device3D.camera.projection); //屏幕透视矩阵
			Device3D.view.copyFrom(Device3D.camera.view); //相机坐标系
			Device3D.scene = this;
			
			var __viewPort:Rectangle = Device3D.camera.clipRectangle;
			if (__viewPort)
			{
				context.setScissorRectangle(__viewPort);
				this._clipped = true;
			}
			else
			{
				if (this._clipped)
				{
					context.setScissorRectangle(null);
					this._clipped = false;
				}

			}
		/*if (defaultLight)
		{
			camera.world.copyColumnTo(2, _temp);
			this.setDirLight(_temp);
		};*/

		}

		override public function draw(_arg1:Boolean = true, _arg2:ShaderBase = null):void
		{
			throw(new Error("The Scene3D can not be drawn, please use render method instead."));
		}

		public function resumData():void
		{
			Device3D.trianglesDrawn = 0;
			Device3D.drawCalls3d = 0;
			Device3D.objectsDrawn = 0;
			Device3D.lastMaterial = null;
		}
		
		
		public var toTexture:Boolean=false;
		
		public function render(camara:Camera3D = null, texture:Texture3D = null , end:Boolean=true ):void
		{
			if (!context)
			{
				return;
			}
			
			resumData();
			
			if(toTexture)
			{
				renderToTexture(camara);
			}else
			{
				renderToScene(camara);
			}
			
			if(end)
			{
				this.endFrame();
			}
		}

		private function renderSelect():void
		{
			var _mesh:Mesh3D;
			context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.STENCIL);
			context.setStencilReferenceValue( 0 );
			context.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE ); 
			//!_mesh.isHide && _mesh.visible
			for each (_mesh in _curSelectObjects)
			{  
				_mesh.render.drawDepth(_mesh,0,0); 
			}
			for each (_mesh in _curSelectObjects)
			{  
				_mesh.render.drawEdge(_mesh, 0xffffff);
			}
			
			context.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.ALWAYS, Context3DStencilAction.KEEP );
		}
		private function renderToScene(camara:Camera3D):void
		{
			camara.viewPort=this.viewPort;
			camara.clipRectangle=null;
			this.setupFrame(camara);
			Device3D.setViewPortRect(viewPort.width,viewPort.height);

			context.setRenderToBackBuffer();
			context.clear(this.clearColor.x, this.clearColor.y, this.clearColor.z, this.clearColor.w);//context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
			//this.context.configureBackBuffer(this._viewPort.width, this._viewPort.height, 0, true);
			
			if(firstDrawFun!=null)
			{
				firstDrawFun.apply();
			}
			
			noneQuad.renderShadow(context,renderLayerList);
			
			noneQuad.render(renderLayerList);
			
			if (!selectIsEmpty )
			{
				renderSelect();
			}
			
		}
		private function renderToTexture(camara:Camera3D):void
		{
			camara.viewPort=staticRect;
			camara.clipRectangle=noneQuad.clipRect;
			
			this.setupFrame(camara);
			Device3D.setViewPortRect(staticRect.width,staticRect.height);
			
			context.setRenderToTexture(noneQuad.texture3d.texture, true, this._antialias);
			context.clear(this.clearColor.x, this.clearColor.y, this.clearColor.z, this.clearColor.w);//context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
			
			if(firstDrawFun!=null)
			{
				firstDrawFun.apply();
			}
			
			noneQuad.renderShadow(context,renderLayerList);
			
			noneQuad.render(renderLayerList);

			if (!selectIsEmpty )
			{
				renderSelect();
			}
			
			camara.viewPort=this.viewPort;
			camara.clipRectangle=null;
			this.setupFrame(camara);
			Device3D.setViewPortRect(viewPort.width,viewPort.height);
			
			context.setRenderToBackBuffer();
			
			context.clear(this.clearColor.x, this.clearColor.y, this.clearColor.z, this.clearColor.w);
			
			noneQuad.layerQuad.draw(false,null);
		}
		public function endFrame():void
		{
			
			var _local1:int;
			_local1 = 0;
			while (_local1 < Device3D.usedSamples)
			{
				context.setTextureAt(_local1, null);
				ShaderBase.textures[_local1]=null;
				_local1++;
			}

			_local1 = 0;
			while (_local1 < Device3D.usedBuffers)
			{
				context.setVertexBufferAt(_local1, null);
				ShaderBase.buffers[_local1]=null;
				_local1++;
			}
			Device3D.usedSamples=0;
			Device3D.usedBuffers=0;
			ShaderBase.pro=null;
		}



		private function completeResourceEvent(_arg1:Event):void
		{
			if (this._camera.name != "Default_Scene_Camera")
			{
				return;
			}

			if ((((((_arg1.target == this._fist)) && (_arg1.target.hasOwnProperty("activeCamera")))) && (_arg1.target.activeCamera)))
			{
				this.camera = _arg1.target.activeCamera;
				this._camera.worldTransformChanged = true;
			}

		}


		/*override public function get parent():Pivot3D
		{
			return (null);
		}

		override public function set parent(_arg1:Pivot3D):void
		{
		}*/

		public function resume():void
		{
			if (((this._stage3D) && (context)))
			{
				context.clear();
				this.render();
				context.present();
			}

			this.frameRate = this._frameRate;
			//this._frameCount = 0;
			this._paused = false;
		}

		public function pause():void
		{
			this._paused = true;
		}

		public function get paused():Boolean
		{
			return (this._paused);
		}

		/*final public function get context():Context3D
		{
			return context;
		}*/

		public function get antialias():int
		{
			return (this._antialias);
		}

		public function set antialias(_arg1:int):void
		{
			if(this._antialias==_arg1)
			{
				return;
			}
			this._antialias = _arg1;
			if (((((this._viewPort) && (this._stage3D))) && (context)))
			{
				context.configureBackBuffer(this._viewPort.width, this._viewPort.height, this._antialias, true);
			}

		}

		public function get viewPort():Rectangle
		{
			return (this._viewPort);
		}

		public function get renderTime():int
		{
			return (this._renderTime);
		}

		public function get rendersPerSecond():int
		{
			return (this._rendersPerSecond);
		}

		public function get updatesPerSecond():int
		{
			return (this._updatesPerSecond);
		}

		public function get frameRate():Number
		{
			return (this._frameRate);
		}

		public function set frameRate(_arg1:Number):void
		{
			this._frameRate = _arg1;
			this._startTime = getTimer();
			this._time = this._startTime;
			this._tick = (1000 / this._frameRate);
		}

		private function mouseDownEvent(_arg1:MouseEvent):void
		{
			if (((!(this._mouseEnabled)) || ((Input3D.eventPhase > EventPhase.AT_TARGET))))
			{
				return;
			}

			if (this._info)
			{
				this._info.mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_DOWN, this._info));
				if (this._interactive.data.length)
				{
					this._down = this._interactive.data[0].mesh;
				}
				else
				{
					this._last.mesh = null;
					this._last.surface = null;
					this._down = null;
					this.updateMouseEvents();
				}

			}

		}

		private function mouseUpEvent(_arg1:MouseEvent):void
		{
			if (((!(this._mouseEnabled)) || ((Input3D.eventPhase > EventPhase.AT_TARGET))))
			{
				return;
			}

			if (this._interactive.data.length)
			{
				this._interactive.data[0].mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_UP, this._info));
				if (((this._down) && ((this._down == this._interactive.data[0].mesh))))
				{
					this._interactive.data[0].mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.CLICK, this._info));
				}

			}

			this._down = null;
			this.updateMouseEvents();
		}

		private function mouseMoveEvent(_arg1:MouseEvent):void
		{
			if (((((!(this._mouseEnabled)) || ((Input3D.eventPhase > EventPhase.AT_TARGET)))) || ((this._interactive.collisionCount == 0))))
			{
				return;
			}

			if (this._info)
			{
				this._last.mesh = this._info.mesh;
				this._last.surface = this._info.surface;
				this._last.normal = this._info.normal;
				this._last.point = this._info.point;
				this._last.poly = this._info.poly;
			}
			else
			{
				this._last.mesh = null;
			}

			this.updateMouseEvents();
		}

		public function updateMouseEvents():void
		{
			if (!this._mouseEnabled)
			{
				return;
			}
			if (((((this._viewPort) && (this._viewPort.contains(Input3D.mouseX, Input3D.mouseY)))) && (this._interactive.test(Input3D.mouseX, Input3D.mouseY, true))))
			{
				this._info = this._interactive.data[0];
				this._info.mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_MOVE, this._info));
				if (((this._last.mesh) && (!((this._last.mesh == this._info.mesh)))))
				{
					this._last.mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT, this._last));
				}

				if (this._last.mesh != this._info.mesh)
				{
					this._info.mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OVER, this._info));
				}

			}
			else
			{
				this._info = null;
				if (this._last.mesh)
				{
					this._last.mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_OUT, this._last));
				}

			}

			if (((this._info) && (this._info.mesh.useHandCursor)))
			{
				Mouse.cursor = MouseCursor.BUTTON;
			}
			else
			{
				Mouse.cursor = MouseCursor.AUTO;
			}

		}

		private function mouseWheelEvent(_arg1:MouseEvent):void
		{
			if (((!(this._mouseEnabled)) || ((Input3D.eventPhase > EventPhase.AT_TARGET))))
			{
				return;
			}

			if (this._interactive.data.length)
			{
				this._interactive.data[0].mesh.dispatchEvent(new MouseEvent3D(MouseEvent3D.MOUSE_WHEEL, this._info));
			}

		}

		public function get mouseEnabled():Boolean
		{
			return (this._mouseEnabled);
		}

		public function set mouseEnabled(_arg1:Boolean):void
		{
			this._mouseEnabled = _arg1;
			if (this._mouseEnabled == false)
			{
				this._last.mesh = null;
				this._info = null;
				this._down = null;
			}

		}

		/* override public function get scene():Scene3D
		 {
			 return (this);
		 }*/
		public function get enableUpdateAndRender():Boolean
		{
			return (this._enableUpdateAndRender);
		}

		public function set enableUpdateAndRender(_arg1:Boolean):void
		{
			this._enableUpdateAndRender = _arg1;
			if (((_arg1) && (this.context)))
			{
				this._container.addEventListener(Event.ENTER_FRAME, this.enterFrameEvent, false, 0, true);
			}
			else
			{
				this._container.removeEventListener(Event.ENTER_FRAME, this.enterFrameEvent);
			}

			if (_arg1)
			{
				this.frameRate = this._frameRate;
					// this._frameCount = 0;
			}

		}

		public function set showMenu(_arg1:Boolean):void
		{
			this._showMenu = _arg1;
		}


		public function get stageIndex():int
		{
			return (this._stageIndex);
		}



		/*override public function get visible():Boolean
		{
			return (this._stage3D.visible);
		}

		override public function set visible(_arg1:Boolean):void
		{
			this._stage3D.visible = _arg1;
		}*/

		public function get autoResize():Boolean
		{
			return (this._autoResize);
		}

		public function set autoResize(_arg1:Boolean):void
		{
			this._autoResize = _arg1;
			if (stage)
			{
				if (_arg1)
				{
					stage.align = "tl";
					stage.scaleMode = "noScale";
					stage.addEventListener(Event.RESIZE, this.resizeStageEvent, false, 0, true);
				}
				else
				{
					stage.removeEventListener(Event.RESIZE, this.resizeStageEvent);
				}

			}

		}

		private function resizeStageEvent(_arg1:Event):void
		{
			this.setViewport(0, 0, stage.stageWidth, stage.stageHeight);
		}


		public function get profile():String
		{
			return (this._profile);
		}

		public function set profile(_arg1:String):void
		{
			this._profile = _arg1;
		}

		public function get targetTexture():Texture3D
		{
			return (this._targetTexture);
		}

		public function set targetTexture(_arg1:Texture3D):void
		{
			var _local2:Point;
			if (_arg1 == this._targetTexture)
			{
				return;
			}

			this._targetTexture = _arg1;
			if (_arg1)
			{
				_arg1.mipMode = Texture3D.MIP_NONE;
				_local2 = (_arg1.request as Point);
				if (!_local2)
				{
					throw(new Error("Target texture should be a dynamic texture."));
				}

				if (!_arg1.optimizeForRenderToTexture)
				{
					throw(new Error("Target texture should have the optimizeForRenderToTexture parameter set to true."));
				}

			}
			else
			{
				if (this._secondTargetTexture)
				{
					this._secondTargetTexture.dispose();
					this._secondTargetTexture = null;
				}

			}

		}

		public function freeMemory():void
		{

			while (this.textures.length)
			{
				this.textures[0].download();
			}

			while (this.materials.length)
			{
				materials[0].download();

			}

			while (this.surfaces.length)
			{
				var s:Surface3D = this.surfaces[0]
				s.download();
			}
		}

		public function registerClass(... _args):void
		{
		}

	}
} //package flare.basic



