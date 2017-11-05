package frEngine.animateControler.keyframe
{
	

	public class BezierVo
	{
		public var LY:Number
		public var RY:Number;
		
		public var LX:Number
		public var RX:Number;

		private var _leftSize:Number=-1;
		private var _rightSize:Number=-1;
		private var _lineAngle:Number=-1;
		
		public var isLineTween:Boolean;
		
		public function BezierVo($LX:Number,$LY:Number,$RX:Number,$RY:Number,$isLineTween:Boolean)
		{
			LY=$LY;
			RY=$RY;
			LX=$LX;
			RX=$RX;
			isLineTween=$isLineTween;
		}

		public function getLeftSize(scaleFrameX:Number,scaleFrameY:Number):Number
		{
			if(_leftSize==-1)
			{
				var lx:Number=LX*scaleFrameX;
				var ly:Number=LY*scaleFrameY;
				_leftSize=ly*ly+lx*lx;
				_leftSize=Math.sqrt(_leftSize);
			}
			return _leftSize;
		}
		
		
		public function getRightSize(scaleFrameX:Number,scaleFrameY:Number):Number
		{
			if(_rightSize==-1)
			{
				var rx:Number=RX*scaleFrameX;
				var ry:Number=RY*scaleFrameY;
				_rightSize=ry*ry+rx*rx;
				_rightSize=Math.sqrt(_rightSize);
			}
			return _rightSize;
		}
		public function getLineAngle(scaleFrameX:Number,scaleFrameY:Number):Number
		{
			if(_lineAngle==-1)
			{
				_lineAngle=Math.atan2(LY*scaleFrameY,LX*scaleFrameX);
			}
			return _lineAngle
		}
		public function reset(lineAngle:Number,leftSize:Number,rightSize:Number):void
		{
			isNaN(lineAngle) && (lineAngle=0);
			var sin:Number=Math.sin(lineAngle);
			var cos:Number=Math.cos(lineAngle);
			LY=leftSize*sin
			LX=leftSize*cos
				
			RY=-rightSize*sin;
			RX=-rightSize*cos;
			
			_lineAngle=lineAngle;
			_leftSize=leftSize;
			_rightSize=rightSize;
			isLineTween=(lineAngle==0 && leftSize==0 && rightSize==0);
		}
	}
}