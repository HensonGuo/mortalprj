package mortal.game.view.effect.type
{
	

	public class AttributeValue
	{
		//属性
		private var _attributeType:AttributeTextType;
		//增加 或者 减少
		private var _isAdd:Boolean = false;
		//值
		private var _value:int;
		
		public function AttributeValue(attributeType:AttributeTextType,isAdd:Boolean,value:int)
		{
			_attributeType = attributeType;
			_isAdd = isAdd;
			_value = value;
		}

		public function get attributeType():AttributeTextType
		{
			return _attributeType;
		}

		public function set attributeType(value:AttributeTextType):void
		{
			_attributeType = value;
		}

		public function get isAdd():Boolean
		{
			return _isAdd;
		}

		public function set isAdd(value:Boolean):void
		{
			_isAdd = value;
		}

		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			_value = value;
		}
	}
}