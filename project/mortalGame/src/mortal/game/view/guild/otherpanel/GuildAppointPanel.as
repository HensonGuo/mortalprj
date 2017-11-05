package mortal.game.view.guild.otherpanel
{
	import Message.DB.Tables.TGuildLevelTarget;
	import Message.Game.EGuildPosition;
	import Message.Game.SGuildMember;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GButton;
	import com.mui.controls.GRadioButton;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.GuildConst;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.GuildLevelTargetConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildAppointPanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildAppointPanel = null;
		
		private var _txtMemberName:GTextFiled;
		private var _radioBtnMaster:GRadioButton;
		private var _radioBtnDeputyMaster:GRadioButton;
		private var _radioBtnPresbyter:GRadioButton;
		private var _radioBtnLaw:GRadioButton;
		private var _radioBtnElite:GRadioButton;
		private var _radioBtnNormal:GRadioButton;
		
		private var _leftPostionNumTxtList:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		
		private var _btnAppoint:GButton;
		
		private var _memberInfo:SGuildMember;
		
		public function GuildAppointPanel($layer:ILayer=null)
		{
			super($layer);
			setSize(278,285);
			title = "职位任命";
		}
		
		public static function get instance():GuildAppointPanel
		{
			if (!_instance)
				_instance = new GuildAppointPanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			UIFactory.gBitmap(ImagesConst.guildAppointmentBg, 12.5, 33, this);
			
			var txtFmt1:GTextFormat = GlobalStyle.textFormatJiang;
			txtFmt1.size = 14;
			UIFactory.gTextField(Language.getString(60082), 63, 44, 35, 22, this, txtFmt1);
			UIFactory.gTextField(Language.getString(60083) + " :", 200, 44, 35, 22, this, txtFmt1);
			
			var txtFmt2:GTextFormat = GlobalStyle.textFormatJiang;
			txtFmt2.size = 14;
			txtFmt2.color = 0x436b74;
			var memberNameLink:String = "<a href='event:memberNameLink' target = ''><font color='#436b74' size='14'><u>我是公会成员</u></font></a>";
			_txtMemberName = UIFactory.gTextField(memberNameLink, 95, 44, 105, 22, this, null, true);
			_txtMemberName.autoSize = "center";
			
			var positionNameList:Vector.<String> = new Vector.<String>();
			positionNameList.push(Language.getString(60077), Language.getString(60078), Language.getString(60079), Language.getString(60080), 
				Language.getString(60081), "普通成员");
			
			for (var i:int = 0; i < positionNameList.length; i++)
			{
				switch(i)
				{
					case 0:
						_radioBtnMaster = UIFactory.radioButton("", 70, 82 + 26 * i, 22, 22, this);
						_radioBtnMaster.groupName = "appointGroup"
						break;
					case 1:
						_radioBtnDeputyMaster = UIFactory.radioButton("", 70, 82 + 26 * i, 22, 22, this);
						_radioBtnDeputyMaster.groupName = "appointGroup"
						break;
					case 2:
						_radioBtnPresbyter = UIFactory.radioButton("", 70, 82 + 26 * i, 22, 22, this);
						_radioBtnPresbyter.groupName = "appointGroup"
						break;
					case 3:
						_radioBtnLaw = UIFactory.radioButton("", 70, 82 + 26 * i, 22, 22, this);
						_radioBtnLaw.groupName = "appointGroup"
						break;
					case 4:
						_radioBtnElite = UIFactory.radioButton("", 70, 82 + 26 * i, 22, 22, this);
						_radioBtnElite.groupName = "appointGroup"
						break;
					case 5:
						_radioBtnNormal = UIFactory.radioButton("", 70, 82 + 26 * i, 22, 22, this);
						_radioBtnNormal.groupName = "appointGroup"
						break;
				}
				UIFactory.gTextField(positionNameList[i], 95, 82 + 26 * i, 60, 22, this, txtFmt1);
				if (i != 0 && i != 5)
				{
					var txt:GTextFiled = UIFactory.gTextField("[14/15]", 145, 82 + 26 * i, 55, 22, this, txtFmt2);
					_leftPostionNumTxtList.push(txt);
				}
			}
			
			_btnAppoint = UIFactory.gButton(Language.getString(60084), 114, 255, 67, 22, this);
		}
		
		public function setMemberData(data:Object):void
		{
			_memberInfo = data as SGuildMember;
			update();
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnAppoint:
					var positon:int = 0;
					var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
					var config:TGuildLevelTarget = GuildLevelTargetConfig.instance.getInfoByLevel(guildInfo.baseInfo.level);
					var isFullMember:Boolean = false;
					var hasPermissions:Boolean = false;
					var isChangeLeader:Boolean = false;

					
					if (_radioBtnMaster.selected)
					{
						positon = EGuildPosition._EGuildLeader;
						hasPermissions = GuildConst.hasPermissions(GuildConst.TransferPositon);
						isChangeLeader = true;
						
					}
					else if (_radioBtnDeputyMaster.selected)
					{
						
						positon = EGuildPosition._EGuildDeputyLeader;
						hasPermissions = GuildConst.hasPermissions(GuildConst.AppointDeputyLeader);
						isFullMember = guildInfo.deputyLeaderNum == config.deputyLeaderAmount;
						
					}
					else if (_radioBtnPresbyter.selected)
					{
						
						positon = EGuildPosition._EGuildPresbyter;
						hasPermissions = GuildConst.hasPermissions(GuildConst.AppointPrestyer);
						isFullMember = guildInfo.presbyterNum == config.presbyterAmount;
						
					}
					else if (_radioBtnLaw.selected)
					{
						
						positon = EGuildPosition._EGuildLaw;
						hasPermissions = GuildConst.hasPermissions(GuildConst.AppointLaw);
						isFullMember = guildInfo.lawNums == config.lawAmount;
						
					}
					else if (_radioBtnElite.selected)
					{
						
						positon = EGuildPosition._EGuildElite;
						hasPermissions = GuildConst.hasPermissions(GuildConst.AppointElite);
						isFullMember = guildInfo.eliteNums == config.eliteAmount;
						
					}
					else if (_radioBtnNormal.selected)
					{
						positon = EGuildPosition._EGuildMember;
						hasPermissions = Cache.instance.guild.selfGuildInfo.selfInfo.position > _memberInfo.position;
					}
					
					if (positon == 0)
					{
						MsgManager.showRollTipsMsg("请选择一个职位!");
						return;
					}
					if (_memberInfo.position == positon)
					{
						MsgManager.showRollTipsMsg("成员职位未变更，请从新选择!");
						return;
					}
					if (_memberInfo.miniPlayer.entityId.id == Cache.instance.role.entityInfo.entityId.id)
					{
						if (_memberInfo.position != EGuildPosition._EGuildLeader)
						{
							MsgManager.showRollTipsMsg("只有会长才能转移职位!");
							return;
						}
					}
					if (!hasPermissions)
					{
						MsgManager.showRollTipsMsg("无权限!");
						return;
					}
					if (isFullMember)
					{
						MsgManager.showRollTipsMsg("对应职位已经满员!");
						return;
					}
					
					var changePositionCallback:Function = function(type:int):void
					{
						if(type == Alert.OK)
						{
							var obj:Object = new Object;
							obj.targetID = _memberInfo.miniPlayer.entityId.id;
							obj.position = positon
							Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_POSITION_OPRATE, obj));
							hide();
						}
					}
					
					if (isChangeLeader)
					{
						Alert.show("您确定将职位转移么，是否确定？", null, Alert.OK|Alert.CANCEL, null, changePositionCallback);
					}
					else
					{
						changePositionCallback(Alert.OK)
					}
					
					break;
			}
		}
		
		override public function update():void
		{
			if (!isLoadComplete)
				return;
			if (_memberInfo == null)
				return;
			var memberNameLink:String = "<a href='event:memberNameLink' target = ''><font color='#436b74' size='14'><u>" + _memberInfo.miniPlayer.name + "</u></font></a>";
			_txtMemberName.htmlText = memberNameLink;
			var selfGuildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			
			var txtLeftDeputyMasterNum:GTextFiled = _leftPostionNumTxtList[0];
			txtLeftDeputyMasterNum.text = "[" + selfGuildInfo.deputyLeaderNum + "/" + selfGuildInfo.getLevelConfig().deputyLeaderAmount + "]"
			var txtLeftPresbyter:GTextFiled = _leftPostionNumTxtList[1];
			txtLeftPresbyter.text = "[" + selfGuildInfo.presbyterNum + "/" + selfGuildInfo.getLevelConfig().presbyterAmount + "]";
			var txtLeftLaw:GTextFiled = _leftPostionNumTxtList[2];
			txtLeftLaw.text = "[" + selfGuildInfo.lawNums + "/" + selfGuildInfo.getLevelConfig().lawAmount + "]";
			var txtLeftElite:GTextFiled = _leftPostionNumTxtList[3];
			txtLeftElite.text = "[" + selfGuildInfo.eliteNums + "/" + selfGuildInfo.getLevelConfig().eliteAmount + "]";
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_leftPostionNumTxtList.length = 0;
			super.disposeImpl(isReuse);
		}
	}
}