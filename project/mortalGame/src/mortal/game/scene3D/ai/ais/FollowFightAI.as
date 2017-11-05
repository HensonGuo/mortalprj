/**
 * 2013-12-17
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.player.entity.MovePlayer;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 一直跟随着target， 并且释放技能直到target死亡为止 
	 * @author hdkiller
	 * 
	 */	
	public class FollowFightAI extends FollowAI
	{
		public function FollowFightAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			
			if(_isStoped)
			{
				// super已经检测符合条件
				skillFire();
				return;
			}
			
			if(_target != null)
			{
				MovePlayer(_target).addEventListener(PlayerEvent.ENTITY_DEAD, onPlayerDeadHandler, false, 0, true);
			}
			
			
			_meRole.addEventListener(PlayerEvent.ATTACK_GAP_TIMEOUT, onAttackGapTimeOut, false, 0, true);
			_meRole.addEventListener(PlayerEvent.ObstructNotFight,onObstructNotFightHandler);
			
//			Dispatcher.addEventListener(EventName.Skill_CoolDown_Finish,onSkillCoolDownFinish);
			
			Dispatcher.addEventListener(EventName.FightEntityNotOnLine,onFightEntityNotOnLine);
			Dispatcher.addEventListener(EventName.FightTargetIsTooFar,onFightTargetTooFar);
			Dispatcher.addEventListener(EventName.InputPointError,onInputPointError);
			
		}
		
		public override function stop():void
		{
			if(_target != null)
			{
				MovePlayer(_target).removeEventListener(PlayerEvent.ENTITY_DEAD, onPlayerDeadHandler, false);
			}
			_meRole.removeEventListener(PlayerEvent.ATTACK_GAP_TIMEOUT, onAttackGapTimeOut, false);
			_meRole.removeEventListener(PlayerEvent.ObstructNotFight, onObstructNotFightHandler);
			Dispatcher.removeEventListener(EventName.FightEntityNotOnLine, onFightEntityNotOnLine);
			Dispatcher.removeEventListener(EventName.FightTargetIsTooFar, onFightTargetTooFar);
			Dispatcher.removeEventListener(EventName.InputPointError, onInputPointError);
			
//			AIFactory.instance.inFollowFightAIData(_data as FollowFightAIData);
			
			super.stop();
			
		}
		
		protected override function onGirdWalkEnd(evt:PlayerEvent):void
		{
			super.onGirdWalkEnd(evt);
			if(isInRange())
			{
				skillFire();
				stop();
			}
		}
		
		protected override function onWalkEnd(evt:PlayerEvent):void
		{
			if(isInRange())
			{
				onGirdWalkEnd(null);
			}
			else
			{
				sceneMove(_targetPixPoint);
			}
		}
		
		private function onPlayerDeadHandler(evt:PlayerEvent):void
		{
			stop();
		}
		
		/**
		 * 攻击
		 */
		protected function skillFire():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SkillAskServerUseSkill, _data));
		}
		
		protected function onAttackGapTimeOut(evt:PlayerEvent):void
		{
//			if(!_meRole || _meRole.isTweening || SkillProgress.instance.isSkillRunning)
//			{
//				return;
//			}
		}
		
		protected function onSkillCoolDownFinish(event:DataEvent):void
		{
			if(isProcessing())
			{
				return;
			}
		}
		
		/**
		 * 地形阻挡不可以攻击 
		 * @param event
		 * 
		 */
		protected function onObstructNotFightHandler(event:PlayerEvent):void
		{
			if(isProcessing())
			{
				return;
			}
		}
		
		
		/**
		 * 目标不存在 
		 * @param event
		 * 
		 */
		protected function onFightEntityNotOnLine(event:DataEvent):void
		{
			if(isProcessing())
			{
				return;
			}
		}
		
		/**
		 * 距离太远不可攻击 
		 * @param event
		 * 
		 */
		protected function onFightTargetTooFar(event:DataEvent):void
		{
			if(isProcessing())
			{
				return;
			}
		}
		
		/**
		 * 输入坐标错误 
		 * @param event
		 * 
		 */
		protected function onInputPointError(event:DataEvent):void
		{
			if(isProcessing()) 
			{
				return;
			}
		}
		
		private function isProcessing():Boolean
		{
//			if(_meRole.isTweening || SkillProgress.instance.isSkillRunning)
//			{
//				return true;
//			}
			return false;
		}
	}
}