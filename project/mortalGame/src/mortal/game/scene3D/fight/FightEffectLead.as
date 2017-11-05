/**
 * 引导技能自身特效
 * @heartspeak
 * 2014-4-2 
 */   	

package mortal.game.scene3D.fight
{
	import Message.DB.Tables.TSkillModel;
	
	import com.gengine.utils.MathUitl;
	
	import mortal.game.resource.tableConfig.SkillModelConfig;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.view.systemSetting.SystemSetting;

	public class FightEffectLead extends FightEffectBase
	{
		protected var skillModel:TSkillModel;
		protected var effectPlayer:EffectPlayer;
		
		public function FightEffectLead()
		{
			super();
		}
		
		override public function runStart():void
		{
			maxTime = 12000;
			super.runStart();
			//技能施法方不存在 直接结束
			if(!_fromPlayer)
			{
				runFinish();
				return;
			}
			//朝向
			if(_targetPoint)
			{
				_fromPlayer.direction = MathUitl.getAngleByXY(_fromPlayer.x2d,_fromPlayer.y2d,_targetPoint.x,_targetPoint.y);
			}
			else if(_targetPlayer && _targetPlayer != _fromPlayer)
			{
				_fromPlayer.direction = MathUitl.getAngleByXY(_fromPlayer.x2d,_fromPlayer.y2d,_targetPlayer.x2d,_targetPlayer.y2d);
			}
			//技能模型配置
			skillModel = SkillModelConfig.instance.getInfoById(_skill.skillModel);
			if(!skillModel)
			{
				runFinish();
				return;
			}
			//播放攻击动作
			if(skillModel.action && ActionType.isLeadStartAction(skillModel.action))
			{
				_fromPlayer.addEventListener(PlayerEvent.PLAYER_LEADING, leadingHandler);
				_fromPlayer.addEventListener(PlayerEvent.PLAYER_LEADING_END, leadingEndHandler);
				_fromPlayer.setAction(ActionType.leadStart,skillModel.action);
				if(_fromPlayer.actionName != skillModel.action)
				{
					_fromPlayer.removeEventListener(PlayerEvent.PLAYER_LEADING, leadingHandler);
					_fromPlayer.removeEventListener(PlayerEvent.PLAYER_LEADING_END, leadingEndHandler);
					runFinish();
				}
			}
			//旋风斩
			else if(skillModel.leadAction == ActionName.Tornado)
			{
				//直接播放持续动作
				_fromPlayer.setAction(ActionType.leading,skillModel.leadAction);
				_fromPlayer.addEventListener(PlayerEvent.PLAYER_LEADING_END, leadingEndHandler);
				leadingHandler(null);
			}
			else
			{
				runFinish();
			}
		}
		
		/**
		 * 引导特效开始 
		 * @param e
		 * 
		 */
		protected function leadingHandler(e:PlayerEvent):void
		{
			if(SystemSetting.instance.isHideAllEffect.bValue)
			{
				return;
			}
			if (skillModel.selfModel)
			{
				effectPlayer = SkillEffectUtil.addPlayerEffect(_fromPlayer,skillModel.selfModel,null,true);
			}
		}
		
		/**
		 * 引导结束 
		 * @param e
		 * 
		 */
		protected function leadingEndHandler(e:PlayerEvent):void
		{
			runFinish();
		}
		
		/**
		 * 移除监听 
		 * 
		 */
		protected function removeListeners():void
		{
			_fromPlayer.removeEventListener(PlayerEvent.PLAYER_LEADING, leadingHandler);
			_fromPlayer.removeEventListener(PlayerEvent.PLAYER_LEADING_END, leadingEndHandler);
		}
		
		override public function runFinish():void
		{
			if(effectPlayer)
			{
				effectPlayer.dispose();
				effectPlayer = null;
			}
			removeListeners();
			super.runFinish();
			skillModel = null;
		}
	}
}