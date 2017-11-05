/**
 * 引导技能目标受击特效
 * @heartspeak
 * 2014-4-2 
 */   	

package mortal.game.scene3D.fight
{
	import Message.DB.Tables.TSkillModel;
	
	import mortal.game.resource.tableConfig.SkillModelConfig;
	import mortal.game.scene3D.player.entity.SpritePlayer;

	public class FightEffectLeadRelease extends FightEffectBase
	{
		protected var skillModel:TSkillModel;
		
		public function FightEffectLeadRelease()
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
			//技能模型配置
			skillModel = SkillModelConfig.instance.getInfoById(_skill.skillModel);
			if(!skillModel)
			{
				runFinish();
				return;
			}
			var isTrack:Boolean = false;
			//暂时不处理弹道 
//			if(skillModel.trackModel)
//			{
//				isTrack = true;
//				trackHandler();
//			}
			//播放目标特效和受击特效
			targetHandler();
		}
		
		protected function targetHandler():void
		{
			//播放目标特效
			if (skillModel.targetModel)
			{
				//点特效
				if(_targetPoint)
				{
					SkillEffectUtil.addPointEffect(_targetPoint,skillModel.targetModel);
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
			runFinish();
		}
		
		override public function dispose():void
		{
			super.dispose();
			skillModel = null;
		}
	}
}