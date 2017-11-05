


//flare.primitives.Radius

package frEngine.primitives
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	
	import frEngine.animateControler.DrawShapeControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;

    public class Radius extends Mesh3D 
    {

        private var _radius:Number;
        private var _color:uint;
        private var _alpha:Number;
        private var _steps:int;
		private var drawInstance:DrawShapeControler;
        public function Radius(_arg1:String="radius", _arg2:Number=5, _arg3:uint=0xFFFFFF, _arg4:Number=1, _arg5:int=24,$renderList:RenderList=null)
        {
            super(_arg1,false,$renderList);
			drawInstance=this.getAnimateControlerInstance(AnimateControlerType.DrawShapeControler) as DrawShapeControler;
            this._color = _arg3;
            this._alpha = _arg4;
            this._radius = _arg2;
            this._steps = _arg5;
            this.config();
        }
        private function config():void
        {
            var _local3:Number;
            var _local4:Number;
            var _local5:Number;
            var _local1:Number = 0;
            var _local2:Number = ((Math.PI * 2) / this.steps);
            var _local6:Number = this._radius;
			drawInstance.clear();
			drawInstance.lineStyle(1, this.color, this._alpha);
            drawInstance.moveTo((Math.cos(0) * _local6), 0, (Math.sin(0) * _local6));
            _local1 = _local2;
            while (_local1 <= ((Math.PI * 2) + _local2))
            {
                drawInstance.lineTo((Math.cos(_local1) * _local6), 0, (Math.sin(_local1) * _local6));
                _local1 = (_local1 + _local2);
            };
            drawInstance.moveTo(0, (Math.cos(0) * _local6), (Math.sin(0) * _local6));
            _local1 = _local2;
            while (_local1 <= ((Math.PI * 2) + _local2))
            {
                drawInstance.lineTo(0, (Math.cos(_local1) * _local6), (Math.sin(_local1) * _local6));
                _local1 = (_local1 + _local2);
            };
            drawInstance.moveTo((Math.cos(0) * _local6), (Math.sin(0) * _local6), 0);
            _local1 = _local2;
            while (_local1 <= ((Math.PI * 2) + _local2))
            {
                drawInstance.lineTo((Math.cos(_local1) * _local6), (Math.sin(_local1) * _local6), 0);
                _local1 = (_local1 + _local2);
            };
        }
        public function get color():uint
        {
            return (this._color);
        }
        public function get size():Number
        {
            return (this._radius);
        }
        public function get steps():int
        {
            return (this._steps);
        }

    }
}//package flare.primitives

