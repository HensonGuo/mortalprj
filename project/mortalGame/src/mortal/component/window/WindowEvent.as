/**
 * @date	2011-3-16 下午09:35:50
 * @author  jianglang
 * 
 */	

package mortal.component.window
{
	import flash.events.Event;

	public class WindowEvent extends Event
	{
		public static const CLOSE:String = "window_close";
		public static const SHOW:String = "window_show";
		
		public static const POSITIONCHANGE:String = "positionChange";
		
		//windowLayer派发
		public static const WINDOWLEVELCHANGE:String = "windowLevelChange";
		
		public function WindowEvent( type:String,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
	}
}
