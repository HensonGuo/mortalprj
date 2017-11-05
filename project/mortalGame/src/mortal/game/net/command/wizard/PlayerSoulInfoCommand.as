package mortal.game.net.command.wizard
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SSeqSoul;
	
	import com.gengine.debug.Log;
	
	import flash.utils.getTimer;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.mvc.core.NetDispatcher;
	
	public class PlayerSoulInfoCommand extends BroadCastCall
	{
		public function PlayerSoulInfoCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive PlayerSoulInfoCommand");
			var msg:SSeqSoul = mb.messageBase as SSeqSoul;
			
			_cache.wizard.leftTime = msg.upgradeTime;
			_cache.wizard.gost = msg.ghost;
			_cache.wizard.nowSoul = msg.nowSoul;
			_cache.wizard.updateList(msg.souls);
			
			var _cdData:CDData = Cache.instance.cd.registerCDData(CDDataType.backPackLock, "WiardTiem", _cdData) as CDData;
			_cdData.beginTime = getTimer() -   msg.upgradeTime * 1000;
			//			Log.debug(_cdData.totalTime);
			_cdData.startCoolDown();
			
//			NetDispatcher.dispatchCmd(ServerCommand.WizardInfoUpde,null);
		}
	}
}