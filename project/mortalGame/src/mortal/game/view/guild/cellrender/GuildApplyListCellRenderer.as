package mortal.game.view.guild.cellrender
{
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.GuildUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;

	public class GuildApplyListCellRenderer extends GuildCellRenderer
	{
		private var _bmpVip:GBitmap;//wait
		private var _txtPlayerName:GTextFiled;
		private var _txtLevel:GTextFiled;
		private var _txtCareer:GTextFiled;
		private var _txtFightPower:GTextFiled;
		private var _btnAgree:GLoadedButton;
		private var _btnReject:GLoadedButton;
		
		private var _saveData:SMiniPlayer;
		
		public function GuildApplyListCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			var alignCenterFmt:GTextFormat = GlobalStyle.textFormatPutong;
			alignCenterFmt.align = "center";
			
			_txtPlayerName = UIFactory.gTextField("我是大侠", 30, 3, 100, 20, this);
			_txtLevel = UIFactory.gTextField("lv.11", 168, 3, 40, 20, this);
			_txtCareer = UIFactory.gTextField("法师", 256, 3, 60, 20, this);
			_txtFightPower = UIFactory.gTextField("100000", 340, 3, 80, 20, this, alignCenterFmt);
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
			var data:SMiniPlayer = arg0 as SMiniPlayer;
			_saveData = data;
			_txtPlayerName.text = data.name;
			_txtLevel.text = "lv." + data.level;
			_txtFightPower.text = data.combat.toString();
			_txtCareer.text = GameDefConfig.instance.getItem("ECareer", data.career).text;
			
			if (data.online)
			{
				_txtPlayerName.textColor = _txtLevel.textColor = _txtFightPower.textColor = _txtCareer.textColor = GuildUtil.MemberOnlineColor;
			}
			else
			{
				_txtPlayerName.textColor = _txtLevel.textColor = _txtFightPower.textColor = _txtCareer.textColor = GuildUtil.MemberOfflineColor;
			}
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnAgree:
					var obj:Object = new Object();
					obj.playerID = _saveData.entityId.id;
					obj.agree = true;
					obj.handleAll = false;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DEAL_APPLY, obj));
					break;
				case _btnReject:
					obj = new Object();
					obj.playerID = _saveData.entityId.id;
					obj.agree = false;
					obj.handleAll = false;
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DEAL_APPLY, obj));
					break;
			}
		}
	}
}