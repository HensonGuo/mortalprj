package mortal.game.view.pack
{
	import mortal.game.cache.Cache;
	import mortal.game.resource.info.item.ItemData;

	public class DragDropData
	{
		private var _fromPosType:int;
		private var _toPosType:int;
		private var _uid:String;
		private var _fromIndex:int;
		private var _toIndex:int;
		private var _fromItemData:ItemData;
		private var _toItemData:ItemData;
		
		public function DragDropData(fromPosType:int,toPosType:int,uid:String,fromIndex:int,toIndex:int,fromItemData:ItemData,toItemData:ItemData)
		{
			_fromPosType = fromPosType;
			_toPosType = toPosType;
			_uid = uid;
			_fromIndex = fromIndex;
			_toIndex = toIndex;
			_fromItemData = fromItemData;
			_toItemData = toItemData;
		}

		public function get toItemData():ItemData
		{
			return _toItemData;
		}

		public function set toItemData(value:ItemData):void
		{
			_toItemData = value;
		}

		public function get fromItemData():ItemData
		{
			return _fromItemData;
		}

		public function set fromItemData(value:ItemData):void
		{
			_fromItemData = value;
		}

		public function get toIndex():int
		{
			return _toIndex;
		}

		public function set toIndex(value:int):void
		{
			_toIndex = value;
		}

		public function get fromIndex():int
		{
			return _fromIndex;
		}

		public function set fromIndex(value:int):void
		{
			_fromIndex = value;
		}

		public function get uid():String
		{
			return _uid;
		}

		public function set uid(value:String):void
		{
			_uid = value;
		}

		public function get toPosType():int
		{
			return _toPosType;
		}

		public function set toPosType(value:int):void
		{
			_toPosType = value;
		}

		public function get fromPosType():int
		{
			return _fromPosType;
		}

		public function set fromPosType(value:int):void
		{
			_fromPosType = value;
		}
	}
}