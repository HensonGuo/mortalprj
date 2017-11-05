package mortal.game.cache
{
	import Message.Game.SMail;
	import Message.Game.SMailNotice;

	/**
	 * 邮件缓存
	 * @author lizhaoning
	 */
	public class MailCache
	{
		private var _mailNotice:Boolean = false;

		/** 所有邮件 */
		public var mailVec:Vector.<SMail>;
		/** 邮件最大数 */
		private var _mailTotalCount:int;
		public var mailStartIndex:int;
		
		private var _mailGetAfterDelete:Boolean;
		
		public function MailCache()
		{
			mailVec = new Vector.<SMail>();
		}
		

		public function updateMail(_mail:SMail):void {
			for (var i:int = 0; i < mailVec.length; i++) 
			{
				if(mailVec[i].mailId == _mail.mailId)
				{
					mailVec[i] = _mail;
					break;
				}
			}
		}
		
		/**
		 * 移出一封邮件所有附件 
		 */
		public function removeMailAttachMents(mailId:int):void
		{
			var mail:SMail = getMailByMailId(mailId);
			if(mail)
			{
				mail.attachmentCoin = 0;
				mail.attachmentGold = 0;
				mail.playerItems.splice(0,mail.playerItems.length);
			}
		}
		
		public function updateMails(_mails:Array , startIndex:int,totalCount:int):void
		{
			mailVec.splice(0,mailVec.length);
			for (var i:int = 0; i < _mails.length; i++) 
			{
				mailVec.push(_mails[i] as SMail);
			}
			this.mailStartIndex = startIndex;
			this.mailTotalCount = totalCount;
		}
		
		public function removeMails(_mailIds:Array):void
		{
			for (var i:int = 0; i < _mailIds.length; i++) 
			{
				for (var j:int = 0; j < mailVec.length; j++) 
				{
					if(_mailIds[i] == mailVec[j].mailId)
					{
						mailVec.splice(j,1);
						break;
					}
				}
			}
			this.mailTotalCount -= _mailIds.length;
		}
		
		/**
		 * 通过邮件ID获取邮件 
		 * @param id
		 * @return 
		 */
		public function getMailByMailId(id:int):SMail
		{
			if(mailVec)
			for (var i:int = 0; i < mailVec.length; i++) 
			{
				if(mailVec[i].mailId == id)
					return mailVec[i];
			}
			return null;
		}
		
		/**
		 * 获取未读邮件
		 * @return 
		 */
		public function getUnReadMails():Vector.<SMail>
		{
			var vec:Vector.<SMail> = new Vector.<SMail>;
			
			for (var i:int = 0; i < mailVec.length; i++) 
			{
				if(mailVec[i].status == 1)
					vec.push(mailVec[i]);
			}
			return vec;
		}
		
		/**
		 * 获取已读邮件
		 * @return 
		 */
		public function getReadedMails():Vector.<SMail>
		{
			var vec:Vector.<SMail> = new Vector.<SMail>;
			
			for (var i:int = 0; i < mailVec.length; i++) 
			{
				if(mailVec[i].status != 1)
					vec.push(mailVec[i]);
			}
			return vec;
		}
		
		/**
		 * 获取系统邮件
		 * @return 
		 */
		public function getSysMails():Vector.<SMail>
		{
			var vec:Vector.<SMail> = new Vector.<SMail>;
			
			for (var i:int = 0; i < mailVec.length; i++) 
			{
				if(mailVec[i].type != 2)
					vec.push(mailVec[i]);
			}
			return vec;
		}
		
		/**
		 * 获取私人邮件 
		 * @return 
		 */
		public function getPersonalMails():Vector.<SMail>
		{
			var vec:Vector.<SMail> = new Vector.<SMail>;
			
			for (var i:int = 0; i < mailVec.length; i++) 
			{
				if(mailVec[i].type == 2)
					vec.push(mailVec[i]);
			}
			return vec;
		}
		
//************************************************************get和set	******************************
		/** 新邮件提醒  */
		public function get mailNotice():Boolean
		{
			return _mailNotice;
		}
		
		/**
		 * @private
		 */
		public function set mailNotice(value:Boolean):void
		{
			if(value == mailNotice)
				return;
			
			_mailNotice = value;
		}
		
		/** 获取附件后是否删除邮件 */
		public function get mailGetAfterDelete():Boolean
		{
			return _mailGetAfterDelete;
		}
		
		/**
		 * @private
		 */
		public function set mailGetAfterDelete(value:Boolean):void
		{
			_mailGetAfterDelete = value;
		}
		
		/**
		 * 检查邮件是不是有附件 
		 */
		public function checkMailhadAttach(mail:SMail):Boolean
		{
			if(mail == null )
			{
				return false;
			}
			
			if(mail.attachmentCoin>0)
				return true;
			if(mail.attachmentGold>0)
				return true;
			if(mail.playerItems.length>0)
				return true;
			return false;
		}
		
		public function getMailAttachItemCount(mail:SMail):int
		{
			if(mail == null )
			{
				return 0;
			}
			return mail.playerItems.length;
		}
		
		/** 邮件最大数 */
		public function get mailTotalCount():int
		{
			return _mailTotalCount;
		}
		
		/**
		 * @private
		 */
		public function set mailTotalCount(value:int):void
		{
			if(value>100)
			{
				value = 100;
			}
			
			_mailTotalCount = value;
		}
	}
}