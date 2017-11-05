package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;

	public class FragmentFilter extends FilterBase
	{
		
		
		public function FragmentFilter($texture3DList:Array=null)
		{
			super(FilterType.Fragment,FilterPriority.fragment,$texture3DList);
			//blendMode="normal";
		}
		
		
		/*
		public function toString():String
		{
			return cullFace+","+depthCompare+","+enableDepthWrite+","+srcBlend+","+destBlend;
		}*/
	}
}