


//flare.primitives.Cylinder

package frEngine.primitives
{
    import baseEngine.basic.RenderList;
    import baseEngine.materials.Material3D;

    public class Cylinder extends Cone 
    {

        private var _radius:Number;
        private var _height:Number;
        private var _segments:int;

        public function Cylinder(_arg1:String="cylinder",$renderList:RenderList=null, _arg2:Number=5, _arg3:Number=10, _arg4:int=12, _arg5:Material3D=null)
        {
            super(_arg1,$renderList, _arg2, _arg2, _arg3, _arg4, _arg5);
            this._segments = _arg4;
            this._height = _arg3;
            this._radius = _arg2;
        }
        override public function get segments():int
        {
            return (this._segments);
        }
        override public function get height():Number
        {
            return (this._height);
        }
        public function get radius():Number
        {
            return (this._radius);
        }

    }
}//package flare.primitives

