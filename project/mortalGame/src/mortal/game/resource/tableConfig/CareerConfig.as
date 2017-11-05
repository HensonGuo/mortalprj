/**
 * 2014-3-6
 * @author chenriji
 **/
package mortal.game.resource.tableConfig
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.info.CareerInfo;

	public class CareerConfig
	{
		private var _map:Dictionary;
		private static var _instance:CareerConfig;
		
		public function CareerConfig()
		{
			init();
		}
		
		public static function get instance():CareerConfig
		{
			if(_instance == null)
			{
				_instance = new CareerConfig();
			}
			return _instance;
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_career.json");
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
			_map = new Dictionary();
			var info:CareerInfo;
			for each( var o:Object in dic  )
			{
				info = new CareerInfo();
				
				info.code = o.code;
				info.maleBodySize = o.maleBodySize;
				info.femaleBodySize = o.femaleBodySize;
				
				_map[ info.code ] = info;
			}
		}
		
		public function getBodySize(code:int, isMale:Boolean=true):int
		{
			var info:CareerInfo = _map[code];
			if(info == null)
			{
				return 0;
			}
			if(isMale)
			{
				return info.maleBodySize;
			}
			return info.femaleBodySize;
		}
	}
}