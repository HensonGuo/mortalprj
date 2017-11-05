/**
 * @date 2011-6-24 下午08:52:11
 * @author  陈炯栩
 * 
 */

package mortal.game.resource
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;

	public class MusicsAndSoundsConfig
	{
		private static var _instance:MusicsAndSoundsConfig;
		
		private var _musicsDic:Dictionary = new Dictionary();
		private var _soundsDic:Dictionary = new Dictionary();
		
		public function MusicsAndSoundsConfig()
		{
			if( _instance != null )
			{
				throw new Error(" MusicsAndSoundsConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():MusicsAndSoundsConfig
		{
			if( _instance == null )
			{
				_instance = new MusicsAndSoundsConfig();
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
			var musics:Array = dic["musics"]["music"] as Array;
			var sounds:Array = dic["sounds"]["sound"] as Array;
			
			var o:Object;
			for each(o in musics)
			{
				var key:String = o.mapId + "_" + o.sceneName;
				_musicsDic[key] = o.fileName;
			}
			for each(o in sounds)
			{
				_soundsDic[o.type] = o.fileName;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getObjectByFileName("musicsAndSounds.xml");
			write( object );
		}
		
		/**
		 * 获取场景音乐文件名信息
		 * @param mapId 地图ID
		 * @return 文件名
		 * 
		 */		
		public function getMusicFileNameByMapId( mapId:int,sceneName:String="" ):String
		{
			return _musicsDic[ mapId + "_" + sceneName ] as String;
		}
		
		/**
		 * 获音效文件名信息
		 * @param type 音效类型
		 * @return 文件名
		 * 
		 */
		public function getSoundFileNameByType( type:String ):String
		{
			return _soundsDic[type] as String;
		}
	}
}