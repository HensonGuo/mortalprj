package mortal.game.view.guild.cellrender
{
	import Message.Game.SGuildMember;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.GuildUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;

	public class GuildMembersListCellRenderer extends GuildCellRenderer
	{
		private var _isSelected:Boolean = false;
		private var _bgSelected:ScaleBitmap;
		
		private var _bmpVip:GBitmap;//wait
		private var _txtMemberName:GTextFiled;
		private var _txtPosition:GTextFiled;
		private var _txtLevel_Career:GTextFiled;
		private var _txtFightPower:GTextFiled;
		private var _txtTodayContribution:GTextFiled;
		private var _txtWeekContribution:GTextFiled;
		private var _txtTotalContribution:GTextFiled;
		private var _txtActives:GTextFiled;
		private var _txtState:GTextFiled;
		
		public function GuildMembersListCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			var alignCenterFmt:GTextFormat = GlobalStyle.textFormatPutong;
			alignCenterFmt.align = "center";
			
			_txtMemberName = UIFactory.gTextField("我是大侠", 30, 3, 100, 20, this);
			_txtPosition = UIFactory.gTextField("xxxx", 134, 3, 60, 20, this, alignCenterFmt);
			_txtLevel_Career = UIFactory.gTextField("lv.90.法师", 210, 3, 70, 20, this);
			_txtFightPower = UIFactory.gTextField("100000", 293, 3, 80, 20, this, alignCenterFmt);
			_txtTodayContribution = UIFactory.gTextField("100000", 368, 3, 55, 20, this, alignCenterFmt);
			_txtWeekContribution = UIFactory.gTextField("100000", 443, 3, 55, 20, this, alignCenterFmt);
			_txtTotalContribution = UIFactory.gTextField("100000", 517, 3, 55, 20, this, alignCenterFmt);
			_txtActives = UIFactory.gTextField("100000", 588, 3, 50, 20, this, alignCenterFmt);
			_txtState = UIFactory.gTextField("100000", 648, 3, 50, 20, this, alignCenterFmt);
			
			UIFactory.bg(0,25,700,1,this,ImagesConst.SplitLine);
			_bgSelected = UIFactory.bg(0,0,700,30,this,"selectFilter");
		}
		
		override public function set data(arg0:Object):void
		{
			var memberInfo:SGuildMember = arg0 as SGuildMember;
			PlayerMenuRegister.UnRegister(this);
			if (memberInfo.miniPlayer.online)
			{
				PlayerMenuRegister.Register(this, memberInfo.miniPlayer, PlayerMenuConst.GuildMemberOnlineOpMenu);
				_txtMemberName.textColor = _txtPosition.textColor = _txtFightPower.textColor = _txtLevel_Career.textColor = 
					_txtTodayContribution.textColor = _txtWeekContribution.textColor = _txtTotalContribution.textColor = _txtActives.textColor = 
					_txtState.textColor = GuildUtil.MemberOnlineColor;
			}
			else
			{
				PlayerMenuRegister.Register(this, memberInfo.miniPlayer, PlayerMenuConst.GuildMemberOnlineOpMenu);
				PlayerMenuRegister.Register(this, memberInfo.miniPlayer, PlayerMenuConst.GuildMemberOnlineOpMenu);
				_txtMemberName.textColor = _txtPosition.textColor = _txtFightPower.textColor = _txtLevel_Career.textColor = 
					_txtTodayContribution.textColor = _txtWeekContribution.textColor = _txtTotalContribution.textColor = _txtActives.textColor = 
					_txtState.textColor = GuildUtil.MemberOfflineColor;
			}
			
			_txtMemberName.text = memberInfo.miniPlayer.name;
			_txtPosition.text = GameDefConfig.instance.getItem("EGuildPostion", memberInfo.position).text;
			if (memberInfo.miniPlayer.online)
			{
				_txtPosition.textColor = parseInt(GameDefConfig.instance.getItem("EGuildPostion", memberInfo.position).text1.split("#")[1], 16);
			}
			_txtLevel_Career.text = "lv." + memberInfo.miniPlayer.level + "." + GameDefConfig.instance.getItem("ECareer", memberInfo.miniPlayer.career).text;
			_txtFightPower.text = memberInfo.miniPlayer.combat.toString();
			_txtTodayContribution.text = memberInfo.contributionDay.toString();
			_txtWeekContribution.text = memberInfo.contributionWeek.toString();
			_txtTotalContribution.text = memberInfo.totalContribution.toString();
			_txtActives.text = memberInfo.activity.toString();
			if (memberInfo.miniPlayer.online)
			{
				_txtActives.textColor = GlobalStyle.colorChenUint;
			}
			_txtState.text = memberInfo.miniPlayer.online ? "在线" : GuildUtil.getMemberOfflineState(memberInfo.lastLogoutDt);
			
		}
		
		override public function set selected(value:Boolean):void
		{
			_isSelected = value;
			if (_isSelected)
			{
				_bgSelected.visible = true;
			}
			else
			{
				_bgSelected.visible = false;
			}
		}
		
	}
}