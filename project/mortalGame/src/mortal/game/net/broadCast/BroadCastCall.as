package mortal.game.net.broadCast
{
	import Framework.MQ.MessageBlock;
	
	import mortal.game.cache.Cache;

	public class BroadCastCall
	{
		private var _type:Object;
		
		protected var _cache:Cache = Cache.instance;
		
		public function BroadCastCall( type:Object )
		{
			_type = type;
		}
		
		public function get type():Object
		{
			return _type;
		}

		public function call(  mb:MessageBlock ):void
		{
			
		}
	}
}