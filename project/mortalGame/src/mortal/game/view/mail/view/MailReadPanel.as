package mortal.game.view.mail.view
{
	import Message.Game.EMailType;
	import Message.Game.SMail;
	
	import com.gengine.utils.FilterText;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextArea;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import fl.data.DataProvider;
	
	import flash.events.MouseEvent;
	
	import frEngine.loaders.resource.info.image.Image;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.cache.MailCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.common.display.TextBox;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 看邮件面板
	 * @author lizhaoning
	 */
	public class MailReadPanel extends GSprite
	{
		/** 背景 */
		private var _bg:ScaleBitmap;
		/** 正文背景 */
		private var _bg2:ScaleBitmap;
		
		/** 收件人发件人 */
		private var _txtName1:GTextFiled;
		private var _txtName2:TextBox;
		 
		/** 标题 */
		private var _txtTitle1:GTextFiled;
		private var _txtTitle2:TextBox;
		
		/** 内容 */
		private var _txtContent:GTextArea;
		private var _warnBg:ScaleBitmap;
		/** 邮件警告 */
		private var _bmpWarn:GBitmap;
		
		
		//元宝和铜钱
		private var _bmpYuanbao:GBitmap;
		private var _bmpTongqian:GBitmap;
		private var _goldTextBox:TextBox;
		private var _coinTextBox:TextBox;
		
		
		/**物品字样*/
		private var _txtItemStatic:GTextFiled;
		/**物品列表*/
		private var _itemList:GTileList;
		
		private var _line:ScaleBitmap;
		
		/** 提取附件 */
		private var _btnGetAttachment:GButton;
		/** 回复 */
		public var btnReply:GButton;
		
		private var _data:SMail;
		
		public function MailReadPanel()
		{
			super();
		}
		

		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			//背景
			_bg = UIFactory.bg(0,0,311,290,this);
			//文本框
			_txtName1 = UIFactory.textField("发件人：",6,5,54,20,this,null,false,false);
			_txtName1.textColor = 0xFFFFFF;
			_txtTitle1 = UIFactory.textField("标   题：",6,28,54,20,this,null,false,false);
			_txtTitle1.textColor = 0xFFFFFF;
			
			_txtName2 = createTextBox(0,0,242,20);
			_txtName2.x = _txtName1.x + _txtName1.width,_txtName1.y;
			_txtName2.y = _txtName1.y;
			_txtName2._text.selectable = true;
			
			_txtTitle2 = createTextBox(0,0,242,20);
			_txtTitle2.x  = _txtTitle1.x + _txtTitle1.width;
			_txtTitle2.y  = _txtName2.y+24;
			_txtTitle2._text.selectable = true;
			//正文部分
			_bg2 = UIFactory.bg(_txtName1.x+2,_txtTitle1.y+_txtTitle2.height+5,295,155,this,"InputDisablBg");
			_warnBg = UIFactory.bg(_bg2.x,_bg2.y+2,300,19,this,"TextBg");
			_txtContent = UIFactory.textArea("", _txtName1.x+3,74,_bg2.width-2,125,this);
			
			//物品部分
			_txtItemStatic = UIFactory.textField("",10,212,17,40,this,null,false,false);
			_txtItemStatic.wordWrap = true;
			_txtItemStatic.multiline = true;
			_txtItemStatic.textColor = 0xFFFFFF;
			_txtItemStatic.htmlText = "物品";
			_itemList = UIFactory.tileList(30,212,140,43,this);
			_itemList.rowHeight = 42;
			_itemList.columnWidth = 42;
			_itemList.horizontalGap = 1;
			_itemList.verticalGap = 1;
			_itemList.rowCount = 3;
			_itemList.setStyle("cellRenderer",MailAttachRenderer);
			this.addChild(_itemList);
			
			_itemList.selectedIndex=1;
			
			
			//元宝
			_goldTextBox = createTextBox(0,0,92,20);
			_goldTextBox.x = 210;
			_goldTextBox.y = _itemList.y;
			_goldTextBox._text.textColor = GlobalStyle.yellowUint;
			_bmpYuanbao = UIFactory.bitmap(ImagesConst.Yuanbao,185,_goldTextBox.y+3,this);
			//铜钱
			_coinTextBox = createTextBox(0,0,92,20);
			_coinTextBox.x = 210;
			_coinTextBox.y = _goldTextBox.y + 22;
			_goldTextBox._text.textColor = GlobalStyle.yellowUint;
			_bmpTongqian = UIFactory.bitmap(ImagesConst.Jinbi,185,_coinTextBox.y+1,this);
			
			_line = UIFactory.bg(0,257,295,1,this,"SplitLine");
				
			//提取附件
			_btnGetAttachment = UIFactory.gButton("提取附件",236,263,63,22,this);
			
			//回复
			btnReply = UIFactory.gButton("回复",249,263,50,22,this);
			
			//事件监听
			_btnGetAttachment.configEventListener(MouseEvent.CLICK,_btnGetAttachmentClickHandler);
			_itemList.doubleClickEnabled = true;
			_itemList.configEventListener(MouseEvent.DOUBLE_CLICK,itemListDoubleClick);
			
			//刷新界面
			showMail(null);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_data = null;
			
			
			_bg.dispose(isReuse);
			_txtName1.dispose(isReuse);
			_txtTitle1.dispose(isReuse);
			_txtName2.dispose(isReuse);
			_txtTitle2.dispose(isReuse);
			_bg2.dispose(isReuse);
			_warnBg.dispose(isReuse);
			if(_bmpWarn)_bmpWarn.dispose(isReuse);
			_txtContent.dispose(isReuse);
			_txtItemStatic.dispose(isReuse);
			_itemList.dispose(isReuse);
			_goldTextBox.dispose(isReuse);
			_bmpYuanbao.dispose(isReuse);
			_coinTextBox.dispose(isReuse);
			_bmpTongqian.dispose(isReuse);
			_line.dispose(isReuse);
			_btnGetAttachment.dispose(isReuse);
			btnReply.dispose(isReuse);
			
			
			_bg = null;
			_txtName1 = null;
			_txtTitle1 = null;
			_txtName2 = null;
			_txtTitle2 = null;
			_bg2 = null;
			_warnBg = null;
			_bmpWarn = null;
			_txtContent = null;
			_txtItemStatic = null;
			_itemList = null;
			_goldTextBox = null;
			_bmpYuanbao = null;
			_coinTextBox = null;
			_bmpTongqian = null;
			_line = null;
			_btnGetAttachment = null;
			btnReply = null;
		}
		
		
		/**
		 * 显示一封邮件的内容 
		 * 
		 */
		public function showMail(mail:SMail	):void
		{
			this._data = mail;
			
			if(mail == null)  //清空显示
			{
				this._txtName2._text.text = "";
				this._txtTitle2._text.text = "";
				this._txtContent.text = "";
				this._btnGetAttachment.visible = false;
				this.btnReply.visible = false;
				this._coinTextBox._text.text = "";
				this._goldTextBox._text.text = "";
				this._btnGetAttachment.visible = Cache.instance.mail.checkMailhadAttach(mail);
				this._itemList.dataProvider = getDataProvider();
				if(this._bmpWarn)
				{
					this._bmpWarn.dispose();
					this._bmpWarn = null;
				}
				return;
			}
			else if(mail.status == 1)  //未阅读
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MailRead,mail.mailId));
			}
			
			this._txtName2._text.text = this._data.fromPlayerName;
			
			
			var imgName:String;  //邮件警告图片
			if(_data.type == EMailType._EMailTypeSystem)  //系统邮件
			{
				this.btnReply.visible = false;  //系统邮件不能回复
				//系统邮件不需要过滤
				this._txtTitle2._text.text = this._data.title;
				this._txtContent.text = this._data.content;
				
				imgName = ImagesConst.mailSysMail;
			}
			else if(_data.type == EMailType._EMailTypePlayer)  //私人邮件
			{
				this.btnReply.visible = true;  //私人邮件可以回复
				//私人邮件过滤屏蔽字
				this._txtTitle2._text.text = FilterText.instance.getFilterStr(this._data.title);
				this._txtContent.text = FilterText.instance.getFilterStr(this._data.content);
				
				if(Cache.instance.friend.findRecordByRoleId(mail.fromPlayerId) == null)  //陌生人
					imgName = ImagesConst.mailWarn;
				else
					imgName = ImagesConst.mailPersMail;
			}
			if(this._bmpWarn)   //销毁之前的图片
			{
				this._bmpWarn.dispose();
				this._bmpWarn = null;
			}
			this._bmpWarn = UIFactory.bitmap(imgName,0,54,this);
			this._bmpWarn.x = (_bg2.width -_bmpWarn.width)/2;
			
			//附件
			_itemList.dataProvider = getDataProvider();
			_coinTextBox._text.text = _data.attachmentCoin.toString();
			_goldTextBox._text.text = _data.attachmentGold.toString();
			
			this._btnGetAttachment.visible = Cache.instance.mail.checkMailhadAttach(mail);
		}
		
		/**
		 * 检查邮件是不是被删掉了,刷新邮件 
		 * 
		 */
		public function checkMail():void
		{
			if(this._data == null)
			{
				showMail(null);
				return;
			}
			
			if(Cache.instance.mail.getMailByMailId(this._data.mailId) == null)
			{
				showMail(null);
			}
		}
		
		private function getDataProvider():DataProvider
		{
			var dp:DataProvider = new DataProvider();
			for (var i:int = 0; i < _itemList.rowCount; i++) 
			{
				var itemData:*;
				if(_data && i<_data.playerItems.length)
					itemData = new ItemData(_data.playerItems[i]);
				else
					itemData = new Object();
				
				dp.addItem(itemData);
			}
			return dp;
		}
		
		private function createTextBox(row:int,col:int,width:int = 117,height:int = 23):TextBox
		{
			var textbox:TextBox = UICompomentPool.getUICompoment(TextBox);
			textbox.createDisposedChildren();
			textbox.textFieldHeight = 18;
			textbox.textFieldWidth = 80;
			textbox.bgHeight = height;
			textbox.bgWidth = width;
			textbox.x = col*120;
			textbox.y = 38+row*26;
			
			var textFormat:GTextFormat = new GTextFormat();
			textFormat.color = 0xffffff;
			textbox.setbgStlye("InputDisablBg",textFormat);
			this.addChild(textbox);
			
			return textbox;
		}
		
		private function _btnGetAttachmentClickHandler(e:MouseEvent):void  //提取全部附件
		{
			// TODO Auto Generated method stub
			if(Cache.instance.pack.backPackCache.isPackFull())
			{
				MsgManager.showRollTipsMsg("背包已满");
				return;
			}
			if(Cache.instance.pack.backPackCache.getSpareCapacity()<
				Cache.instance.mail.getMailAttachItemCount(this.data))
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
		
		
		private function itemListDoubleClick(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(_data == null)
				return;
			if(_data.playerItems.length<=_itemList.selectedIndex)
				return;
			
			if(Cache.instance.pack.backPackCache.isPackFull())
			{
				MsgManager.showRollTipsMsg("背包已满");
				return;
			}
			
			trace("itemList双击:",_itemList.selectedIndex);
			var obj:Object={};
			obj.mailId = _data.mailId;
			obj.attachementIndex = _itemList.selectedIndex+1;
			obj.isDelete = Cache.instance.mail.mailGetAfterDelete;
			Dispatcher.dispatchEvent(new DataEvent(EventName.MailGetAttachment,obj));
		}
		
		public function get data():SMail
		{
			return _data;
		}
	}
}