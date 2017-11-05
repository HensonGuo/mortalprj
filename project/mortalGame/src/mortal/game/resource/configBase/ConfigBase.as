/**
 * @date 2013-2-20 上午10:55:42
 * @author chenriji
 */
package mortal.game.resource.configBase
{
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import mortal.game.view.common.ClassTypesUtil;
	
	public class ConfigBase
	{
		/**
		 * 数据
		 */
		protected var _data:Dictionary;
		
		/**
		 * 查找的缓存 
		 */		
		protected var _cache:Dictionary = new Dictionary();
		
		protected var _mainCache:Dictionary = new Dictionary();
		
		/**
		 *  
		 * @param fileName 配置文件全名, 如："t_cross_defense_upgrade.json"
		 * @param struct 对应的数据结构，如：TCrossDefenseUpgrade
		 * 
		 */		
		public function ConfigBase(configFileName:String)
		{
			initConfig(configFileName);
		}
		
		/**
		 * 初始化配置文件，不重写的话配置为空
		 * 
		 */		
		protected function initConfig(configFileName:String):void
		{
			var classNames:String = ConfigConst.map[configFileName];
			if(classNames == null || classNames == "")
			{
				Log.debug("在ConfigConst.map中找不到：" + configFileName + "的配置");
			}
			var arr:Array = classNames.split(";");
			var className:String = arr[0];
			var cls:Class = getDefinitionByName(className) as Class;//Global.stage.loaderInfo.applicationDomain.getDefinition(className) as Class;
			if(cls == null)
			{
				Log.debug("找不到类名定义：" + className);
			}
			_data = new Dictionary();
			
			var objs:Object = ConfigManager.instance.getJSONByFileName(configFileName);
			if(objs == null)
			{
				Log.debug("ConfigFiles: 加载不到配置文件:" + configFileName);
				return;
			}
			var index:int = 0;
			for each(var obj:Object in objs)
			{
				var info:Object  = new cls();
				ClassTypesUtil.copyValue(info, obj);
				_data[index++] = info;
			}
			
			if(arr.length >= 2)
			{
				addMainCache(String(arr[1]));
			}
		}
		
		private function cobine():void
		{
			var detial2:TAchievementDetial2;
		}
		
		public function get data():Dictionary
		{
			return _data;
		}
		
		/**
		 * 添加主键 ， 支持多个字段做主键
		 * @param key, 例如"name"或者"name_level"
		 * 
		 */		
		public function addMainCache(key:String):void
		{
			if(key == null || key == "")
			{
				return;
			}
			var arr:Array = key.split("_");
			for each(var obj:Object in _data)
			{
				key = obj[arr[0]].toString();
				for(var i:int = 1; i < arr.length; i++)
				{
					var atrributeName:String = arr[i] as String;
					key += "_" + obj[atrributeName].toString();
				}
				_mainCache[key] = obj;
			}
			
		}
		
		/**
		 * 删除主键 
		 * 
		 */		
		public function delMainKey():void
		{
			_mainCache = null;
		}
		
		/**
		 * 从关键缓存中获取配置项 
		 * @param value
		 * @return 
		 * 
		 */		
		public function getConfigFromMainCache(value:Object):Object
		{
			return _mainCache[value.toString()];
		}
		
		/**
		 * 添加缓存 
		 * @param attributeNames
		 * @param customData
		 * 
		 */		
		public function addCache(attributeNames:Array, customData:Dictionary=null):void
		{
			if(attributeNames == null || attributeNames.length == 0)
			{
				return;
			}
			var key:String = getKey(attributeNames);
			if(_cache[key] != null)
			{
				return;
			}
			
			var curData:Dictionary = _data;
			if(customData != null)
			{
				curData = customData;
			}
			
			var dic:Dictionary = new Dictionary();
			_cache[key] = dic;
			
			for each(var obj:Object in curData)
			{
				key = obj[attributeNames[0]].toString();
				for(var i:int = 1; i < attributeNames.length; i++)
				{
					var atrributeName:String = attributeNames[i] as String;
					key += "_" + obj[atrributeName].toString();
				}
				dic[key] = obj;
			}
		}
		
		/**
		 * 删除缓存 
		 * @param attributeNames
		 * 
		 */		
		public function delCache(attributeNames:Array):void
		{
			if(attributeNames == null || attributeNames.length == 0)
			{
				return;
			}
			var key:String = getKey(attributeNames);
			if(_cache[key] != null)
			{
				delete _cache[key];
			}
		}
		
		private function getKey(keys:Array):String
		{
			var key:String = "";
			for(var i:int = 0; i < keys.length; i++)
			{
				key += keys[i].toString();
			}
			return key;
		}
		
		/**
		 * 从缓存中获取数据（批量数据的时候，这个很有用，必须先addCache, 用完之后想释放内存可以delCache） 
		 * @param attributeNames
		 * @param values
		 * @return 
		 * 
		 */		
		public function getConfigFromCache(attributeNames:Array, values:Array):Object
		{
			if(attributeNames == null || attributeNames.length == 0 || values == null || values.length == 0)
			{
				return null;
			}
			var key:String = getKey(attributeNames);
			var dic:Dictionary = _cache[key];
			if(dic == null)
			{
				return null;
			}
			return dic[getKey(values)];
			
		}
		
		/**
		 * 根据key数组、value数组， 获取相应的配置 
		 * @param keys null或者长度为0的时候，返回所有数值
		 * @param values
		 * @return 
		 * 
		 */		
		public function getConfigs(attributeNames:Array, values:Array, customData:Dictionary=null):Array
		{
			var curData:Dictionary = _data;
			if(customData != null)
			{
				curData = customData;
			}
			var res:Array = [];
			if(curData == null)
			{
				return res;
			}
			
			if(attributeNames == null || attributeNames.length == 0)
			{
				return dicToArray(curData);
			}
			
			if(attributeNames == null || attributeNames.length == 0 || values == null || values.length == 0)
			{
				return dicToArray(curData);
			}
			
			for each(var obj:Object in curData)
			{
				for(var i:int = 0; i < attributeNames.length; i++)
				{
					var atrributeName:String = attributeNames[i] as String;
					if(obj[atrributeName] != values[i])
					{
						break;
					}
					if(i == attributeNames.length - 1)
					{
						res.push(obj);
					}
				}
			}
			return res;
		}
		
		private function dicToArray(dic:Dictionary):Array
		{
			var res:Array = [];
			if(dic == null)
			{
				return res;
			}
			for each(var obj:* in dic)
			{
				res.push(obj);
			}
			return res;
		}
	}
}