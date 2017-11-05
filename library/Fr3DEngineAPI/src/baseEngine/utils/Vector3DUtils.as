


//flare.utils.Vector3DUtils

package baseEngine.utils
{
    import flash.geom.Vector3D;

    public class Vector3DUtils 
    {

        public static const UP:Vector3D = new Vector3D(0, 1, 0);
        public static const DOWN:Vector3D = new Vector3D(0, -1, 0);
        public static const RIGHT:Vector3D = new Vector3D(1, 0, 0);
        public static const LEFT:Vector3D = new Vector3D(-1, 0, 0);
        public static const FORWARD:Vector3D = new Vector3D(0, 0, 1);
        public static const BACK:Vector3D = new Vector3D(0, 0, -1);
        public static const ZERO:Vector3D = new Vector3D(0, 0, 0);
        public static const ONE:Vector3D = new Vector3D(1, 1, 1);

        public static function lengthSquared(_arg1:Vector3D, _arg2:Vector3D):Number
        {
            var _local3:Number = (_arg1.x - _arg2.x);
            var _local4:Number = (_arg1.y - _arg2.y);
            var _local5:Number = (_arg1.z - _arg2.z);
            return ((((_local3 * _local3) + (_local4 * _local4)) + (_local5 * _local5)));
        }
        public static function length(_arg1:Vector3D, _arg2:Vector3D):Number
        {
            var _local3:Number = (_arg1.x - _arg2.x);
            var _local4:Number = (_arg1.y - _arg2.y);
            var _local5:Number = (_arg1.z - _arg2.z);
            return (Math.sqrt((((_local3 * _local3) + (_local4 * _local4)) + (_local5 * _local5))));
        }
        public static function setLength(_arg1:Vector3D, _arg2:Number):void
        {
            var _local3:Number = _arg1.length;
            if (_local3 > 0)
            {
                _local3 = (_local3 / _arg2);
                _arg1.x = (_arg1.x / _local3);
                _arg1.y = (_arg1.y / _local3);
                _arg1.z = (_arg1.z / _local3);
            }
            else
            {
                _arg1.x = (_arg1.y = (_arg1.z = 0));
            };
        }
        public static function cross(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _arg3.x = ((_arg1.y * _arg2.z) - (_arg1.z * _arg2.y));
            _arg3.y = ((_arg1.z * _arg2.x) - (_arg1.x * _arg2.z));
            _arg3.z = ((_arg1.x * _arg2.y) - (_arg1.y * _arg2.x));
            return (_arg3);
        }
        public static function sub(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _arg3.x = (_arg1.x - _arg2.x);
            _arg3.y = (_arg1.y - _arg2.y);
            _arg3.z = (_arg1.z - _arg2.z);
            return (_arg3);
        }
        public static function add(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _arg3.x = (_arg1.x + _arg2.x);
            _arg3.y = (_arg1.y + _arg2.y);
            _arg3.z = (_arg1.z + _arg2.z);
            return (_arg3);
        }
        public static function set(_arg1:Vector3D, _arg2:Number=0, _arg3:Number=0, _arg4:Number=0, _arg5:Number=0):void
        {
            _arg1.x = _arg2;
            _arg1.y = _arg3;
            _arg1.z = _arg4;
            _arg1.w = _arg5;
        }
        public static function negate(_arg1:Vector3D, _arg2:Vector3D=null):Vector3D
        {
            if (!_arg2)
            {
                _arg2 = new Vector3D();
            };
            _arg2.x = -(_arg1.x);
            _arg2.y = -(_arg1.y);
            _arg2.z = -(_arg1.z);
            return (_arg2);
        }
        public static function interpolate(_arg1:Vector3D, _arg2:Vector3D, _arg3:Number, _arg4:Vector3D=null):Vector3D
        {
            if (!_arg4)
            {
                _arg4 = new Vector3D();
            };
            _arg4.x = (_arg1.x + ((_arg2.x - _arg1.x) * _arg3));
            _arg4.y = (_arg1.y + ((_arg2.y - _arg1.y) * _arg3));
            _arg4.z = (_arg1.z + ((_arg2.z - _arg1.z) * _arg3));
            return (_arg4);
        }
        public static function random(_arg1:Number, _arg2:Number, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _arg3.x = ((Math.random() * (_arg2 - _arg1)) + _arg1);
            _arg3.y = ((Math.random() * (_arg2 - _arg1)) + _arg1);
            _arg3.z = ((Math.random() * (_arg2 - _arg1)) + _arg1);
            return (_arg3);
        }
        public static function mirror(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            var _local4:Number = _arg1.dotProduct(_arg2);
            _arg3.x = (_arg1.x - ((2 * _arg2.x) * _local4));
            _arg3.y = (_arg1.y - ((2 * _arg2.y) * _local4));
            _arg3.z = (_arg1.z - ((2 * _arg2.z) * _local4));
            return (_arg3);
        }
        public static function min(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _arg3.x = (((_arg1.x < _arg2.x)) ? _arg1.x : _arg2.x);
            _arg3.y = (((_arg1.y < _arg2.y)) ? _arg1.y : _arg2.y);
            _arg3.z = (((_arg1.z < _arg2.z)) ? _arg1.z : _arg2.z);
            return (_arg3);
        }
        public static function max(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _arg3.x = (((_arg1.x > _arg2.x)) ? _arg1.x : _arg2.x);
            _arg3.y = (((_arg1.y > _arg2.y)) ? _arg1.y : _arg2.y);
            _arg3.z = (((_arg1.z > _arg2.z)) ? _arg1.z : _arg2.z);
            return (_arg3);
        }
        public static function abs(_arg1:Vector3D):void
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

    }
}//package flare.utils

