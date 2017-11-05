package frEngine.effectEditTool.parser.def
{

	public class ELayerType
	{
		public static const Model:String = "模型层";

		public static const Geometry:String = "几何层";

		public static const Particle:String = "粒子层";

		public static const DaoGuang:String = "刀光层";

		public static const Hang:String = "虚拟层";

		public static const Road:String = "路径层";
		
		public static function get layerTypeArray():Array
		{
			return [Model , Geometry , Particle , DaoGuang , Hang ,Road];
		}
	}
}
