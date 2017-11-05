package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IPlayer_activeSoul;
	import Message.Game.AMI_IPlayer_callInSoul;
	import Message.Game.AMI_IPlayer_getPlayerSoul;
	import Message.Game.AMI_IPlayer_getSoulTime;
	import Message.Game.AMI_IPlayer_putOutSoul;
	import Message.Game.AMI_IPlayer_reduceUpgradeSoul;
	import Message.Game.AMI_IPlayer_upgradeSoul;
	import Message.Game.SSoul;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.tableConfig.WizardConfig;
	import mortal.game.view.wizard.WizardCache;
	import mortal.game.view.wizard.data.WizardData;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	public class WizardProxy extends Proxy
	{
		private var _wizardCache:WizardCache;
		
		public function WizardProxy()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_wizardCache = this.cache.wizard;
		}
		
		/**
		 * 获取玩家斗魂信息 
		 * @param playerId
		 * 
		 */		
		public function getPlayerSoul(playerId:int):void
		{
			rmi.iPlayerPrx.getPlayerSoul_async(new AMI_IPlayer_getPlayerSoul(),playerId);
		}
		
		
		/**
		 *  激活斗魂
		 * 
		 */		
		public function activeSoul(playerId:int,itemCode:int):void
		{
			rmi.iPlayerPrx.activeSoul_async(new AMI_IPlayer_activeSoul(getSuccess,getFail,itemCode),playerId,itemCode);
		}
		
		private function getSuccess(e:AMI_IPlayer_getPlayerSoul):void
		{
			var itemCode:int = e.userObject as int;
			var ssoul:SSoul = new SSoul();
			ssoul.level = 0;
			ssoul.node = 0;
			ssoul.soul = WizardConfig.instance.wizardItemDic[itemCode];
			cache.wizard.addSoul(ssoul);
			
			NetDispatcher.dispatchCmd(ServerCommand.WizardInfoUpde,null);
		}
		
		private function getFail(e:Exception):void
		{
		}
		
		
		/**
		 * 升级斗魂穴位
		 * @param playerId
		 * @param soul
		 * @param node
		 * @param level
		 * 
		 */		
		public function upgradeSoul(data:WizardData):void
		{
			rmi.iPlayerPrx.upgradeSoul_async(new AMI_IPlayer_upgradeSoul(upgradeSoulSuccess,upgradeSoulFail),0,data.soulId,data.sSoul.node + 1,data.sSoul.level + 1);
		}
		
		private function upgradeSoulSuccess(e:AMI_IPlayer_upgradeSoul,leftTime:int):void
		{
			
		}
		
		private function upgradeSoulFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
		/**
		 * 放出精灵 
		 * @param playerId
		 * @param soul
		 * 
		 */		
		public function putOutSoul(playerId:int, soul:int):void
		{
			rmi.iPlayerPrx.putOutSoul_async(new AMI_IPlayer_putOutSoul(),playerId,soul);
		}
		
		/**
		 * 回收精灵 
		 * @param playerId
		 * @param soul
		 * 
		 */		
		public function callInSoul(playerId:int, soul:int):void
		{
			rmi.iPlayerPrx.callInSoul_async(new AMI_IPlayer_callInSoul(),playerId,soul);
		}
		
		
		/**
		 * 秒掉cd时间 
		 * @param playerId
		 * @param time
		 * 
		 */		
		public function reduceUpgradeSoul(playerId:int,time:int):void
		{
			rmi.iPlayerPrx.reduceUpgradeSoul_async(new AMI_IPlayer_reduceUpgradeSoul(),playerId,time);
		}
		
		public function getSoulTime():void
		{
			rmi.iPlayerPrx.getSoulTime_async(new AMI_IPlayer_getSoulTime(getTimeSuccess),0);
		}
		
		private function getTimeSuccess(e:AMI_IPlayer_upgradeSoul,leftTime:int):void
		{
			
		}
	}
}