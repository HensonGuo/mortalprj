/**
 * @heartspeak
 * 2014-2-12 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TModel;
	import Message.DB.Tables.TPetConfig;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;
	
	public class ModelConfig
	{
		private static var _instance:ModelConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function ModelConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ModelConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():ModelConfig
		{
			if( _instance == null )
			{
				_instance = new ModelConfig();
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
			var info:TModel;
			for each( var o:Object in dic  )
			{
				info = new TModel();
				info.id = o.id;
				info.type = o.type;
				info.name = o.name;
				info.sortNum = o.sortNum;
				info.test = o.test;
				info.mesh1 = o.mesh1;
				info.texture1 = o.texture1;
				info.bone1 = o.bone1;
				info.mesh2 = o.mesh2;
				info.texture2 = o.texture2;
				info.bone2 = o.bone2;
				info.mesh3 = o.mesh3;
				info.texture3 = o.texture3;
				info.bone3 = o.bone3;
				info.mesh4 = o.mesh4;
				info.texture4 = o.texture4;
				info.bone4 = o.bone4;
				_map[ info.id ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_model.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByCode( code:int ):TModel
		{
			return _map[code] as TModel;
		}
		
		/**
		 * 根据大小类获取资源信息 
		 * @param sortNum 小类
		 * @param type    大类
		 * @return 
		 * 
		 */		
		public function getInfoByType(sortNum:int,type:int = 3):TModel
		{
			for each(var model:TModel in _map)
			{
				if(model.sortNum == sortNum && model.type == type)
				{
					return model;
				}
			}
			return null;
		}
	}
}
