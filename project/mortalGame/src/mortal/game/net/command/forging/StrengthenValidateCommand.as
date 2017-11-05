package mortal.game.net.command.forging
{
	import Framework.MQ.MessageBlock;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * @date   2014-3-21 上午9:38:26
	 * @author dengwj
	 */	 
	public class StrengthenValidateCommand extends BroadCastCall
	{
		public function StrengthenValidateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive StrengthenValidateCommand");
			var msg:Array = mb.messageBase as Array;
			NetDispatcher.dispatchCmd(ServerCommand.FirstFourStrengthenInfo, msg);
		}
	}
}