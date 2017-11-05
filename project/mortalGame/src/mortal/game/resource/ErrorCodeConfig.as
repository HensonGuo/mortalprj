package mortal.game.resource
{
	import Message.DB.Tables.TErrorCode;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;

	/**
	 * 错误码 
	 * @author jianglang
	 * t_error_code.json
	 */	
	public class ErrorCodeConfig
	{
		private static var _instance:ErrorCodeConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function ErrorCodeConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():ErrorCodeConfig
		{
			if( _instance == null )
			{
				_instance = new ErrorCodeConfig();
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
			var info:TErrorCode;
			for each( var o:Object in dic  )
			{
				info = new TErrorCode();
				info.errorCode = o.errorCode;
				
				info.errorName = StringHelper.getString(o.errorName);
				
				info.errorStr = StringHelper.getString(o.errorStr);
				
				info.display = o.display;
				
				info.showServerMsg = o.showServerMsg;
				_map[ info.errorCode ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_error_code.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoByCode( code:int ):TErrorCode
		{
			return _map[code];
		}
		
		
		public function getErrorStringByCode( code:int ):String
		{
			var error:TErrorCode = _map[ code ] ;
			if(error )
			{
				return error.errorStr;
			}
			return "";
		}
	}
}