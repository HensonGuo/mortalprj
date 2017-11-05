package mortal.game.view.guild.cellrender
{
	import Message.Game.EGuildPosition;
	import Message.Game.SGuildMember;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.GuildConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.GuildUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;

	public class GuildBranchMembersListCellRenderer extends GuildCellRenderer
	{
		private var _bmpVip:GBitmap;//wait
		private var _txtMemberName:GTextFiled;
		private var _txtLevel:GTextFiled;
		private var _txtFightPower:GTextFiled;
		private var _txtWeekContribution:GTextFiled;
		private var _txtTotalContribution:GTextFiled;
		private var _txtResource:GTextFiled;
		private var _txtState:GTextFiled;
		private var _btnBecomeRegular:GLoadedButton;
		private var _btnKickOut:GLoadedButton;
		
		private var _saveData:SGuildMember;
		
		public function GuildBranchMembersListCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			var alignCenterFmt:GTextFormat = GlobalStyle.textFormatPutong;
			alignCenterFmt.align = "center";
			
			_txtMemberName = UIFactory.gTextField("我是大侠", 30, 3, 100, 20, this);
			_txtLevel = UIFactory.gTextField("xxxx", 145, 3, 45, 20, this);
			_txtFightPower = UIFactory.gTextField("100000", 207, 3, 50, 20, this, alignCenterFmt);
			_txtWeekContribution = UIFactory.gTextField("100000", 290, 3, 48, 20, this, alignCenterFmt);
			_txtTotalContribution = UIFactory.gTextField("100000", 372, 3, 48, 20, this, alignCenterFmt);
			_txtResource = UIFactory.gTextField("lv.90.法师", 451, 3, 35, 20, this, alignCenterFmt);
			_txtState = UIFactory.gTextField("100000", 532, 3, 50, 20, this, alignCenterFmt);
			_btnBecomeRegular = UIFactory.gLoadedButton("GroupBtn_upSkin",612,1.5,38,22,this);
			_btnBecomeRegular.label = Language.getString(60085);
			_btnBecomeRegular.configEventListener(MouseEvent.CLICK, onMouseClick);
			_btnKickOut = UIFactory.gLoadedButton("GroupBtn_upSkin",660,1.5,38,22,this);
			_btnKickOut.label = Language.getString(60086);
			_btnKickOut.configEventListener(MouseEvent.CLICK, onMouseClick);
			
			UIFactory.bg(0,25,700,1,this,ImagesConst.SplitLine)
		}
		
		override public function set data(arg0:Object):void
		{
			var data:SGuildMember = arg0 as SGuildMember;
			_saveData = data;
			if (data.miniPlayer.online)
			{
				_txtMemberName.textColor = _txtLevel.textColor = _txtFightPower.textColor = _txtWeekContribution.textColor = 
					_txtTotalContribution.textColor = _txtResource.textColor = _txtState.textColor = GuildUtil.MemberOnlineColor;
			}
			else
			{
				_txtMemberName.textColor = _txtLevel.textColor = _txtFightPower.textColor = _txtWeekContribution.textColor = 
					_txtTotalContribution.textColor = _txtResource.textColor = _txtState.textColor = GuildUtil.MemberOfflineColor;
			}
			_txtMemberName.text = data.miniPlayer.name;
			_txtLevel.text = "lv." + data.miniPlayer.level;
			_txtFightPower.text = data.miniPlayer.combat.toString();
			_txtWeekContribution.text = data.contributionWeek.toString();
			if (data.miniPlayer.online)
			{
				_txtWeekContribution.textColor = GlobalStyle.greenUint;
			}
			_txtTotalContribution.text = data.totalContribution.toString();
			_txtResource.text = data.resource.toString();
			_txtState.text = data.miniPlayer.online ? "在线" : GuildUtil.getMemberOfflineState(data.lastLogoutDt);
			
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			var hasPermissions:Boolean = GuildConst.hasPermissions(GuildConst.AbsorbBranchMembers);
			if (!hasPermissions)
			{
				MsgManager.showRollTipsMsg("权限不足！");
				return;
			}
			switch(event.target)
			{
				case _btnBecomeRegular:
					var obj:Object = new Object;
					obj.targetID = _saveData.miniPlayer.entityId.id;
					obj.position = EGuildPosition._EGuildMember;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_POSITION_OPRATE, obj));
					break;
				case _btnKickOut:
					obj = new Object();
					obj.targetID = _saveData.miniPlayer.entityId.id;
					obj.position = EGuildPosition._EGuildNotMember;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_POSITION_OPRATE, obj));
					break;
			}
		}
				
	}
}