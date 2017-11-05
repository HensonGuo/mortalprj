package frEngine.core
{
	public class BufferVo
	{
		public var size:int;
		public var format:String;
		public var offset:int;
		public var nameId:int;
		public var buffer:FrVertexBuffer3D;
		public function BufferVo($buffer:FrVertexBuffer3D,$name_id:int)
		{
			buffer=$buffer;
			nameId=$name_id;
		}
	}
}