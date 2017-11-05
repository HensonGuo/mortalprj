package frEngine.shader.filters.vertexFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	
	public class HerizonKilFilter extends FilterBase
	{

		public function HerizonKilFilter()
		{
			super(FilterType.herizionKil,FilterPriority.HerizionKillFilter);
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			
		}
		
		public override function get programeId():String
		{
			return "HerizonKil";
		}

		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[]
			toReplace.push(new ToBuilderInfo("vf0",FilterName.V_GloblePos,false,1));
			return frprogram.toBuild("",toReplace);
		}
	}
}

