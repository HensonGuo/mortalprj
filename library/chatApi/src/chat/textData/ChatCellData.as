/**
 * @date 2011-3-14 下午12:01:08
 * @author  hexiaoming
 * 
 */ 
package chat.textData
{
	import com.gengine.core.IDispose;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.text.engine.ElementFormat;

	public class ChatCellData implements IDispose
	{
		public function ChatCellData()
		{
			
		}
		
		public function init(type:String = null,text:String = ""):void
		{
			_type = type;
			_text = text;
		}
		
		private var _type:String;
		private var _text:String;
		private var _clsName:String;
		private var _linkUrl:String;
		private var _uid:String;
	
		private var _data:Object;
		
		private var _elementFormat:ElementFormat;

		public function get elementFormat():ElementFormat
		{
			return _elementFormat;
		}

		public function set elementFormat(value:ElementFormat):void
		{
			_elementFormat = value;
		}


		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get className():String
		{
			return _clsName;
		}

		public function set className(value:String):void
		{
			_clsName = value;
		}

		public function get linkUrl():String
		{
			return _linkUrl;
		}

		public function set linkUrl(value:String):void
		{
			_linkUrl = value;
		}

		public function get uid():String
		{
			return _uid;
		}

		public function set uid(value:String):void
		{
			_uid = value;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_type = null;
			_text = "";
			_clsName = null;
			_linkUrl = null;
			_uid = null;
			_data = null;
			_elementFormat = null;
			ObjectPool.disposeObject(this);
		}
	}
}