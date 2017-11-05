package mortal.game.net.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SErrorMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.manager.MsgManager;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.ErrorCodeConfig;

	public class ErrorMsgCommand extends BroadCastCall
	{
		public function ErrorMsgCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			var error:SErrorMsg = mb.messageBase as SErrorMsg;
			Log.debug(error.code,ErrorCode.getErrorStringByCode(error.code),error.message);
			MsgManager.systemError(error);
		}
	}
}