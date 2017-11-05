/**
 * 2013-12-25
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import Message.Public.SPoint;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mortal.game.Game;
	import mortal.game.mvc.GameProxy;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.util.JumpUtil;
	
	public class JumpAI extends AICommand
	{
		public function JumpAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			
			// 调用命令
			var p:SPoint = new SPoint();
			p.x = Point(data.target).x * Game.mapInfo.pieceWidth;
			p.y = Point(data.target).y * Game.mapInfo.pieceHeight;
			
			data.meRole.addEventListener(PlayerEvent.JumpPointEnd, jumpEndHandler);
			GameProxy.sceneProxy.jumpPoint(p);
		}
		
		private function jumpEndHandler(evt:PlayerEvent):void
		{
			data.meRole.removeEventListener(PlayerEvent.JumpPointEnd, jumpEndHandler);
			endAI();
		}
		
		public override function get stopable():Boolean
		{
			return false;
		}
	}
}