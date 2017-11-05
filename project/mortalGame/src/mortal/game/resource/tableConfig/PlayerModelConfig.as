/**
 * @heartspeak
 * 2013-12-18 
 */   	
package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TNpc;
	import Message.DB.Tables.TPlayerModel;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.player.type.ModelType;
	
	public class PlayerModelConfig
	{
		
		private static var _instance:PlayerModelConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		private const connect:String = "_";
		
		public function PlayerModelConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():PlayerModelConfig
		{
			if( _instance == null )
			{
				_instance = new PlayerModelConfig();
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
			var info:TPlayerModel;
			for each( var o:Object in dic  )
			{
				info = new TPlayerModel();
				
				info.code = o.code;
				
				info.name = o.name;
				
				info.type = o.type;
				
				info.career = o.career;
				
				info.sex = o.sex;
				
				info.mesh = StringHelper.getString(o.mesh);
				
				info.texture = StringHelper.getString(o.texture);
				
				info.bone = StringHelper.getString(o.bone);
				
				_map[ info.type + connect + info.code + connect + info.sex + connect + info.career ] = info;
				
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_player_model.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getModelInfo( type:int, code:int,sex:int,career:int):TPlayerModel
		{
			return _map[type + connect + code + connect + sex + connect + career];
		}
		
		/**
		 * 获取衣服资d源信息 
		 * @param code
		 * @param sex
		 * @param career
		 * @return 
		 * 
		 */
		public function getClothesModel(code:int,sex:int,career:int):TPlayerModel
		{
			return getModelInfo(ModelType.CLOTHES,code,sex,career);
		}
	}
}
