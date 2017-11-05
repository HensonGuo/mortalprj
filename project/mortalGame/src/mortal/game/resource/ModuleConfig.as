package mortal.game.resource
{
	import com.gengine.FConfig;
	import com.gengine.core.Singleton;
	import com.gengine.modules.ModuleInfo;
	import com.gengine.modules.ModuleManager;
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.ObjectParser;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * 模块 
	 * @author jianglang
	 * 
	 */	
	public class ModuleConfig
	{
		private static var _instance:ModuleConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		private var _list:Array = new Array();
		
		public function ModuleConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ModuleConfig 单例 ");
			}
			_instance = this;
		}
		
		public static function get instance():ModuleConfig
		{
			if( _instance == null )
			{
				_instance = new ModuleConfig();
			}
			return _instance;
		}
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var info:ModuleInfo;
			for each( var o:Object in dic  )
			{
				info = new ModuleInfo();
				info.url = o.url;
				info.name = o.name;
				info.isLoaded = o.isLoaded;
				info.isLoading = o.isLoading;
				info.error = o.error;
				info.module = o.module;
				_map[ info.name ] = info;
				_list.push(info);
			}
			
			ModuleManager.instance.loadModuleInfo(_list); //注入模块
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getObjectByFileName("module.xml");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoByName( name:String ):ModuleInfo
		{
			return _map[name];
		}
	}
}