package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TRune;
	import Message.DB.Tables.TSkill;
	import Message.Public.ESkillType;
	
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.utils.DescUtil;
	import mortal.game.view.common.ClassTypesUtil;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.SkillUtil;

	/**
	 * 技能 
	 * @author heartspeak
	 * t_skill.json
	 */	
	public class SkillConfig
	{
		private static var _instance:SkillConfig;
		
		private var _map:Dictionary = new Dictionary();
		private var _serialDic:Dictionary = new Dictionary(); // 所有技能系列
		private var _maxLevel:Dictionary;// = new Dictionary();
		private var _serialSkills:Dictionary = new Dictionary();
		
		// 符文
		private var _rune:Dictionary = new Dictionary();
		
		public function SkillConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():SkillConfig
		{
			if( _instance == null )
			{
				_instance = new SkillConfig();
			}
			return _instance;
		}
		
		
		private function writeForPlayer( dic:Object ):void
		{
			var info:TSkill;
			for each( var o:Object in dic  )
			{
				info = new TSkill();
				ClassTypesUtil.copyValue(info, o);
				if(info.skillDescription)
				{
					var descId:int = int(info.skillDescription);
					if(descId > 0)
					{
						info.skillDescription = DescConfig.instance.getDescAlyzObj( descId,o);
					}
				}
				_map[ info.skillId ] = info;
				// 每个技能组的第一个技能
				if(_serialDic[info.series] == null && info.skillLevel == 1)
				{
					_serialDic[info.series] = info;
				}
				
				if(_serialSkills[info.series] == null)
				{
					_serialSkills[info.series] = [];
				}
				_serialSkills[info.series][info.skillLevel] = info;
			}
		}
		
		private function writeForBoss( dic:Object ):void
		{
			var info:TSkill;
			for each( var o:Object in dic  )
			{
				info = new TSkill();
				ClassTypesUtil.copyValue(info, o);
				if(info.skillDescription)
				{
					var descId:int = int(info.skillDescription);
					if(descId > 0)
					{
						info.skillDescription = DescConfig.instance.getDescAlyzObj( descId,o);
					}
				}
				_map[ info.skillId ] = info;
			}
		}
		
		private function writeForRune(dic:Object):void
		{
			var info:TRune;
			for each( var o:Object in dic  )
			{
				info = new TRune();
				ClassTypesUtil.copyValue(info, o);
				
				_rune[info.runeId] = info;
			}
		}
		
		public function init():void
		{
			var object:Object;
			object = ConfigManager.instance.getJSONByFileName("t_skill.json");
			writeForPlayer( object );
			object = ConfigManager.instance.getJSONByFileName("t_skill_boss.json");
			writeForBoss( object );
			object = ConfigManager.instance.getJSONByFileName("t_rune.json");
			writeForRune(object);
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getInfoByName( skillId:int ):TSkill
		{
			return _map[skillId];
		}
		
		public function getRune(runeId:int):TRune
		{
			return _rune[runeId] as TRune;
		}
		
		public function getRunesBySerial(skillSerialId:int, runeLevel:int=-1):Array
		{
			var res:Array = [];
			for each(var info:TRune in _rune)
			{
				if(info.skillBelong == skillSerialId)
				{
					if(runeLevel == -1)
					{
						res.push(info);
					}
					else if(runeLevel == info.level)
					{
						res.push(info);
					}
				}
			}
			return res;
		}
		
		/**
		 * 更加物品code获取对应的符文， 可以是绑定的code，也可以是非绑定的code 
		 * @param itemCode
		 * @return 
		 * 
		 */		
		public function getRuneByItemCode(itemCode:int):TRune
		{
			for each(var info:TRune in _rune)
			{
				if(info.item == itemCode)
				{
					return info;
				}
			}
			return null;
		}
		
		public function getNextLevelRune(runeId:int):TRune
		{
			var old:TRune = _rune[runeId];
			if(old == null)
			{
				return null;
			}
			for each(var info:TRune in _rune)
			{
				if(info.skillBelong == old.skillBelong)
				{
					if(info.runePos == old.runePos)
					{
						if(info.level == old.level + 1)
						{
							return info;
						}
					}
				}
			}
			return null;
		}
		
		public function getSkillsDic():Dictionary
		{
			return _map;
		}
		
		/**
		 * 获取技能（根据serial、level） 
		 * @param serialId
		 * @param level
		 * @return 
		 * 
		 */		
		public function getSkillByLevel(serialId:int, level:int):TSkill
		{
			var arr:Array = _serialSkills[serialId];
			if(arr == null)
			{
				return null;
			}
			return arr[level];
		}
		
		/**
		 * 根据不同职业获取所有技能组
		 * @param career
		 * @return 
		 * 
		 */		
		public function getPlayerSkillSerials(career:int):Array
		{
			var res:Array = [];
			for(var key:String in _serialDic)
			{
				if(_serialDic[key].career == career)
				{
					res.push(int(key));
				}
			}
			return res;
		}
		
		/**
		 * 根据技能组ID， 获取第一个技能 
		 * @param serialId
		 * @return 
		 * 
		 */		
		public function getFirstSkillBySerialId(serialId:int):TSkill
		{
			return _serialDic[serialId] as TSkill;
		}
		
		/**
		 * 获取一个技能系列的最高等级 
		 * @param serialId
		 * @return 
		 * 
		 */		
		public function getMaxLevelBySerialId(serialId:int):int
		{
			var arr:Array = _serialSkills[serialId];
			if(arr == null)
			{
				return 1;
			}
			var res:int = 1;
			for each(var info:TSkill in arr)
			{
				if(info.skillLevel > res)
				{
					res = info.skillLevel;
				}
			}
			return res;
		}
	}
}