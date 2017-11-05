package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.DataInfo;

	public class EffectInfo extends DataInfo
	{
		protected var _obj:Object;
		protected var _isUncompress:Boolean = false;
		public function EffectInfo(object:Object)
		{
			super(object);
		}

		override public function set data(value:Object):void
		{
			super.data = value;
			if (!byteArray || _isUncompress)
			{
				return;
			}
			byteArray.position = 0;
			byteArray.uncompress();
			_obj = byteArray.readObject();
			_isUncompress = true;
			
		}
		public function get obj():Object
		{
			return _obj;
		}
		
		override public function clearCacheBytes():void
		{
			super.clearCacheBytes();
			_obj = null;
			_isUncompress = false;
		}
	}
}