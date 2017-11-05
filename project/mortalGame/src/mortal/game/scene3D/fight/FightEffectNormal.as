/**
 * 一般特效释放
 * @heartspeak
 * 2014-4-1 
 */   	

package mortal.game.scene3D.fight
{
	import Message.DB.Tables.TSkillModel;
	
	import com.gengine.utils.MathUitl;
	
	import mortal.game.resource.tableConfig.SkillModelConfig;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;

	public class FightEffectNormal extends FightEffectBase
	{
		protected var skillModel:TSkillModel;
		protected var direction:Number = 0;
		
		//疑问: 弹道是否100%会执行回调
		public function FightEffectNormal()
		{
			super();
		}
		
		override public function runStart():void
		{
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
				direction = MathUitl.getAngleByXY(_fromPlayer.x2d,_fromPlayer.y2d,_targetPoint.x,_targetPoint.y);
				_fromPlayer.direction = direction;
			}
			else if(_targetPlayer && _targetPlayer != _fromPlayer)
			{
				direction = MathUitl.getAngleByXY(_fromPlayer.x2d,_fromPlayer.y2d,_targetPlayer.x2d,_targetPlayer.y2d);
				_fromPlayer.direction = direction;
			}
			//技能模型配置
			skillModel = SkillModelConfig.instance.getInfoById(_skill.skillModel);
			if(!skillModel)
			{
				runFinish();
				return;
			}
			//播放攻击动作
			if(skillModel.action)
			{
				_fromPlayer.attack(skillModel.action);
				//播放刀光特效
				if(skillModel.daoguangModel)
				{
					SkillEffectUtil.addPlayerEffect(_fromPlayer,skillModel.daoguangModel,null,false,true);
				}
				//播放自身特效
				if (skillModel.selfModel)
				{
					SkillEffectUtil.addPlayerEffect(_fromPlayer,skillModel.selfModel);
				}
				var isTrack:Boolean = false;
				//是否配有弹道 
				if(skillModel.trackModel)
				{
					isTrack = true;
					trackHandler();
				}
				else
				{
					//有攻击动作  到达攻击帧执行特效
					if(ActionType.isAttackAction(_fromPlayer.actionName))
					{
						_fromPlayer.addEventListener(PlayerEvent.PLAYER_FIRE, reachTargetHandler);
					}
					else
					{
						reachTargetHandler();
					}
				}
			}
		}
		
		/**
		 * 播放弹道 
		 * 
		 */
		protected function trackHandler():void
		{
			//散射 多弹道
			if(skillModel.isMultiple)
			{
				for each(var hitPlayer:SpritePlayer in _hitPlayers)
				{
					track(_fromPlayer,hitPlayer,skillModel.trackModel,reachTargetHandler);
				}
			}
			//单个弹道
			else
			{
				track(_fromPlayer,_targetPlayer,skillModel.trackModel,reachTargetHandler);
			}
		}
		
		/**
		 * 执行弹道 
		 * @param fromPlayer
		 * @param toPlayer
		 * @param url
		 * @param callBack
		 * 
		 */		
		private function track(fromPlayer:SpritePlayer,toPlayer:SpritePlayer,url:String,callBack:Function):void
		{
			var effectPlayerTrack:EffectPlayer = SkillEffectUtil.addTrackPlayer(fromPlayer,toPlayer,url,trackReachHandler);
			
			function trackReachHandler():void
			{
				callBack.call(null,toPlayer);
			}
		}
		
		/**
		 * 弹道到达触发 或者攻击帧数到达触发
		 * @param e
		 * 
		 */
		protected function reachTargetHandler(obj:* = null):void
		{
			var toPlayer:SpritePlayer;
			if(obj is SpritePlayer)
			{
				toPlayer = obj as SpritePlayer;
			}
			//多重弹道特效
			if(skillModel.isMultiple && toPlayer)
			{
				if (skillModel.hitModel)
				{
					SkillEffectUtil.addPlayerEffect(toPlayer,skillModel.hitModel);
				}
			}
			//单个弹道特效
			else
			{
				//播放目标特效
				if (skillModel.targetModel)
				{
					//点特效
					if(_targetPoint)
					{
						var directionTemp:Number = 0;
						if(skillModel.isTargetDirection)
						{
							directionTemp = direction;
						}
						SkillEffectUtil.addPointEffect(_targetPoint,skillModel.targetModel,directionTemp);
					}
					//目标特效
					else if(_targetPlayer)
					{
						SkillEffectUtil.addPlayerEffect(_targetPlayer,skillModel.targetModel);
					}
				}
				//播放受击特效
				if (skillModel.hitModel)
				{
					for each(var hitPlayer:SpritePlayer in _hitPlayers)
					{
						SkillEffectUtil.addPlayerEffect(hitPlayer,skillModel.hitModel);
					}
				}
			}
			runFinish();
		}
		
		/**
		 * 事件移除 
		 * 
		 */		
		protected function removeListeners():void
		{
			_fromPlayer.removeEventListener(PlayerEvent.PLAYER_FIRE, reachTargetHandler);
		}
		
		override public function dispose():void
		{
			removeListeners();
			super.dispose();
			skillModel = null;
			direction = 0;
		}
	}
}