/**
 * @heartspeak
 * 2014-4-26 
 */   	

package mortal.game.view.systemSetting.data
{
	public class SettingItem
	{
		
		public static const BOOLEAN:int = 0;//boolean
		public static const INT:int = 1;//int
		public static const SELECT:int = 2;//选择项
		
		//描述
		private var _desStr:String;
		//保存到数据库的key		
		private var _key:String;
		//类型
		private var _valueType:int = 0;
		//数值
		private var _value:int = 0;
		//默认数值
		private var _defaultValue:int = 0;
		//显示数值
		private var _displayValue:int = 0;
		//扩展数据  用于特殊类型 INT、SELECT 的显示
		private var _extend:Object;
		
		public function SettingItem(desStr:String,key:String,defaultValue:int = 0,valueType:int = 0,extend:Object = null)
		{
			_desStr = desStr;
			_key = key;
			_valueType = valueType;
			_defaultValue = defaultValue;
			_value = defaultValue;
			_displayValue = defaultValue;
			_extend = extend;
		}
		
		public function get extend():Object
		{
			return _extend;
		}

		public function get valueType():int
		{
			return _valueType;
		}

		public function get key():String
		{
			return _key;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value($value:int):void
		{
			_value = $value;
			_displayValue = $value;
		}
		
		public function get bValue():Boolean
		{
			return Boolean(_value);
		}

		public function get displayValue():int
		{
			return _displayValue;
		}

		public function set displayValue(value:int):void
		{
			_displayValue = value;
		}
		
		/**
		 * 恢复默认 
		 * 
		 */		
		public function resetToDefault():void
		{
			_value = _defaultValue;
			_displayValue = _defaultValue;
		}
		
		/**
		 * 保存
		 * 
		 */		
		public function updateToServer():void
		{
			_value = _displayValue;
		}
		
		/**
		 * 恢复 
		 * 
		 */		
		public function recover():void
		{
			_displayValue = _value;
		}
		
		public function get desStr():String
		{
			return _desStr;
		}

	}
}