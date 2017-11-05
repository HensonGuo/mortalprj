/**
 * 2014-3-19
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import Message.Command.EPublicCommand;
	
	import flash.utils.setTimeout;
	
	import mortal.game.mvc.GameProxy;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.view.skillProgress.SkillProgressView;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class CollectAI extends AICommand
	{
		private var _monster:MonsterPlayer;
		private var _timerId:int;
		
		public function CollectAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			
			_monster = data.target as MonsterPlayer;
			if(_monster == null)
			{
				stop();
				return;
			}
			
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicCollectBegin, collectBeginHandler);
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicCollectEnd, collectEndHandler);
			
			GameProxy.sceneProxy.collect(_monster.entityInfo.entityInfo.entityId, true);
//			_timerId = setTimeout(_monster.entityInfo.entityInfo.mana*1000);
		}
		
		public override function stop():void
		{
			super.stop();
			NetDispatcher.removeCmdListener(EPublicCommand._ECmdPublicCollectBegin, collectBeginHandler);
			NetDispatcher.removeCmdListener(EPublicCommand._ECmdPublicCollectEnd, collectEndHandler);
		}
		
		private function collectBeginHandler(obj:Object):void
		{
			SkillProgressView.instance.startByTotalTime(_monster.entityInfo.entityInfo.mana*1000, collectEnd);
		}
		
		private function collectEnd():void
		{
			GameProxy.sceneProxy.collect(_monster.entityInfo.entityInfo.entityId, false);
		}
		
		private function collectEndHandler(obj:Object):void
		{
			SkillProgressView.instance.updateCount(null, -1);
		}
	}
}