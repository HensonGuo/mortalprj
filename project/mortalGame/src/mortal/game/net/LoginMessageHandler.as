/**
 * @date	2011-4-13 下午05:22:18
 * @author  jianglang
 * 
 */	

package mortal.game.net
{
	import Framework.MQ.IMessageHandler;
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	
	import mortal.mvc.core.NetDispatcher;

	public class LoginMessageHandler implements IMessageHandler
	{
		public function LoginMessageHandler()
		{
			
		}
		
		public function onMessage( mb : MessageBlock ):void
		{
			switch(mb.messageHead.command)
			{
				case EPublicCommand._ECmdPublicLoginInfoShow:
				{
					NetDispatcher.dispatchCmd(mb.messageHead.command, mb);
					break;
				}
				
			}
		}
	}
}
