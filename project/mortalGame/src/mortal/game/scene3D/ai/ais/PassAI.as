/**
 * 2014-2-11
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import Message.Game.EPassType;
	import Message.Public.SPassPoint;
	import Message.Public.SPassTo;
	
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 传送阵 
	 * @author chenriji
	 * 
	 */	
	public class PassAI extends AICommand
	{
		public function PassAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			var pt:SPassPoint = data.params as SPassPoint;
			var pp:SPassTo = pt.passTo[0] as SPassTo;
			if(pp == null || pp.toPoint == null) // 没配置代表着离开副本
			{
				GameProxy.copy.leaveCopy();
			}
			else
			{
				GameProxy.sceneProxy.pass(new EPassType(EPassType._EPassTypePassPoint), pt.passPointId, pp.passToId, pp.toPoint);
			}
			
			Dispatcher.addEventListener(EventName.MapSwitchToNewMap, mapSwitchedHandler);
		}
		
		private function mapSwitchedHandler(evt:DataEvent):void
		{
			stop();
		}
		
		public override function stop():void
		{
			super.stop();
			Dispatcher.removeEventListener(EventName.MapSwitchToNewMap, mapSwitchedHandler);
		}
	}
}