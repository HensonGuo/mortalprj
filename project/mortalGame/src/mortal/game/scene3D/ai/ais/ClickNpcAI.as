/**
 * 2013-12-19
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import com.mui.controls.Alert;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.view.npc.NpcTaskDialogModule;
	import mortal.mvc.core.Dispatcher;
	
	public class ClickNpcAI extends AICommand
	{
		public function ClickNpcAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			ThingUtil.selectEntity = ThingUtil.npcUtil.getNpc(int(data.params));
			Dispatcher.dispatchEvent(new DataEvent(EventName.NPC_ClickedHandler, ThingUtil.selectEntity));
			stop();
		}
	}
}