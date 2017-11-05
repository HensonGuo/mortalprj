


//flare.primitives.DebugCamera

package frEngine.primitives
{
    import baseEngine.core.Camera3D;
    import baseEngine.core.Mesh3D;
    
    import frEngine.animateControler.DrawShapeControler;
    import frEngine.animateControler.keyframe.AnimateControlerType;

    public class DebugCamera extends Mesh3D 
    {

        private var _camera:Camera3D;
        private var _color:uint;
        private var _alpha:Number;
		private var drawInstance:DrawShapeControler;
        public function DebugCamera(_arg1:Camera3D, _arg2:int=0xFFCB00, _arg3:Number=1)
        {
            super(("debug_" + ((_arg1) ? _arg1.name : "")),false,null);
			drawInstance=this.getAnimateControlerInstance(AnimateControlerType.DrawShapeControler) as DrawShapeControler;
            this._alpha = _arg3;
            this._color = _arg2;
            this.camera = _arg1;
        }
        private function config():void
        {
            var _local1:Number;
            var _local2:Number;
            if (!this._camera)
            {
                return;
            };
            var _local3:Number = this._camera.far;
            var _local4:Number = ((this._camera.aspectRatio) || (1));
			drawInstance.clear();
			drawInstance.lineStyle(1, this._color, this._alpha);
            _local1 = (this._camera.zoom * this._camera.near);
            _local2 = ((this._camera.zoom * this._camera.near) / _local4);
			drawInstance. moveTo(-(_local1), _local2, this._camera.near);
			drawInstance.lineTo(_local1, _local2, this._camera.near);
			drawInstance.lineTo(_local1, -(_local2), this._camera.near);
			drawInstance.lineTo(-(_local1), -(_local2), this._camera.near);
			drawInstance.lineTo(-(_local1), _local2, this._camera.near);
            _local1 = (this._camera.zoom * _local3);
            _local2 = ((this._camera.zoom * _local3) / _local4);
			drawInstance.moveTo(-(_local1), _local2, _local3);
			drawInstance.lineTo(_local1, _local2, _local3);
			drawInstance.lineTo(_local1, -(_local2), _local3);
			drawInstance.lineTo(-(_local1), -(_local2), _local3);
			drawInstance.lineTo(-(_local1), _local2, _local3);
			drawInstance.lineStyle(1, this._color, this._alpha);
			drawInstance.moveTo(0, 0, 0);
			drawInstance.lineTo(_local1, _local2, _local3);
			drawInstance.moveTo(0, 0, 0);
			drawInstance.lineTo(_local1, -(_local2), _local3);
			drawInstance.moveTo(0, 0, 0);
			drawInstance.lineTo(-(_local1), -(_local2), _local3);
			drawInstance.moveTo(0, 0, 0);
			drawInstance.lineTo(-(_local1), _local2, _local3);
        }
        public function get camera():Camera3D
        {
            return (this._camera);
        }
        public function set camera(_arg1:Camera3D):void
        {
            this._camera = _arg1;
            this.config();
        }

    }
}//package flare.primitives

