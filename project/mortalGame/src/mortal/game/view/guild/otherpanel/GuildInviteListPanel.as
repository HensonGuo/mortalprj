/**
 * 帮会邀请面板
 *
 */

package mortal.game.view.guild.otherpanel
{
	import Message.Game.SMiniGuildInfo;
	
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
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.guild.cellrender.GuildInviteListCellRenderer;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildInviteListPanel extends GuildOtherBasePanel
	{
		private static const PAGE_MEMBER_COUNT:int = 10;
		private static var _instance:GuildInviteListPanel = null;
		
		//page handler
		private var _pageSelecter:PageSelecter;
		
		//button
		private var _btnRejectAll:GButton;
		
		//list
		private var _inviteList:GTileList;
		
		public function GuildInviteListPanel($layer:ILayer=null)
		{
			super($layer);
			setSize(546,402);
			title = "邀请列表";
		}
		
		public static function get instance():GuildInviteListPanel
		{
			if (!_instance)
				_instance = new GuildInviteListPanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			//background
			UIFactory.bg(11.5, 30, 532.5, 26, this, ImagesConst.RegionTitleBg);
			
			//tab head
			UIFactory.gTextField(Language.getString(60046),42,34,54,20,this);
			UIFactory.gTextField(Language.getString(30217),132,34,30,20,this);
			UIFactory.gTextField(Language.getString(60058),212,34,30,20,this);
			UIFactory.gTextField(Language.getString(60060),294,34,54,20,this);
			UIFactory.gTextField(Language.getString(60073),370,34,54,20,this);
			UIFactory.gTextField(Language.getString(60033),470,34,30,20,this);
			
			//page handler
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.align = "center";
			_pageSelecter = UIFactory.pageSelecter(215, 375, this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			//button
			_btnRejectAll = UIFactory.gButton(Language.getString(60069),375,373,64,24,this);
			
			//list
			_inviteList = UIFactory.tileList(13, 58, 530, 306, this);
			_inviteList.rowHeight = 30.5;
			_inviteList.columnWidth = 668;
			_inviteList.horizontalGap = 1;
			_inviteList.verticalGap = 0.5;
			_inviteList.setStyle("cellRenderer", GuildInviteListCellRenderer);
		}
		
		override public function update():void
		{
			var list:Array = Cache.instance.guild.inviteList;
			_pageSelecter.maxPage = Math.ceil(list.length / PAGE_MEMBER_COUNT);
			var startIndex:int = (_pageSelecter.currentPage - 1) * PAGE_MEMBER_COUNT;
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0; i < PAGE_MEMBER_COUNT; i++)
			{
				var index:int = startIndex + i;
				if (index >= list.length)
					break;
				var inviteInfo:SMiniGuildInfo = list[index];
				dataProvider.addItem(inviteInfo);
			}
			
			_inviteList.dataProvider = dataProvider;
			_inviteList.drawNow();
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnRejectAll:
					//直接移除客户端缓存数据，服务器不做数据存储的
					Cache.instance.guild.removeInviteInfo(0, true);
					update();
					break;
			}
		}
		
		private function onPageChange(event:Event):void
		{
			update();
		}
	}
}