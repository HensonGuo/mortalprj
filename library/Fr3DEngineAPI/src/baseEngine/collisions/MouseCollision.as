


//flare.collisions.MouseCollision

package baseEngine.collisions
{
    import flash.geom.Vector3D;
    import flash.geom.Matrix3D;
    import __AS3__.vec.Vector;
    import baseEngine.core.Camera3D;
    import baseEngine.system.Device3D;
    import flash.geom.Rectangle;
    import baseEngine.utils.Matrix3DUtils;
    import baseEngine.core.Pivot3D;
    import __AS3__.vec.*;
    import baseEngine.core.*;
    import flash.geom.*;
    import flash.utils.*;
    import baseEngine.system.*;
    import baseEngine.utils.*;

    public class MouseCollision 
    {

        private static var _pos:Vector3D = new Vector3D();
        private static var _dir:Vector3D = new Vector3D();
        private static var _inv:Matrix3D = new Matrix3D();

        public var data:Vector.<CollisionInfo>;
        private var _ray:RayCollision;
        private var _cam:Camera3D;

        public function MouseCollision(_arg1:Camera3D=null)
        {
            this.data = new Vector.<CollisionInfo>();
            super();
            this._cam = _arg1;
            this._ray = new RayCollision();
        }
        public function dispose():void
        {
            this.data = null;
            this._cam = null;
            this._ray.dispose();
            this._ray = null;
        }
        public function test(_arg1:Number, _arg2:Number, _arg3:Boolean=false, _arg4:Boolean=true, _arg5:Boolean=true):Boolean
        {
            if (!this.getCameraDir(_arg1, _arg2))
            {
                return (false);
            };
            this._ray.test(_pos, _dir, _arg3, _arg5);
            this.data = this._ray.data;
            return (this._ray.collided);
        }
        private function getCameraDir(_arg1:Number, _arg2:Number):Boolean
        {
            var _local3:Camera3D = ((this._cam) ? this._cam : Device3D.camera);
			if(!Device3D.scene)return false;
            var _local4:Rectangle = Device3D.scene.viewPort;
            if (!_local3 || !_local4)
            {
                return (false);
            };
			
            _local3.getPosition(false, _pos);
            _arg1 = (_arg1 - _local4.x);
            _arg2 = (_arg2 - _local4.y);
            _dir.x = (((_arg1 / _local4.width) - 0.5) * 2);
            _dir.y = (((-(_arg2) / _local4.height) + 0.5) * 2);
            _dir.z = 1;
            Matrix3DUtils.invert(_local3.projection, _inv);
            Matrix3DUtils.transformVector(_inv, _dir, _dir);
            _dir.x = (_dir.x * _dir.z);
            _dir.y = (_dir.y * _dir.z);
            Matrix3DUtils.deltaTransformVector(_local3.world, _dir, _dir);
            return (true);
        }
        public function addCollisionWith(_arg1:Pivot3D, $checkChild:Boolean=true):void
        {
            this._ray.addCollisionWith(_arg1, $checkChild);
        }
        public function removeCollisionWith(_arg1:Pivot3D, _arg2:Boolean=true):void
        {
            this._ray.removeCollisionWith(_arg1, _arg2);
        }
        public function get camera():Camera3D
        {
            return (this._cam);
        }
        public function set camera(_arg1:Camera3D):void
        {
            this._cam = _arg1;
        }
        public function get collisionTime():int
        {
            return (this._ray.collisionTime);
        }
        public function get collisionCount():int
        {
            return (this._ray.collisionCount);
        }
        public function get collided():Boolean
        {
            return (this._ray.collided);
        }
        public function get ray():RayCollision
        {
            return (this._ray);
        }

    }
}//package flare.collisions

