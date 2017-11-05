package mortal.game.control
{
	import com.gengine.debug.Log;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.MailCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.MailProxy;
	import mortal.game.view.mail.MailModule;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	/**
	 * 邮件控制器
	 * @author lizhaoning
	 */
	public class MailController extends Controller
	{
		private var _mailCache:MailCache;
		private var _mailProxy:MailProxy;
		private var _mailModule:MailModule;
		
		public function MailController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_mailCache = cache.mail;
			_mailProxy = GameProxy.mail;
		}
		
		override protected function initView():IView
		{
			if( _mailModule == null)
			{
				_mailModule = new MailModule();
				_mailModule.addEventListener(WindowEvent.SHOW, onMailShow);
				_mailModule.addEventListener(WindowEvent.CLOSE, onMailClose);
			}
			return _mailModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.MailMenuSend,clickMenuSendMail);	
		}
		
		protected function onMailShow(event:Event):void
		{
			// TODO Auto-generated method stub
			cache.mail.mailNotice = false;
			NetDispatcher.dispatchCmd(ServerCommand.MailNotice,null);
			
			NetDispatcher.addCmdListener(ServerCommand.MailListUpdate, mailListUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.MailUpdate, mailUpdateHandler);
			
			
			Dispatcher.addEventListener(EventName.MailQueryAll, queryAllMailHandler);
			Dispatcher.addEventListener(EventName.MailQueryUnread, queryUnReadMailHandler);
			Dispatcher.addEventListener(EventName.MailQueryRead, queryReadMailHandler);
			Dispatcher.addEventListener(EventName.MailQuerySys, querySysMailHandler);
			Dispatcher.addEventListener(EventName.MailQueryPers, queryPersMailHandler);
			Dispatcher.addEventListener(EventName.MailSend, sendMailHandler);
			Dispatcher.addEventListener(EventName.MailRead, readMailHandler);
			Dispatcher.addEventListener(EventName.MailDelete, deleteMailHandler);
			Dispatcher.addEventListener(EventName.MailGetAttachment, getAttachmentHandler);
			Dispatcher.addEventListener(EventName.MailGetAttachments, getAttachmentsHandler);
			Dispatcher.addEventListener(EventName.MailGASucced, getAttachmentsSuccedHandler);
			Dispatcher.addEventListener(EventName.MailDelteSucced, delteSuccedHandler);
			Dispatcher.addEventListener(EventName.MailSendSucced, mailSendSuccedHandler);
			
			if((view as MailModule).uiLoadComplete)
				queryAllMailHandler(null);
		}
		
		protected function onMailClose(event:Event):void
		{
			// TODO Auto-generated method stub
			
			NetDispatcher.removeCmdListener(ServerCommand.MailListUpdate, mailListUpdateHandler);
			NetDispatcher.removeCmdListener(ServerCommand.MailUpdate, mailUpdateHandler);
			
			Dispatcher.removeEventListener(EventName.MailQueryAll, queryAllMailHandler);
			Dispatcher.removeEventListener(EventName.MailQueryUnread, queryUnReadMailHandler);
			Dispatcher.removeEventListener(EventName.MailQueryRead, queryReadMailHandler);
			Dispatcher.removeEventListener(EventName.MailQuerySys, querySysMailHandler);
			Dispatcher.removeEventListener(EventName.MailQueryPers, queryPersMailHandler);
			Dispatcher.removeEventListener(EventName.MailSend, sendMailHandler);
			Dispatcher.removeEventListener(EventName.MailRead, readMailHandler);
			Dispatcher.removeEventListener(EventName.MailDelete, deleteMailHandler);
			Dispatcher.removeEventListener(EventName.MailGetAttachment, getAttachmentHandler);
			Dispatcher.removeEventListener(EventName.MailGetAttachments, getAttachmentsHandler);
			Dispatcher.removeEventListener(EventName.MailGASucced, getAttachmentsSuccedHandler);
			Dispatcher.removeEventListener(EventName.MailDelteSucced, delteSuccedHandler);
			Dispatcher.removeEventListener(EventName.MailSendSucced, mailSendSuccedHandler);
		}
		
		private function queryUnReadMailHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_mailProxy.queryMail(2,0,1,int(e.data));
		}
		
		private function queryReadMailHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_mailProxy.queryMail(2,0,2,int(e.data));
		}
		
		private function querySysMailHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_mailProxy.queryMail(1,1,0,int(e.data));
		}
		
		private function queryPersMailHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_mailProxy.queryMail(1,2,0,int(e.data));
		}
		
		private function queryAllMailHandler(e:DataEvent):void  //查询全部邮件
		{
			// TODO Auto Generated method stub
			if(e && e.data)
				_mailProxy.queryMail(0,0,0,int(e.data));
			else
				_mailProxy.queryMail(0,0,0,0);
		}
		
		private function getAttachmentHandler(e:DataEvent):void  //提取附件
		{
			// TODO Auto Generated method stub
			if(e.data)
				_mailProxy.getMailAttachment(e.data.mailId,e.data.attachementIndex,e.data.isDelete);
		}
		
		private function deleteMailHandler(e:DataEvent):void  //删除邮件
		{
			// TODO Auto Generated method stub
			if(e.data)
				_mailProxy.deleteMail(e.data.arr as Array,e.data.boo as Boolean);
		}
		private function getAttachmentsHandler(e:DataEvent):void   //一键提取附件
		{
			// TODO Auto Generated method stub
			if(e.data)
				_mailProxy.getMailAttachments_async(e.data as Array);
		}
		
		private function readMailHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			if(e.data)
				_mailProxy.readMail(e.data as Number);
		}		
		
		private function sendMailHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			if(e.data)
				_mailProxy.sendMail(e.data.toPlayerName,e.data.title,e.data.content);
		}
		
		private function mailSendSuccedHandler(e:Object):void   //邮件发送成功
		{
			// TODO Auto Generated method stub
			(view as MailModule).mailWritePanel.clearWord();
		}
		
		private function getAttachmentsSuccedHandler(e:DataEvent):void   //一键获取成功
		{
			// TODO Auto Generated method stub
			(view as MailModule).queryMail();
		}
		
		private function delteSuccedHandler(e:DataEvent):void  //删除成功
		{
			// TODO Auto Generated method stub
			(view as MailModule).clearMailSelect();
			(view as MailModule).mailReadPanel.checkMail();
			(view as MailModule).queryMail();
		}
		
		private function mailListUpdateHandler(e:Object):void
		{
			// TODO Auto Generated method stub
			Log.debug("mailList刷新");
			(view as MailModule).updateMailList();
		}
		private function mailUpdateHandler(e:Object):void
		{
			// TODO Auto Generated method stub
			Log.debug("mail刷新");
			(view as MailModule).updateMailList(true);
		}
		
		private function clickMenuSendMail(e:DataEvent):void   //点击头像菜单中的发送邮件
		{
			// TODO Auto Generated method stub
			(view as MailModule).openWritePanelFunc(e.data as String);
			GameManager.instance.popupView(this.view);
		}
	}
}