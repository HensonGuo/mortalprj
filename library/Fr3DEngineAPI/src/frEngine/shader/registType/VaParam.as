package frEngine.shader.registType
{
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.registType.base.RegistParam;

	public class VaParam extends RegistParam
	{
		public var format:String;
		public var vertexNameId:int;
		//public var offset:int=-1;
		public function VaParam($index:int,$format:String,$paramName:String)
		{
			format=$format;
			vertexNameId=FilterName_ID.getVertexNameId($paramName);
			super("va"+$index,$index,$paramName,false,null);
		}
		public function clone():VaParam
		{
			return new VaParam(this.index,this.format,this.paramName);
		}
	}
}

