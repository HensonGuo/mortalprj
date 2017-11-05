package mortal.game.scene3D.events
{
	import flash.events.Event;
	
	public class RolePlayerEvent extends Event
	{
		/**
		 * 控制状态改变
		 * */
		public static const ControlStateChange:String="controlStateChange";
		
		public function RolePlayerEvent( type:String)
		{
			super(type,true,true);
		}
	}
}