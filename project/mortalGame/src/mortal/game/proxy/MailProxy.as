package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IMail_getMailAttachment;
	import Message.Game.AMI_IMail_getMailAttachments;
	import Message.Game.AMI_IMail_queryMail;
	import Message.Game.AMI_IMail_readMail;
	import Message.Game.AMI_IMail_removeMail;
	import Message.Game.AMI_IMail_sendMail;
	import Message.Game.SMail;
	
	import com.gengine.debug.Log;
	
	import flash.utils.setTimeout;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.cache.MailCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	/**
	 * 邮件
	 * @author lizhaoning
	 */
	public class MailProxy extends Proxy
	{
		private var _mailCache:MailCache;
		
		public function MailProxy()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_mailCache = this.cache.mail;
		}
		
		/**
		 * 查询邮件 
		 * @param condition
		 * @param type
		 * @param status
		 * @param startIndex
		 */
		public function queryMail(condition:int = 0,type:int = 0,status:int = 0,startIndex:int = 0):void
		{
			rmi.iMailPrx.queryMail_async(new AMI_IMail_queryMail(querMailSucced,querMailFail),condition,type,status,startIndex);
		}
			private function querMailSucced(e:AMI_IMail_queryMail,outMails:Array,outStartIndex:int , outTotalCount:int):void
			{
				Log.debug("查询邮件成功");
				cache.mail.updateMails(outMails,outStartIndex,outTotalCount);
				NetDispatcher.dispatchCmd(ServerCommand.MailListUpdate,null);
			}
			private function querMailFail(e:Exception):void
			{
				// TODO Auto Generated method stub
				Log.debug("查询邮件失败");
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		
		/**
		 * 删除邮件 
		 * @param mailIds
		 */
		public function deleteMail(mailIds : Array,hasAttachment:Boolean = false):void
		{
			this._hasAttachMent = hasAttachment;
			rmi.iMailPrx.removeMail_async(new AMI_IMail_removeMail(removeMailSucced,removeMailFail,mailIds),mailIds);
		}
		private var _hasAttachMent:Boolean; //记录勾选的邮件中是不是有未提取附件的邮件，如果有，则给予提示
		private function removeMailSucced(e:AMI_IMail_removeMail):void
		{
			Log.debug("删除邮件成功");
			_mailCache.removeMails(e.userObject as Array);
			Dispatcher.dispatchEvent(new DataEvent(EventName.MailDelteSucced));
			
			if(_hasAttachMent)
			{
				MsgManager.showRollTipsMsg("部分删除失败，未提取附件");
			}
			else
			{
				MsgManager.showRollTipsMsg("删除成功");
			}
		}
		private function removeMailFail(e:Exception):void
		{
			Log.debug("删除邮件失败");
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
		/**
		 * 阅读邮件 
		 * @param mailId
		 */
		public function readMail(mailId : Number) : void 
		{
			rmi.iMailPrx.readMail_async(new AMI_IMail_readMail(readMailSucced,readMailFail),mailId);
		}
			private function readMailSucced(e:AMI_IMail_readMail,mail:SMail):void
			{
				Log.debug("阅读邮件成功");
				_mailCache.updateMail(mail);
				NetDispatcher.dispatchCmd(ServerCommand.MailUpdate,mail);
			}
			private function readMailFail(e:Exception):void
			{
				Log.debug("阅读邮件失败");
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		
		/**
		 * 发送邮件 
		 * @param toPlayerName
		 * @param title
		 * @param content
		 */
		public function sendMail(toPlayerName:String,title:String,content:String):void
		{
			rmi.iMailPrx.sendMail_async(new AMI_IMail_sendMail(sendMailSucced,sendMailFail),toPlayerName,title,content,0,0,null);
		}
			private function sendMailSucced(e:AMI_IMail_sendMail):void
			{
				// TODO Auto Generated method stub
				Log.debug("发送邮件成功");
				MsgManager.showRollTipsMsg("发送成功");
				Dispatcher.dispatchEvent(new DataEvent(EventName.MailSendSucced));
			}
			private function sendMailFail(e:Exception):void
			{
				// TODO Auto Generated method stub
				Log.debug("发送邮件失败");
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		
			
		/**
		 * 获取附件(可单个物品获取) 
		 * @param mailId
		 * @param attachementIndex
		 * @param isDelete
		 */
		public function getMailAttachment(mailId : Number , attachementIndex : int , isDelete : Boolean ) : void 
		{
			rmi.iMailPrx.getMailAttachment_async(new AMI_IMail_getMailAttachment(getAttachSucced,getAttachFail),mailId,attachementIndex,isDelete);
		}
			private function getAttachSucced(e:AMI_IMail_getMailAttachment,outMail:Array):void
			{
				Log.debug("获取附件成功");
				var mail:SMail = outMail[0];
				//提取后删除，并且没有附件
				if(_mailCache.mailGetAfterDelete && (cache.mail.checkMailhadAttach(mail) == false)) 
				{
					_mailCache.removeMails([outMail[0].mailId]);
					
					setTimeout(func,100);  //延迟请求，防止bug
					function func():void
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.MailDelteSucced));
					}
				}
				else
				{
					_mailCache.updateMail(outMail[0]);
					NetDispatcher.dispatchCmd(ServerCommand.MailUpdate,outMail[0]);
				}
			
			}
			private function getAttachFail(e:Exception):void
			{
				Log.debug("获取附件失败");
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		
		/**
		 * 获取邮件所有附件 
		 * @param mailIds
		 * 
		 */
		public function getMailAttachments_async(mailIds : Array ) : void 
		{
			rmi.iMailPrx.getMailAttachments_async(new AMI_IMail_getMailAttachments(getAttachsSucced,getAttachsFail),null);
		}
			private function getAttachsSucced(e:AMI_IMail_getMailAttachments,result:Boolean,outMails:Array):void
			{
				if(result == false)
				{
					MsgManager.showRollTipsMsg("部分提取失败，背包已满");
				}
				else
				{
					MsgManager.showRollTipsMsg("获取附件成功");
					Log.debug("获取附件成功");
				}
				if(outMails.length==0)
				{
					MsgManager.showRollTipsMsg("没有可提取的物品");
					return;
				}
				
				if(_mailCache.mailGetAfterDelete)
				{
					deleteMail(outMails);  //再发一次包删掉邮件
				}
				else
				{
					setTimeout(func,100);  //延迟请求，防止bug
				}
				function func():void
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailGASucced));
				}
			}
			private function getAttachsFail(e:Exception):void
			{
				// TODO Auto Generated method stub
				Log.debug("获取附件失败");
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		
	}
}