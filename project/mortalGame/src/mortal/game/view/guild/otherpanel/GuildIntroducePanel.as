package mortal.game.view.guild.otherpanel
{
	import Message.Game.EApplyGuildType;
	import Message.Game.SBranchGuildInfo;
	import Message.Game.SMiniGuildInfo;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildIntroducePanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildIntroducePanel = null;
		
		private var _txtGuildName:GTextFiled;
		private var _txtGuildMaster:GTextFiled;
		private var _txtGuildLevel:GTextFiled;
		private var _txtGuildCamp:GTextFiled;
		private var _txtGuildMembersNum:GTextFiled;
		private var _txtGuildBranchLevel:GTextFiled;
		private var _txtGuildPurpose:GTextFiled;
		private var _bgGuildPurpose:ScaleBitmap;
		
		private var _btnApply:GButton;
		
		private var _guildData:SMiniGuildInfo;
		
		public function GuildIntroducePanel($layer:ILayer=null)
		{
			super($layer);
			setSize(280,302);
			title = "公会简介";
		}
		
		public static function get instance():GuildIntroducePanel
		{
			if (!_instance)
				_instance = new GuildIntroducePanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			UIFactory.gTextField(Language.getString(60046) + " : ", 17, 40, 60, 20, this, GlobalStyle.textFormatJiang);
			UIFactory.gTextField(Language.getString(60075) + " : ", 17, 64, 60, 20, this, GlobalStyle.textFormatJiang);
			UIFactory.gTextField(Language.getString(60001) + Language.getString(60027) + " : ", 17, 88, 60, 20, this, GlobalStyle.textFormatJiang);
			UIFactory.gTextField(Language.getString(60072) + " : ", 17, 112, 60, 20, this, GlobalStyle.textFormatJiang);
			UIFactory.gTextField(Language.getString(60073) + " : ", 17, 136, 60, 20, this, GlobalStyle.textFormatJiang);
			UIFactory.gTextField(Language.getString(60023) + " : ", 17, 160, 60, 20, this, GlobalStyle.textFormatJiang);
			UIFactory.gTextField(Language.getString(60006) + " : ", 17, 184, 60, 20, this, GlobalStyle.textFormatJiang);
			
			_txtGuildName = UIFactory.gTextField("XXXXXXXXXXXXXX", 75, 40, 60, 20, this, GlobalStyle.textFormatItemGreen);
			var masterLink:String = "<a href='event:masterLink' target = ''><font color='#ffffff'><u>XXXXXXXXX</u></font></a>";
			_txtGuildMaster = UIFactory.gTextField(masterLink, 75, 64, 60, 20, this, null, true);
			_txtGuildLevel = UIFactory.gTextField("24", 75, 88, 60, 20, this, GlobalStyle.textFormatYellow);
			_txtGuildCamp = UIFactory.gTextField("XXX", 75, 112, 60, 20, this, GlobalStyle.textFormatJiang);
			_txtGuildMembersNum = UIFactory.gTextField("11/50", 75, 136, 60, 20, this, GlobalStyle.textFormatItemWhite)
			_txtGuildBranchLevel = UIFactory.gTextField("11", 75, 160, 100, 20, this, GlobalStyle.textFormatItemWhite)
			_bgGuildPurpose = UIFactory.bg(75, 184, 192, 72, this, ImagesConst.InputBg);
			_txtGuildPurpose = UIFactory.gTextField("", 76, 184, 194, 72, this, GlobalStyle.textFormatItemWhite);
			
			_btnApply = UIFactory.gButton(Language.getString(60074),110,270,64,24,this);
		}
		
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnApply:
					var obj:Object = new Object();
					obj.type = EApplyGuildType._EApplyGuild;
					obj.guildInfo = _guildData;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_APPLY, obj));
					hide();
					break;
			}
		}
		
		public function setGuildInfo(info:SMiniGuildInfo):void
		{
			_guildData = info;
			update();
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			if (_guildData == null)
				return;
			_txtGuildName.text = _guildData.guildName;
			_txtGuildMaster.text = _guildData.leaderName;
			_txtGuildCamp.text = GameDefConfig.instance.getItem("ECamp", _guildData.camp).text;
			_txtGuildCamp.textColor = parseInt(GameDefConfig.instance.getItem("ECamp", _guildData.camp).text1.split("#")[1], 16);
			_txtGuildLevel.text = _guildData.level.toString();
			_txtGuildMembersNum.text = _guildData.playerNum + "/" + _guildData.maxPlayerNum;
			
			var branchInfo:SBranchGuildInfo = _guildData.branch.length > 0 ? _guildData.branch[0] : null;
			_txtGuildBranchLevel.text = branchInfo != null ? branchInfo.level.toString() : "(未创建分会)";
			_txtGuildPurpose.text = _guildData.purpose;
		}
	}
}