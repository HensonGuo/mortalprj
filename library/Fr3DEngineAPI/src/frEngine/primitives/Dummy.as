


//flare.primitives.Dummy

package frEngine.primitives
{
    import baseEngine.basic.RenderList;
    import baseEngine.core.Boundings3D;
    
    import frEngine.primitives.base.LineBase;

    public class Dummy extends LineBase 
    {

        private var _size:Number;
        private var _color:uint;
        private var _thickness:Number;
        private var _alpha:Number;
        public function Dummy(_name:String="dummy", $_size:Number=10, $_thickness:Number=1, $_color:uint=0xFFFFFF, $_alpha:Number=1,$renderList:RenderList=null)
        {
            super(_name,false,$renderList);
            this._thickness = $_thickness;
            this._color = $_color;
            this._alpha = $_alpha;
            this._size = $_size;
            this.config();
        }

        private function config():void
        {
            var _local1:Number = (this._size * 0.5);
			drawInstance.clear();
			drawInstance.lineStyle(this._thickness, this._color, this._alpha);
			drawInstance.moveTo(-(_local1), -(_local1), -(_local1));
            drawInstance.lineTo(_local1, -(_local1), -(_local1));
            drawInstance.lineTo(_local1, _local1, -(_local1));
            drawInstance.lineTo(-(_local1), _local1, -(_local1));
            drawInstance.lineTo(-(_local1), -(_local1), -(_local1));
            drawInstance.moveTo(-(_local1), -(_local1), _local1);
            drawInstance.lineTo(_local1, -(_local1), _local1);
            drawInstance.lineTo(_local1, _local1, _local1);
            drawInstance.lineTo(-(_local1), _local1, _local1);
            drawInstance.lineTo(-(_local1), -(_local1), _local1);
            drawInstance.moveTo(-(_local1), -(_local1), -(_local1));
            drawInstance.lineTo(-(_local1), -(_local1), _local1);
            drawInstance.moveTo(_local1, -(_local1), -(_local1));
            drawInstance.lineTo(_local1, -(_local1), _local1);
            drawInstance.moveTo(-(_local1), _local1, -(_local1));
            drawInstance.lineTo(-(_local1), _local1, _local1);
            drawInstance.moveTo(_local1, _local1, -(_local1));
            drawInstance.lineTo(_local1, _local1, _local1);
            bounds = new Boundings3D();
            bounds.min.setTo(-(_local1), -(_local1), -(_local1));
            bounds.max.setTo(_local1, _local1, _local1);
            bounds.length = bounds.max.subtract(bounds.min);
            bounds.radius = bounds.max.length;
        }
		
        public function get color():uint
        {
            return (this._color);
        }
        public function get size():Number
        {
            return (this._size);
        }

    }
}//package flare.primitives

