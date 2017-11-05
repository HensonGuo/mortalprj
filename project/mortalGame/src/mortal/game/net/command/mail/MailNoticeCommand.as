package mortal.game.net.command.mail
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SMailNotice;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 新邮件提醒
	 * @author lizhaoning
	 */
	public class MailNoticeCommand extends BroadCastCall
	{
		public function MailNoticeCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			// TODO Auto Generated method stub
			super.call(mb);
			
			var sMailNotice:SMailNotice = mb.messageBase as SMailNotice;
			if(sMailNotice)
			{
				Cache.instance.mail.mailNotice = true;
				NetDispatcher.dispatchCmd(ServerCommand.MailNotice,null);
			}
		}
		
		
	}
}