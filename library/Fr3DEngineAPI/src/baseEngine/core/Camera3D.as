


//flare.core.Camera3D

package baseEngine.core
{
    import flash.events.Event;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    import baseEngine.system.Device3D;
    
    import frEngine.Engine3dEventName;
    import frEngine.core.lenses.LensBase;

    public class Camera3D extends Pivot3D 
    {
		
        private var _near:Number;
        private var _far:Number;
        private var _fieldOfView:Number;
        private var _zoom:Number;
        protected var _aspect:Number;
		public static const FieldChange_flag:int = (1 << 5);
		protected static const fieldChangeEvent:Event = new Event(Engine3dEventName.FieldChange);
        private var _view:Matrix3D;
        private var _projection:Matrix3D;
        private var _viewProjection:Matrix3D;
        private var _viewport:Rectangle;
        private var _canvasSize:Point;
        public var clipRectangle:Rectangle;
		/*private var _depthRect:Rectangle;
		private var _depthDirty:Boolean=true;
		private var _depthProjection:Matrix3D;
		private var _depthViewProjection:Matrix3D;*/
		private var _lens:LensBase;
        public function Camera3D(_arg1:String="", _arg2:Number=75, lens:LensBase=null)
        {
            super(_arg1);
			this._lens=lens;
            this._near = 1;
            this._far = 10000;
            this._view = new Matrix3D();
            this._projection = new Matrix3D();
            this._viewProjection = new Matrix3D();
			//this._depthProjection = new Matrix3D();
			//this._depthViewProjection = new Matrix3D();
			
            this.aspectRatio = this._aspect;
            this.fieldOfView = _arg2;
            this.updateProjectionMatrix();
        }
		override public function addEventListener(_arg1:String , _arg2:Function , _arg3:Boolean = false , _arg4:int = 0 , _arg5:Boolean = false):void
		{
			super.addEventListener(_arg1,_arg2,_arg3,_arg4,_arg5);
			if( _arg1==Engine3dEventName.FieldChange)
			{
				this._eventFlags = (this._eventFlags | FieldChange_flag);
			}
		}
		override public function removeEventListener(_arg1:String , _arg2:Function , _arg3:Boolean = false):void
		{
			super.removeEventListener(_arg1 , _arg2 , _arg3);
			if( _arg1==Engine3dEventName.FieldChange)
			{
				if (!hasEventListener(_arg1))
				{
					this._eventFlags = (this._eventFlags | FieldChange_flag);
					this._eventFlags = (this._eventFlags - FieldChange_flag);
				}
			}
		}
		public function getPointDir(screenX:Number, screenY:Number, resultCameraPos:Vector3D=null):Vector3D
		{
			throw new Error("请覆盖getPointDir方法！");
			return null;
		}
		public function getPoint3DAtScreenCoords(_arg1:Vector3D, _arg2:Vector3D = null):Vector3D
		{
			if (!_arg2)
			{
				_arg2 = new Vector3D();
			}
			
			var _local3:Vector3D = this.viewProjection.transformVector(_arg1);
			var _viewRect:Rectangle=Device3D.scene.viewPort
			var _local4:Number = (_viewRect.width * 0.5);
			var _local5:Number = (_viewRect.height * 0.5);
			_arg2.x = ((((_local3.x / _local3.w) * _local4) + _local4) + _viewRect.x);
			_arg2.y = ((((-(_local3.y) / _local3.w) * _local5) + _local5) + _viewRect.y);
			_arg2.z = _local3.z;
			_arg2.w = _local3.w;
			return (_arg2);
		}
		public function screenToCamera(screenX:Number, screenY:Number,depthZ:Number, resultCameraPos:Vector3D):void
		{
			throw new Error("请覆盖screenToCamera方法！");
		}
		final public function get lens():LensBase
		{
			return _lens;
		}
		public function getScreenMouseDistance(screenX:Number,screenY:Number,worldPoint3d:Vector3D):Number
		{
			throw new Error("getScreenMouseDistance！");
			return 0;
		}
		
		final public function set viewPort(_arg1:Rectangle):void
        {
            this._viewport = _arg1;
            this.updateProjectionMatrix();
        }
		final public function get viewPort():Rectangle
        {
            return (this._viewport);
        }
		final public function set canvasSize(_arg1:Point):void
        {
            this._canvasSize = _arg1;
            this.updateProjectionMatrix();
        }
		final public function get canvasSize():Point
        {
            return (this._canvasSize);
        }
        
        public function updateProjectionMatrix():void
        {
			
            updateProj(this._viewport,this._projection);
			worldTransformChanged = true;
           // Device3D.proj.copyFrom(this._projection);
			if (this._eventFlags & FieldChange_flag)
			{
				this.dispatchEvent(fieldChangeEvent);
			}
			
        }

        public function get fieldOfView():Number
        {
            return (this._fieldOfView);
        }
        public function set fieldOfView(_arg1:Number):void
        {
            this._fieldOfView = _arg1;
            this._zoom = Math.tan((((_arg1 / 2) * Math.PI) / 180));
            this.updateProjectionMatrix();
			
        }
        public function get zoom():Number
        {
            return (this._zoom);
        }
        public function set zoom(_arg1:Number):void
        {
            this._zoom = _arg1;
            this._fieldOfView = (((Math.atan(_arg1) * 180) / Math.PI) * 2);
            this.updateProjectionMatrix();
        }
        public function get near():Number
        {
            return (this._near);
        }
        public function set near(_arg1:Number):void
        {
            if (_arg1 <= 0.1)
            {
                _arg1 = 0.1;
            };
            this._near = _arg1;
            this.updateProjectionMatrix();
        }
        public function get far():Number
        {
            return (this._far);
        }
        public function set far(_arg1:Number):void
        {
            this._far = _arg1;
            this.updateProjectionMatrix();
        }
		final public function get view():Matrix3D
        {
            if (((worldTransformChanged) || (_dirtyInv)))
            {
                this._view.copyFrom(invWorld);
				//this._view.prependScale(1,1,-1);
            };
            return (this._view);
        }
		final public function get viewProjection():Matrix3D
        {
            if (((worldTransformChanged) || (_dirtyInv)))
            {
                this._viewProjection.copyFrom(this.view);
                this._viewProjection.append(this._projection);
            };
            return (this._viewProjection);
        }
		final public function get projection():Matrix3D
        {
            return (this._projection);
        }
		final public function set projection(value:Matrix3D):void
		{
			this._projection=value;
		}
		final public function get aspectRatio():Number
        {
            return (this._aspect);
        }
		final  public function set aspectRatio(_arg1:Number):void
        {
            this._aspect = _arg1;
            this.updateProjectionMatrix();
        }
        override public function dispose(isReuse:Boolean=true):void
        {
            if (((scene) && ((scene.camera == this))))
            {
                scene.camera = new Camera3D();
                scene.camera.transform.copyFrom(world);
                scene.camera.fieldOfView = this.fieldOfView;
                scene.camera.near = this.near;
                scene.camera.far = this.far;
            };
            super.dispose(isReuse);
        }
        override public function clone():Pivot3D
        {
            var _local2:Pivot3D;
            var _local1:Camera3D = new Camera3D(name);
            _local1.copyFrom(this);
            _local1.near = this.near;
            _local1.far = this.far;
            _local1.fieldOfView = this.fieldOfView;
            for each (_local2 in children)
            {
                if (!_local2.lock)
                {
                    _local1.addChild(_local2.clone());
                };
            };
            return (_local1);
        }
		/*public function get depthViewProj():Matrix3D
		{
			if (((_depthDirty) || (_dirtyInv)))
			{
				this._depthViewProjection.copyFrom(this.view);
				this._depthViewProjection.append(this.depthProj);
			};
			return (this._depthViewProjection);
		}
		public function get depthProj():Matrix3D
		{
			if(_depthDirty)
			{
				updateProj(depthRect,_depthProjection);
				_depthDirty=false;
			}
			return _depthProjection;
		}*/
		public function updateProj(cameraRect:Rectangle,targetProjection:Matrix3D):void
		{
			throw new Error("请覆盖重写该方法");
		}
		/*public function get depthRect():Rectangle
		{
			if(!_depthRect)
			{
				_depthRect=new Rectangle(0,0,Device3D.depthSize,Device3D.depthSize);
			}
			return _depthRect;
		}*/

    }
}//package flare.core

