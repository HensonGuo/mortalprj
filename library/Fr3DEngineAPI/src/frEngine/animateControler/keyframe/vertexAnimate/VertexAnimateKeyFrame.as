package frEngine.animateControler.keyframe.vertexAnimate
{
	import baseEngine.core.Pivot3D;
	import baseEngine.core.interfaces.IFrame;

	public class VertexAnimateKeyFrame implements IFrame
	{
		public var frame:int;
		public var pOffsetIndex:int;
		public var bufferIndex:int;
		public var normalVect:Vector.<Number>;
		public function VertexAnimateKeyFrame($bufferIndex:int,$pOffsetIndex:int,$frame:int,$normal:Vector.<Number>)
		{
			pOffsetIndex=$pOffsetIndex;
			bufferIndex=$bufferIndex;
			frame=$frame
			normalVect=$normal;
			
		}
		public function cloneFrame():IFrame
		{
			var _local1:VertexAnimateKeyFrame = new VertexAnimateKeyFrame( bufferIndex,pOffsetIndex,frame,normalVect);
			return (_local1);
		}
		public function seting(targetMesh:Pivot3D):void
		{
			
		}
	}
}