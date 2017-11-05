package mortal.game.view.guild.cellrender
{
	import Message.Game.SMiniGuildInfo;
	
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.guild.otherpanel.GuildInviteListPanel;
	import mortal.mvc.core.Dispatcher;

	public class GuildInviteListCellRenderer extends GuildCellRenderer
	{
		private var _txtGuildName:GTextFiled;
		private var _txtCamp:GTextFiled;
		private var _txtGuildMaster:GTextFiled;
		private var _txtGuildLevel:GTextFiled;
		private var _txtGuildMembers:GTextFiled;
		private var _btnAgree:GLoadedButton;
		private var _btnReject:GLoadedButton;
		
		private var _inviteData:SMiniGuildInfo;
		
		public function GuildInviteListCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			var alignCenterFmt:GTextFormat = GlobalStyle.textFormatPutong;
			alignCenterFmt.align = "center";
			
			_txtGuildName = UIFactory.gTextField("第一公会", 15, 3, 100, 20, this);
			_txtCamp = UIFactory.gTextField("xxx", 120, 3, 45, 20, this);
			_txtGuildMaster = UIFactory.gTextField("xxxxxxx", 172, 3, 100, 20, this);
			_txtGuildLevel = UIFactory.gTextField("25", 300, 3, 50, 20, this);
			_txtGuildMembers = UIFactory.gTextField("25", 355, 3, 60, 20, this, alignCenterFmt);
			_btnAgree = UIFactory.gLoadedButton("GroupBtn_upSkin",440,1.5,38,22,this);
			_btnAgree.label = Language.getString(60070);
			_btnAgree.configEventListener(MouseEvent.CLICK, onMouseClick);
			_btnReject = UIFactory.gLoadedButton("GroupBtn_upSkin",483,1.5,38,22,this);
			_btnReject.label = Language.getString(60071);
			_btnReject.configEventListener(MouseEvent.CLICK, onMouseClick);
			
			UIFactory.bg(0,25,530,1,this,ImagesConst.SplitLine)
		}
		
		override public function set data(arg0:Object):void
		{
			var inviteInfo:SMiniGuildInfo = arg0 as SMiniGuildInfo;
			_inviteData = inviteInfo;
			
			_txtGuildName.text = inviteInfo.guildName;
			_txtCamp.text = GameDefConfig.instance.getItem("ECamp", inviteInfo.camp).text;
			_txtCamp.textColor = parseInt(GameDefConfig.instance.getItem("ECamp", inviteInfo.camp).text1.split("#")[1], 16);
			_txtGuildMaster.htmlText = "<a href='event:guildmasterlink' target = ''><font color='#ff9100'><u>"
				+ inviteInfo.leaderName + "</u></font></a>";
			_txtGuildLevel.text = inviteInfo.level.toString();
			_txtGuildMembers.text = inviteInfo.playerNum + "/" + inviteInfo.maxPlayerNum;
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnAgree:
					var obj:Object = new Object;
					obj.guildId = _inviteData.guildId;
					obj.agree = true;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DEAL_INVITE, obj));
					break;
				case _btnReject:
					Cache.instance.guild.removeInviteInfo(_inviteData.guildId);
					GuildInviteListPanel.instance.update();
					break;
			}
		}
	}
}