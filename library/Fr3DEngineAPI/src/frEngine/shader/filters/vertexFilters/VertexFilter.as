package frEngine.shader.filters.vertexFilters
{
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterPriority;

	public class VertexFilter extends FilterBase
	{
		public var useAlpha:Boolean;
		public function VertexFilter($filterType:int,$texture3DList:Array=null)
		{
			super($filterType,FilterPriority.vertex,$texture3DList);
		}
		
	}
}