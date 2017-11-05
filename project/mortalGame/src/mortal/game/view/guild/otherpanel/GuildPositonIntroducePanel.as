package mortal.game.view.guild.otherpanel
{
	import Message.DB.Tables.TGuildLevelTarget;
	
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.GuildLevelTargetConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.guild.cellrender.GuildPositionCellRenderer;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildPositonIntroducePanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildPositonIntroducePanel = null;
		private static const PAGE_CELL_COUNT:int = 10;
		//list
		private var _list:GTileList;
		private var _pageSelecter:PageSelecter;
		
		public function GuildPositonIntroducePanel($layer:ILayer=null)
		{
			super($layer);
			setSize(474,470);
			title = "公会职位介绍";
		}
		
		public static function get instance():GuildPositonIntroducePanel
		{
			if (!_instance)
				_instance = new GuildPositonIntroducePanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			//background
			UIFactory.bg(16, 37, 452, 389, this);
			UIFactory.bg(16, 37, 452, 26, this, ImagesConst.RegionTitleBg);
			
			//tab head
			UIFactory.gTextField("公会等级",18,40,54,20,this);
			UIFactory.gTextField("副会长数量",102,40,30,20,this);
			UIFactory.gTextField("长老数量",175,40,65,20,this);
			UIFactory.gTextField("精英数量",257,40,40,20,this);
			UIFactory.gTextField("职位介绍",365,40,54,20,this);
			
			//list
			_list = UIFactory.tileList(16, 64, 294, 210, this);
			_list.rowHeight = 20;
			_list.columnWidth = 304;
			_list.horizontalGap = 1;
			_list.verticalGap = 0.5;
			_list.setStyle("cellRenderer", GuildPositionCellRenderer);
			
			//page handler
			var textFormat1:GTextFormat = GlobalStyle.textFormatBai;
			textFormat1.align = "center";
			_pageSelecter = UIFactory.pageSelecter(100, 268, this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat1);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			//positon permissions
			var txtFmt:GTextFormat = GlobalStyle.textFormatChen;
			txtFmt.size = 13;
			UIFactory.gTextField("会长权限",36,290,60,20,this, txtFmt);
			var txtFmtN:GTextFormat = GlobalStyle.textFormatPutong;
			var leaderTxt:GTextFiled = UIFactory.gTextField("公会管理\n成员管理\n仓库管理\n建筑升级\n副本开启\n活动开启",36,312,60,130,this, txtFmtN);
			leaderTxt.multiline = true;
			leaderTxt.wordWrap = true;
			
			txtFmt = GlobalStyle.textFormatDarkRed;
			txtFmt.size = 13;
			UIFactory.gTextField("副会长权限",126,290,70,20,this, txtFmt);
			var deputyLeaderTxt:GTextFiled = UIFactory.gTextField("成员管理\n仓库管理\n建筑升级\n副本开启\n活动开启",126,312,60,100,this, txtFmtN);
			deputyLeaderTxt.multiline = true;
			deputyLeaderTxt.wordWrap = true;
			
			txtFmt = GlobalStyle.textFormatItemBlue;
			txtFmt.size = 13;
			UIFactory.gTextField("长老权限",216,290,60,20,this, txtFmt);
			var prestyerTxt:GTextFiled = UIFactory.gTextField("成员管理\n副本开启\n活动开启",216,312,60,100,this, txtFmtN);
			prestyerTxt.multiline = true;
			prestyerTxt.wordWrap = true;
			
			//postion describle
			var html:String = "<font size='12' color='#FF5a00'>会长：</font>" +
				"<font size='12' color='#ffffff'>本会职位最高管理者，可任命任何职位，拥有最高权限，是公会形象的最高代表" +
				"，一举一动影响公会的荣辱存亡。</font><br>" +
				"<font size='12' color='#CC0066'>副会长：</font>" +
				"<font size='12' color='#ffffff'>为会长最得力的助手，拥有管理成员、公会活动等权限，维护公会日常运行，活跃公会" +
				"气氛，提高公会活跃度，是公会走向昌盛的顶梁柱。</font><br>" + 
				"<font size='12' color='#00BEFF'>长老：</font>" +
				"<font size='12' color='#ffffff'>公会中的砥柱中流，拥有开启副本和活动等权限，组织成员参加集体活动，活跃公会气氛" +
				"起到非常大作用</font><br>" +
				"<font size='12' color='#00FF00'>精英：</font>" +
				"<font size='12' color='#ffffff'>公会中最积极的成员，因为有你们，公会才会这么活跃，如此让人有归属感</font>";
			var describTxt:GTextFiled = UIFactory.gTextField("", 300, 68, 162, 354, this, null, true);
			describTxt.multiline = true;
			describTxt.wordWrap = true;
			describTxt.htmlText = html;
		}
		
		private function onPageChange(event:Event):void
		{
			update();
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			var targetList:Vector.<TGuildLevelTarget> = GuildLevelTargetConfig.instance.getTargetList();
			_pageSelecter.maxPage = targetList.length / PAGE_CELL_COUNT == 0 
				? 1 : Math.ceil(targetList.length / PAGE_CELL_COUNT);
			
			var startIndex:int = (_pageSelecter.currentPage - 1) * PAGE_CELL_COUNT;
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0; i < PAGE_CELL_COUNT; i++)
			{
				var index:int = startIndex + i;
				if (index >= targetList.length)
					break;
				var info:TGuildLevelTarget = targetList[index];
				dataProvider.addItem(info);
			}
			
			_list.dataProvider = dataProvider;
			_list.drawNow();
		}
	}
}