package mortal.game.view.mail
{
	import Message.Game.SMail;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.cache.MailCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.mail.view.MailListItem;
	import mortal.game.view.mail.view.MailReadPanel;
	import mortal.game.view.mail.view.MailWritePanel;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 邮件面板
	 * @author lizhaoning
	 */
	public class MailModule extends BaseWindow
	{
		/**背景*/
		private var _middlePaneBg:ScaleBitmap;
		
		/**分组标题数据*/
		private var _tabData:Array;
		
		/**分组导航*/
		private var _tabBar:GTabBar;
		/** 左边邮件列表 */
		private var _mailList:GTileList;
		/** 邮件选中效果 */
		private var _mailSelected:ScaleBitmap;
		/**暂无邮件*/
		private var _txtNoMail:GTextFiled;
		/**分页导航*/
		private var _pageSelecter:PageSelecter;
		
		/**标题数据*/
		private var _writeOrReadTabBarData:Array;
		/** 收件箱，写邮件导航按钮 */
		private var _writeOrReadTabBar:GTabBar;
		
		/** 删除 */
		private var _btnDelte:GButton;
		/** 提取附件 */
		private var _btnGetAttachment:TimeButton;
		/** 全部 */
		private var _allCheckBox:GCheckBox;
		/** 提取后删除 */
		private var _checkBox1:GCheckBox;
		/**看邮件面板*/
		public var mailReadPanel:MailReadPanel;
		/**写邮件面板*/
		public var mailWritePanel:MailWritePanel;
		/** GM提示 */
		private var _txtGMTip:GTextFiled;
		
		public var uiLoadComplete:Boolean = false;
		private var _mailCache:MailCache;
		
		//默认打开写邮件界面
		private var _openWritePanel:Boolean = false;
		public function MailModule($layer:ILayer=null)
		{
			super($layer);
			
			init();
			this.layer = LayerManager.windowLayer;
		}
		
		public function init():void
		{
			_mailCache = Cache.instance.mail;
			_tabData = Language.getArray(50002);
			_writeOrReadTabBarData = [{"label":"收件箱","name":"inbox"},{"label":"写邮件","name":"write"}];
			setSize(635,420);
			title = Language.getString(50001);
			titleHeight = 60;
			//titleIcon = ImagesConst.PackIcon;
			this.isHideDispose = true;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			LoaderHelp.addResCallBack(ResFileConst.mail, showSkin);
		}
		private function showSkin():void
		{
			//背景
			_middlePaneBg = UIFactory.bg(15,67,298,311,this);
			
			//导航 收件箱、未读、已读等
			_tabBar = UIFactory.gTabBar(15,35,_tabData,85,26,this,tabBarChangeHandler);
			
			_txtNoMail = UIFactory.gTextField("暂无邮件",135,200,60,25,this);
			_txtNoMail.textColor = GlobalStyle.redUint;
			
			//邮件列表
			_mailList = UIFactory.tileList(21,75,289,269,this);
			_mailList.rowHeight = 52;
			_mailList.columnWidth = 287;
			_mailList.rowCount  = 5;
			_mailList.horizontalGap = 1;
			_mailList.verticalGap = 2;
			_mailList.setStyle("cellRenderer", MailListItem);
			addChild(_mailList);
			
			_mailSelected = UIFactory.bg(-3,-3,291,54,_mailList,ImagesConst.selectFilter);
			_mailSelected.visible = false;
			
			
			//页码选择器
			_pageSelecter = UIFactory.pageSelecter(131,354,this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg,new GTextFormat);
			_pageSelecter.maxPage = 1;
			_pageSelecter.pageTextBoxSize = 36;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			//删除按钮
			_btnDelte = UIFactory.gButton("删除",73,349,55,22,this);
			//提取按钮
			_btnGetAttachment = UIFactory.timeButton("一键提取",242,349,65,22,this);
			_btnGetAttachment.cdTime = 10000;
			
			_allCheckBox = UIFactory.checkBox("全部",28,347,50,28,this);
			
			_checkBox1 = UIFactory.checkBox("提取后删除",28,377,100,28,this);
			if(_mailCache)  //还原勾选
			{
				_checkBox1.selected = _mailCache.mailGetAfterDelete;
			}
			
			_txtGMTip = UIFactory.textField("GM提示：切勿相信索取账号密码/家族/免费等相关的信息",160,381,350,20,this);
			_txtGMTip.textColor = GlobalStyle.greenUint;
			
			//收件箱，发邮件导航按钮
			_writeOrReadTabBar = UIFactory.gTabBar(_middlePaneBg.x +_middlePaneBg.width+6,_middlePaneBg.y+1,_writeOrReadTabBarData,57,22,this,onWriteOrReadChange,"PageBtn");
			
			
			_mailList.configEventListener(Event.CHANGE,lisetSecletHandler);
			
			_allCheckBox.configEventListener(MouseEvent.CLICK,btnAllClickHandler);
			_checkBox1.configEventListener(MouseEvent.CLICK,checkBox1ClickHandler);
			_btnDelte.configEventListener(MouseEvent.CLICK,btnDeleteClickHandler);
			_btnGetAttachment.configEventListener(MouseEvent.CLICK,btnGetAttachHandler);
			
			//初始化看邮件或写邮件界面
			if(_openWritePanel)
			{
				_writeOrReadTabBar.selectedIndex = 1;
			}
			else
			{
				_writeOrReadTabBar.selectedIndex = 0;
			}
			onWriteOrReadChange();
			
			_mailList.selectable = true;
			
			if(!uiLoadComplete)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MailQueryAll));   //界面初始化完成请求数据
				uiLoadComplete = true;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_openWritePanel = false;
			_readOrWrite = 0;
			_toPlayerName = "";
			
			_middlePaneBg.dispose(isReuse);
			_tabBar.dispose(isReuse);
			_txtNoMail.dispose(isReuse);
			_mailSelected.dispose(isReuse);
			_mailList.dispose(isReuse);
			_pageSelecter.dispose(isReuse);
			_btnDelte.dispose(isReuse);
			_btnGetAttachment.dispose(isReuse);
			_allCheckBox.dispose(isReuse);
			_checkBox1.dispose(isReuse);
			_txtGMTip.dispose(isReuse);
			_writeOrReadTabBar.dispose(isReuse);
			if(mailReadPanel)
			{
				this.mailReadPanel.visible = this.mailReadPanel.mouseEnabled = this.mailReadPanel.mouseChildren = true;
				mailReadPanel.dispose(isReuse);
			}
			if(mailWritePanel)
			{
				this.mailWritePanel.visible = this.mailWritePanel.mouseEnabled = this.mailWritePanel.mouseChildren = true;
				mailWritePanel.dispose(isReuse);
			}
			
			_middlePaneBg = null;
			_tabBar = null;
			_txtNoMail = null;
			_mailSelected = null;
			_mailList = null;
			_pageSelecter = null;
			_btnDelte = null;
			_btnGetAttachment = null;
			_allCheckBox = null;
			_checkBox1 = null;
			_txtGMTip = null;
			_writeOrReadTabBar = null;
			mailReadPanel = null;
			mailWritePanel = null;
		}
		
		private function lisetSecletHandler(e:Event):void   //选中邮件改变
		{
			// TODO Auto Generated method stub
			
			if(_mailList.selectedIndex<0 || _mailList.selectedIndex>_mailList.rowCount -1 )
			{
				_mailSelected.visible = false;
				return;
			}
			
			var m:MailListItem = (_mailList.itemToCellRenderer(_mailList.selectedItem)) as MailListItem;
			_mailSelected.x = m.x;
			_mailSelected.y = m.y;
			_mailSelected.visible = true;
			_mailList.addChild(_mailSelected);
			
			openOneMail(_mailList.selectedIndex);
			
			_writeOrReadTabBar.selectedIndex = 0;
			onWriteOrReadChange(null);
			
			trace(_mailList.selectedIndex);
		}		
		
		private function tabBarChangeHandler(e:MuiEvent = null):void
		{
			_pageSelecter.currentPage = 1;
			
			queryMail();
		}
		public function queryMail():void
		{
			var startIndex:int = (_pageSelecter.currentPage-1)*_mailList.rowCount;
			
			if(startIndex > _mailCache.mailTotalCount-1)
			{
				startIndex = (startIndex-_mailList.rowCount)<0?0:startIndex-_mailList.rowCount;
			}
			
			switch(_tabBar.selectedIndex)
			{
				case 0:
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailQueryAll,startIndex));  
					break;
				case 1:
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailQueryUnread,startIndex));
					break;
				case 2:
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailQueryRead,startIndex));
					break;
				case 3:
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailQuerySys,startIndex));
					break;
				case 4:
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailQueryPers,startIndex));
					break;
			}
		}
		
		private function onPageChange(e:Event):void  //翻页
		{
			clearMailSelect();
			
			_pageSelecter.mouseEnabled = _pageSelecter.mouseChildren = false;
			queryMail();
			//updateMailList();
		}
		
		/**更新邮件列表*/
		public function updateMailList(openAMail:Boolean = false):void
		{
			_pageSelecter.mouseEnabled = _pageSelecter.mouseChildren = true;
			
			//clearMailSelect();
			if(_mailList == null)
				return;
			
			_mailList.dataProvider = getDataProvider1();
			_mailList.drawNow();
			
			//默认不选中
			_mailList.selectedIndex = -1;
			//还原选中
			if(mailReadPanel && mailReadPanel.data)
			{
				for (var i:int = 0; i < _mailList.dataProvider.length; i++) 
				{
					var data:SMail = _mailList.getItemAt(i) as SMail;
					if(data.mailId == mailReadPanel.data.mailId)
					{
						_mailList.selectedIndex = i;
					}
				}
			}
			lisetSecletHandler(null);
			
			
			//设置页数
			updatePageSeleter();
			
			_txtNoMail.visible = Boolean(_mailList.dataProvider.length==0);
			
			//默认打开一封邮件
			if(openAMail)
				openOneMail(_mailList.selectedIndex);
		}
		
		/**
		 * 更新页码选择器的页码 
		 */
		public function updatePageSeleter():void
		{
			this._pageSelecter.maxPage = Math.ceil(_mailCache.mailTotalCount/_mailList.rowCount);
			this._pageSelecter.currentPage = Math.ceil((_mailCache.mailStartIndex+1)/_mailList.rowCount); 
		}
		
		public function openOneMail(selectedIndex:int = 0):void
		{
			if(_mailList.selectedIndex == -1)
			{
				this.mailReadPanel.showMail(null);
				return;
			}
			
			if(_mailList.dataProvider.length>0)
				this.mailReadPanel.showMail(_mailList.dataProvider.getItemAt(selectedIndex) as SMail);
			else
				this.mailReadPanel.showMail(null);
		}
		
		public function clearMailSelect():void
		{
			for (var i:int = 0; i < _mailList.length; i++)   //清空选中
			{
				var m:MailListItem = (_mailList.itemToCellRenderer(_mailList.getItemAt(i))) as MailListItem;
				if(m)m.mailSelected = false;
			}
			this._allCheckBox.selected = false;
		}
		
		private var _readOrWrite:int = 0;
		private function onWriteOrReadChange(e:MuiEvent = null):void
		{
			if(_writeOrReadTabBar.selectedIndex == 0)  //看邮件
				readOrWrite = 1;
			else if(_writeOrReadTabBar.selectedIndex == 1)  //写邮件
				readOrWrite = 2;
		}
		/** 看邮件还是写邮件 看1   写 2*/
		public function set readOrWrite(value:int):void
		{
			if(_readOrWrite == value)
				return;
			
			_readOrWrite = value;
			
			if(_readOrWrite == 1)  //看邮件
			{
				if(mailWritePanel)
				{
					this.mailWritePanel.visible = this.mailWritePanel.mouseEnabled = this.mailWritePanel.mouseChildren = false;
				}
				if(mailReadPanel == null)
				{
					mailReadPanel = UICompomentPool.getUICompoment(MailReadPanel);
					mailReadPanel.createDisposedChildren();
					mailReadPanel.x = _middlePaneBg.x +_middlePaneBg.width+2;
					mailReadPanel.y = _writeOrReadTabBar.y + 22;
					this.addChild(mailReadPanel);
					mailReadPanel.btnReply.configEventListener(MouseEvent.CLICK,bntReplyClickHandler,false,0,true);
				}
				this.mailReadPanel.visible = this.mailReadPanel.mouseEnabled = this.mailReadPanel.mouseChildren = true;
			}
			else  if(_readOrWrite == 2)  //写邮件
			{
				if(mailReadPanel)
				{
					this.mailReadPanel.visible = this.mailReadPanel.mouseEnabled = this.mailReadPanel.mouseChildren = false;
				}
				if(mailWritePanel == null)
				{
					mailWritePanel = UICompomentPool.getUICompoment(MailWritePanel);
					mailWritePanel.createDisposedChildren();
					mailWritePanel.x = _middlePaneBg.x +_middlePaneBg.width+2;
					mailWritePanel.y = _writeOrReadTabBar.y + 22;
					this.addChild(mailWritePanel);
				}
				this.mailWritePanel.visible = this.mailWritePanel.mouseEnabled = this.mailWritePanel.mouseChildren = true;
				mailWritePanel.setToPlyerName(_toPlayerName);
			}
		}
		
		private var _toPlayerName:String = "";
		private function bntReplyClickHandler(e:MouseEvent):void   //回复
		{
			// TODO Auto Generated method stub
			_toPlayerName = mailReadPanel.data.fromPlayerName;
			_writeOrReadTabBar.selectedIndex = 1;
			onWriteOrReadChange(null);
		}
		
		private function getDataProvider1():DataProvider
		{
			var dp:DataProvider = new DataProvider();
			
			var dataVec:Vector.<SMail> = _mailCache.mailVec;
			
			var count:int = _mailList.rowCount;
			if(dataVec.length)
			{
				var endIndex:int = Math.min(count,dataVec.length);
				for (var i:int = 0; i < endIndex; i++) 
				{
					dp.addItem(dataVec[i]);
				}
			}
			return dp;
		}
		
		private function checkBox1ClickHandler(e:MouseEvent):void  //提取后删除按钮点击
		{
			// TODO Auto Generated method stub
			_mailCache.mailGetAfterDelete = _checkBox1.selected;
		}
		
		private function btnAllClickHandler(e:MouseEvent):void  //全选按钮
		{
			// TODO Auto Generated method stub
			for (var i:int = 0; i < _mailList.length; i++) 
			{
				var m:MailListItem = (_mailList.itemToCellRenderer(_mailList.getItemAt(i))) as MailListItem;
				m.mailSelected = _allCheckBox.selected;
			}
		}
		/** 一键删除邮件 */
		private function btnDeleteClickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			var boo:Boolean = false;  //记录勾选的邮件中是不是有未提取附件的邮件，如果有，则给予提示
			
			var arr:Array = [];
			//获取勾选的邮件ID数组
			for (var i:int = 0; i < _mailList.length; i++) 
			{
				var data:SMail = _mailList.getItemAt(i) as SMail;
				var m:MailListItem = _mailList.itemToCellRenderer(data) as MailListItem;
				if(m.mailSelected)
				{
					arr.push(data.mailId);
				}
			}
			
			if(arr.length==0)
			{
				MsgManager.showRollTipsMsg("未选中任何邮件");
				return;
			}
			if(arr.length == 1)  //只有一封邮件时，判断有没有附件然后弹框
			{
				if(_mailCache.checkMailhadAttach(_mailCache.getMailByMailId(arr[0])))
					Alert.show("不能删除含物品或金钱的信件",null,Alert.OK,this,null);
				else
					Alert.show("你确定要删除该邮件吗？",null,Alert.OK|Alert.CANCEL,this,onSelect);
			}
			else
			{
				Alert.show("你确定要删除邮件吗？",null,Alert.OK|Alert.CANCEL,this,onSelect);
			}
			
			function onSelect(type:int):void
			{
				for (var j:int = arr.length-1; j > -1; j--)   //过滤掉有附件的邮件ID
				{
					if(_mailCache.checkMailhadAttach(_mailCache.getMailByMailId(arr[j])))
					{
						arr.splice(j,1);
						boo = true;
					}
				}
				
				if(arr.length == 0)
				{
					MsgManager.showRollTipsMsg("没有可删除的邮件");
					return;
				}
				
				if(type == Alert.OK)
				{
					var obj:Object={};
					obj.boo = boo;
					obj.arr = arr;
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailDelete,obj));
				}
			}
		}
		/** 一键获取附件 */
		private function btnGetAttachHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			//if()
			var arr:Array = [];
			for (var i:int = 0; i < _mailCache.mailVec.length; i++) 
			{
				arr.push(_mailCache.mailVec[i].mailId);
			}
			if(arr.length==0)
			{
				MsgManager.showRollTipsMsg("暂无邮件");
				return;
			}
			if(Cache.instance.pack.backPackCache.isPackFull())
			{
				MsgManager.showRollTipsMsg("背包已满");
				return;
			}
			
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.MailGetAttachments,arr));
		}
		
		public function openWritePanelFunc(name:String):void
		{
			_toPlayerName = name;
			this._openWritePanel = true;
		}
		
	}
}