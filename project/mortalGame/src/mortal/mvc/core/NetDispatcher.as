package mortal.mvc.core
{
	import com.gengine.core.call.Caller;

	public class NetDispatcher
	{
		private static var command:Caller = new Caller();
		
		public function NetDispatcher()
		{
			
		}
		
		/**
		 * 加侦听
		 */
		public static function addCmdListener( type:Object, listener:Function ) : void 
		{
			command.addCall( type, listener);
		}
		
		/**
		 * 移除侦听
		 */
		public static function removeCmdListener( type:Object, listener:Function ) : void 
		{
			command.removeCall( type, listener );
		}
		
		/**
		 * 派发事件
		 */
		public static function dispatchCmd( type:Object,data:Object) : Boolean
		{
			return command.call( type , data );
		}
		
		/**
		 * 返回是否有这个侦听
		 */
		public static function hasCmdListener( type:Object ) : Boolean 
		{
			return command.hasCall(type);
		}
		
	}
}