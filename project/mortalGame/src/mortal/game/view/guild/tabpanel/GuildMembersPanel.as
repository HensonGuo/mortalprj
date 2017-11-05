package mortal.game.view.guild.tabpanel
{
	import Message.Game.EGuildPosition;
	import Message.Game.SGuildMember;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.SortEvent;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.GuildConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.utils.GuildUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.SortButton;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.guild.cellrender.GuildMembersListCellRenderer;
	import mortal.game.view.guild.otherpanel.GuildAppointPanel;
	import mortal.mvc.core.Dispatcher;
	
	public class GuildMembersPanel extends GuildBasePanel
	{
		private static const PAGE_MEMBER_COUNT:int = 12;
		
		//ascending or descending sort button
		private var _btnSortByPosition:SortButton;
		private var _btnSortByLevel:SortButton;
		private var _btnSortByFightpower:SortButton;
		private var _btnSortByTodayContribution:SortButton;
		private var _btnSortByWeekContribution:SortButton;
		private var _btnSortByTotalContribution:SortButton;
		private var _btnSortByActive:SortButton;
		
		//good member
		private var _txtGoodMemberNum:GTextFiled;
		
		//page handler
		private var _pageSelecter:PageSelecter;
		
		//members num
		private var _txtMembersNum:GTextFiled;
		private var _txtLeftVacancy:GTextFiled;
		
		//bottom
		private var _btnRecruit:GButton;
		private var _btnExitGuild:GButton;
		private var _btnDisbandGuild:GButton;
		private var _btnPositonOprate:GButton;
		private var _btnKickOutMember:GButton;
		
		//list
		private var _memberList:GTileList;
		
		private var _sortFunction:Function;
		 
		public function GuildMembersPanel()
		{
			super(ResFileConst.guildOtherPanel);
		}
		
		override protected function layoutUI():void
		{
			//background
			UIFactory.bg(17, 69, 703, 420, this);
			UIFactory.bg(17, 69, 703, 26, this, ImagesConst.RegionTitleBg);
			
			//tab head
			UIFactory.gTextField(Language.getString(60026),53,73,54,20,this);
			UIFactory.gTextField(Language.getString(60034),164,73,30,20,this);
			UIFactory.gTextField(Language.getString(60035),225,73,65,20,this);
			UIFactory.gTextField(Language.getString(60036),310,73,40,20,this);
			UIFactory.gTextField(Language.getString(60037),380,73,54,20,this);
			UIFactory.gTextField(Language.getString(60029),458,73,54,20,this);
			UIFactory.gTextField(Language.getString(60030),536,73,40,20,this);
			UIFactory.gTextField(Language.getString(60038),604,73,40,20,this);
			UIFactory.gTextField(Language.getString(60032),674,73,40,30,this);
			
			//sortbutton
			_btnSortByPosition = UIFactory.sortButton(194,76,this);
			_btnSortByPosition.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByPosition.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			_btnSortByLevel = UIFactory.sortButton(285,76,this);
			_btnSortByLevel.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByLevel.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			_btnSortByFightpower = UIFactory.sortButton(350,76,this);
			_btnSortByFightpower.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByFightpower.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			_btnSortByTodayContribution = UIFactory.sortButton(434,76,this);
			_btnSortByTodayContribution.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByTodayContribution.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			_btnSortByWeekContribution = UIFactory.sortButton(512,76,this);
			_btnSortByWeekContribution.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByWeekContribution.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			_btnSortByTotalContribution = UIFactory.sortButton(576,76,this);
			_btnSortByTotalContribution.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByTotalContribution.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			_btnSortByActive = UIFactory.sortButton(644,76,this);
			_btnSortByActive.configEventListener(SortEvent.DESCENDING, onSortChange);
			_btnSortByActive.configEventListener(SortEvent.ASCENDING, onSortChange);
			
			
			//good member
			var goodMemberLink:String = "<a href='event:goodMemberLink' target = ''><font color='#00ff00'><u>"
				+ Language.getString(60039) + "</u></font></a>";
			UIFactory.gTextField(goodMemberLink, 44, 460, 100, 22, this, null, true);
			UIFactory.gBitmap(ImagesConst.NumberBg, 133, 450, this);
			var textFormat:TextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 14;
			_txtGoodMemberNum = UIFactory.gTextField("99", 135, 451.5, 24, 24, this, textFormat);
			
			//page handler
			var textFormat2:GTextFormat = GlobalStyle.textFormatBai;
			textFormat2.align = "center";
			_pageSelecter = UIFactory.pageSelecter(302,460,this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat2);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			//membersnum
			_txtMembersNum = UIFactory.gTextField(Language.getString(60040) + ":25/50", 463, 459, 98, 20, this);
			_txtLeftVacancy = UIFactory.gTextField("(" + Language.getString(60041) + "12)", 557, 459, 78, 20, this, textFormat2);
			
			//bottom
			_btnRecruit = UIFactory.gButton(Language.getString(60003),100,493,62,24,this);
			_btnPositonOprate = UIFactory.gButton("职位任命", 220, 493, 62, 24, this);
			_btnExitGuild = UIFactory.gButton(Language.getString(60004),337,493,62,24,this);
			_btnDisbandGuild = UIFactory.gButton(Language.getString(60005),455,493,62,24,this);
			_btnKickOutMember = UIFactory.gButton("踢出公会", 572, 493, 62, 24, this);
			
			//list
			_memberList = UIFactory.tileList(15, 95, 704, 396, this);
			_memberList.rowHeight = 30;
			_memberList.columnWidth = 668;
			_memberList.horizontalGap = 1;
			_memberList.verticalGap = 0;
			_memberList.setStyle("cellRenderer", GuildMembersListCellRenderer);
			
			_sortFunction = GuildUtil.defaultMemberListSortFunc;
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			guildInfo.memberList.sort(_sortFunction);
			
			_pageSelecter.maxPage = Math.ceil(guildInfo.memberList.length / PAGE_MEMBER_COUNT);
			var startIndex:int = (_pageSelecter.currentPage - 1) * PAGE_MEMBER_COUNT;
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0; i < PAGE_MEMBER_COUNT; i++)
			{
				var index:int = startIndex + i;
				if (index >= guildInfo.memberList.length)
					break;
				var memberInfo:SGuildMember = guildInfo.memberList[index];
				dataProvider.addItem(memberInfo);
			}
			
			_memberList.dataProvider = dataProvider;
			_memberList.drawNow();
			
			_txtMembersNum.text = Language.getString(60040) + ":" + guildInfo.memberList.length + "/" + guildInfo.baseInfo.maxPlayerNum;
			_txtLeftVacancy.text = "(" + Language.getString(60041) + (guildInfo.baseInfo.maxPlayerNum - guildInfo.baseInfo.playerNum) + ")";
			
			//set button visible
			_btnPositonOprate.visible 		= GuildConst.hasPermissions(GuildConst.ManagerMembers);
			_btnDisbandGuild.visible 		= GuildConst.hasPermissions(GuildConst.DisbandGuild);
			_btnRecruit.visible 			= GuildConst.hasPermissions(GuildConst.Recruit);
			_btnKickOutMember.visible 		= GuildConst.hasPermissions(GuildConst.KickOutMember);
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnRecruit:
					break;
				case _btnExitGuild:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_EXIT, null));
					break;
				case _btnDisbandGuild:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DISBAND, null));
					break;
				case _btnPositonOprate:
					if (_memberList.selectedIndex == -1)
					{
						MsgManager.showRollTipsMsg("请先选择一个公会成员!");
						return;
					}
					var memberInfo:SGuildMember = _memberList.dataProvider.getItemAt(_memberList.selectedIndex) as SGuildMember;
					GuildAppointPanel.instance.setMemberData(memberInfo);
					GuildAppointPanel.instance.show();
					break;
				case _btnKickOutMember:
					if (_memberList.selectedIndex == -1)
					{
						MsgManager.showRollTipsMsg("请先选择一个公会成员!");
						return;
					}
					memberInfo = _memberList.dataProvider.getItemAt(_memberList.selectedIndex) as SGuildMember;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_KICK_OUT_MEMEBER, memberInfo.miniPlayer.entityId.id));
					break;
			}
		}
		
		private function onPageChange(event:Event):void
		{
			update();
		}
		
		private function onSortChange(event:SortEvent):void
		{
			switch(event.target)
			{
				case _btnSortByPosition:
					_sortFunction = GuildUtil.constructMemberListSortFunc("position", event.type);
					break;
				case _btnSortByLevel:
					_sortFunction = GuildUtil.constructMemberListSortFunc("level", event.type, true);
					break;
				case _btnSortByFightpower:
					_sortFunction = GuildUtil.constructMemberListSortFunc("combat", event.type, true);
					break;
				case _btnSortByTodayContribution:
					_sortFunction = GuildUtil.constructMemberListSortFunc("contributionDay", event.type);
					break;
				case _btnSortByWeekContribution:
					_sortFunction = GuildUtil.constructMemberListSortFunc("contributionWeek", event.type);
					break;
				case _btnSortByTotalContribution:
					_sortFunction = GuildUtil.constructMemberListSortFunc("totalContribution", event.type);
					break;
				case _btnSortByActive:
					_sortFunction = GuildUtil.constructMemberListSortFunc("activity", event.type);
					break;
			}
			update();
		}
		
	}
}