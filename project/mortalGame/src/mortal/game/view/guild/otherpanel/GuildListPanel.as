package mortal.game.view.guild.otherpanel
{
	import Message.Game.SMiniGuildInfo;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.guild.cellrender.GuildListCellRenderer;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildListPanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildListPanel = null;
		private static const PAGE_CELL_COUNT:int = 10;
		
		private var _comboBoxFilterCamp:GComboBox;
		private var _checkBoxFilterFullMemberGuild:GCheckBox;
		
		//search zone
		private var _txtSearch:GTextInput;
		private var _btnSearch:GButton;
		private var _btnReset:GButton;
		
		//page handler
		private var _pageSelecter:PageSelecter;
		
		//my guild
		private var _txtMyGuild:GTextFiled;
		private var _txtMyGuildRank:GTextFiled;
		
		//bottom buttom
		private var _btnCreateGuild:GButton;
		private var _btnInviteList:GButton;
		
		//list
		private var _guildList:GTileList;
		
		//是否重置
		
		public function GuildListPanel($layer:ILayer=null)
		{
			super($layer);
			title = "公会列表";
			setSize(690,485);
		}
		
		public static function get instance():GuildListPanel
		{
			if (!_instance)
				_instance = new GuildListPanel();
			return _instance;
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			var obj:Object = new Object();
			obj.camp = Cache.instance.role.roleEntityInfo.entityInfo.camp; 
			obj.guildName = "";
			obj.startIdx = 0;
			obj.isfull = false;
			Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_SEARCH, obj));
			
			super.show(x, y);
		}
		
		override protected function layoutUI():void
		{
			//background
			UIFactory.bg(16, 67, 668, 358, this);
			UIFactory.bg(16, 67, 668, 26, this, ImagesConst.RegionTitleBg);
			
			//topleft camp filter
			UIFactory.gTextField(Language.getString(30217), 24, 42, 40, 20, this, GlobalStyle.textFormatJiang);
			
			var comboBoxItemArr:Array = [{label:Language.getString(60053),type:0}, 
				{label:GameDefConfig.instance.getItem("ECamp", 1).text, type : 1}, 
				{label:GameDefConfig.instance.getItem("ECamp", 2).text, type : 2}, 
				{label:GameDefConfig.instance.getItem("ECamp", 3).text, type : 3}];
			var comboBoxItemData:DataProvider = new DataProvider(comboBoxItemArr);
			_comboBoxFilterCamp = UIFactory.gComboBox(64, 40, 80, 22, comboBoxItemData, this);
			_comboBoxFilterCamp.configEventListener(Event.CHANGE, onCampSelectChange);
			_comboBoxFilterCamp.selectedIndex = Cache.instance.role.roleEntityInfo.entityInfo.camp;
			
			_checkBoxFilterFullMemberGuild = UIFactory.checkBox("过滤满员公会", 37, 423, 120, 24, this);
			
			//search zone
			UIFactory.gTextField(Language.getString(60046) + ":", 354, 42, 65, 20, this, GlobalStyle.textFormatJiang);
			_txtSearch = UIFactory.gTextInput(415, 42, 144, 20, this);
			_btnSearch = UIFactory.gButton(Language.getString(60050),564,40,54,24,this);
			_btnReset = UIFactory.gButton(Language.getString(60051),623,40,54,24,this);
			
			//page handler
			var textFormat1:GTextFormat = GlobalStyle.textFormatBai;
			textFormat1.align = "center";
			_pageSelecter = UIFactory.pageSelecter(290, 400, this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat1);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			//my guild
			var myGuildLink:String = "<a href='event:myGuildLink' target = ''><font color='#00ff00'><u>"
				+ Language.getString(60049) + "</u></font></a>";
			_txtMyGuild = UIFactory.gTextField(myGuildLink, 546, 400, 56, 20, this, null, true);
			var rankStr:String = "<font color='#ffffff'>" + Language.getString(60052) + " : </font><font color='#ffcc00'>108</font>";
			_txtMyGuildRank = UIFactory.gTextField(rankStr, 615, 400, 60, 20, this, null, true);
			
			//tab head
			UIFactory.gTextField(Language.getString(60052),24,71,30,20,this);
			UIFactory.gTextField(Language.getString(60046),88,71,65,20,this);
			UIFactory.gTextField(Language.getString(30217),175,71,30,20,this);
			UIFactory.gTextField(Language.getString(60058),250,71,30,20,this);
			UIFactory.gTextField(Language.getString(60060),330,71,65,20,this);
			UIFactory.gTextField(Language.getString(60059),403,71,65,20,this);
			UIFactory.gTextField(Language.getString(60024),475,71,65,20,this);
			UIFactory.gTextField(Language.getString(60033),598,71,30,30,this);
			
			//bottom button
			_btnCreateGuild = UIFactory.gButton(Language.getString(60047),272,453,64,24,this);
			_btnInviteList = UIFactory.gButton(Language.getString(60048),362,453,64,24,this);
			
			//list
			_guildList = UIFactory.tileList(16, 94, 668, 305, this);
			_guildList.rowHeight = 30;
			_guildList.columnWidth = 668;
			_guildList.horizontalGap = 1;
			_guildList.verticalGap = 0.5;
			_guildList.setStyle("cellRenderer", GuildListCellRenderer);
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			if (!Cache.instance.guild.list)
				return;
			_pageSelecter.maxPage = Cache.instance.guild.totalCount / PAGE_CELL_COUNT == 0 
				? 1 : Math.ceil(Cache.instance.guild.totalCount / PAGE_CELL_COUNT);
			
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0; i < Cache.instance.guild.list.length; i++)
			{
				if (i >= Cache.instance.guild.list.length)
					break;
				var data:SMiniGuildInfo = Cache.instance.guild.list[i];
				dataProvider.addItem(data);
			}
			
			_guildList.dataProvider = dataProvider;
			_guildList.drawNow();
			
			if (!Cache.instance.guild.selfGuildInfo.selfHasJoinGuild)
			{
				_txtMyGuild.visible = _txtMyGuildRank.visible = false;
			}
			else
			{
				_txtMyGuild.visible = _txtMyGuildRank.visible = true;
				_txtMyGuildRank.htmlText = "<font color='#ffffff'>" + Language.getString(60052) + " : </font><font color='#ffcc00'>" + Cache.instance.guild.selfGuildInfo.baseInfo.rank + "</font>";
			}
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnSearch:
					var reg:RegExp = /\S/;
					if (_txtSearch.text.match(reg) == null)
					{
						MsgManager.showRollTipsMsg("搜索内容不能为空，请重新输入!");
						return;
					}
					var obj:Object = new Object();
					obj.camp = _comboBoxFilterCamp.selectedItem == null ? 0 : _comboBoxFilterCamp.selectedItem.type;
					obj.guildName = _txtSearch.text;
					obj.startIdx = 0;
					obj.isfull = _checkBoxFilterFullMemberGuild.selected;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_SEARCH, obj));
					break;
				case _btnReset:
					_txtSearch.text = "";
					_comboBoxFilterCamp.selectedIndex = Cache.instance.role.roleEntityInfo.entityInfo.camp;
					
					obj = new Object();
					obj.camp = Cache.instance.role.roleEntityInfo.entityInfo.camp;
					obj.guildName = "";
					obj.startIdx = 0;
					obj.isfull = _checkBoxFilterFullMemberGuild.selected;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_SEARCH, obj));
					break;
				case _btnCreateGuild:
					GuildCreatePanel.instance.show();
					break;
				case _btnInviteList:
					if (Cache.instance.guild.inviteList.length == 0)
					{
						MsgManager.showRollTipsMsg("无公会发出邀请!");
						return;
					}
					GuildInviteListPanel.instance.show();
					break;
			}
		}
		
		private function onPageChange(event:Event):void
		{
			var curPage:int = _pageSelecter.currentPage;
			var startIndex:int = (curPage - 1) * PAGE_CELL_COUNT;
			var obj:Object = new Object();
			obj.camp = _comboBoxFilterCamp.selectedItem == null ? 0 : _comboBoxFilterCamp.selectedItem.type;
			obj.guildName = _txtSearch.text;
			obj.startIdx = startIndex;
			obj.isfull = _checkBoxFilterFullMemberGuild.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_SEARCH, obj));
		}
		
		private function onCampSelectChange(event:Event):void
		{
			var obj:Object = new Object();
			obj.camp = _comboBoxFilterCamp.selectedItem.type;
			obj.guildName = _txtSearch.text;
			obj.startIdx = 0;
			obj.isfull = _checkBoxFilterFullMemberGuild.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_SEARCH, obj));
			_pageSelecter.currentPage = 1;
		}
		
		
	}
}