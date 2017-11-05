/**
 * 2014-2-8
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import flash.utils.setTimeout;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.ai.data.AIData;
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.mvc.core.Dispatcher;
	
	public class FlyBootAI extends AICommand
	{
		public function FlyBootAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			
			data.meRole.stopWalking();
			var pt:SPassTo = data.params as SPassTo;
			GameProxy.sceneProxy.covey(pt); 
			
			Dispatcher.addEventListener(EventName.ChangeScene, flyEnd);
			Dispatcher.addEventListener(EventName.ChangePosition, flyEnd);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.AI_FlyBootCalled));
			
		}
		
		public override function stop():void
		{
			Dispatcher.removeEventListener(EventName.ChangeScene, flyEnd);
			Dispatcher.removeEventListener(EventName.ChangePosition, flyEnd);
			super.stop();
		}
		
		protected function flyEnd(evt:*=null):void
		{
			stop();
		}
	}
}