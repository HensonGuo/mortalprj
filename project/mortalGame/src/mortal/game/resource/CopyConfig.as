/**
 * 2014-3-10
 * @author chenriji
 **/
package mortal.game.resource
{
	import Message.DB.Tables.TCopy;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class CopyConfig
	{
		private static var _instance:CopyConfig;
		
		private var _dic:Dictionary = new Dictionary();
		
		public function CopyConfig()
		{
			init();
		}
		
		public static function get instance():CopyConfig
		{
			if(_instance == null)
			{
				_instance = new CopyConfig();
			}
			return _instance;
		}
		
		private function init():void
		{
			_dic = new Dictionary();
			var objs:Object = ConfigManager.instance.getJSONByFileName("t_copy.json");
			for each(var obj:Object in objs)
			{
				var infox:TCopy  = new TCopy();
				ClassTypesUtil.copyValue(infox, obj);
				_dic[infox.code] = infox;
			}
		}
		
		public function getCopyInfoByCode(code:int):TCopy
		{
			return _dic[code] as TCopy;
		}
	}
}