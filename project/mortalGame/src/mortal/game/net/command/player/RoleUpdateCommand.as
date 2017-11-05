package mortal.game.net.command.player
{
	import Framework.MQ.MessageBlock;
	
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TExperience;
	import Message.Game.SRole;
	import Message.Public.EEntityAttribute;
	import Message.Public.EFightingType;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SFightAttribute;
	import Message.Public.SSeqAttributeUpdate;
	
	import com.gengine.debug.Log;
	
	import mortal.common.ResManager;
	import mortal.component.gconst.UpdateCode;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.utils.ItemsUtil;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class RoleUpdateCommand extends BroadCastCall
	{
		private var _code:int;	//更新原因
		
		private var _mount777Updates:SSeqAttributeUpdate; //坐骑777会延迟更新战斗力,暂时缓存这个更新
		
		public function RoleUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			var updates:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
			_code = updates.code;
			
			var attUpdate:SAttributeUpdate;
			
			if(_code == UpdateCode.EUpdateCodeMount777)
			{
				_mount777Updates = updates;
				Dispatcher.addEventListener(EventName.Mount777End,updateLater);//777转盘结束后
				return;
			}
			else
			{
				_mount777Updates = null;
				Dispatcher.removeEventListener(EventName.Mount777End,updateLater);
			}
			
			
			//更新实体属性
			Cache.instance.role.roleEntityInfo.updateAttribute(updates.updates);
			
			//更新人物面板属性
			for each(  attUpdate in updates.updates  )
			{
				entityInfoUpdate(attUpdate);	//实体属性更新
				fightInfoUpdate(attUpdate);  	//战斗属性更新
			}
//			if( RolePlayer.instance.isInitInfo )
//			{
//				RolePlayer.instance.updateEntityAttribute(updates.updates);
//			}
		}
		
		private function updateLater(e:DataEvent):void
		{
			//更新实体属性
			Cache.instance.role.roleEntityInfo.updateAttribute(_mount777Updates.updates);
			
			var attUpdate:SAttributeUpdate;
			
			//更新人物面板属性
			for each( attUpdate in _mount777Updates.updates  )
			{
				entityInfoUpdate(attUpdate);	//实体属性更新
				fightInfoUpdate(attUpdate);  	//战斗属性更新
			}
		}
		
		/**
		 * 玩家相关属性 
		 * 
		 */
		private function entityInfoUpdate(attUpdate:SAttributeUpdate):void
		{
			var sRole:SRole = Cache.instance.role.roleInfo;
			var entityInfo:SEntityInfo = _cache.role.entityInfo;
			switch( attUpdate.attribute.__value )
			{
				case EEntityAttribute._EAttributeLevel:           //人物等级更新
				{
					sRole.level = attUpdate.value;
					NetDispatcher.dispatchCmd( ServerCommand.RoleLevelUpdate,attUpdate.value);
					ResManager.instance.loadLevelRes();
					break;
				}
				case EEntityAttribute._EAttributeLife:           //生命值更新
				{
					sRole.life = attUpdate.value;
					NetDispatcher.dispatchCmd( ServerCommand.LifeUpdate,sRole.life);
					break;
				}
//				case EEntityAttribute._EAttributeLifeAdd:       //生命值增加
//				{
//					sRole.life += attUpdate.value;
//					NetDispatcher.dispatchCmd( ServerCommand.LifeUpdate,sRole.life);
//					break;
//				}
				case EEntityAttribute._EAttributeMana:           //魔法值更新
				{
					sRole.mana = attUpdate.value;
					NetDispatcher.dispatchCmd( ServerCommand.ManaUpdate,sRole.mana);
					break;
				}
//				case EEntityAttribute._EAttributeManaAdd:           //魔法值增加
//				{
//					sRole.mana += attUpdate.value;
//					NetDispatcher.dispatchCmd( ServerCommand.ManaUpdate,sRole.mana);
//					break;
//				}
				case EEntityAttribute._EAttributeExperience:           //经验值更新
				{
					sRole.experience = Number(attUpdate.valueStr);
					NetDispatcher.dispatchCmd( ServerCommand.ExpUpdate,sRole.experience);

					break;
				}
				case EEntityAttribute._EAttributeExperienceAdd:           //经验值增加
				{
					MsgManager.addTipText("获取" + attUpdate.value + "经验",MsgHistoryType.GetMsg);
//					sRole.experience += attUpdate.value;
//					var tExperience:TExperience = ConfigCenter.getConfigs(ConfigConst.expLevel, "level", sRole.level, true) as TExperience;
//					if(sRole.experience >= tExperience.upgradeNeedExperience)
//					{
//						sRole.experience = sRole.experience - tExperience.upgradeNeedExperience;
//					}
//					NetDispatcher.dispatchCmd( ServerCommand.ExpUpdate,sRole.experience);
					break;
				}
				case EEntityAttribute._EAttributeExperienceDel: 
				{
					MsgManager.addTipText("消耗" + attUpdate.value + "经验",MsgHistoryType.LostMsg);
					break;
				}
				case EEntityAttribute._EAttributeStamina:           //体力更新
				{
					break;
				}
				case EEntityAttribute._EAttributeFighting:           //战斗状态更新
				{
					var isFighting:Boolean = Boolean(attUpdate.value);
					var isPVP:Boolean = int(attUpdate.valueStr) == EFightingType._EFightingTypePVP;
					var fightType:String = isPVP?"PVP":"PVE";
					if(isFighting)
					{
						
						MsgManager.showRollTipsMsg("进入" + fightType + "战斗状态");
					}
					else
					{
						MsgManager.showRollTipsMsg("离开" + fightType + "战斗状态");
					}
					break;
				}
				case EEntityAttribute._EAttributeFightMode:  //状态模式
				{
					Cache.instance.role.playerInfo.mode = attUpdate.value;
					NetDispatcher.dispatchCmd( ServerCommand.FightSetModeSuccess,attUpdate.value);
				}
			}
		}
		
		/**
		 * 玩家相关属性 
		 * 
		 */
		private function fightInfoUpdate(attUpdate:SAttributeUpdate):void
		{
			var sFightAttribute:SFightAttribute = Cache.instance.role.fightAttribute;
			switch( attUpdate.attribute.__value )
			{
				case EEntityAttribute._EAttributeMaxLife:          //最大生命值
				{
					sFightAttribute.maxLife = attUpdate.value;
					break;
				}
				case EEntityAttribute._EAttributeMaxMana:           //最大法力值
				{
					sFightAttribute.maxMana = attUpdate.value;
					break;
				}
			}
		}
		
//		override public function call(mb:MessageBlock):void
//		{
////			Log.debug("I have receive RoleUpdateCommand");
//			var sFightAttribute:SFightAttribute = Cache.instance.role.fightAttribute;
//			var sRole:SRole = Cache.instance.role.roleInfo;
//			var updates:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
//			var attUpdate:SAttributeUpdate;
//			for each(  attUpdate in updates.updates  )
//			{
//				
//			}
//		}
	}
}