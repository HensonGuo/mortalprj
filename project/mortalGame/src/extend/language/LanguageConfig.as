package extend.language
{
	import com.gengine.core.Singleton;
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	public class LanguageConfig extends Singleton
	{
		private static var _instance:LanguageConfig;
		private var _map:Object = new Object();	
		
		public function LanguageConfig()
		{
			parseXML( ConfigManager.instance.getJSONByFileName("language.json") );
		}
		
		public static function get instance():LanguageConfig
		{
			if( _instance == null)
			{
				_instance = new LanguageConfig();
			}
			return _instance;
		}
		
		public function getString( code:int ):String
		{
			var str:String = _map[ code ];
			return str == null?"":str;
		}
		
		private function parseXML( object:Object ):void
		{
			_map = object;
		}
		
	}
}