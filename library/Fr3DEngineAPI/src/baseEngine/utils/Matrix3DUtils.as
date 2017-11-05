


//flare.utils.Matrix3DUtils

package baseEngine.utils
{
    import flash.geom.Vector3D;
    import flash.geom.Matrix3D;
    import flash.geom.Orientation3D;
    import __AS3__.vec.Vector;
    import flash.geom.*;

    public class Matrix3DUtils 
    {

        private static var _toRad:Number = (Math.PI / 180);//0.0174532925199433
        private static var _toAng:Number = (180 / Math.PI);//57.2957795130823
        private static var _vector:Vector3D = new Vector3D();
        private static var _right:Vector3D = new Vector3D();
        private static var _up:Vector3D = new Vector3D();
        private static var _dir:Vector3D = new Vector3D();
        private static var _scale:Vector3D = new Vector3D();
        private static var _pos:Vector3D = new Vector3D();
        private static var _x:Number;
        private static var _y:Number;
        private static var _z:Number;

        public static function getRight(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(0, _arg2);
            return (_arg2);
        }
        public static function getUp(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(1, _arg2);
            return (_arg2);
        }
        public static function getDir(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(2, _arg2);
            return (_arg2);
        }
        public static function getLeft(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(0, _arg2);
            _arg2.negate();
            return (_arg2);
        }
        public static function getDown(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(1, _arg2);
            _arg2.negate();
            return (_arg2);
        }
        public static function getBackward(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(2, _arg2);
            _arg2.negate();
            return (_arg2);
        }
        public static function getPosition(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (_arg2 == null)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(3, _arg2);
            return (_arg2);
        }
        public static function getScale(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            if (!_arg2)
            {
                _arg2 = new Vector3D();
            };
            _arg1.copyColumnTo(0, _right);
            _arg1.copyColumnTo(1, _up);
            _arg1.copyColumnTo(2, _dir);
            _arg2.x = _right.length;
            _arg2.y = _up.length;
            _arg2.z = _dir.length;
            return (_arg2);
        }
		
		/**
		 * 从from点， 到(toX, toY, toZ)点， 比例为ratio的点坐标 (或者向量运算) 
		 * @param from
		 * @param toX
		 * @param toY
		 * @param toZ
		 * @param ratio
		 * 
		 */		
        public static function setPosition(from:Matrix3D, toX:Number, toY:Number, toZ:Number, ratio:Number=1):void
        {
            if (ratio == 1)
            {
                _vector.setTo(toX, toY, toZ);
                _vector.w = 1;
				from.copyColumnFrom(3, _vector);
            }
            else
            {
				from.copyColumnTo(3, _pos);
                _pos.x = (_pos.x + ((toX - _pos.x) * ratio));
                _pos.y = (_pos.y + ((toY - _pos.y) * ratio));
                _pos.z = (_pos.z + ((toZ - _pos.z) * ratio));
				from.copyColumnFrom(3, _pos);
            };
        }
        public static function setOrientation(_arg1:Matrix3D, _direction:Vector3D, $up:Vector3D=null, _arg4:Number=1):void
        {
            getScale(_arg1, _scale);
            if ($up == null)
            {
                if ((((((_direction.x == 0)) && ((Math.abs(_direction.y) == 1)))) && ((_direction.z == 0))))
                {
                    $up = Vector3D.Z_AXIS;
                }
                else
                {
                    $up = Vector3D.Y_AXIS;
                };
            };
            if (_arg4 != 1)
            {
                getDir(_arg1, _dir);
                _dir.x = (_dir.x + ((_direction.x - _dir.x) * _arg4));
                _dir.y = (_dir.y + ((_direction.y - _dir.y) * _arg4));
                _dir.z = (_dir.z + ((_direction.z - _dir.z) * _arg4));
				_direction = _dir;
                getUp(_arg1, _up);
                _up.x = (_up.x + (($up.x - _up.x) * _arg4));
                _up.y = (_up.y + (($up.y - _up.y) * _arg4));
                _up.z = (_up.z + (($up.z - _up.z) * _arg4));
                $up = _up;
            };
			_direction.normalize();
            var _left:Vector3D = $up.crossProduct(_direction);
			_left.normalize();
			$up = _direction.crossProduct(_left);
			_left.scaleBy(_scale.x);
			$up.scaleBy(_scale.y);
			_direction.scaleBy(_scale.z);
            setVectors(_arg1, _left, $up, _direction);
        }

        public static function setNormalOrientation(_arg1:Matrix3D, _arg2:Vector3D, _arg3:Number=1):void
        {
            if ((((((_arg2.x == 0)) && ((_arg2.y == 0)))) && ((_arg2.z == 0))))
            {
                return;
            };
            getScale(_arg1, _scale);
            getDir(_arg1, _dir);
            if (_arg3 != 1)
            {
                getUp(_arg1, _up);
                _up.x = (_up.x + ((_arg2.x - _up.x) * _arg3));
                _up.y = (_up.y + ((_arg2.y - _up.y) * _arg3));
                _up.z = (_up.z + ((_arg2.z - _up.z) * _arg3));
                _arg2 = _up;
            };
            _arg2.normalize();
            var _local4:Vector3D = (((Math.abs(_dir.dotProduct(_arg2)) == 1)) ? getRight(_arg1, _right) : _dir);
            var _local5:Vector3D = _arg2.crossProduct(_local4);
            _local5.normalize();
            var _local6:Vector3D = _local5.crossProduct(_arg2);
            _local5.scaleBy(_scale.x);
            _arg2.scaleBy(_scale.y);
            _local6.scaleBy(_scale.z);
            setVectors(_arg1, _local5, _arg2, _local6);
        }
		public static function setVectors(_arg1:Matrix3D, _arg2:Vector3D, _arg3:Vector3D, _arg4:Vector3D):void
        {
            _arg2.w = 0;
            _arg3.w = 0;
            _arg4.w = 0;
            _arg1.copyColumnFrom(0, _arg2);
            _arg1.copyColumnFrom(1, _arg3);
            _arg1.copyColumnFrom(2, _arg4);
        }
        public static function lookAt(_arg1:Matrix3D, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Vector3D=null, _arg6:Number=1):void
        {
            _arg1.copyColumnTo(3, _pos);
            _vector.x = (_arg2 - _pos.x);
            _vector.y = (_arg3 - _pos.y);
            _vector.z = (_arg4 - _pos.z);
            setOrientation(_arg1, _vector, _arg5, _arg6);
        }
        public static function setTranslation(_arg1:Matrix3D, _arg2:Number=0, _arg3:Number=0, _arg4:Number=0, _arg5:Boolean=true):void
        {
            if (_arg5)
            {
                _arg1.prependTranslation(_arg2, _arg3, _arg4);
            }
            else
            {
                _arg1.appendTranslation(_arg2, _arg3, _arg4);
            };
        }
        public static function translateX(_arg1:Matrix3D, _arg2:Number, _arg3:Boolean=true):void
        {
            _arg1.copyColumnTo(3, _pos);
            _arg1.copyColumnTo(0, _right);
            if (_arg3)
            {
                _pos.x = (_pos.x + (_arg2 * _right.x));
                _pos.y = (_pos.y + (_arg2 * _right.y));
                _pos.z = (_pos.z + (_arg2 * _right.z));
            }
            else
            {
                _pos.x = (_pos.x + _arg2);
            };
            _arg1.copyColumnFrom(3, _pos);
        }
        public static function translateY(_arg1:Matrix3D, _arg2:Number, _arg3:Boolean=true):void
        {
            _arg1.copyColumnTo(3, _pos);
            _arg1.copyColumnTo(1, _up);
            if (_arg3)
            {
                _pos.x = (_pos.x + (_arg2 * _up.x));
                _pos.y = (_pos.y + (_arg2 * _up.y));
                _pos.z = (_pos.z + (_arg2 * _up.z));
            }
            else
            {
                _pos.y = (_pos.y + _arg2);
            };
            _arg1.copyColumnFrom(3, _pos);
        }
        public static function translateZ(_arg1:Matrix3D, _arg2:Number, _arg3:Boolean=true):void
        {
            _arg1.copyColumnTo(3, _pos);
            _arg1.copyColumnTo(2, _dir);
            if (_arg3)
            {
                _pos.x = (_pos.x + (_arg2 * _dir.x));
                _pos.y = (_pos.y + (_arg2 * _dir.y));
                _pos.z = (_pos.z + (_arg2 * _dir.z));
            }
            else
            {
                _pos.z = (_pos.z + _arg2);
            };
            _arg1.copyColumnFrom(3, _pos);
        }
        public static function translateAxis(_arg1:Matrix3D, _arg2:Number, _arg3:Vector3D):void
        {
            _arg1.copyColumnTo(3, _pos);
            _pos.x = (_pos.x + (_arg2 * _arg3.x));
            _pos.y = (_pos.y + (_arg2 * _arg3.y));
            _pos.z = (_pos.z + (_arg2 * _arg3.z));
            _arg1.copyColumnFrom(3, _pos);
        }
        public static function setScale(_arg1:Matrix3D, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number=1):void
        {
            getScale(_arg1, _scale);
            _x = _scale.x;
            _y = _scale.y;
            _z = _scale.z;
            _scale.x = (_scale.x + ((_arg2 - _scale.x) * _arg5));
            _scale.y = (_scale.y + ((_arg3 - _scale.y) * _arg5));
            _scale.z = (_scale.z + ((_arg4 - _scale.z) * _arg5));
            _right.scaleBy((_scale.x / _x));
            _up.scaleBy((_scale.y / _y));
            _dir.scaleBy((_scale.z / _z));
            setVectors(_arg1, _right, _up, _dir);
        }
        public static function scaleX(_arg1:Matrix3D, _arg2:Number):void
        {
            _arg1.copyColumnTo(0, _right);
            _right.normalize();
            _right.x = (_right.x * _arg2);
            _right.y = (_right.y * _arg2);
            _right.z = (_right.z * _arg2);
            _arg1.copyColumnFrom(0, _right);
        }
        public static function scaleY(_arg1:Matrix3D, _arg2:Number):void
        {
            _arg1.copyColumnTo(1, _up);
            _up.normalize();
            _up.x = (_up.x * _arg2);
            _up.y = (_up.y * _arg2);
            _up.z = (_up.z * _arg2);
            _arg1.copyColumnFrom(1, _up);
        }
        public static function scaleZ(_arg1:Matrix3D, _arg2:Number):void
        {
            _arg1.copyColumnTo(2, _dir);
            _dir.normalize();
            _dir.x = (_dir.x * _arg2);
            _dir.y = (_dir.y * _arg2);
            _dir.z = (_dir.z * _arg2);
            _arg1.copyColumnFrom(2, _dir);
        }
        public static function getRotation(_arg1:Matrix3D, _arg2:Vector3D=null):Vector3D
        {
            _arg2 = ((_arg2) || (new Vector3D()));
            _vector = _arg1.decompose(Orientation3D.EULER_ANGLES)[1];
            _arg2.x = (_vector.x * _toAng);
            _arg2.y = (_vector.y * _toAng);
            _arg2.z = (_vector.z * _toAng);
            return (_arg2);
        }
        public static function setRotation(_arg1:Matrix3D, _arg2:Number, _arg3:Number, _arg4:Number):void
        {
            var _local5:Vector.<Vector3D> = _arg1.decompose(Orientation3D.EULER_ANGLES);
            _local5[1].x = (_arg2 * _toRad);
            _local5[1].y = (_arg3 * _toRad);
            _local5[1].z = (_arg4 * _toRad);
            _arg1.recompose(_local5, Orientation3D.EULER_ANGLES);
        }
        public static function rotateX(_arg1:Matrix3D, _angle:Number, _isLocal:Boolean=true, _arg4:Vector3D=null):void
        {
            rotateAxis(_arg1, _angle, (_isLocal ? getRight(_arg1, _vector) : Vector3D.X_AXIS), _arg4);
        }
        public static function rotateY(_arg1:Matrix3D, _angle:Number, _isLocal:Boolean=true, _arg4:Vector3D=null):void
        {
            rotateAxis(_arg1, _angle, (_isLocal ? getUp(_arg1, _vector) : Vector3D.Y_AXIS), _arg4);
        }
        public static function rotateZ(_arg1:Matrix3D, _angle:Number, _isLocal:Boolean=true, _arg4:Vector3D=null):void
        {
            rotateAxis(_arg1, _angle, (_isLocal ? getDir(_arg1, _vector) : Vector3D.Z_AXIS), _arg4);
        }
        public static function rotateAxis(source:Matrix3D, angle:Number, axis:Vector3D, _arg4:Vector3D=null):void
        {
            _vector.x = axis.x;
            _vector.y = axis.y;
            _vector.z = axis.z;
            _vector.normalize();
			source.copyColumnTo(3, _pos);
			source.appendRotation(angle, _vector, ((_arg4) || (_pos)));
        }
        public static function transformVector(_arg1:Matrix3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _vector.copyFrom(_arg2);
            _arg1.copyRowTo(0, _right);
            _arg1.copyRowTo(1, _up);
            _arg1.copyRowTo(2, _dir);
            _arg1.copyColumnTo(3, _arg3);
            _arg3.x = (_arg3.x + (((_vector.x * _right.x) + (_vector.y * _right.y)) + (_vector.z * _right.z)));
            _arg3.y = (_arg3.y + (((_vector.x * _up.x) + (_vector.y * _up.y)) + (_vector.z * _up.z)));
            _arg3.z = (_arg3.z + (((_vector.x * _dir.x) + (_vector.y * _dir.y)) + (_vector.z * _dir.z)));
            return (_arg3);
        }
        public static function deltaTransformVector(_arg1:Matrix3D, _arg2:Vector3D, _arg3:Vector3D=null):Vector3D
        {
            if (!_arg3)
            {
                _arg3 = new Vector3D();
            };
            _vector.copyFrom(_arg2);
            _arg1.copyRowTo(0, _right);
            _arg1.copyRowTo(1, _up);
            _arg1.copyRowTo(2, _dir);
            _arg3.x = (((_vector.x * _right.x) + (_vector.y * _right.y)) + (_vector.z * _right.z));
            _arg3.y = (((_vector.x * _up.x) + (_vector.y * _up.y)) + (_vector.z * _up.z));
            _arg3.z = (((_vector.x * _dir.x) + (_vector.y * _dir.y)) + (_vector.z * _dir.z));
            return (_arg3);
        }
        public static function invert(_arg1:Matrix3D, _arg2:Matrix3D=null):Matrix3D
        {
            if (!_arg2)
            {
                _arg2 = new Matrix3D();
            };
            _arg2.copyFrom(_arg1);
            _arg2.invert();
            return (_arg2);
        }
        public static function equal(_arg1:Matrix3D, _arg2:Matrix3D):Boolean
        {
            var _local3:Vector.<Number> = _arg1.rawData;
            var _local4:Vector.<Number> = _arg2.rawData;
            var _local5:int;
            while (_local5 < 16)
            {
                if (_local3[_local5] != _local4[_local5])
                {
                    return (false);
                };
                _local5++;
            };
            return (true);
        }
        public static function interpolateTo(_arg1:Matrix3D, _arg2:Matrix3D, _arg3:Number):void
        {
            Matrix3DUtils.getScale(_arg1, _scale);
            Matrix3DUtils.getScale(_arg2, _vector);
            _scale.x = (_scale.x + ((_vector.x - _scale.x) * _arg3));
            _scale.y = (_scale.y + ((_vector.y - _scale.y) * _arg3));
            _scale.z = (_scale.z + ((_vector.z - _scale.z) * _arg3));
            _arg1.interpolateTo(_arg2, _arg3);
            _arg1.prependScale(_scale.x, _scale.y, _scale.z);
        }
        public static function resetPosition(_arg1:Matrix3D):void
        {
            setPosition(_arg1, 0, 0, 0);
        }
        public static function resetRotation(_arg1:Matrix3D):void
        {
            setRotation(_arg1, 0, 0, 0);
        }
        public static function resetScale(_arg1:Matrix3D):void
        {
            setScale(_arg1, 1, 1, 1);
        }

    }
}//package flare.utils

