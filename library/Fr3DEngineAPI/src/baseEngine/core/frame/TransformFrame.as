


//flare.core.Frame3D

package baseEngine.core.frame
{
    import flash.geom.Matrix3D;
    
    import __AS3__.vec.Vector;
    
    import baseEngine.core.Pivot3D;
    import baseEngine.core.interfaces.IFrame;

    public class TransformFrame extends Matrix3D implements IFrame
    {

        public static const TYPE_FRAME:int = 0;
        public static const TYPE_TWEEN:int = 1;
        public static const TYPE_NULL:int = 2;

        public var type:int = 0;
        private var _callback:Function;

        public function TransformFrame(_arg1:Vector.<Number>=null, _arg2:int=0)
        {
            super(_arg1);
            this.type = _arg2;
        }
		public function seting(targetMesh:Pivot3D):void
		{
			targetMesh.setTransform(this,true);
			/*if (blendValue == 1)
			{
				targetMesh.transform.copyFrom(this);
			}
			else
			{
				targetMesh.transform.interpolateTo(this, blendValue);
			};*/
		}
		public override function clone():Matrix3D
		{
			throw new Error("请用cloneFrame");
			return null;
		}
		public function cloneFrame():IFrame
		{
			var _local1:TransformFrame = new TransformFrame(rawData, this.type);
			_local1.callback = this.callback;
			return (_local1);
		}
		public function get callback():Function
		{
			return _callback;
		}
		public function set callback(value:Function):void
		{ 
			_callback=value;
		}
		

    }
}//package flare.core

