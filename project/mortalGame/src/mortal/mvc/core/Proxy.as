package mortal.mvc.core
{
	import mortal.game.cache.Cache;
	import mortal.game.net.rmi.GameRMI;

	public class Proxy
	{
		protected var rmi:GameRMI = GameRMI.instance;
		protected var cache:Cache = Cache.instance;
		
		public function Proxy()
		{
			
		}
	}
}
