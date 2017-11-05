package mortal.game.view.guild.otherpanel
{
	import Message.Game.SMiniGuildInfo;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildWelcomePanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildWelcomePanel = null;
		
		private var _txtGuildName:GTextFiled;
		private var _txtGuildMaster:GTextFiled;
		private var _txtGuildLevel:GTextFiled;
		private var _txtGuildMembersNum:GTextFiled;
		
		private var _btnConfirm:GButton;
		
		private var _guildInfo:SMiniGuildInfo
		
		public function GuildWelcomePanel($layer:ILayer=null)
		{
			super($layer);
			setSize(467,327);
			title = "加入公会";
		}
		
		public static function get instance():GuildWelcomePanel
		{
			if (!_instance)
				_instance = new GuildWelcomePanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			UIFactory.gBitmap(ImagesConst.guildWelcomeBg, 13, 32, this);
			
			var textFormat:GTextFormat = GlobalStyle.textFormatItemWhite;
			textFormat.size = 14;
			_txtGuildMaster = UIFactory.gTextField("我是会长", 92, 256, 90, 26, this, textFormat);
			_txtGuildLevel = UIFactory.gTextField("4级", 280, 256, 90, 26, this, textFormat);
			_txtGuildMembersNum = UIFactory.gTextField("15/100", 404, 256, 90, 26, this, textFormat);
			
			var txtFmt:GTextFormat = GlobalStyle.textFormatItemGreen;
			txtFmt.size = 18;
			txtFmt.align = "center";
			_txtGuildName = UIFactory.gTextField("天下第一公会", 180, 80, 130, 30, this, txtFmt);
			
			_btnConfirm = UIFactory.gButton(Language.getString(60076), 208, 302, 67, 22, this);
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnConfirm:
					hide();
					break;
			}
		}
		
		public function setData(data:SMiniGuildInfo):void
		{
			_guildInfo = data;
			update();
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			if (_guildInfo == null)
				return;
			_txtGuildName.text = _guildInfo.guildName;
			_txtGuildMaster.text = _guildInfo.leaderName;
			_txtGuildLevel.text = _guildInfo.level + "级";
			_txtGuildMembersNum.text = _guildInfo.playerNum + "/" + _guildInfo.maxPlayerNum;
		}
	}
}