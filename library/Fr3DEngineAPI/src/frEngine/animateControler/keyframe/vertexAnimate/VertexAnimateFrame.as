package frEngine.animateControler.keyframe.vertexAnimate
{
	import baseEngine.core.Pivot3D;
	import baseEngine.core.interfaces.IFrame;

	public class VertexAnimateFrame implements IFrame
	{
		
		public var frame:Number;
		public var preOffset:int;
		public var nextOffset:int;
		public var rate:Number;
		public var isKeyFrame:Boolean;
		public var preBufferIndex:int;
		public var nextBufferIndex:int;
		private var _callback:Function;
		public function VertexAnimateFrame($isKeyFrame:Boolean,$frame:Number)
		{
			frame=$frame;
			isKeyFrame=$isKeyFrame;
		}
		public function updateFrame($preKeyFrame:VertexAnimateKeyFrame,$nextKeyFrame:VertexAnimateKeyFrame):void
		{
			rate=(frame-$preKeyFrame.frame)/($nextKeyFrame.frame-$preKeyFrame.frame);
			preOffset=$preKeyFrame.pOffsetIndex;
			nextOffset=$nextKeyFrame.pOffsetIndex;
			preBufferIndex=$preKeyFrame.bufferIndex;
			nextBufferIndex=$nextKeyFrame.bufferIndex;
		}
		public function cloneFrame():IFrame
		{
			var _local1:VertexAnimateFrame = new VertexAnimateFrame( isKeyFrame,frame);
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
		public function seting(targetMesh:Pivot3D):void
		{
			
		}
	}
}