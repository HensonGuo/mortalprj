


//flare.collisions.CollisionInfo

package baseEngine.collisions
{
    import baseEngine.core.Mesh3D;
    import baseEngine.core.Surface3D;
    import baseEngine.core.Poly3D;
    import flash.geom.Vector3D;

    public class CollisionInfo 
    {

        public var mesh:Mesh3D;
        public var surface:Surface3D;
        public var poly:Poly3D;
        public var point:Vector3D;
        public var normal:Vector3D;
        public var u:Number;
        public var v:Number;

        public function CollisionInfo()
        {
            this.point = new Vector3D();
            this.normal = new Vector3D();
            super();
        }
        public function toString():String
        {
            return ("[object CollisionInfo]");
        }

    }
}//package flare.collisions

