package mortal.game.view.guild.tabpanel
{
	import Message.Game.SGuildMember;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
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
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.utils.GuildUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.SortButton;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.guild.cellrender.GuildBranchMembersListCellRenderer;
	import mortal.mvc.core.Dispatcher;
	
	public class GuildBranchManagerPanel extends GuildBasePanel
	{
		private static const PAGE_MEMBER_COUNT:int = 12;
		
		//ascending or descending sort button
		private var _btnSortByLevel:SortButton;
		private var _btnSortByFightpower:SortButton;
		private var _btnSortByWeekContribution:SortButton;
		private var _btnSortByTotalContribution:SortButton;
		private var _btnSortByResource:SortButton;
		
		//good member
		private var _txtGoodMemberNum:GTextFiled;
		
		//page handler
		private var _pageSelecter:PageSelecter;
		
		//members num
		private var _txtMembersNum:GTextFiled;
		private var _txtLeftVacancy:GTextFiled;
		
		//bottm
		private var _btnUpgradeBranch:GButton;
		
		//list
		private var _memberList:GTileList;
		
		private var _sortFunction:Function;
		
		public function GuildBranchManagerPanel()
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
			UIFactory.gTextField(Language.getString(60027),164,73,30,20,this);
			UIFactory.gTextField(Language.getString(60028),225,73,40,20,this);
			UIFactory.gTextField(Language.getString(60012),304,73,54,20,this);
			UIFactory.gTextField(Language.getString(60030),388,73,40,20,this);
			UIFactory.gTextField(Language.getString(60031),463,73,54,20,this);
			UIFactory.gTextField(Language.getString(60032),557,73,40,30,this);
			UIFactory.gTextField(Language.getString(60033),653,73,30,20,this);
			
			//sortbutton
			_btnSortByLevel = UIFactory.sortButton(194,76,this);
			_btnSortByLevel.configEventListener(SortEvent.ASCENDING, onSortChange);
			_btnSortByLevel.configEventListener(SortEvent.DESCENDING, onSortChange);
			
			_btnSortByFightpower = UIFactory.sortButton(265,76,this);
			_btnSortByFightpower.configEventListener(SortEvent.ASCENDING, onSortChange);
			_btnSortByFightpower.configEventListener(SortEvent.DESCENDING, onSortChange);
			
			_btnSortByWeekContribution = UIFactory.sortButton(358,76,this);
			_btnSortByWeekContribution.configEventListener(SortEvent.ASCENDING, onSortChange);
			_btnSortByWeekContribution.configEventListener(SortEvent.DESCENDING, onSortChange);
			
			_btnSortByTotalContribution = UIFactory.sortButton(428,76,this);
			_btnSortByTotalContribution.configEventListener(SortEvent.ASCENDING, onSortChange);
			_btnSortByTotalContribution.configEventListener(SortEvent.DESCENDING, onSortChange);
			
			_btnSortByResource = UIFactory.sortButton(517,76,this);
			_btnSortByResource.configEventListener(SortEvent.ASCENDING, onSortChange);
			_btnSortByResource.configEventListener(SortEvent.DESCENDING, onSortChange);
			
			//good member
			var goodMemberLink:String = "<a href='event:goodMemberLink' target = ''><font color='#00ff00'><u>"
				+ Language.getString(60043) + "</u></font></a>";
			UIFactory.gTextField(goodMemberLink, 44, 460, 100, 22, this, null, true);
			UIFactory.gBitmap(ImagesConst.NumberBg, 133, 450, this);
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 14;
			textFormat.color = 0xffffff;
			_txtGoodMemberNum = UIFactory.gTextField("99", 135, 451.5, 24, 24, this, textFormat);
			
			//page handler
			var textFormat1:GTextFormat = GlobalStyle.textFormatBai;
			textFormat1.align = "center";
			_pageSelecter = UIFactory.pageSelecter(302,460,this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat1);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			_txtMembersNum = UIFactory.gTextField(Language.getString(60044) + ":25/50", 463, 459, 98, 20, this);
			var textFormat2:TextFormat = GlobalStyle.textFormatYellow;
			textFormat2.align = "center";
			_txtLeftVacancy = UIFactory.gTextField("(" + Language.getString(60045) + "12)", 557, 459, 78, 20, this, textFormat2);
			
			//bottom
			_btnUpgradeBranch = UIFactory.gButton(Language.getString(60042),336,493,62,24,this);
			
			//list
			_memberList = UIFactory.tileList(15, 95, 704, 396, this);
			_memberList.rowHeight = 30;
			_memberList.columnWidth = 668;
			_memberList.horizontalGap = 1;
			_memberList.verticalGap = 0;
			_memberList.setStyle("cellRenderer", GuildBranchMembersListCellRenderer);
			
			_sortFunction = GuildUtil.defaultMemberListSortFunc;
		}
		
		override public function update():void
		{
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			guildInfo.branchMemberList.sort(_sortFunction);
			
			_pageSelecter.maxPage = Math.ceil(guildInfo.branchMemberList.length / PAGE_MEMBER_COUNT);
			var startIndex:int = (_pageSelecter.currentPage - 1) * PAGE_MEMBER_COUNT;
			
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0; i < PAGE_MEMBER_COUNT; i++)
			{
				var index:int = startIndex + i;
				if (index >= guildInfo.branchMemberList.length)
					break;
				var memberInfo:SGuildMember = guildInfo.branchMemberList[index];
				dataProvider.addItem(memberInfo);
			}
			
			_memberList.dataProvider = dataProvider;
			_memberList.drawNow();
			
			_txtMembersNum.text = Language.getString(60044) + ":" + guildInfo.branchInfo.playerNum + "/" + guildInfo.branchInfo.maxPlayerNum;
			_txtLeftVacancy.text = "(" + Language.getString(60045) + (guildInfo.branchInfo.maxPlayerNum - guildInfo.branchInfo.playerNum) + ")";
		}
		
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnUpgradeBranch:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_BRANCH_LEVEL_UP, null));
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
				case _btnSortByLevel:
					_sortFunction = GuildUtil.constructMemberListSortFunc("level", event.type, true);
					break;
				case _btnSortByFightpower:
					_sortFunction = GuildUtil.constructMemberListSortFunc("combat", event.type, true);
					break;
				case _btnSortByWeekContribution:
					_sortFunction = GuildUtil.constructMemberListSortFunc("contributionWeek", event.type);
					break;
				case _btnSortByTotalContribution:
					_sortFunction = GuildUtil.constructMemberListSortFunc("totalContribution", event.type);
					break;
				case _btnSortByResource:
					_sortFunction = GuildUtil.constructMemberListSortFunc("resource", event.type);
					break;
			}
		}
	}
}