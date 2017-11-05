/**
 * 2014-1-20
 * @author chenriji
 **/
package mortal.game.view.systemSetting
{
	import com.gengine.utils.ObjectParser;
	import com.mui.serialization.json.JSON;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;
	import mortal.game.view.systemSetting.ClientSetting;

	public class ClientSettingInfo
	{
		private var _mapInfo:Dictionary = new Dictionary();
		public var isDirty:Boolean = false;
		
		public function ClientSettingInfo()
		{
			initMapInfo();
		}
		
		/**
		 * 所有的Boolean类型的设置放到这里 
		 */		
		public var isDoneList:Array = [];
		public var valueTest:Number = 0.5;
		/**
		 * 自动挂机列表中要保存的值， 例如生命低于30%自动释放加血技能， 那么这保存30， index为技能的posType 
		 */		
		public var AFAssistSkillValues:Array = [];
		
		private function initMapInfo():void
		{
			_mapInfo["isDoneList"] = "a";
			_mapInfo["valueTest"] = "b";
			_mapInfo["AFAssistSkillValues"] = "c";
		}
		
		/**
		 * 将数据系列化为string类型
		 * @return 
		 * 
		 */		
		public function getString():String
		{
			var attributeAry:Array = ObjectParser.getClassVars(this);
			var defaultSetter:ClientSettingInfo = ClientSetting.defualt;
			var obj:Object = new Object();
			var key:*;
			for each(key in attributeAry)
			{
				if(this[key] is Array)
				{
					obj[_mapInfo[key]] = [];
					ClassTypesUtil.copyValue(obj[_mapInfo[key]], this[key]);
				}
				else if(this[key] != defaultSetter[key])
				{
					obj[_mapInfo[key]] = this[key];
				}
				
				
			}
			return com.mui.serialization.json.JSON.serialize(obj);
		}
		
		public function toObject():Object
		{
			var obj:Object = new Object();
			var attributeAry:Array = ObjectParser.getClassVars(this);
			var key:*;
			for each(key in attributeAry)
			{
				if(this[key] is Array)
				{
					obj[key] = [];
					ClassTypesUtil.copyValue(obj[key], this[key]);
				}
				else
				{
					obj[key] = this[key];
				}
			}
			return obj;
		}
		
		/**
		 * 将服务器返回的string数据解析为object
		 * @param str
		 * @return 
		 * 
		 */		
		public function initFromServerStr(str:String):Object
		{
			if(str == "" || str == null)
			{
				return null;
			}
			var obj:Object = com.mui.serialization.json.JSON.deserialize(str);
			var attributeAry:Array = ObjectParser.getClassVars(this);
			var key:*;
			for each(key in attributeAry)
			{
				if(obj.hasOwnProperty(_mapInfo[key]))
				{
					if(obj[_mapInfo[key]] is Array)
					{
						this[key] = [];
						ClassTypesUtil.copyValue(this[key], obj[_mapInfo[key]]);
					}
					else
					{
						this[key] = obj[_mapInfo[key]];
					}
				}
			}
			return obj;
		}
		
		/**
		 * 数据赋值
		 * @param sysSetterInfo
		 * @param isSetGuideData
		 * 
		 */		
		public function copy(sysSetterInfo:ClientSettingInfo):void
		{
			var attributeAry:Array = ObjectParser.getClassVars(this);
			var copyAry:Array = [];
			var keyx:*;
			for each(keyx in attributeAry)
			{
				if(sysSetterInfo[keyx] is Array)//object类型的数据不能简单复制，会报错
				{
					this[keyx] = [];
					ClassTypesUtil.copyValue(this[keyx], sysSetterInfo[keyx]);
				}
				else
				{
					this[keyx] = sysSetterInfo[keyx];
				}
			}
		}
		
		/**
		 * 设置某个位置是否true， 这里用数组保存， 每个数值是int，包括32个boolean 
		 * @param isDoneType 参考枚举类：IsDoneType
		 * @param value
		 * 
		 */		
		public function setIsDone(value:Boolean, type:uint=0):void
		{
			var index:int = int(type/31);
			if(isDoneList.length <= index)
			{
				isDoneList[index] = 0x00000000;
			}
			var bitOrigin:int = isDoneList[index];
			var bitIndex:int = type - (31*index);
			var bitValue:int = value?1:0;
			isDoneList[index] = ClassTypesUtil.getSetBitValueResult(bitOrigin, bitIndex, bitValue);
			isDirty = true;
		}
		
		/**
		 * 获取某个设置是否已经设置过（值为true） 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getIsDone(type:uint=0):Boolean
		{
			var index:int = int(type/31);
			if(isDoneList.length <= index)
			{
				return false;
			}
			var bitIndex:int = type - (31*index);
			var bitOrigin:int = isDoneList[index];
			var bitValue:int = ClassTypesUtil.getBitValue(bitOrigin, bitIndex);
			return (bitValue == 1)?true:false;
		}
	}
}