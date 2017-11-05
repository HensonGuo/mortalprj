package Engine.RMI
{
	import Framework.Util.Exception;
	
	import flash.events.Event;
	
	public class RMIEvent extends Event
	{
		public static const RMI_ERROR:String = "rmi_error";
		
		private var _error:Exception;
		
		public function RMIEvent(type:String, buttles:Boolean=false, cancelabel:Boolean=false, error:Exception=null)
		{
			super(type, buttles, cancelabel);
			_error = error;
		}
		
		public function get error():Exception
		{
			return _error;
		}
	}
}