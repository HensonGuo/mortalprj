


//flare.core.Spline3D

package baseEngine.core
{
    import flash.geom.Vector3D;
    import __AS3__.vec.Vector;
    import baseEngine.utils.Vector3DUtils;
    import __AS3__.vec.*;
    import flash.geom.*;
    import baseEngine.utils.*;

    public class Spline3D 
    {

        private static var _dir:Vector3D = new Vector3D();
        private static var _pos:Vector3D = new Vector3D();

        public var knots:Vector.<Knot3D>;
        private var _closed:Boolean = false;
        private var _count:int;

        public function Spline3D()
        {
            this.knots = new Vector.<Knot3D>();
            super();
        }
        public function toString():String
        {
            return ("[object Spline3D]");
        }
        public function clone():Spline3D
        {
            var _local2:Knot3D;
            var _local1:Spline3D = new Spline3D();
            for each (_local2 in this.knots)
            {
                _local1.knots.push((_local2.clone() as Knot3D));
            };
            _local1.closed = this.closed;
            return (_local1);
        }
        public function getPoint(_arg1:Number, _arg2:Vector3D=null):Vector3D
        {
            if (_arg1 < 0)
            {
                _arg1 = 0;
            }
            else
            {
                if (_arg1 > 1)
                {
                    _arg1 = 1;
                };
            };
            _arg2 = ((_arg2) || (new Vector3D()));
            var _local3:Number = (1 / this._count);
            var _local4:Number = Math.floor((_arg1 / _local3));
            var _local5:Knot3D = this.knots[_local4];
            var _local6:Knot3D = ((((_local4 + 1) < this.knots.length)) ? this.knots[(_local4 + 1)] : this.knots[0]);
            this.getSegmentPoint(_local5, _local6, ((_arg1 / _local3) - _local4), _arg2);
            return (_arg2);
        }
        private function getSegmentPoint(_arg1:Knot3D, _arg2:Knot3D, _arg3:Number, _arg4:Vector3D=null):void
        {
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            _local8 = (_arg3 * _arg3);
            _local5 = (1 - _arg3);
            _local9 = (_local5 * _local5);
            _local6 = (_local9 * _local5);
            _local7 = (_local8 * _arg3);
            _arg4.x = ((((_local6 * _arg1.x) + (((3 * _arg3) * _local9) * _arg1.outVec.x)) + (((3 * _local8) * _local5) * _arg2.inVec.x)) + (_local7 * _arg2.x));
            _arg4.y = ((((_local6 * _arg1.y) + (((3 * _arg3) * _local9) * _arg1.outVec.y)) + (((3 * _local8) * _local5) * _arg2.inVec.y)) + (_local7 * _arg2.y));
            _arg4.z = ((((_local6 * _arg1.z) + (((3 * _arg3) * _local9) * _arg1.outVec.z)) + (((3 * _local8) * _local5) * _arg2.inVec.z)) + (_local7 * _arg2.z));
        }
        public function getTangent(_arg1:Number, _arg2:Vector3D=null):Vector3D
        {
            if (_arg1 < 0)
            {
                _arg1 = 0;
            }
            else
            {
                if (_arg1 > 1)
                {
                    _arg1 = 1;
                };
            };
            _arg2 = ((_arg2) || (new Vector3D()));
            var _local3:Number = (1 / this._count);
            var _local4:Number = Math.floor((_arg1 / _local3));
            var _local5:Knot3D = this.knots[_local4];
            var _local6:Knot3D = ((((_local4 + 1) < this.knots.length)) ? this.knots[(_local4 + 1)] : this.knots[0]);
            this.getSetgmentTangent(_local5, _local6, ((_arg1 / _local3) - _local4), _arg2);
            return (_arg2);
        }
        private function getSetgmentTangent(_arg1:Knot3D, _arg2:Knot3D, _arg3:Number, _arg4:Vector3D):void
        {
            if (_arg3 < 0)
            {
                _arg3 = 0;
            }
            else
            {
                if (_arg3 > 1)
                {
                    _arg3 = 1;
                };
            };
            this.getSegmentPoint(_arg1, _arg2, _arg3, _pos);
            this.getSegmentPoint(_arg1, _arg2, (_arg3 - 0.001), _dir);
            Vector3DUtils.sub(_pos, _dir, _arg4);
            _arg4.normalize();
        }
        public function get closed():Boolean
        {
            return (this._closed);
        }
        public function set closed(_arg1:Boolean):void
        {
            this._closed = _arg1;
            if (_arg1)
            {
                this._count = this.knots.length;
            }
            else
            {
                this._count = (this.knots.length - 1);
            };
        }

    }
}//package flare.core

