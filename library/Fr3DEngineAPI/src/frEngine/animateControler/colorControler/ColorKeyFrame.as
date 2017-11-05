package frEngine.animateControler.colorControler
{
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.animateControler.keyframe.INodeKey;

	public class ColorKeyFrame implements INodeKey
	{
		
		private var _frame:int=0;
		public var colorOffsetR:Number=0;
		public var colorOffsetG:Number=0;
		public var colorOffsetB:Number=0;
		
		public function ColorKeyFrame(key:int,value:int,$bezierVo:BezierVo)
		{
			
			frame=key;
			
			_bezierVo=$bezierVo;
			
			if(value>=0)
			{
				colorOffsetR=(value>>16 & 0xff)/255;
				colorOffsetG=(value>>8 & 0xff)/255;
				colorOffsetB=(value & 0xff)/255;
			}
			

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