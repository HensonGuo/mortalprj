package baseEngine.basic
{
	import baseEngine.core.Mesh3D;

	public class Layer3DSort
	{
		public var list:Vector.<Mesh3D>=new Vector.<Mesh3D>();
		public var isActive:Boolean;
		public var layerId:int;
		
		
		public function Layer3DSort($layerId:int)
		{
			layerId=$layerId;
			var _id:String="layer:"+$layerId;
			
		}
		public function sort():void
		{
			list.sort(sortFun);
			isActive=false;
		}
		
		private function sortFun(obj1:Mesh3D,obj2:Mesh3D):int
		{
			
			if(obj1.priority==obj2.priority)
			{
				return 0;
			}else if(obj1.priority<obj2.priority)
			{
				return -1;
			}else
			{
				return 1;
			}
				
			
		}
	}
}