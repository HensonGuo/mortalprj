


//flare.collisions.RayCollision

package baseEngine.collisions
{
    import flash.events.Event;
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    import __AS3__.vec.Vector;
    
    import baseEngine.core.Mesh3D;
    import baseEngine.core.Pivot3D;
    import baseEngine.core.Poly3D;
    import baseEngine.core.Surface3D;
    import baseEngine.utils.Matrix3DUtils;
    import baseEngine.utils.Surface3DUtils;
    
    import frEngine.Engine3dEventName;
    import frEngine.core.FrSurface3D;
    import frEngine.primitives.FrPlane;

    public class RayCollision 
    {

        private static var _collisionDistance:Number;
        private static var _collisionSurface:Surface3D;
        private static var _collisionMesh:Mesh3D;
        private static var _collisionPoly:Poly3D;
        private static var _polyIntersectionNormal:Vector3D = new Vector3D();
        private static var _polyIntersectionPoint:Vector3D = new Vector3D();
        private static var _global:Matrix3D = new Matrix3D();
        private static var _inv:Matrix3D = new Matrix3D();
        private static var _pos:Vector3D = new Vector3D();
        private static var _dir:Vector3D = new Vector3D();
        private static var _q:Vector3D = new Vector3D();
        private static var _f:Vector3D = new Vector3D();
        private static var _d:Vector3D = new Vector3D();
        private static var _pIPoint:Vector3D = new Vector3D();
        private static var _dist0:Number;

        public var data:Vector.<CollisionInfo>;
        private var _collided:Boolean;
        private var _collisionTime:int;
        private var _pull:Vector.<CollisionInfo>;
        private var _list:Vector.<Mesh3D>;
        private var _meshList:Dictionary;
        public function RayCollision()
        {
            this.data = new Vector.<CollisionInfo>();
            this._pull = new Vector.<CollisionInfo>();
            this._list = new Vector.<Mesh3D>();
            this._meshList = new Dictionary(true);
            super();
        }
        public function dispose():void
        {
            _collisionSurface = null;
            _collisionMesh = null;
            _collisionPoly = null;
            this._pull = null;
            this._list = null;
            this._meshList = null;
        }
        public function test(_arg1:Vector3D, _arg2:Vector3D, multyObject:Boolean=false, _arg5:Boolean=true):Boolean
        {
            var _local6:int = getTimer();
            while (this.data.length)
            {
                this._pull.push(this.data.pop());
            };
            this.update(_arg1, _arg2, multyObject, _arg5);
            if (((!(multyObject)) && (this._collided)))
            {
                this.data.push(this.addInfo(_collisionMesh, _collisionSurface, _collisionPoly, _polyIntersectionPoint, _polyIntersectionNormal));
            };
            this._collisionTime = (getTimer() - _local6);
            return (this._collided);
        }
        private function update(_arg1:Vector3D, _arg2:Vector3D, multyObject:Boolean=false, _arg5:Boolean=false):void
        {
            var _local9:Mesh3D;
            var _local10:Poly3D;
            var _local11:Surface3D;
            var _local12:Vector3D;
            var _local13:Number;
            var _local14:Number;
            var _local15:Number;
            var _local16:Vector.<Poly3D>;
            var _local17:int;
            var _local18:int;
            var _local19:int;
            this._collided = false;
            _collisionDistance = Number.MAX_VALUE;
            var _local6:Number = Number.MAX_VALUE;
            var _local7:Number = Number.MAX_VALUE;
            var _local8:Vector3D = new Vector3D();
            for each (_local9 in this._list)
            {
                if (_local9.visible && _local9.mouseEnabled)
                {
                   
                    _global.copyFrom(_local9.world);
                    Matrix3DUtils.invert(_global, _inv);
                    Matrix3DUtils.transformVector(_inv, _arg1, _f);
                    Matrix3DUtils.deltaTransformVector(_inv, _arg2, _d);
                    _d.normalize();
                    if (_local9.bounds)
                    {
                        _local12 = _local9.bounds.center;
                        _local13 = _local9.bounds.radius;
                        _q.x = (_f.x - _local12.x);
                        _q.y = (_f.y - _local12.y);
                        _q.z = (_f.z - _local12.z);
                        _local14 = _q.dotProduct(_d);
                        _local15 = (_q.dotProduct(_q) - (_local13 * _local13));
                        if (((_local14 * _local14) - _local15) < 0) continue;
                    };
					var len:int=_local9.getSurfacesLen();
                    for (var i:int=0;i<len;i++)
                    {
						_local11=_local9.getSurface(i);
                        _local16 = _local11.polys;
						if(!_local16)return;
                        if ((((((_arg5 == true)) && (_local9.material))) && ((_local9.materialPrams.twoSided == true))))
                        {
                            _arg5 = false;
                        };
                        _local17 = (_local11.firstIndex / 3);
                        _local18 = _local11.numTriangles;
                        if (_local18 == -1)
                        {
                            _local18 = _local11.polys.length;
                        };
                        _local18 = (_local18 + _local17);
                        _local19 = _local17;
						
                        while (_local19 < _local18)
                        {
                            _local10 = _local16[_local19];
                            if (!((_arg5) && ((((((_local10.normal.x * _f.x) + (_local10.normal.y * _f.y)) + (_local10.normal.z * _f.z)) + _local10.plane) < 0))))
                            {
								var num1:Number=(_local10.normal.x * _f.x) + (_local10.normal.y * _f.y)+ (_local10.normal.z * _f.z)+ _local10.plane;
                              	var num2:Number=(_local10.normal.x * _d.x) + (_local10.normal.y * _d.y)+ (_local10.normal.z * _d.z)
								_dist0 = - num1/ num2;
                                if (_dist0 > 0)
                                {
                                    _pIPoint.x = (_f.x + (_d.x * _dist0));
                                    _pIPoint.y = (_f.y + (_d.y * _dist0));
                                    _pIPoint.z = (_f.z + (_d.z * _dist0));
                                    if (_local10.isPoint(_pIPoint.x, _pIPoint.y, _pIPoint.z))
                                    {
                                        Matrix3DUtils.transformVector(_global, _pIPoint, _local8);
                                        _local7 = Vector3D.distance(_arg1, _local8);
                                        _collisionDistance = _dist0;
                                        this._collided = true;
                                        if ((((_local7 < _local6)) || (multyObject)))
                                        {
                                            _collisionPoly = _local10;
                                            _collisionSurface = _local11;
                                            _collisionMesh = _local9;
                                            Matrix3DUtils.deltaTransformVector(_global, _local10.normal, _polyIntersectionNormal);
                                            _polyIntersectionPoint.copyFrom(_local8);
                                            if (multyObject)
                                            {
                                                if (_local7 < _local6)
                                                {
                                                    _local6 = _local7;
                                                    this.data.unshift(this.addInfo(_local9, _local11, _local10, _polyIntersectionPoint, _polyIntersectionNormal));
                                                }
                                                else
                                                {
                                                    this.data.push(this.addInfo(_local9, _local11, _local10, _polyIntersectionPoint, _polyIntersectionNormal));
                                                };
                                            }
                                            else
                                            {
                                                _local6 = _local7;
                                            };
                                        };
                                    };
                                };
                            };
                            _local19++;
                        };
                    };
                    
                };
            };
        }
        private function addInfo(_arg1:Mesh3D, _arg2:Surface3D, _arg3:Poly3D, _arg4:Vector3D, _arg5:Vector3D):CollisionInfo
        {
            var _local6:CollisionInfo = ((this._pull.length) ? this._pull.pop() : new CollisionInfo());
            _local6.mesh = _arg1;
            _local6.surface = _arg2;
            _local6.poly = _arg3;
            _local6.point.copyFrom(_arg4);
            _local6.normal.copyFrom(_arg5);
            _local6.u = _arg3.getPointU();
            _local6.v = _arg3.getPointV();
            return (_local6);
        }
        public function addCollisionWith(_arg1:Pivot3D, $checkChild:Boolean=true):void
        {
            var _local3:Mesh3D;
            var _local4:FrSurface3D;
            var _local5:Pivot3D;
			var _offsetTransform:Matrix3D=_arg1 is FrPlane? FrPlane(_arg1).offsetMatrix:null;
            if (this._meshList[_arg1] == undefined)
            {
                _local3 = (_arg1 as Mesh3D);
                if (_local3)
                {
					var len:int=_local3.getSurfacesLen();
					
                    for (var i:int=0;i<len;i++)
                    {
						_local4=_local3.getSurface(i);
                        if (!_local4.polys)
                        {
                            Surface3DUtils.buildPolys(_local4,_offsetTransform);
                        };
                    };
                    _local3.addEventListener(Engine3dEventName.UNLOAD_EVENT, this.unloadEvent, false, 0, true);
                    _local3.addEventListener(Engine3dEventName.REMOVED_FROM_SCENE_EVENT, this.unloadEvent, false, 0, true);
                    this._meshList[_local3] = (this._list.push(_local3) - 1);
                };
            };
            if ($checkChild)
            {
                for each (_local5 in _arg1.children)
                {
                    this.addCollisionWith(_local5, $checkChild);
                };
            };
        }
        private function unloadEvent(_arg1:Event):void
        {
            while (this.data.length)
            {
                this._pull.push(this.data.pop());
            };
            this.removeCollisionWith((_arg1.target as Pivot3D), false);
        }
        public function removeCollisionWith(_arg1:Pivot3D, _arg2:Boolean=true):void
        {
            var _local3:Mesh3D;
            var _local4:uint;
            var _local5:Pivot3D;
            if (this._meshList[_arg1] >= 0)
            {
                if ((_arg1 is Mesh3D))
                {
                    _local3 = (_arg1 as Mesh3D);
                    _local4 = this._list.indexOf(_local3);
                    delete this._meshList[_local3];
                    this._list.splice(_local4, 1);
                };
            };
            if (_arg2)
            {
                for each (_local5 in _arg1.children)
                {
                    this.removeCollisionWith(_local5, _arg2);
                };
            };
        }
        public function get collisionTime():int
        {
            return (this._collisionTime);
        }
        public function get collisionCount():int
        {
            return (this._list.length);
        }
        public function get collided():Boolean
        {
            return (this._collided);
        }

    }
}//package flare.collisions

