package mortal.game.net.broadCast
{
	import Framework.MQ.MessageBlock;
	
	import com.gengine.core.call.Caller;
	
	public class BroadCastManager
	{
		private var _caller:Caller = new Caller();
		
		private static var _instance:BroadCastManager;
		
		public function BroadCastManager()
		{
//			if( _instance != null )
//			{
//				throw new Error("BroadCastManager 单例");
//			}
		}
		
		public static function get instance():BroadCastManager
		{
			if( _instance == null )
			{
				_instance = new BroadCastManager();
			}
			return _instance;
		}
		
		public function call( type:Object ,mb:MessageBlock ):void
		{
			_caller.call(type,mb);
		}
		
		public function registerCall( call:BroadCastCall ):void
		{
			_caller.addCall(call.type,call.call);
		}
		
		public function removeCall( call:BroadCastCall ):void
		{
			_caller.removeCall(call.type,call.call);
		}
	}
}