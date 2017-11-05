


//flare.core.Shape3D

package baseEngine.core
{
    import flash.geom.Vector3D;
    
    import __AS3__.vec.Vector;

    public class Shape3D extends Pivot3D 
    {

        public var splines:Vector.<Spline3D>;
        public var color:uint = 0xFFFFFF;

        public function Shape3D(_arg1:String)
        {
            this.splines = new Vector.<Spline3D>();
            super(_arg1);
        }
        override public function toString():String
        {
            return ("[object Shape3D]");
        }
        override public function clone():Pivot3D
        {
            var _local2:Spline3D;
            var _local3:Pivot3D;
            var _local1:Shape3D = new Shape3D(name);
            _local1.copyFrom(this);
            _local1.color = this.color;
            for each (_local2 in this.splines)
            {
                _local1.splines.push(_local2.clone());
            };
            for each (_local3 in children)
            {
                _local1.addChild(_local3.clone());
            };
            return (_local1);
        }
        public function getPoint(_arg1:Number, _arg2:Boolean=true, _arg3:Vector3D=null):Vector3D
        {
            _arg3 = ((_arg3) || (new Vector3D()));
            var _local4:int = (_arg1 * this.splines.length);
            var _local5:Number = (1 / this.splines.length);
            var _local6:Number = (_arg1 - (_local4 * _local5));
            this.splines[_local4].getPoint((_local6 / _local5), _arg3);
            if (_arg2)
            {
                localToGlobal(_arg3, _arg3);
            };
            return (_arg3);
        }
        public function getTangent(_arg1:Number, _arg2:Boolean=true, _arg3:Vector3D=null):Vector3D
        {
            _arg3 = ((_arg3) || (new Vector3D()));
            var _local4:int = (_arg1 * this.splines.length);
            var _local5:Number = (1 / this.splines.length);
            var _local6:Number = (_arg1 - (_local4 * _local5));
            this.splines[_local4].getTangent((_local6 / _local5), _arg3);
            if (_arg2)
            {
                localToGlobalVector(_arg3, _arg3);
            };
            return (_arg3);
        }

    }
}//package flare.core

