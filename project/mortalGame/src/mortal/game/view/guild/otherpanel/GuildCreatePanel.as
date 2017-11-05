package mortal.game.view.guild.otherpanel
{
	import Message.Game.ECreate;
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.FilterText;
	import com.mui.controls.GButton;
	import com.mui.controls.GRadioButton;
	import com.mui.controls.GTextInput;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.GuildConst;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.GuildCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildCreatePanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildCreatePanel = null;
		
		private var _txtInputGuildName:GTextInput;
		private var _txtInputGuildPurpose:GTextInput;
		private var _radioButtonCreateByYuanBao:GRadioButton;
		private var _radioButtonCreateByFree:GRadioButton;
		
		private var _btnCreateGuild:GButton;
		
		public function GuildCreatePanel($layer:ILayer=null)
		{
			super($layer);
			setSize(280,290);
			title = "建立公会";
		}
		
		public static function get instance():GuildCreatePanel
		{
			if (!_instance)
				_instance = new GuildCreatePanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			UIFactory.gTextField(Language.getString(60046), 116, 36, 60, 20, this, GlobalStyle.textFormatJiang);
			_txtInputGuildName = UIFactory.gTextInput(24, 55, 240, 24, this);
			_txtInputGuildName.text = Language.getString(60063);
			UIFactory.gTextField(Language.getString(60006), 116, 85, 60, 20, this, GlobalStyle.textFormatJiang);
			_txtInputGuildPurpose = UIFactory.gTextInput(24, 104, 240, 84, this);
			_txtInputGuildPurpose.text = Language.getString(60064);
			
			_radioButtonCreateByYuanBao = UIFactory.radioButton(Language.getString(60055), 24, 196, 50, 20, this);
			_radioButtonCreateByYuanBao.groupName = "createGuild";
			_radioButtonCreateByYuanBao.selected = true;
			var extend:String = "<font color='#ffcc00'>" + GuildConst.CreateGuildRequireCostGold + "元宝</font><font color='#ffffff'>" + Language.getString(60056) + "</font>";
			UIFactory.gTextField(extend, 70, 196, 100, 20, this, null, true);
			_radioButtonCreateByFree = UIFactory.radioButton(Language.getString(60054), 24, 218, 70, 20, this);
			_radioButtonCreateByFree.groupName = "createGuild";
			UIFactory.gTextField("[" + Language.getString(60057) + "]", 94, 218, 120, 20, this, GlobalStyle.textFormatItemGreen);
			
			_btnCreateGuild = UIFactory.gButton(Language.getString(60047),112,257,67,22,this);
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnCreateGuild:
					if (!_radioButtonCreateByYuanBao.selected && !_radioButtonCreateByFree.selected)
					{
						MsgManager.showRollTipsMsg("请选择一个模式!");
						return;
					}
					var type:int = _radioButtonCreateByYuanBao.selected ? ECreate._ECreateMoney : ECreate._ECreateNoMoney;
					
					var reg:RegExp = /\S/;
					var name:String = _txtInputGuildName.text != Language.getString(60063) ? _txtInputGuildName.text : "";
					if (name.match(reg) == null)
					{
						MsgManager.showRollTipsMsg("公会名字不能为空!");
						return;
					}
					if (name.length > 7)
					{
						MsgManager.showRollTipsMsg("公会名字过长，请从新输入!");
						return;
					}
					name = FilterText.instance.getFilterStr(name);
					if (name.indexOf("*") != -1)
					{
						_txtInputGuildName.text = name;
						_txtInputGuildName.setStyle("textFormat", GlobalStyle.textFormatItemRed);
						MsgManager.showRollTipsMsg("公会名字有敏感字，请从新输入!");
						return;
					}
					var purpose:String = _txtInputGuildPurpose.text != Language.getString(60064) ? _txtInputGuildPurpose.text : "";
					var obj:Object = new Object();
					obj.type = type;
					obj.name = name;
					obj.purpose = purpose;
					Dispatcher.dispatchEvent( new DataEvent(EventName.GUILD_CREATE, obj));
					break;
			}
			if (event.target.parent && event.target.parent is GTextInput)
			{
				switch(event.target.parent)
				{
					case _txtInputGuildName:
					if (_txtInputGuildName.text == Language.getString(60063))
					{
						_txtInputGuildName.text = "";
					}
					break;
					case _txtInputGuildPurpose:
					if (_txtInputGuildPurpose.text == Language.getString(60064))
					{
						_txtInputGuildPurpose.text = "";
					}
					break;
				}
			}
		}
		
	}
}