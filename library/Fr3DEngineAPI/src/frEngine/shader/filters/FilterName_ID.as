package frEngine.shader.filters
{
	public class FilterName_ID
	{
		public static const POSITION_ID:int = 1;
		public static const UV_ID:int = 2;
		public static const NORMAL_ID:int = 3;
		public static const SKIN_WEIGHTS_ID:int = 4;
		public static const SKIN_INDICES_ID:int = 5;
		public static const COLOR_ID:int = 6;
		public static const PARAM0_ID:int = 7;
		public static const PARAM1_ID:int = 8;
		public static const PARAM2_ID:int = 9;
		public static const PARAM3_ID:int = 10;
		public static const PARAM4_ID:int = 11;
		public static const PARAM5_ID:int = 12;
		public static const PARAM6_ID:int = 13;
		public static const PARAM7_ID:int = 14;
		public static const PARAM8_ID:int = 15;
		public static const TANGENT_ID:int = 16;
		public static const BITANGENT_ID:int = 17;
		
		static public function getVertexNameId(vertexName:String):int
		{
			vertexName=vertexName.substr(1,vertexName.length-2);
			var _id:int=FilterName_ID[vertexName+"_ID"];
			if(_id==0)
			{
				throw new Error("找不到相应名称"+vertexName+"的id");
			}
			return _id;
		}
	}
}