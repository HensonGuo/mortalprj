package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TMountGoldUp;
	import Message.DB.Tables.TMountToolUp;
	import Message.DB.Tables.TMountUp;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.common.tools.DateParser;
	import mortal.game.cache.Cache;
	import mortal.game.manager.ClockManager;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemMountInfo;
	import mortal.game.view.common.ClassTypesUtil;
	import mortal.game.view.mount.data.MountData;

	public class MountConfig
	{
		private static var _instance:MountConfig;
		
		private var _baseMultiple:int;  //加经验的倍数
		
		private var _mountGoldUp:Dictionary = new Dictionary();
		
		private var _mountToolUp:Dictionary = new Dictionary(); //坐骑血统升级配置
		
		private var _mountUpMap:Dictionary = new Dictionary();  //坐骑等级配置
		
		private var _mountMap:Dictionary = new Dictionary();   //坐骑配置
		
		private var _speciesArr:Array = new Array();  //种群
		
		private var _mountList:Vector.<MountData> = new Vector.<MountData>;
		
		private var _vcAttribute:Vector.<String> = new Vector.<String>;  //坐骑血统属性名字列表
		
		private var _attribute:Vector.<String> = new Vector.<String>; //所有属性名字列表
		
		public function MountConfig()
		{
			if( _instance != null )
			{
				throw new Error(" MountConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():MountConfig
		{
			if( _instance == null )
			{
				_instance = new MountConfig();
			}
			return _instance;
		}
		
		private function init():void
		{
			_vcAttribute.push("addPenetration", "addCrit", "addToughness", "addHit", "addJouk", "addExpertise", "addBlock");
			
			_attribute.push("attack","life", "physDefense", "magicDefense", "penetration", "jouk", "hit", "crit", "toughness", "block", "expertise");
			
			writeMountList();
			
			var object:Object = ConfigManager.instance.getJSONByFileName("t_mount_up.json");
			write( object );
			
			object = ConfigManager.instance.getJSONByFileName("t_mount_tool_up.json");
			writeToopUp( object );
			
			object = ConfigManager.instance.getJSONByFileName("t_mount_gold_up.json");
			writeGoldUp( object );
			
			_baseMultiple = ItemConfig.instance.getConfig(410140000).effect;  //拿到升级道具的配置,暂时写死
		}
		
		public function writeMountList():void
		{
			_mountList.length = 0;
			
			_mountMap = ItemConfig.instance.mountMap;
			
			var date:Date = ClockManager.instance.nowDate;
			
			for each(var i:ItemMountInfo in _mountMap)
			{
				if(_speciesArr.indexOf(i.species) == -1 && ((date.time >= i.beginTime.time && date.time < i.endTime.time) || i.endTime.time == i.beginTime.time))
				{
					_speciesArr.push(i.species);
					_mountList.push(new MountData(i));
				}
			}
			Cache.instance.mount.mountList = null;
		}
		
		private function write( dic:Object ):void
		{
			var info:TMountUp;
			
			for each( var o:Object in dic )
			{
				info = new TMountUp();
				ClassTypesUtil.copyValue(info,o);
				_mountUpMap[ info.level ] = info;
			}
			_mountUpMap[0] = new TMountUp();
		}
		
		private function writeToopUp( dic:Object ):void
		{
			var info:TMountToolUp;
			
			for each( var o:Object in dic )
			{
				info = new TMountToolUp();
				ClassTypesUtil.copyValue(info,o);
				_mountToolUp[ info.level ] = info;
			}
			_mountToolUp[0] = new TMountToolUp();
		}
		
		private function writeGoldUp( dic:Object ):void
		{
			var info:TMountGoldUp;
			
			for each( var o:Object in dic )
			{
				info = new TMountGoldUp();
				ClassTypesUtil.copyValue(info,o);
				_mountGoldUp[ info.num ] = info;
			}
//			_mountGoldUp[0] = new TMountGoldUp();
		}
		
		/**
		 * 根据Code获取坐骑配置
		 * @param value
		 * @return 
		 * 
		 */		
		public function getMountInfoById( code:int ):ItemMountInfo
		{
			return _mountMap[code];
		}
		
		public function getMountGoldUpByNum( num:int ):TMountGoldUp
		{
		    return _mountGoldUp[num];	
		}
		
		public function getMountUpByLevel( level:int ):TMountUp
		{
			return _mountUpMap[level];
		}
		
		public function getMountToolLevel( level:int ):TMountToolUp
		{
			return _mountToolUp[level];
		}
		
		public function get mountList(): Vector.<MountData>
		{
			return _mountList;
		}
		
		public function get mountUpDec():Dictionary
		{
			return _mountUpMap;
		}
		
		public function get vcAttribute():Vector.<String>
		{
			return _vcAttribute;
		}
		
		public function get attribute():Vector.<String>
		{
			return _attribute;
		}
		
		public function get baseMultiple():int
		{
			return _baseMultiple;
		}
	}
}