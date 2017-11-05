package frEngine.core
{
	public class Data3dInfo
	{
		public var data:Vector.<Number>;
		public var dataPerSize:int;
		public var dataOffset:int;
		public var dataFormat:String;
		
		public function Data3dInfo($data:Vector.<Number>,$dataPerSize:int,$dataOffset:int,$dataFormat:String)
		{
			data=$data;
			dataPerSize=$dataPerSize;
			dataOffset=$dataOffset;
			dataFormat=$dataFormat;
			
		}
	}
}