package frEngine.render.drawCache
{
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Surface3D;
	
	import frEngine.shader.filters.FilterBase;
	
	public class DrawCacheBase
	{
		protected var _isFull:Boolean=false;
		public var  objectsNum:int=0;
		public function DrawCacheBase()
		{
		}
		public function pushObject(object:Pivot3D,surface:Surface3D,...otherParams):void
		{
			
		}
		public function get isFull():Boolean
		{
			return _isFull;
		}
		public function clear():void
		{
			_isFull=false;
			objectsNum=0;
		}
	}
}