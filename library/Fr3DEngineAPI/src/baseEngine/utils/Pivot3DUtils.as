


//flare.utils.Pivot3DUtils

package baseEngine.utils
{
    import flash.geom.Matrix3D;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;
    
    import baseEngine.core.Boundings3D;
    import baseEngine.core.Mesh3D;
    import baseEngine.core.Pivot3D;


    public class Pivot3DUtils 
    {

        private static var _tmp:Vector3D = new Vector3D();
        private static var _mr:Vector3D = new Vector3D();
        private static var _mu:Vector3D = new Vector3D();
        private static var _md:Vector3D = new Vector3D();
        private static var _center:Vector3D = new Vector3D();
        private static var _length:Vector3D = new Vector3D();
        private static var _transform:Matrix3D = new Matrix3D();
        private static var _bounds:Boolean;
        private static var _added:Dictionary;

        public static function traceInfo(_arg1:Pivot3D, _arg2:Boolean=false, _arg3:Boolean=true):void
        {
           
        }
       
        public static function setPositionWithReference(_arg1:Pivot3D, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Pivot3D, _arg6:Number=1):void
        {
            _tmp.x = _arg2;
            _tmp.y = _arg3;
            _tmp.z = _arg4;
            _arg5.localToGlobal(_tmp, _tmp);
            if (_arg1.parent)
            {
                _arg1.parent.globalToLocal(_tmp, _tmp);
            };
            _arg1.setPosition(_tmp.x, _tmp.y, _tmp.z);
        }
        public static function lookAtWithReference(_arg1:Pivot3D, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Pivot3D, _arg6:Vector3D=null, _arg7:Number=1):void
        {
            _tmp.x = _arg2;
            _tmp.y = _arg3;
            _tmp.z = _arg4;
            _arg5.localToGlobal(_tmp, _tmp);
            if (_arg1.parent)
            {
                _arg1.parent.globalToLocal(_tmp, _tmp);
            };
            _arg1.lookAt(_tmp.x, _tmp.y, _tmp.z, _arg6, _arg7);
        }
        public static function getBounds(_arg1:Pivot3D, _arg2:Boundings3D=null, _arg3:Pivot3D=null, _arg4:Boolean=true):Boundings3D
        {
            if (!_arg2)
            {
                _arg2 = new Boundings3D();
                _arg2.min.setTo(10000000, 10000000, 10000000);
                _arg2.max.setTo(-10000000, -10000000, -10000000);
            };
            _bounds = false;
            growBounds(((_arg3) || (_arg1)), _arg1, _arg2, _arg4);
            if (_bounds)
            {
                _arg2.length.x = (_arg2.max.x - _arg2.min.x);
                _arg2.length.y = (_arg2.max.y - _arg2.min.y);
                _arg2.length.z = (_arg2.max.z - _arg2.min.z);
                _arg2.center.x = ((_arg2.length.x * 0.5) + _arg2.min.x);
                _arg2.center.y = ((_arg2.length.y * 0.5) + _arg2.min.y);
                _arg2.center.z = ((_arg2.length.z * 0.5) + _arg2.min.z);
                _arg2.radius = Vector3D.distance(_arg2.center, _arg2.max);
            }
            else
            {
                _arg2.reset();
            };
            return (_arg2);
        }
        private static function growBounds(_arg1:Pivot3D, _arg2:Pivot3D, _arg3:Boundings3D, _arg4:Boolean=true):void
        {
            var _local5:Mesh3D;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Pivot3D;
            _bounds = true;
            if ((_arg2 is Mesh3D))
            {
                _local5 = (_arg2 as Mesh3D);
                _transform.copyFrom(_arg2.world);
                _transform.append(_arg1.invWorld);
                _transform.copyColumnTo(0, _mr);
                _transform.copyColumnTo(1, _mu);
                _transform.copyColumnTo(2, _md);
                _center.x = ((_local5.bounds.max.x + _local5.bounds.min.x) * 0.5);
                _center.y = ((_local5.bounds.max.y + _local5.bounds.min.y) * 0.5);
                _center.z = ((_local5.bounds.max.z + _local5.bounds.min.z) * 0.5);
                Matrix3DUtils.transformVector(_transform, _center, _center);
                _length.x = (_local5.bounds.length.x * 0.5);
                _length.y = (_local5.bounds.length.y * 0.5);
                _length.z = (_local5.bounds.length.z * 0.5);
                Matrix3DUtils.deltaTransformVector(_transform, _length, _length);
                _mr.scaleBy((_mr.dotProduct(_length) / _mr.dotProduct(_mr)));
                abs(_mr);
                _mu.scaleBy((_mu.dotProduct(_length) / _mu.dotProduct(_mu)));
                abs(_mu);
                _md.scaleBy((_md.dotProduct(_length) / _md.dotProduct(_md)));
                abs(_md);
                _local6 = ((_mr.x + _mu.x) + _md.x);
                _local7 = ((_mr.y + _mu.y) + _md.y);
                _local8 = ((_mr.z + _mu.z) + _md.z);
                if ((_local6 + _center.x) > _arg3.max.x)
                {
                    _arg3.max.x = (_local6 + _center.x);
                };
                if ((-(_local6) + _center.x) < _arg3.min.x)
                {
                    _arg3.min.x = (-(_local6) + _center.x);
                };
                if ((_local7 + _center.y) > _arg3.max.y)
                {
                    _arg3.max.y = (_local7 + _center.y);
                };
                if ((-(_local7) + _center.y) < _arg3.min.y)
                {
                    _arg3.min.y = (-(_local7) + _center.y);
                };
                if ((_local8 + _center.z) > _arg3.max.z)
                {
                    _arg3.max.z = (_local8 + _center.z);
                };
                if ((-(_local8) + _center.z) < _arg3.min.z)
                {
                    _arg3.min.z = (-(_local8) + _center.z);
                };
            }
            else
            {
                _center = _arg2.world.position;
                if (_center.x > _arg3.max.x)
                {
                    _arg3.max.x = _center.x;
                };
                if (_center.x < _arg3.min.x)
                {
                    _arg3.min.x = _center.x;
                };
                if (_center.y > _arg3.max.y)
                {
                    _arg3.max.y = _center.y;
                };
                if (_center.y < _arg3.min.y)
                {
                    _arg3.min.y = _center.y;
                };
                if (_center.z > _arg3.max.z)
                {
                    _arg3.max.z = _center.z;
                };
                if (_center.z < _arg3.min.z)
                {
                    _arg3.min.z = _center.z;
                };
            };
            if (_arg4)
            {
                for each (_local9 in _arg2.children)
                {
                    growBounds(_arg1, _local9, _arg3, _arg4);
                };
            };
        }
        private static function abs(_arg1:Vector3D):void
        {
            if (_arg1.x < 0)
            {
                _arg1.x = -(_arg1.x);
            };
            if (_arg1.y < 0)
            {
                _arg1.y = -(_arg1.y);
            };
            if (_arg1.z < 0)
            {
                _arg1.z = -(_arg1.z);
            };
        }
       
       
        public static function getDistance(_arg1:Pivot3D, _arg2:Pivot3D):Number
        {
            return (Vector3D.distance(_arg1.world.position, _arg2.world.position));
        }

    }
}//package flare.utils

