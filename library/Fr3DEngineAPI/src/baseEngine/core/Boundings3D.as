


//flare.core.Boundings3D

package baseEngine.core
{
    import flash.geom.Vector3D;

    public class Boundings3D 
    {

        public var radius:Number = 0;
        public var min:Vector3D;
        public var max:Vector3D;
        public var length:Vector3D;
        public var center:Vector3D;

        public function Boundings3D()
        {
            this.reset();
        }
        public function clone():Boundings3D
        {
            var _local1:Boundings3D = new Boundings3D();
            _local1.radius = this.radius;
            _local1.min = this.min.clone();
            _local1.max = this.max.clone();
            _local1.length = this.length.clone();
            _local1.center = this.center.clone();
            return (_local1);
        }
        public function toString():String
        {
            return ("[object Boundings3D]");
        }
        public function reset():void
        {
            this.radius = 0;
            this.min = new Vector3D();
            this.max = new Vector3D();
            this.center = new Vector3D();
            this.length = new Vector3D();
        }

    }
}//package flare.core

