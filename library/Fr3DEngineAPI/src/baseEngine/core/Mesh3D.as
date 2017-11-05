


//flare.core.Mesh3D

package baseEngine.core
{
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.geom.Utils3D;
    import flash.geom.Vector3D;
    
    import baseEngine.basic.RenderList;
    import baseEngine.basic.Scene3D;
    import baseEngine.events.MouseEvent3D;
    import baseEngine.materials.Material3D;
    import baseEngine.modifiers.Modifier;
    import baseEngine.system.Device3D;
    import baseEngine.utils.Vector3DUtils;
    
    import frEngine.Engine3dEventName;
    import frEngine.animateControler.DrawShapeControler;
    import frEngine.animateControler.colorControler.AlphaControler;
    import frEngine.animateControler.colorControler.ColorControler;
    import frEngine.animateControler.keyframe.AnimateControlerType;
    import frEngine.animateControler.uvControler.FrUvStepControler;
    import frEngine.animateControler.uvControler.UVCenterScaleControler;
    import frEngine.animateControler.uvControler.UVRotateController;
    import frEngine.animateControler.uvControler.UoffsetControler;
    import frEngine.animateControler.uvControler.VoffsetControler;
    import frEngine.core.FrSurface3D;
    import frEngine.core.mesh.ParticleMesh;
    import frEngine.loaders.resource.Resource3dManager;
    import frEngine.primitives.FrPlane;
    import frEngine.render.DefaultRender;
    import frEngine.render.IRender;
    import frEngine.shader.MaterialParams;
    import frEngine.shader.ShaderBase;
    import frEngine.shader.filters.fragmentFilters.ColorFilter;
    import frEngine.shader.filters.fragmentFilters.FragmentFilter;
    import frEngine.shader.filters.fragmentFilters.TextureFilter;
    import frEngine.shader.filters.vertexFilters.TransformFilter;
    import frEngine.util.HelpUtils;

    public class Mesh3D extends Pivot3D implements IDrawable 
    {

		private static const CLICK:int = (1 << 6);
        private static const MOUSE_DOWN:int = (1 << 7);
        private static const MOUSE_MOVE:int = (1 << 8);
        private static const MOUSE_OUT:int = (1 << 9);
        private static const MOUSE_OVER:int = (1 << 10);
        private static const MOUSE_UP:int = (1 << 11);
        private static const MOUSE_WHELL:int = (1 << 12);

        
        private static var _bScale:Vector3D = new Vector3D();
        private static var _bCenter:Vector3D = new Vector3D();

		protected var surfaces:Vector.<FrSurface3D>;
        
		private var _bounds:Boundings3D;
        private var _inView:Boolean = false;
        private var _boundsCenter:Vector3D;
        private var _boundsRadius:Number = 1;
        private var _updateBoundsScale:Boolean = true;
        public var mouseEnabled:Boolean = true;
        public var useHandCursor:Boolean = false;
		public var render:IRender=DefaultRender.instance;
		public var loadPriority:int=3;
		private var _materialPrams:MaterialParams=new MaterialParams();

		public var material:ShaderBase;
		private var _renderList:RenderList;
		//public var targetQuad:TargetQuad;
        public function Mesh3D(meshName:String,useColorAnimate:Boolean,$renderList:RenderList)
        {
            this.surfaces = new Vector.<FrSurface3D>();
            this._boundsCenter = new Vector3D();
			_renderList=$renderList;
            super(meshName);
			/*if(useColorAnimate)
			{
				getAnimateControlerInstance(AnimateControlerType.colorAnimateControler);
			}*/
        }

		public function set renderList(value:RenderList):void
		{
			if(value!=this._renderList)
			{
				this._renderList && _renderList.removeFromList(this);
				this._renderList=value;
			}
			
			
			if (this._renderList && (this is IDrawable) && this._scene )
			{
				this._renderList.insertIntoList(this);
			}
		}
		public function get renderList():RenderList
		{
			return _renderList;
		}
		
		final public function get materialPrams():MaterialParams
		{
			return _materialPrams;
		}
		final public function getSurface(index:int):FrSurface3D
		{
			if(index<surfaces.length)
			{
				return surfaces[index]; 
			}else
			{
				return null;
			}
			
		}
		final public function getSurfacesLen():int
		{
			return surfaces.length;
		}
		public function setSurface(index:int,value:FrSurface3D):void
		{
			if(surfaces.indexOf(value)==-1)
			{
				surfaces[index]=value;
				this.dispatchEvent(new Event(Engine3dEventName.SetMeshSurface));
			}
			
		}
		public function addSurface(value:FrSurface3D):void
		{
			setSurface(surfaces.length,value);
		}
		public function clearSurface():void
		{
			surfaces.length=0;
		}

		public override function getAnimateControlerInstance(animateControlerType:int,instane:Modifier=null):Modifier
		{
			var  modifier:Modifier=super.getAnimateControlerInstance(animateControlerType,instane);
			if(modifier==null)
			{ 
				switch(animateControlerType)
				{ 
					
					case AnimateControlerType.DefaultAnimateControler:		modifier=instane ? instane : new Modifier();						break;
					case AnimateControlerType.DrawShapeControler:			modifier=instane ? instane : new DrawShapeControler();				break;
					case AnimateControlerType.UvStepControler:				modifier=instane ? instane : new FrUvStepControler();				break;
					case AnimateControlerType.UoffsetControler:				modifier=instane ? instane : new UoffsetControler();				break;
					case AnimateControlerType.VoffsetControler:				modifier=instane ? instane : new VoffsetControler();				break;
					case AnimateControlerType.colorAnimateControler:		modifier=instane ? instane : new ColorControler();					break;
					case AnimateControlerType.alphaAnimateControler:		modifier=instane ? instane : new AlphaControler();					break;
					case AnimateControlerType.UVRotateAnimationController:	modifier=instane ? instane : new UVRotateController();				break;
					case AnimateControlerType.UVCenterScaleController:		modifier=instane ? instane : new UVCenterScaleControler();			break;
					
				}
				if(modifier)
				{
					
					_animateControlerList[animateControlerType]=modifier;
					modifier.targetObject3d=this;
					if(modifier is IRender)
					{
						this.render=IRender(modifier);
					}
				}
				
			}
			
			return modifier;
		}
		/*public function set animateControler(value:Modifier):void
		{
			_animateControler=value;
			_animateControler.targetMesh=this;
		}*/
		/*public function get animateControler():Modifier
		{
			return _animateControler;
		}*/

        override public function dispose(isReuse:Boolean=true):void
        {
			scene && scene.removeSelectObject(this,false);
			
            this._bounds = null;
            
			disposeMaterials();
			disposeSurfaces();

            super.dispose(isReuse);
			
        }
		public function disposeSurfaces():void
		{
			var _local1:int;
			while (_local1 < this.surfaces.length)
			{
				this.surfaces[_local1].dispose();
				_local1++;
			};
			this.surfaces = new Vector.<FrSurface3D>();
		}
		public function disposeMaterials():void
		{
			if(material)
			{
				material.dispose();	
			}
			
			material=null;
		}
        override public function upload(_arg1:Scene3D, _arg2:Boolean=true):void
        {
            var _local3:FrSurface3D;
            super.upload(_arg1, _arg2);
            for each (_local3 in this.surfaces)
            {
                _local3.upload(_arg1);
            };
        }
        override public function download(_arg1:Boolean=true):void
        {
            var _local2:FrSurface3D;
            super.download(_arg1);
            for each (_local2 in this.surfaces)
            {
                _local2.download();
            };
        }
        override public function clone():Pivot3D
        {
            var _local2:FrSurface3D;
            var _local3:Pivot3D;
			var hasColorAnimate:Boolean=this.hasControler(AnimateControlerType.colorAnimateControler)
            var _local1:Mesh3D = new Mesh3D(name,hasColorAnimate,this._renderList);
            _local1.copyFrom(this);
            _local1.useHandCursor = this.useHandCursor;
            _local1.bounds = this._bounds;
			
			_local1.materialPrams.cloneFrom(this.materialPrams);

            for each (_local2 in this.surfaces)
            {
                _local1.surfaces.push(_local2.clone());
            };
           /* if (this.animateControler)
            {
                _local1.animateControler = this.animateControler.clone();
            };*/
            for each (_local3 in children)
            {
                if (!_local3.lock)
                {
                    _local1.addChild(_local3.clone());
                };
            };
            return (_local1);
        }
		
		protected function setTextureFilter(_arg1:*,mipType:int):FragmentFilter
		{
			_arg1=new TextureFilter(Resource3dManager.instance.getTexture3d(_arg1,mipType));
			return _arg1;
		}
		public override function setLayer(_arg1:int , _arg2:Boolean = true):void
		{
			if (_renderList && _arg1 != this.layer )
			{
				_renderList.removeFromList(this);
				this.layer = _arg1;
				if (this is IDrawable && this._scene)
				{
					this._renderList.insertIntoList(this);
				}
			}
			super.setLayer(_arg1,_arg2);
		}
		
		public override function removedFromScene():void
		{
			_renderList && _renderList.removeFromList(this);
			super.removedFromScene();
		}
		public override function addedToScene(_arg1:Scene3D):void
		{
			super.addedToScene(_arg1);
			if (_renderList && (this is IDrawable) && this._scene)
			{
				
				_renderList.insertIntoList(this);// , (this._eventFlags >= 64)
				
				dispatchEvent(new Event(Engine3dEventName.ADDED_TO_SCENE_EVENT));
			}
		}
		
        public function setMaterial(_arg1:*,mipType:int,materilaName:String):void
        {
			//mipType=Texture3D.MIP_LINEAR;
			if(_arg1 is ShaderBase)
			{
				setShaderBase(_arg1);
			}
			if( (_arg1 is String) || (_arg1 is BitmapData))
			{
				_arg1=setTextureFilter(_arg1,mipType);
			}

			if(_arg1 is Number)
			{
				var _num:Number=Number(_arg1);
				var _colorA:Number;
				if(_num<=0xffffff)
				{
					_colorA=1;
				}else
				{
					_colorA=((_num & 0xff000000)>>24)/255;
				}
				
				var _colorR:Number=((_num & 0xff0000)>>16)/255;
				var _colorG:Number=((_num & 0xff00)>>8)/255
				var _colorB:Number=(_num & 0xff)/255;
				_arg1=new ColorFilter(_colorR,_colorG,_colorB,_colorA);
			}

			this.priority=HelpUtils.getSortIdByName(materilaName)
				
			if(this is FrPlane)
			{
				this.priority+=100000;
			}else if(this is ParticleMesh)
			{
				this.priority+=200000
			}
			

			if(_arg1 is FragmentFilter)
			{
				if(this.material)
				{
					this.material.setFragmentFilter(_arg1);
				}else
				{
					var _material:ShaderBase=new ShaderBase(materilaName,new TransformFilter(),_arg1,this.materialPrams);
					setShaderBase(_material);
				}
			}
           
        }
		protected function setShaderBase(materaial:ShaderBase):void
		{
			var old:ShaderBase=this.material;
			this.material=materaial;
			this.material.materialParams=this.materialPrams;
			if (materaial)
			{  
				this.dispatchEvent(new Event(Engine3dEventName.MATERIAL_CHANGE, false, true));
			}
			
		}


		public function setMateiralBlendMode(blendType:int,sourceFactor:String="one",destFactor:String="one"):void
		{
			if(blendType==materialPrams.blendMode)
			{
				return;
			}
			materialPrams.setBlendMode(blendType);
			
			if(blendType==Material3D.BLEND_CUSTOM)
			{
				materialPrams.sourceFactor=sourceFactor;
				materialPrams.destFactor=destFactor;
			}
			/*if(scene)
			{
				this.scene.removeFromScene(this);
				
				if (_canInsertIntoScene)
				{
					this._scene.insertIntoScene(this ,(this is IDrawable));
				}
			}*/
			
			
		}
        public function updateBoundings():void
        {
            this._bounds = null;
            this._bounds = this.bounds;
        }
        public function get bounds():Boundings3D
        {
            var _local1:FrSurface3D;
            if (this._bounds)
            {
                return (this._bounds);
            };
            this._bounds = new Boundings3D();
            this._bounds.min.setTo(10000000, 10000000, 10000000);
            this._bounds.max.setTo(-10000000, -10000000, -10000000);
            for each (_local1 in this.surfaces)
            {
                if (!_local1.bounds)
                {
                    _local1.updateBoundings();
                };
                Vector3DUtils.min(_local1.bounds.min, this._bounds.min, this._bounds.min);
                Vector3DUtils.max(_local1.bounds.max, this._bounds.max, this._bounds.max);
            };
            this._bounds.length.x = (this._bounds.max.x - this._bounds.min.x);
            this._bounds.length.y = (this._bounds.max.y - this._bounds.min.y);
            this._bounds.length.z = (this._bounds.max.z - this._bounds.min.z);
            this._bounds.center.x = ((this._bounds.length.x * 0.5) + this._bounds.min.x);
            this._bounds.center.y = ((this._bounds.length.y * 0.5) + this._bounds.min.y);
            this._bounds.center.z = ((this._bounds.length.z * 0.5) + this._bounds.min.z);
            this._bounds.radius = Vector3D.distance(this._bounds.center, this._bounds.max);
            return (this._bounds);
        }
        public function set bounds(_arg1:Boundings3D):void
        {
            this._bounds = _arg1;
        }
        override public function getMaterialByName(_arg1:String, _arg2:Boolean=true):Material3D
        {
            var _local4:Pivot3D;
            var _local5:Material3D;
           
            if (_arg1==null || ( this.material && this.material.name == _arg1) )
            {
                return this.material;
            }
            
            if (_arg2)
            {
                for each (_local4 in children)
                {
                    _local5 = _local4.getMaterialByName(_arg1);
                    if (_local5)
                    {
                        return (_local5);
                    }
                }
            }
            return (null);
        }
        override public function replaceMaterial(_arg1:Material3D, _arg2:Material3D, _arg3:Boolean=true):void
        {
            var _local4:FrSurface3D;
            super.replaceMaterial(_arg1, _arg2, _arg3);
			if(this.material==_arg1)
			{
				this.setShaderBase( ShaderBase(_arg2) );
			}
        }
        override public function updateTransforms(updateLocle:Boolean,updateChildren:Boolean):void
        {
            super.updateTransforms(updateLocle,updateChildren);
            this._updateBoundsScale = true;
        }
        public override function get inView():Boolean
        {
			
			return (this.visible && !isHide);
            /*var _local1:Number;
            var _local2:Number;
            this._inView = false;

            if (this._bounds)
            {
                if (this._updateBoundsScale)
                {
                    Matrix3DUtils.transformVector(world, this._bounds.center, this._boundsCenter);
                    Matrix3DUtils.getScale(world, _bScale);
                    this._boundsRadius = (this._bounds.radius * Math.max(_bScale.x, _bScale.y, _bScale.z));
                    this._updateBoundsScale = false;
                };
                Matrix3DUtils.transformVector(Device3D.view, this._boundsCenter, _bCenter);
                if ((_sortMode & SORT_CENTER))
                {
                    priority = ((_bCenter.z / Device3D.camera.far) * 100000);
                }
                else
                {
                    if ((_sortMode & SORT_NEAR))
                    {
                        priority = (((_bCenter.z - this._boundsRadius) / Device3D.camera.far) * 100000);
                    }
                    else
                    {
                        if ((_sortMode & SORT_FAR))
                        {
                            priority = (((_bCenter.z + this._boundsRadius) / Device3D.camera.far) * 100000);
                        };
                    };
                };
                if (_bCenter.length >= this._boundsRadius)
                {
                    _local1 = ((1 / Device3D.camera.zoom) / _bCenter.z);
                    _local2 = Device3D.camera.aspectRatio;
                    if (((_bCenter.x + this._boundsRadius) * _local1) < -1)
                    {
                        return (false);
                    };
                    if (((_bCenter.x - this._boundsRadius) * _local1) > 1)
                    {
                        return (false);
                    };
                    if ((((_bCenter.y + this._boundsRadius) * _local1) * _local2) < -1)
                    {
                        return (false);
                    };
                    if ((((_bCenter.y - this._boundsRadius) * _local1) * _local2) > 1)
                    {
                        return (false);
                    };
                    if ((_bCenter.z - this._boundsRadius) > Device3D.camera.far)
                    {
                        return (false);
                    };
                    if ((_bCenter.z + this._boundsRadius) < Device3D.camera.near)
                    {
                        return (false);
                    };
                };
            }
            else
            {
                getPosition(false, this._boundsCenter);
                Matrix3DUtils.transformVector(Device3D.view, this._boundsCenter, _bCenter);
                priority = ((_bCenter.z / Device3D.camera.far) * 100000);
            };
            return (true);
			*/
        }
        public function getScreenRect(_arg1:Rectangle=null, _arg2:Camera3D=null, _arg3:Rectangle=null):Rectangle
        {
            if (!this._bounds)
            {
                return (null);
            };
            if (!_arg1)
            {
                _arg1 = new Rectangle();
            };
            if (!_arg3)
            {
                _arg3 = Device3D.scene.viewPort;
            };
            if (!_arg2)
            {
                _arg2 = Device3D.camera;
            };
            Device3D.temporal0.copyFrom(world);
            Device3D.temporal0.append(_arg2.viewProjection);
            var _local4:Boolean;
            var _local5:Vector3D = this.projectCorner(0, Device3D.temporal0);
            if (_local5.w > 0)
            {
                _local4 = true;
            };
            _arg1.setTo(_local5.x, _local5.y, _local5.x, _local5.y);
            var _local6:int = 1;
            while (_local6 < 8)
            {
                _local5 = this.projectCorner(_local6, Device3D.temporal0);
                if (_local5.w > 0)
                {
                    _local4 = true;
                };
                if (_local5.x < _arg1.x)
                {
                    _arg1.x = _local5.x;
                };
                if (_local5.y > _arg1.y)
                {
                    _arg1.y = _local5.y;
                };
                if (_local5.x > _arg1.width)
                {
                    _arg1.width = _local5.x;
                };
                if (_local5.y < _arg1.height)
                {
                    _arg1.height = _local5.y;
                };
                _local6++;
            };
            if (!_local4)
            {
                return (null);
            };
            _arg1.y = -(_arg1.y);
            _arg1.width = (_arg1.width - _arg1.x);
            _arg1.height = (-(_arg1.height) - _arg1.y);
            var _local7:Number = (_arg3.width * 0.5);
            var _local8:Number = (_arg3.height * 0.5);
            _arg1.x = (((_arg1.x * _local7) + _local7) + _arg3.x);
            _arg1.y = (((_arg1.y * _local8) + _local8) + _arg3.y);
            _arg1.width = (_arg1.width * _local7);
            _arg1.height = (_arg1.height * _local8);
            if (_arg1.x < 0)
            {
                _arg1.width = (_arg1.width + _arg1.x);
                _arg1.x = 0;
            };
            if (_arg1.y < 0)
            {
                _arg1.height = (_arg1.height + _arg1.y);
                _arg1.y = 0;
            };
            if (_arg1.right > _arg3.width)
            {
                _arg1.right = _arg3.width;
            };
            if (_arg1.bottom > _arg3.height)
            {
                _arg1.bottom = _arg3.height;
            };
            return (_arg1);
        }
        private function projectCorner(_arg1:int, _arg2:Matrix3D):Vector3D
        {
            switch (_arg1)
            {
                case 0:
                    _bCenter.setTo(this._bounds.min.x, this._bounds.min.y, this._bounds.min.z);
                    break;
                case 1:
                    _bCenter.setTo(this._bounds.max.x, this._bounds.min.y, this._bounds.min.z);
                    break;
                case 2:
                    _bCenter.setTo(this._bounds.min.x, this._bounds.max.y, this._bounds.min.z);
                    break;
                case 3:
                    _bCenter.setTo(this._bounds.max.x, this._bounds.max.y, this._bounds.min.z);
                    break;
                case 4:
                    _bCenter.setTo(this._bounds.min.x, this._bounds.min.y, this._bounds.max.z);
                    break;
                case 5:
                    _bCenter.setTo(this._bounds.max.x, this._bounds.min.y, this._bounds.max.z);
                    break;
                case 6:
                    _bCenter.setTo(this._bounds.min.x, this._bounds.max.y, this._bounds.max.z);
                    break;
                case 7:
                    _bCenter.setTo(this._bounds.max.x, this._bounds.max.y, this._bounds.max.z);
                    break;
            };
            return (Utils3D.projectVector(_arg2, _bCenter));
        }
		/*
		override public function completeDraw():void
		{
			if (this.inView && render)
			{
				
				render.completeDraw(this);  
				
			};
		}
		*/
		
        override public function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
        {
            var _local3:int;
            if (!_scene)
            {
                this.upload(Device3D.scene);
            };
            if ((_eventFlags & ENTER_DRAW_FLAG))
            {
                dispatchEvent(_enterDrawEvent);
            };
			
            if (this.visible && !this.isHide)
            {
				render.draw(this, _material);
            };
            if (_drawChildren)
            {
                _local3 = (children.length - 1);
                while (_local3 >= 0)
                {
                    children[_local3].draw(true, _material);
                    _local3--;
                };
            };
            if ((_eventFlags & EXIT_DRAW_FLAG))
            {
                dispatchEvent(_exitDrawEvent);
            };
        }

        override public function addEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false, _arg4:int=0, _arg5:Boolean=false):void
        {
            var _local6:Boolean = (((_eventFlags >= CLICK)) ? true : false);
            switch (_arg1)
            {
                case MouseEvent3D.CLICK:
                    _eventFlags = (_eventFlags | CLICK);
                    break;
                case MouseEvent3D.MOUSE_DOWN:
                    _eventFlags = (_eventFlags | MOUSE_DOWN);
                    break;
                case MouseEvent3D.MOUSE_MOVE:
                    _eventFlags = (_eventFlags | MOUSE_MOVE);
                    break;
                case MouseEvent3D.MOUSE_OUT:
                    _eventFlags = (_eventFlags | MOUSE_OUT);
                    break;
                case MouseEvent3D.MOUSE_OVER:
                    _eventFlags = (_eventFlags | MOUSE_OVER);
                    break;
                case MouseEvent3D.MOUSE_UP:
                    _eventFlags = (_eventFlags | MOUSE_UP);
                    break;
                case MouseEvent3D.MOUSE_WHEEL:
                    _eventFlags = (_eventFlags | MOUSE_WHELL);
                    break;
            };
           /* if (((((scene) && (!(_local6)))) && ((_eventFlags >= CLICK))))
            {
                scene.insertIntoScene(this, false, false, true);
            };*/
            super.addEventListener(_arg1, _arg2, _arg3, _arg4, _arg5);
        }
		
		private var _oldBlendMode:uint=Material3D.BLEND_ALPHA2;
		public function set alpha(value:Number):void
		{
			if(this.materialPrams.alphaBase==value)
			{
				return;
			}
			
			this.materialPrams.alphaBase=value;
			if(value!=1)
			{
				if(this.materialPrams.blendMode!=Material3D.BLEND_ALPHA2)
				{
					_oldBlendMode=this.materialPrams.blendMode
					this.setMateiralBlendMode(Material3D.BLEND_ALPHA2);
				}
			}else
			{
				if(this.materialPrams.blendMode!=_oldBlendMode)
				{
					this.setMateiralBlendMode(_oldBlendMode);
				}
				
			}
			
		}
		
		public function get alpha():Number
		{
			return this.materialPrams.alphaBase;
		}
		
        override public function removeEventListener(_arg1:String, _arg2:Function, _arg3:Boolean=false):void
        {
            super.removeEventListener(_arg1, _arg2, _arg3);
            switch (_arg1)
            {
                case MouseEvent3D.CLICK:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | CLICK);
                        _eventFlags = (_eventFlags - CLICK);
                    };
                    break;
                case MouseEvent3D.MOUSE_DOWN:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | MOUSE_DOWN);
                        _eventFlags = (_eventFlags - MOUSE_DOWN);
                    };
                    break;
                case MouseEvent3D.MOUSE_MOVE:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | MOUSE_MOVE);
                        _eventFlags = (_eventFlags - MOUSE_MOVE);
                    };
                    break;
                case MouseEvent3D.MOUSE_OUT:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | MOUSE_OUT);
                        _eventFlags = (_eventFlags - MOUSE_OUT);
                    };
                    break;
                case MouseEvent3D.MOUSE_OVER:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | MOUSE_OVER);
                        _eventFlags = (_eventFlags - MOUSE_OVER);
                    };
                    break;
                case MouseEvent3D.MOUSE_UP:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | MOUSE_UP);
                        _eventFlags = (_eventFlags - MOUSE_UP);
                    };
                    break;
                case MouseEvent3D.MOUSE_WHEEL:
                    if (!hasEventListener(_arg1))
                    {
                        _eventFlags = (_eventFlags | MOUSE_WHELL);
                        _eventFlags = (_eventFlags - MOUSE_WHELL);
                    };
                    break;
            };
            /*if (((scene) && ((_eventFlags < CLICK))))
            {
                scene.removeFromScene(this, false, false, true);
            };*/
        }

    }
}//package flare.core

