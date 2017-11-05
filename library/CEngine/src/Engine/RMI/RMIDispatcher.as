package Engine.RMI
{
	import Framework.Util.Exception;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="rmi_error",type="Engine.RMI.RMIEvent")]
	/**
	 * RMI 事件发送器 
	 * 主要处理 RMI错误事件处理等 
	 * @author jianglang
	 * 
	 */	
	public class RMIDispatcher extends EventDispatcher
	{
		private static var _instance:RMIDispatcher;		
		public function RMIDispatcher(block:ConstructorBlock)
		{
			if ( _instance != null ) 
			{
				throw new Error( "Only one RMIDispatcher instance should be instantiated" );   
			}
		}
		public static function getInstance() : RMIDispatcher 
		{
	       	if( _instance == null ) {
				_instance = new RMIDispatcher(new ConstructorBlock);
			}
			return _instance;
		}
		
		public function dispatchErrorEvent(ex:Exception):void
		{
			var evt:Event = new RMIEvent(RMIEvent.RMI_ERROR,false,false,ex);
			dispatchEvent(evt);
			
		}
	}
}
class ConstructorBlock {  }