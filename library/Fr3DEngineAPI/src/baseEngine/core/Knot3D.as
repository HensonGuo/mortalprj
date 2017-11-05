


//flare.core.Knot3D

package baseEngine.core
{
    import flash.geom.Vector3D;

    public class Knot3D extends Vector3D 
    {

        public var inVec:Vector3D;
        public var outVec:Vector3D;

        public function Knot3D()
        {
            this.inVec = new Vector3D();
            this.outVec = new Vector3D();
            super();
        }
        override public function toString():String
        {
            return ("[object Knot3D]");
        }
        override public function clone():Vector3D
        {
            var _local1:Knot3D = new Knot3D();
            _local1.x = x;
            _local1.y = y;
            _local1.z = z;
            _local1.w = w;
            _local1.inVec = this.inVec.clone();
            _local1.outVec = this.outVec.clone();
            return (_local1);
        }

    }
}//package flare.core

