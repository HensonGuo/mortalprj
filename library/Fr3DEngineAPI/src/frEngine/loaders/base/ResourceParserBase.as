package frEngine.loaders.base
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import frEngine.Engine3dEventName;
	
	
	public class ResourceParserBase extends EventDispatcher
	{
		public var url:*;
	
		protected var hasLoaded:Boolean = false;
		private var hasLoadAnimateList:Dictionary=new Dictionary(false);
		private var _bytesTotal:uint;
		private var _bytesLoaded:uint;
		private var _useMaterial:Boolean=true;
		public function ResourceParserBase($url:*)
		{
			url=$url;
			super();
		}
		
		protected function parserFinish():void
		{
			this.hasLoaded=true;
			this.dispatchEvent(new Event(Engine3dEventName.PARSEFINISH));
		}


		public function get loaded():Boolean
		{
			return (this.hasLoaded);
		}
	}
}

