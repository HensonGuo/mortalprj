/**
 
 * @date	2013-12-17 下午7:15:52
 
 *  @author  wuzhangliang
 *
 
 * 
 */	
package  com.gengine.utils
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;

	public class JsonMergerConst
	{
		public static const MergerFileName:String = "JsonMergerConfig.xml";
		
		private static var _instance:JsonMergerConst;
		
		public function JsonMergerConst()
		{
			if(_instance)
			{
				throw new Error("JsonFilterConst 单例");
			}
			readMergerConfig();
		}
		
		public static function get instance():JsonMergerConst
		{
			if(!_instance)
			{
				_instance = new JsonMergerConst();
			}
			return _instance;
		}
		
		private var mergerDic:Dictionary = new Dictionary();
		
		
		private function readMergerConfig():void
		{
			var  fileObj:Object = ConfigManager.instance.getObjectByFileName(MergerFileName);
			if(fileObj && fileObj["mergers"])
			{
				var data:* = fileObj["mergers"]["merger"];
				if(data is Array)
				{
					for each(var o:Object in data)
					{
						mergerDic[o["fileName"]] = getInfo(o);
					}
				}
				else if(data is Object)
				{
					mergerDic[data["fileName"]] = getInfo(data);
				}
			}
		}
		
		private function getInfo(o:Object):AttributeMergerInfo
		{
			return new AttributeMergerInfo(o["fileName"],o["keyCode"],o["mergerType"],o["jsonDifferentKeyName"]);
		}
		
		public function revertAttributes(name:String,content:Object):Object
		{
			for (var key:String in  _unBindObjDic)
			{
				delete _unBindObjDic[key];
			}
			
			var info:AttributeMergerInfo = mergerDic[name];
			if(info)
			{
				if(content is Array)
				{
					var newContent:Array = [];
					
					var o:Object;
					for each(o in content)
					{
						newContent.push(revertObjectImpl(name,info,o));
					}
					
					return newContent;
				}
				else if(content is Object)
				{
					return revertObjectImpl(name,info,content);
				}
			}
			return content;
		}
		
		// 未绑定的信息 
		private var _unBindObjDic:Dictionary = new Dictionary();
		
		private function 	revertObjectImpl(name:String,info:AttributeMergerInfo, obj:Object):Object
		{
			if(info.attrKeyCode =="")
			{
				return obj;
			}
			var resultObj:Object = obj;
			if(info.attrKeyCode!="")
			{
				var unBindCode:int = int(obj[info.attrKeyCode]);
				if(info.mergerType == MergerTypeConst.Type_Item)
				{
					//道具 装备绑定与非绑的规则
					unBindCode =int(unBindCode/10)*10;
				}
				else if(info.mergerType == MergerTypeConst.Type_Skill)
				{
					//技能存在1到100级的合并
					unBindCode =int(unBindCode/100)*100;
				}
				else
				{
					return obj;
				}
				var keyCodeStr:String=name+unBindCode.toString();
				if(_unBindObjDic[keyCodeStr])
				{
					var unneedAttrArr:Array;
					if(obj[info.jsonDifferentKeyName])//非绑有 绑定没有的属性  
					{
						unneedAttrArr = obj[info.jsonDifferentKeyName] as Array;
						delete resultObj[info.jsonDifferentKeyName];
					}
					var unBindObj:Object = 	_unBindObjDic[keyCodeStr];
					var key:String;
					for(key in unBindObj)
					{
						// 遍历被比较对象的key     比较对象没有的  并判断原本存在被比较对象有 但比较对象没有的key 
						if(!obj.hasOwnProperty(key) &&(!unneedAttrArr ||unneedAttrArr.indexOf(key)== -1))
						{
							resultObj[key] = unBindObj[key];
						}
					}
				}
				else
				{
					_unBindObjDic[keyCodeStr] = obj
					return obj;
				}
			}
			return resultObj;
		}
	}
}