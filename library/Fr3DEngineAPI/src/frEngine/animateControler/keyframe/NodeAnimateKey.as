package frEngine.animateControler.keyframe
{
	public class NodeAnimateKey implements INodeKey
	{
		private var _frame:int=0;
		public var value:Number;
		
		
		
		public function NodeAnimateKey($frame:int,$value:Number,$bezierVo:BezierVo)
		{
			frame=$frame;
			value=$value;
			_bezierVo=$bezierVo;
		}
		
		private var _bezierVo:BezierVo;
		public function get bezierVo():BezierVo
		{
			return _bezierVo;
		}
		public function set bezierVo(value:BezierVo):void
		{
			_bezierVo = value;
		}
		
		
		public function get frame():int
		{
			return _frame;
		}

		public function set frame(value:int):void
		{
			_frame = value;
		}

		
		
	}
}