/**
 * @heartspeak
 * 2014-2-15 
 */   	

package mortal.game.scene3D.player.info
{
	import flash.events.Event;

	public class EntityInfoEvent extends Event
	{
		public function EntityInfoEvent(type:String,bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type,bubbles,cancelable)
		}
	}
}