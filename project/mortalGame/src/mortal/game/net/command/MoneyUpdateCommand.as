/**
 * @date	2011-3-4 上午11:44:14
 * @author  jianglang
 *
 */

package mortal.game.net.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.EEntityAttribute;
	import Message.Public.EPrictUnit;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SSeqAttributeUpdate;
	
	import extend.language.Language;
	
	import mortal.common.net.CallLater;
	import mortal.common.tools.DateParser;
	import mortal.component.gconst.UpdateCode;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.ConstConfig;
	import mortal.game.resource.GameDefConfig;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;

	public class MoneyUpdateCommand extends BroadCastCall
	{
		private var _isMoneyUpdate:Boolean = false;		// 金钱
		
		public function MoneyUpdateCommand(type:Object)
		{
			super(type);
		}

		override public function call(mb:MessageBlock):void
		{
			
			var updates:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
			//trace(updates.code.__value); 更新原因
			var attUpdate:SAttributeUpdate;
			for each(  attUpdate in updates.updates  )
			{
				moneyUpdate(attUpdate,updates.code);			//金钱更新
				_isMoneyUpdate = true;
			}
			//实体更新
			if( _isMoneyUpdate )
			{
				CallLater.addCallBack(onMoneyUpdateHandler);
				_isMoneyUpdate = false;
			}
		}
		
		private function onMoneyUpdateHandler():void
		{
			NetDispatcher.dispatchCmd(ServerCommand.MoneyUpdate,_cache.role.money);
			_isMoneyUpdate = true;
		}
		
		/**
		 * 金钱相关 
		 */		
		
		private function moneyUpdate(attUpdate:SAttributeUpdate,updateCode:int):void
		{
			var updateStr:String = ConstConfig.instance.getOutUpdateStrByCode(updateCode);
			var walletStr:String;
			var strAddOrDes:String;
			var addValue:int;
			var addStr:String = "";
			var unitName:String = "";//货币名称
			var coinTxt:String = "";
			switch( attUpdate.attribute.__value )
			{
				//金钱相关
				case EEntityAttribute._EAttributeCoin:           //铜钱
				{
					var valueCoin:int = attUpdate.value - _cache.role.money.coin;
					_cache.role.money.coin= attUpdate.value;
					
					if(valueCoin > 0)
					{
						coinTxt = Language.getStringByParam(30013,valueCoin.toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.GetMsg);
					}
					else if(valueCoin < 0)
					{
						coinTxt = Language.getStringByParam(30014,Math.abs(valueCoin).toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.LostMsg);
					}
					NetDispatcher.dispatchCmd(ServerCommand.CoinUpdate,_cache.role.money);
					break;
				}
				case EEntityAttribute._EAttributeCoinBind:       //绑定铜钱
				{
					var valueCoinB:int = attUpdate.value - _cache.role.money.coinBind;
					_cache.role.money.coinBind= attUpdate.value;
					if(valueCoinB > 0)
					{
						coinTxt = Language.getStringByParam(30015,valueCoinB.toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.GetMsg);
					}
					else if(valueCoinB < 0)
					{
						coinTxt = Language.getStringByParam(30016,Math.abs(valueCoinB).toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.LostMsg);
					}
					NetDispatcher.dispatchCmd(ServerCommand.CoinUpdate,_cache.role.money);
					break;
				}
				case EEntityAttribute._EAttributeGold:           //元宝
				{
					var valueGold:int = attUpdate.value - _cache.role.money.gold;
					_cache.role.money.gold= attUpdate.value;
					if(valueGold > 0)
					{
						coinTxt = Language.getStringByParam(30017,valueGold.toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.GetMsg);
					}
					else if(valueGold < 0)
					{
						coinTxt = Language.getStringByParam(30018,Math.abs(valueGold).toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.LostMsg);
					}
					NetDispatcher.dispatchCmd(ServerCommand.GoldUpdate,_cache.role.money);
					break;
				}
				case EEntityAttribute._EAttributeGoldBind:       //绑定元宝
				{
					var valueGoldB:int = attUpdate.value - _cache.role.money.goldBind;
					_cache.role.money.goldBind= attUpdate.value;
					if(valueGoldB > 0)
					{
						coinTxt = Language.getStringByParam(30019,valueGoldB.toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.GetMsg);
					}
					else if(valueGoldB < 0)
					{
						coinTxt = Language.getStringByParam(30020,Math.abs(valueGoldB).toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.LostMsg);
					}
					NetDispatcher.dispatchCmd(ServerCommand.GoldUpdate,_cache.role.money);
					break;
				}
				case EEntityAttribute._EAttributeVitalEnergy:
					var skillPointAdd:int = attUpdate.value - _cache.role.money.vitalEnergy;
					_cache.role.money.vitalEnergy= attUpdate.value;
					if(skillPointAdd > 0)
					{
						coinTxt = Language.getStringByParam(20118, skillPointAdd.toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.GetMsg);
					}
					else if(skillPointAdd < 0)
					{
						coinTxt = Language.getStringByParam(20119, Math.abs(skillPointAdd).toString());
						MsgManager.addTipText(coinTxt,MsgHistoryType.LostMsg);
					}
					NetDispatcher.dispatchCmd(ServerCommand.SkillPointUpdate, _cache.role.money);
					break;
				case EEntityAttribute._EAttributeRunicPower:
					var added:int = attUpdate.value - _cache.role.money.runicPower;
					_cache.role.money.runicPower = attUpdate.value;
					if(added > 0)
					{
						coinTxt = Language.getStringByParam(20222, skillPointAdd.toString());
					}
					else if(added < 0)
					{
						coinTxt = Language.getStringByParam(20223, Math.abs(skillPointAdd).toString());
					}
					NetDispatcher.dispatchCmd(ServerCommand.RunePowerUpdate, _cache.role.money);
					break;
			}
		}
		
	}
}
