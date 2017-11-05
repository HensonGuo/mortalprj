/**
 * 2014-4-25
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 立马执行技能，在执行完毕后才结束本AI 
	 * @author hdkiller
	 * 
	 */	
	public class FightOnceAI extends AICommand
	{
		private var _timerId:int;
		
		public function FightOnceAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SkillAskServerUseSkill, _data));
			RolePlayer.instance.addEventListener(PlayerEvent.SkillPointEnd, skillEndHandler);
			_timerId = setTimeout(skillEndHandler, 4000);
		}
		
		private function skillEndHandler(evt:PlayerEvent=null):void
		{
			stop();
		}
		
		public override function stop():void
		{
			if(_timerId > 0)
			{
				clearTimeout(_timerId);
				_timerId = -1;
			}
			RolePlayer.instance.removeEventListener(PlayerEvent.SkillPointEnd, skillEndHandler);
			super.stop();
		}
		
	}
}