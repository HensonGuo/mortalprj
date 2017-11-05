package mortal.game.resource.tableConfig
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;

	public class ProxyConfig
	{
		private static var _instance:ProxyConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function ProxyConfig()
		{
			if( _instance != null )
			{
				throw new Error(" BossConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():ProxyConfig
		{
			if( _instance == null )
			{
				_instance = new ProxyConfig();
			}
			return _instance;
		}
		
		private function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_proxy.json");
			write( object );
		}
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			for each( var o:Object in dic  )
			{
				_map[o.proxyId] = o;
			}
		}
		
		public function getProxyName( proxyId:int ):String
		{
			var o:Object = _map[proxyId];
			if( o )
			{
				return o.proxyNameShow;
			}
			return proxyId.toString();
		}
	}
}