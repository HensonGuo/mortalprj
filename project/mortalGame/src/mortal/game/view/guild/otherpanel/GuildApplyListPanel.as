package mortal.game.view.guild.otherpanel
{
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.guild.cellrender.GuildApplyListCellRenderer;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildApplyListPanel extends GuildOtherBasePanel
	{
		private static const PAGE_MEMBER_COUNT:int = 10;
		private static var _instance:GuildApplyListPanel = null;
		
		//page handler
		private var _pageSelecter:PageSelecter;
		
		//button
		private var _btnRejectAll:GButton;
		private var _btnAgreeAll:GButton;
		
		//list
		private var _applyList:GTileList;
		
		public function GuildApplyListPanel($layer:ILayer=null)
		{
			super($layer);
			setSize(550,402);
			title = "申请列表";
		}
		
		public static function get instance():GuildApplyListPanel
		{
			if (!_instance)
				_instance = new GuildApplyListPanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			//background
			UIFactory.bg(12, 30, 537, 26, this, ImagesConst.RegionTitleBg);
			
			//tab head
			UIFactory.gTextField(Language.getString(60066),54,34,54,20,this);
			UIFactory.gTextField(Language.getString(60027),180,34,30,20,this);
			UIFactory.gTextField(Language.getString(60067),268,34,30,20,this);
			UIFactory.gTextField(Language.getString(60036),354,34,45,20,this);
			UIFactory.gTextField(Language.getString(60033),473,34,30,20,this);
			
			//page handler
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.align = "center";
			_pageSelecter = UIFactory.pageSelecter(217, 375, this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			//button
			_btnAgreeAll = UIFactory.gButton(Language.getString(60068),375,373,64,24,this);
			_btnRejectAll = UIFactory.gButton(Language.getString(60069),449,373,64,24,this);
			
			//list
			_applyList = UIFactory.tileList(13, 58, 530, 306, this);
			_applyList.rowHeight = 30.5;
			_applyList.columnWidth = 668;
			_applyList.horizontalGap = 1;
			_applyList.verticalGap = 0.5;
			_applyList.setStyle("cellRenderer", GuildApplyListCellRenderer);
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			if (guildInfo.applyMemberList == null)
				return;
			guildInfo.applyMemberList.sort(applyMemberSortFunc);
			_pageSelecter.maxPage = Math.ceil(guildInfo.applyMemberList.length / PAGE_MEMBER_COUNT);
			var startIndex:int = (_pageSelecter.currentPage - 1) * PAGE_MEMBER_COUNT;
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0; i < PAGE_MEMBER_COUNT; i++)
			{
				var index:int = startIndex + i;
				if (index >= guildInfo.applyMemberList.length)
					break;
				var applyMemberInfo:SMiniPlayer = guildInfo.applyMemberList[index];
				dataProvider.addItem(applyMemberInfo);
			}
			
			_applyList.dataProvider = dataProvider;
			_applyList.drawNow();
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnRejectAll:
					var obj:Object = new Object();
					obj.playerID = 0;
					obj.agree = false;
					obj.handleAll = true;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DEAL_APPLY, obj));
					break;
				case _btnAgreeAll:
					obj = new Object();
					obj.playerID = 0;
					obj.agree = true;
					obj.handleAll = true;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DEAL_APPLY, obj));
					break;
			}
		}
		
		private function onPageChange(event:Event):void
		{
			update();
		}
		
		private function applyMemberSortFunc(player1:SMiniPlayer, player2:SMiniPlayer):Number
		{
			if (player1.online && !player2.online)
				return -1;
			if (!player1.online && player2.online)
				return 1;
			return 0;
		}
		
	}
}