package mortal.game.resource.tableConfig
{
	
	import Message.DB.Tables.TDesc;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.utils.DescUtil;
	
	public class DescConfig
	{
		
		private static var _instance:DescConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function DescConfig()
		{
			if( _instance != null )
			{
				throw new Error(" DelegateConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():DescConfig
		{
			if( _instance == null )
			{
				_instance = new DescConfig();
			}
			return _instance;
		}
		
		private function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_desc.json");
			write( object );
		}
		
		private function write(dic:Object):void
		{
			var desc:TDesc;
			var o:Object;
			for each(o in dic)
			{
				desc = new TDesc();
				desc.code = o.code;
				desc.desc = o.desc;
				
				_map[desc.code] = desc;
			}
		}
		
		public function getDescById(id:int):String
		{
			if(!_map.hasOwnProperty(id))
			{
				return "";
			}
			return (_map[id] as TDesc).desc;
		}
		
		/**
		 * 根据一条id和对象得到实际描述 
		 * @param id
		 * @param obj
		 * @return 
		 * 
		 */		
		public function getDescAlyzObj(id:int,obj:Object):String
		{
			var str:String = getDescById(int(id));
			return DescUtil.analyzeStr(str,obj);
		}
	}
}