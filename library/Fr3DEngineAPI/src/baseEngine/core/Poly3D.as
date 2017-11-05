


//flare.core.Poly3D

package baseEngine.core
{
    import flash.geom.Vector3D;
    import flash.geom.Point;

    public final class Poly3D 
    {

        private static var _a:Vector3D = new Vector3D();
        private static var _b:Vector3D = new Vector3D();
        private static var c:Vector3D = new Vector3D();
        private static var V:Vector3D = new Vector3D();
        private static var Rab:Vector3D = new Vector3D();
        private static var Rbc:Vector3D = new Vector3D();
        private static var Rca:Vector3D = new Vector3D();
        private static var sub:Vector3D = new Vector3D();

        public var v0:Vector3D;
        public var v1:Vector3D;
        public var v2:Vector3D;
        public var uv0:Point;
        public var uv1:Point;
        public var uv2:Point;
        public var normal:Vector3D;
        public var plane:Number;
        private var _axis:Number;
        private var _tu1:Number;
        private var _tv1:Number;
        private var _tu2:Number;
        private var _tv2:Number;
        private var _tu0:Number;
        private var _tv0:Number;
        private var _alpha:Number;
        private var _beta:Number;

        public function Poly3D(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D, _arg4:Point=null, _arg5:Point=null, _arg6:Point=null)
        {
            this.v0 = _arg1;
            this.v1 = _arg2;
            this.v2 = _arg3;
            this.uv0 = _arg4;
            this.uv1 = _arg5;
            this.uv2 = _arg6;
            this.normal = new Vector3D();
            this.update();
        }
        public function update():void
        {
            _a.x = (this.v1.x - this.v0.x);
            _a.y = (this.v1.y - this.v0.y);
            _a.z = (this.v1.z - this.v0.z);
            _b.x = (this.v2.x - this.v0.x);
            _b.y = (this.v2.y - this.v0.y);
            _b.z = (this.v2.z - this.v0.z);
            this.normal.x = ((_b.y * _a.z) - (_b.z * _a.y));
            this.normal.y = ((_b.z * _a.x) - (_b.x * _a.z));
            this.normal.z = ((_b.x * _a.y) - (_b.y * _a.x));
            this.normal.normalize();
            this.normal.w = -(this.normal.dotProduct(this.v0));
            var _local1:Number = (((this.normal.x > 0)) ? this.normal.x : -(this.normal.x));
            var _local2:Number = (((this.normal.y > 0)) ? this.normal.y : -(this.normal.y));
            var _local3:Number = (((this.normal.z > 0)) ? this.normal.z : -(this.normal.z));
            var _local4:Number = (((_local1 > _local2)) ? (((_local1 > _local3)) ? _local1 : _local3) : (((_local2 > _local3)) ? _local2 : _local3));
            if (_local1 == _local4)
            {
                this._tu1 = (this.v1.y - this.v0.y);
                this._tv1 = (this.v1.z - this.v0.z);
                this._tu2 = (this.v2.y - this.v0.y);
                this._tv2 = (this.v2.z - this.v0.z);
                this._axis = 0;
            }
            else
            {
                if (_local2 == _local4)
                {
                    this._tu1 = (this.v1.x - this.v0.x);
                    this._tv1 = (this.v1.z - this.v0.z);
                    this._tu2 = (this.v2.x - this.v0.x);
                    this._tv2 = (this.v2.z - this.v0.z);
                    this._axis = 1;
                }
                else
                {
                    this._tu1 = (this.v1.x - this.v0.x);
                    this._tv1 = (this.v1.y - this.v0.y);
                    this._tu2 = (this.v2.x - this.v0.x);
                    this._tv2 = (this.v2.y - this.v0.y);
                    this._axis = 2;
                };
            };
            this.plane = -(this.normal.dotProduct(this.v0));
        }
        public function isPoint(_arg1:Number, _arg2:Number, _arg3:Number):Boolean
        {
            if (this._axis == 0)
            {
                this._tu0 = (_arg2 - this.v0.y);
                this._tv0 = (_arg3 - this.v0.z);
            }
            else
            {
                if (this._axis == 1)
                {
                    this._tu0 = (_arg1 - this.v0.x);
                    this._tv0 = (_arg3 - this.v0.z);
                }
                else
                {
                    this._tu0 = (_arg1 - this.v0.x);
                    this._tv0 = (_arg2 - this.v0.y);
                };
            };
            if (this._tu1 != 0)
            {
                this._beta = (((this._tv0 * this._tu1) - (this._tu0 * this._tv1)) / ((this._tv2 * this._tu1) - (this._tu2 * this._tv1)));
                if ((((this._beta >= 0)) && ((this._beta <= 1))))
                {
                    this._alpha = ((this._tu0 - (this._beta * this._tu2)) / this._tu1);
                };
            }
            else
            {
                this._beta = (this._tu0 / this._tu2);
                if ((((this._beta >= 0)) && ((this._beta <= 1))))
                {
                    this._alpha = ((this._tv0 - (this._beta * this._tv2)) / this._tv1);
                };
            };
            if ((((((this._alpha >= 0)) && ((this._beta >= 0)))) && (((this._alpha + this._beta) <= 1))))
            {
                return (true);
            };
            return (false);
        }
        private function closetPointOnLine(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D, _arg4:Vector3D):void
        {
            c.x = (_arg3.x - _arg1.x);
            c.y = (_arg3.y - _arg1.y);
            c.z = (_arg3.z - _arg1.z);
            V.x = (_arg2.x - _arg1.x);
            V.y = (_arg2.y - _arg1.y);
            V.z = (_arg2.z - _arg1.z);
            var _local5:Number = V.length;
            V.normalize();
            var _local6:Number = V.dotProduct(c);
            if (_local6 < 0)
            {
                _arg4.x = _arg1.x;
                _arg4.y = _arg1.y;
                _arg4.z = _arg1.z;
                return;
            };
            if (_local6 > _local5)
            {
                _arg4.x = _arg2.x;
                _arg4.y = _arg2.y;
                _arg4.z = _arg2.z;
                return;
            };
            V.x = (V.x * _local6);
            V.y = (V.y * _local6);
            V.z = (V.z * _local6);
            _arg4.x = (_arg1.x + V.x);
            _arg4.y = (_arg1.y + V.y);
            _arg4.z = (_arg1.z + V.z);
        }
        public function closetPoint(_arg1:Vector3D, _arg2:Vector3D):void
        {
            this.closetPointOnLine(this.v0, this.v1, _arg1, Rab);
            this.closetPointOnLine(this.v1, this.v2, _arg1, Rbc);
            this.closetPointOnLine(this.v2, this.v0, _arg1, Rca);
            sub.x = (_arg1.x - Rab.x);
            sub.y = (_arg1.y - Rab.y);
            sub.z = (_arg1.z - Rab.z);
            var _local3:Number = sub.length;
            sub.x = (_arg1.x - Rbc.x);
            sub.y = (_arg1.y - Rbc.y);
            sub.z = (_arg1.z - Rbc.z);
            var _local4:Number = sub.length;
            sub.x = (_arg1.x - Rca.x);
            sub.y = (_arg1.y - Rca.y);
            sub.z = (_arg1.z - Rca.z);
            var _local5:Number = sub.length;
            var _local6:Number = _local3;
            _arg2.x = Rab.x;
            _arg2.y = Rab.y;
            _arg2.z = Rab.z;
            if (_local4 <= _local6)
            {
                _local6 = _local4;
                _arg2.x = Rbc.x;
                _arg2.y = Rbc.y;
                _arg2.z = Rbc.z;
            };
            if (_local5 < _local6)
            {
                _arg2.x = Rca.x;
                _arg2.y = Rca.y;
                _arg2.z = Rca.z;
            };
        }
        public function getPointU():Number
        {
            if (!this.uv0)
            {
                return (0);
            };
            var _local1:Number = ((((this.uv1.x - this.uv0.x) * this._alpha) + ((this.uv2.x - this.uv0.x) * this._beta)) + this.uv0.x);
            return ((((_local1 > 0)) ? (_local1 - int(_local1)) : ((_local1 - int(_local1)) + 1)));
        }
        public function getPointV():Number
        {
            if (!this.uv0)
            {
                return (0);
            };
            var _local1:Number = ((((this.uv1.y - this.uv0.y) * this._alpha) + ((this.uv2.y - this.uv0.y) * this._beta)) + this.uv0.y);
            return ((((_local1 > 0)) ? (_local1 - int(_local1)) : ((_local1 - int(_local1)) + 1)));
        }

    }
}//package flare.core

