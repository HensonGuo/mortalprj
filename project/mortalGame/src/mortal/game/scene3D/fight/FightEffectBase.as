/**
 * @heartspeak
 * 战斗特效表现基础类
 * 2014-4-1 
 */   	

package mortal.game.scene3D.fight
{
	import Message.DB.Tables.TSkill;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.manager.ClockManager;
	import mortal.game.scene3D.player.entity.SpritePlayer;

	public class FightEffectBase
	{
		//最大持续时间，如果超过这个时间还没播放回调自动销毁
		protected var maxTime:int = 4000;
		private var _disposeDate:Date;
		
		protected var _attackId:int;
		protected var _fromPlayer:SpritePlayer;
		protected var _targetPlayer:SpritePlayer;
		protected var _hitPlayers:Vector.<SpritePlayer>;
		protected var _targetPoint:Point;
		protected var _skill:TSkill;
		protected var _callBack:Function;
		
		public function FightEffectBase()
		{
		}
		
		public function setCallBack(callBack:Function):void
		{
			_callBack = callBack;
		}
		
		/**
		 * 设置攻击编号 
		 * @param attackId
		 * 
		 */		
		public function setAttackId(attackId:int):void
		{
			_attackId = attackId;
		}
		
		/**
		 * 设置技能 
		 * @param skill
		 * 
		 */
		public function setSkill(skill:TSkill):void
		{
			_skill = skill;
		}
		
		/**
		 * 设置攻击方 
		 * @param fromPlayer
		 * 
		 */		
		public function setFromPlayer(fromPlayer:SpritePlayer):void
		{
			_fromPlayer = fromPlayer;
		}
		
		/**
		 * 设置目标点 
		 * @param targetPoint
		 * 
		 */		
		public function setTargetPoint(targetPoint:Point):void
		{
			_targetPoint = targetPoint;
		}
		
		/**
		 * 设置目标对象 
		 * @param targetPlayer
		 * 
		 */
		public function setTargetPlayer(targetPlayer:SpritePlayer):void
		{
			_targetPlayer = targetPlayer;
		}
		
		/**
		 * 设置受击方 
		 * @param hitPlayers
		 * 
		 */		
		public function setHitPlayers(hitPlayers:Vector.<SpritePlayer>):void
		{
			_hitPlayers = hitPlayers;
		}
		
		/**
		 * 开始执行 
		 * 
		 */
		public function runStart():void
		{
			_disposeDate = ClockManager.instance.getDelayDate(maxTime);
			ClockManager.instance.addDateCall(_disposeDate,runFinish);
		}
		
		/**
		 * 执行完毕 
		 * 
		 */
		public function runFinish():void
		{
			if(_disposeDate)
			{
				ClockManager.instance.removeDateCall(_disposeDate);
			}
			if(_callBack != null)
			{
				_callBack.call(null,_attackId);
			}
			dispose();
		}
		
		public function dispose():void
		{
			_disposeDate = null;
			_attackId = 0;
			_fromPlayer = null;
			_hitPlayers = null;
			_hitPlayers = null;
			_targetPoint = null;
			_skill = null;
			_callBack = null;
			ObjectPool.disposeObject(this);
		}
	}
}