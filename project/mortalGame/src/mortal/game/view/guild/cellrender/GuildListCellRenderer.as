package mortal.game.view.guild.cellrender
{
	import Message.Game.EApplyGuildType;
	import Message.Game.SBranchGuildInfo;
	import Message.Game.SMiniGuildInfo;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.guild.otherpanel.GuildIntroducePanel;
	import mortal.mvc.core.Dispatcher;
	
	public class GuildListCellRenderer extends GuildCellRenderer
	{
		private var _txtRank:GTextFiled;
		private var _bmpRank:GBitmap;
		private var _txtGuildName:GTextFiled;
		private var _txtCamp:GTextFiled;
		private var _txtGuildMaster:GTextFiled;
		private var _txtGuildLevel:GTextFiled;
		private var _txtGuildMembersNum:GTextFiled;
		private var _txtGuildBranchMembersNum:GTextFiled;
		private var _btnApplyMainGuild:GLoadedButton;
		private var _btnApplyBranchGuild:GLoadedButton;
		
		private var _saveData:SMiniGuildInfo;
		
		public function GuildListCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			var alignCenterFmt:GTextFormat = GlobalStyle.textFormatPutong;
			alignCenterFmt.align = "center";
			
			_txtRank = UIFactory.gTextField("1", 16, 3, 20, 20, this);
			_bmpRank = UIFactory.gBitmap("", 12, 0, this);
			_txtGuildName = UIFactory.gTextField("1", 54, 3, 90, 20, this, alignCenterFmt);
			_txtCamp = UIFactory.gTextField("xx", 162, 3, 30, 20, this);
			_txtGuildMaster = UIFactory.gTextField("xx", 208, 3, 90, 20, this, alignCenterFmt);
			_txtGuildLevel = UIFactory.gTextField("11", 330, 3, 30, 20, this);
			_txtGuildMembersNum = UIFactory.gTextField("11/50", 390, 3, 45, 20, this, alignCenterFmt);
			_txtGuildBranchMembersNum = UIFactory.gTextField("11/50", 464, 3, 45, 20, this, alignCenterFmt);
			_btnApplyMainGuild = UIFactory.gLoadedButton("GroupBtn_upSkin",534,1,62,22,this);
			_btnApplyMainGuild.label = Language.getString(60061);
			_btnApplyMainGuild.configEventListener(MouseEvent.CLICK, onMouseClick);
			_btnApplyBranchGuild = UIFactory.gLoadedButton("GroupBtn_upSkin",600,1,62,22,this);
			_btnApplyBranchGuild.label = Language.getString(60062);
			_btnApplyBranchGuild.configEventListener(MouseEvent.CLICK, onMouseClick);
			
			UIFactory.bg(0,25,690,1,this,ImagesConst.SplitLine);
		}
		
		override public function set data(arg0:Object):void
		{
			var data:SMiniGuildInfo = arg0 as SMiniGuildInfo;
			_saveData = data;
			if (data.rank == 1)
			{
				_bmpRank.bitmapData = GlobalClass.getBitmapData(ImagesConst.guildRank1_icon)
			}
			else if (data.rank == 2)
			{
				_bmpRank.bitmapData = GlobalClass.getBitmapData(ImagesConst.guildRank2_icon)
			}
			else if (data.rank == 3)
			{
				_bmpRank.bitmapData = GlobalClass.getBitmapData(ImagesConst.guildRank3_icon)
			}
			else
			{
				_bmpRank.bitmapData = null;
			}
			_txtRank.text = data.rank.toString();
			_txtGuildName.htmlText =  "<a href='event:guildlink' target = ''><font color='#ffffff'><u>" + data.guildName + 
				"</u></font></a>";
			_txtGuildName.configEventListener(TextEvent.LINK, onGuildLink);
			_txtCamp.text = GameDefConfig.instance.getItem("ECamp", data.camp).text;
			_txtCamp.textColor = parseInt(GameDefConfig.instance.getItem("ECamp", data.camp).text1.split("#")[1], 16);
			_txtGuildMaster.text = data.leaderName;
			_txtGuildLevel.text = data.level.toString();
			_txtGuildMembersNum.text = data.playerNum + "/" + data.maxPlayerNum;
			
			var branch:SBranchGuildInfo = data.branch.length > 0 ? data.branch[0] : null;
			
			if (branch != null)
			{
				_txtGuildBranchMembersNum.text = branch.playerNum + "/" + branch.maxPlayerNum;
//				_btnApplyMainGuild.x = 534;
				_btnApplyBranchGuild.enabled = true;
			}
			else
			{
//				_btnApplyMainGuild.x = 567;
				_btnApplyBranchGuild.enabled = false;
				_txtGuildBranchMembersNum.text = "0/0";
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var obj:Object = new Object();
			obj.guildID = _saveData.guildId;
			switch(event.target)
			{
				case _btnApplyBranchGuild:
					obj.type = EApplyGuildType._EApplyBranchGuild;
					obj.guildInfo = _saveData;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_APPLY, obj));
					break;
				case _btnApplyMainGuild:
					obj.type = EApplyGuildType._EApplyGuild;
					obj.guildInfo = _saveData;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_APPLY, obj));
					break;
			}
		}
		
		protected function onGuildLink(event:TextEvent):void
		{
			GuildIntroducePanel.instance.setGuildInfo(_saveData);
			GuildIntroducePanel.instance.show();
		}
		
	}
}