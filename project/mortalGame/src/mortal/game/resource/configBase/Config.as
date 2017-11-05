/**
 * 2014-1-2
 * @author chenriji
 **/
package mortal.game.resource.configBase
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class Config
	{
		/**
		 * 数据
		 */
		protected var _data:Dictionary;
		/**
		 * 配置表的名字 
		 */		
		protected var _configName:String = "t_item.json";
		/**
		 * 对应的解析结构 
		 */		
		protected var _cls:Class;
		
		public function Config()
		{
			
		}
		
		/**
		 *  
		 * @param cls 解析结果对应的结构
		 * @param configName 配置文件， 例如 "t_item.json"
		 * 
		 */
		protected function initConfig(cls:Class, configName:String):void
		{
			_data = new Dictionary();
			var objs:Object =  ConfigManager.instance.getJSONByFileName(configName);
			for each(var obj:Object in objs)
			{
				var item:Object = new cls();
				ClassTypesUtil.copyValue(item, obj);
				_data[getKey(item)] = item;
			}
		}
		
		public function getConfigItem(value:Object):Object
		{
			return _data[value.toString()];
		}
		
		/**
		 * 保存到Dictiona的key， 不重写的话是随机的 
		 * @return 
		 * 
		 */		
		protected function getKey(obj:Object):Object
		{
			return "ConfigBaseKey_" + int(Math.random() * 100000).toString();
		}
		
		/**
		 * 根据key数组、value数组， 获取相应的配置 
		 * @param keys
		 * @param values
		 * @return 
		 * 
		 */		
		public function getConfigByKeys(keys:Array, values:Array, customData:Dictionary=null):Array
		{
			var curData:Dictionary = _data;
			if(customData != null)
			{
				curData = customData;
			}
			var res:Array = [];
			if(keys == null || keys.length == 0)
			{
				return res;
			}
			if(curData == null)
			{
				return res;
			}
			for each(var obj:Object in curData)
			{
				for(var i:int = 0; i < keys.length; i++)
				{
					var key:String = keys[i] as String;
					if(obj[key] != values[i])
					{
						break;
					}
					if(i == keys.length - 1)
					{
						res.push(obj);
					}
				}
			}
			return res;
		}
	}
	
}