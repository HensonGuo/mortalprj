/**
 * @date 2013-2-20 上午10:49:24
 * @author chenriji
 */
package mortal.game.resource
{
	import com.gengine.debug.Log;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.configBase.ConfigBase;
	
	public class ConfigCenter
	{
		private static var _map:Dictionary = new Dictionary();
		
		public function ConfigCenter()
		{
		}
		
		/**
		 * 获取configFileName对应的整个配置数据源
		 * @param configFileName
		 * @return 
		 * 
		 */		
		public static function getConfigBase(configFileName:String):ConfigBase
		{
			if(_map[configFileName] == null)
			{
				_map[configFileName] = new ConfigBase(configFileName);
			}
			return _map[configFileName] as ConfigBase;
		}
		
		
		public static function addMainCache(configFileName:String, mainKey:String):void
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null)
			{
				return;
			}
			config.addMainCache(mainKey);
		}
		
		public static function delMainCache(configFileName:String):void
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null)
			{
				return;
			}
			config.delMainKey();
		}
		
		public static function addCache(configFileName:String, attributeNames:Array):void
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null)
			{
				return;
			}
			config.addCache(attributeNames);
		}
		
		public static function delCache(configFileName:String, attributeNames:Array):void
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null)
			{
				return;
			}
			config.delCache(attributeNames);
		}
		
		public static function getConfigItemFromCache(configFileName:String, attributeNames:Array, values:Array):Object
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null)
			{
				return null;
			}
			return config.getConfigFromCache(attributeNames, values);
		}
		
		/**
		 * 获取配置项 
		 * @param configFileName 配置文件， 参考ConfigConst的配置
		 * @param value 主键的值
		 * @return Object对应ConfigConst中map对应的结构
		 * 
		 */		
		public static function getConfigItemFromMain(configFileName:String, value:Object):Object
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null)
			{
				return null;
			}
			return config.getConfigFromMainCache(value);
		}
		
		/**
		 * 获取主键为value的配置项中， 属性名字为 targetAttributName 的值
		 * @param configFileName 配置文件， 参考ConfigConst的配置
		 * @param value 主键的值
		 * @param targetAttributName 目标属性的名字
		 * @return 
		 * 
		 */		
		public static function getConfigValueFromMain(configFileName:String, value:Object, targetAttributName:String):Object
		{
			var obj:Object = getConfigItemFromMain(configFileName, value);
			if(obj == null)
			{
				return null;
			}
			return obj[targetAttributName];
		}
		
		/**
		 * 查找配置,  确保配置了ConfigConst.map， 使用请参考类ConfigCenterDemo
		 * @param configFileName 如"t_boss.json",  建议在ConfigConst中配置，例如：ConfigConst.TLevelSeal
		 * @param attributeNames 属性名字， 如："code"或者["code", "level"], 代码是这样判断的(boss.code == 1100001 && boss.level == 1)
		 * @param values 查找匹配的值，如：1100001或者[1100001, 1]， 代码是这样判断的(boss.code == 1100001 && boss.level == 1)
		 * @param isGetOnlyOne true返回的是单一实例，false返回数组(此数组包含所有匹配的结果)
		 * @param customData 可以传入自己的数据源， 只从此数据源查找
		 * @return 数组或者Object， 根据isGetOnlyOne而定
		 * 
		 */		
		public static function getConfigs(configFileName:String, attributeNames:*, values:*, 
												   isGetOnlyOne:Boolean=false, customData:Dictionary=null):*
		{
			var config:ConfigBase = getConfigBase(configFileName);
			if(config == null && customData == null)
			{
				return [];
			}
			var attrArr:Array;
			var valueArr:Array;
			if(attributeNames is Array)
			{
				attrArr = attributeNames;
			}
			else
			{
				attrArr = [attributeNames];
			}
			if(values is Array)
			{
				valueArr = values;
			}
			else
			{
				valueArr = [values];
			}
			
			var arr:Array = config.getConfigs(attrArr, valueArr, customData);
			if(isGetOnlyOne)
			{
				return arr[0];
			}
			return arr;
		}
		
		/**
		 * 联合双表获取数据
		 * @param struct1 数据源1
		 * @param struct2 数据源2
		 * @param unionKeys1 与数据源2中对应的值相等的key集合
		 * @param unionKeys2 与数据源1中的值相等的key集合
		 * @param struct1Keys 从数据源1中筛选的key集合
		 * @param struct1Value2 数据源1中筛选符合的值集合
		 * @param struct2Keys 从数据源2中筛选的key集合
		 * @param struect2Values 数据源2中筛选符合的值集合
		 * @return 索引0对应的数据源1的筛选后结果，索引1对应数据源2筛选后的结果
		 * 
		 */		
		public static function getUnionConfigs(configFileName1:String, configFileName2:String, 
											   unionKeys1:Array, unionKeys2:Array,
											   struct1Keys:Array=null, struct1Values:Array=null, 
											   struct2Keys:Array=null, struct2Values:Array=null):Array
		{
			var data1:Array = getConfigs(configFileName1, struct1Keys, struct1Values);
			var data2:Array = getConfigs(configFileName2, struct2Keys, struct2Values);
			var res:Array = [];
			var res1:Array = [];
			var res2:Array = [];
			if(unionKeys1 == null || unionKeys1.length == 0
			 || unionKeys2 == null || unionKeys2.length == 0
			 || data1.length == 0 || data2.length == 0)
			{
				res.push(res1);
				res.push(res2);
				return res;
			}
			if(unionKeys1.length != unionKeys2.length)
			{
				Log.debug("ConfigCenter.getUnionConfigs 参数unionKeys1、unionKeys2的长度不一致");
			}
			var dic1:Dictionary = getHashDictionary(data1, unionKeys1);
			var dic2:Dictionary = getHashDictionary(data2, unionKeys2);
			
			for(var key:String in dic1)
			{
				var arr1:Array = dic1[key];
				var arr2:Array = dic2[key];
				if(arr2 == null || arr1.length == 0)
				{
					continue;
				}
				for(var i:int = 0; i < arr1.length; i++)
				{
					for(var j:int = 0; j < arr2.length; j++)
					{
						for(var k:int = 0; k < unionKeys1.length; k++)
						{
							var key1:* = unionKeys1[k];
							var key2:* = unionKeys2[k];
							var data1x:Object = data1[i];
							var data2x:Object = data2[j];
							if(data1x[key1] != data2x[key2])
							{
								break;
							}
							if(k == unionKeys1.length - 1) // 全部key对应的值都匹配，got it记录数据
							{
								res1.push(data1x);
								res2.push(data2x);
								
								arr1.splice(i);
								i--;
								arr2.splice(j);
								j--;
							}
						}
					}
				}
			}
			
			res.push(res1);
			res.push(res2);
			return res;
		}
		
		/**
		 * 获取配置的hash表 
		 * @param data
		 * @param keys
		 * @return 
		 * 
		 */		
		private static function getHashDictionary(data:Array, keys:Array):Dictionary
		{
			var res:Dictionary = new Dictionary();
			for each(var obj:Object in data)
			{
				var value:String = "";
				for(var i:int = 0; i < keys.length; i++)
				{
					// 因为配置文件中填写的都是基本类型，可以用此来区别
					value += obj[keys[i]].toString();
				}
				if(res[value] == null)
				{
					res[value] = [];
				};
				(res[value] as Array).push(obj);
			}
			return res;
		}
	}
}