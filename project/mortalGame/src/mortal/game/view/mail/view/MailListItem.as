package mortal.game.view.mail.view
{
	import Message.Game.EMailType;
	import Message.Game.SMail;
	
	import com.gengine.utils.FilterText;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 邮件列表 单个item
	 * @author lizhaoning
	 */
	public class MailListItem extends GCellRenderer
	{
		/**背景*/
		private var _bg:ScaleBitmap;
		
		/** 邮件类型 */
		private var _txtType:GTextFiled;
		/** 标题静态字 */
		private var _txtStaticTitle:GTextFiled;
		/** 邮件日期 */
		private var _txtDate:GTextFiled;
		/** 邮件状态 已读未读*/
		private var _txtStatus:GTextFiled;
		/** 邮件标题 */
		private var _txtTitle:GTextFiled;
		
		/** 状态图标*/
		private var _bmpStatus:GBitmap;
		/** 附件图标*/
		private var _bmpAttachment:GBitmap;
		
		/** 提取附件 */
		private var _btnGetAttachment:GButton;
		
		
		/** 勾选 */
		private var _checkBox:GCheckBox;
		
		public function MailListItem()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			//背景
			_bg = UIFactory.bg(0,0,287,50,this,"InputDisablBg");
			
			//勾选按钮
			_checkBox = UIFactory.checkBox("",8,11,28,28,this);
			
			
			//文字部分
			var tformat1:TextFormat = new TextFormat();
			tformat1.color = GlobalStyle.yellowUint;
			var tformat2:TextFormat = new TextFormat();
			tformat1.color = GlobalStyle.redUint;
			
			_txtType = UIFactory.textField("",30,2,65,30,this,null,false,false);
			_txtType.textColor = 0xFFFFFF;
			_txtDate = UIFactory.textField("",85,2,65,30,this,null,false,false);
			//未读已读，需要设置颜色
			_txtStatus = UIFactory.textField("",150,2,65,30,this,tformat1,false,false);
			_txtStaticTitle = UIFactory.textField("标     题",30,25,65,30,this,null,false,false);
			_txtStaticTitle.textColor = 0xFFFFFF;
			_txtTitle = UIFactory.textField("",85,25,140,30,this,null,false,false);
			
			
			//提取按钮
			_btnGetAttachment = UIFactory.gButton("提取",235,14,50,22,this);
			
			
			_btnGetAttachment.configEventListener(MouseEvent.CLICK,btnGetAttachmentHandler);
			this.configEventListener(MouseEvent.CLICK,clickHandler,false,9999999);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			
			if(e.target == _btnGetAttachment)
			{
				e.stopImmediatePropagation();
				e.stopPropagation();
				Dispatcher.dispatchEvent(new DataEvent(EventName.MailGetAttachment));
			}
			else if(e.target == _checkBox)
			{
				e.stopImmediatePropagation();
				e.stopPropagation();
				this.mailSelected = _checkBox.selected;
			}
			else
			{
				
			}
		}
		
		private function btnGetAttachmentHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(Cache.instance.pack.backPackCache.isPackFull())
			{
				MsgManager.showRollTipsMsg("背包已满");
				return;
			}
			if(Cache.instance.pack.backPackCache.getSpareCapacity()<
				Cache.instance.mail.getMailAttachItemCount(this._data as SMail))
			{
				MsgManager.showRollTipsMsg("背包空位不足");
				return;
			}
			
			
			var obj:Object={};
			obj.mailId = _data.mailId;
			obj.attachementIndex = 0;
			obj.isDelete = Cache.instance.mail.mailGetAfterDelete;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MailGetAttachment,obj));
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_bg.dispose(isReuse);
			_checkBox.dispose(isReuse);
			_txtType.dispose(isReuse);
			_txtDate.dispose(isReuse);
			_txtStatus.dispose(isReuse);
			_txtStaticTitle.dispose(isReuse);
			_txtTitle.dispose(isReuse);
			_btnGetAttachment.dispose(isReuse);
			if(_bmpStatus)_bmpStatus.dispose(isReuse);
			if(_bmpAttachment)_bmpAttachment.dispose(isReuse);
			
			
			_bg = null;
			_checkBox = null;
			_txtType = null;
			_txtDate = null;
			_txtStatus = null;
			_txtStaticTitle = null;
			_txtTitle = null;
			_btnGetAttachment = null;
			_bmpStatus = null;
			_bmpAttachment = null;
		}
		
		
		override public function set data(arg0:Object):void
		{
			super.data = arg0;
			this._data = arg0;
			
			if(_bmpAttachment)
			{
				_bmpAttachment.dispose();
				_bmpAttachment = null;
			}
			if(_bmpStatus) 
			{
				_bmpStatus.dispose();
				_bmpStatus = null;
			}
			
			var mail:SMail = this.data as SMail;
			
			this._txtDate.text = mail.mailDt.fullYear+"/"+(mail.mailDt.month+1)+"/"+mail.mailDt.date;
			if(mail.type == EMailType._EMailTypePlayer)  
			{
				this._txtType.text = "私人邮件";
				this._txtTitle.text = FilterText.instance.getFilterStr(mail.title);
			}
			else if(mail.type == EMailType._EMailTypeSystem) 
			{
				this._txtType.text = "系统邮件";
				this._txtTitle.text = mail.title;
			}
			
			
			if(mail.status == 1)  //未读
			{
				this._txtStatus.text = "[未读]"
				this._txtStatus.textColor = GlobalStyle.redUint;
				
				//图标
				_bmpStatus = UIFactory.bitmap(ImagesConst.mailUnRead,212,2,this);
			}
			else
			{
				this._txtStatus.text = "[已读]";
				this._txtStatus.textColor = GlobalStyle.yellowUint;
				
				_bmpStatus = UIFactory.bitmap(ImagesConst.mailRead,212,2,this);
			}
			
			if(Cache.instance.mail.checkMailhadAttach(mail))  //有附件
			{
				this._btnGetAttachment.visible = true;
				if(mail.status == 1)
					_bmpAttachment = UIFactory.bitmap(ImagesConst.mailAttach1,198,3,this);
				else
					_bmpAttachment = UIFactory.bitmap(ImagesConst.mailAttach2,198,3,this);
			}
			else
			{
				this._btnGetAttachment.visible = false;
			}
		}
		
		/**
		 * 邮件是不是被勾选 
		 * @return 
		 */
		public function get mailSelected():Boolean
		{
			return _checkBox.selected;
		}
		
		public function set mailSelected(boo:Boolean):void
		{
			_checkBox.selected = boo;
		}
		
		override public function get selected():Boolean
		{
			// TODO Auto Generated method stub
			return super.selected;
		}
		
		override public function set selected(arg0:Boolean):void
		{
			// TODO Auto Generated method stub
			super.selected = arg0;
		}
		
	}
}