package mortal.game.view.guild.tabpanel
{
	import Message.DB.Tables.TGuildBranchTarget;
	import Message.Game.EGuildPosition;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFormat;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.GuildConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.GuildBranchLevelUpTargetConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.guild.otherpanel.GuildApplyListPanel;
	import mortal.game.view.guild.otherpanel.GuildImpeachLeaderPanel;
	import mortal.game.view.guild.otherpanel.GuildListPanel;
	import mortal.game.view.guild.otherpanel.GuildPositonIntroducePanel;
	import mortal.mvc.core.Dispatcher;
	
	public class GuildInfoPanel extends GuildBasePanel
	{
		//left
		private var _bmpTxtGuildLevel:BitmapNumberText;
		private var _btnApplyList:GButton;
		private var _bmpApply:GBitmap;
		private var _txtApplyNum:GTextFiled;
		private var _txtGuildName:GTextFiled;
		private var _txtGuildInfoDesc:GTextFiled;
		private var _btnChangeGuildPurpose:GLoadedButton;
		private var _txtGuildPurpose:GTextInput;
		private var _btnCreateOrLevelUpBranchGuild:GButton;
		private var _toolTipBranchSprite:ToolTipSprite;
		private var _btnImpeachLeader:GButton;
		
		//right top
		private var _btnContributionsDonate:GButton;
		private var _btnRecieveSalary:GButton;
		private var _txtSelfPosition:GTextFiled;
		private var _txtSelfContribution:GTextFiled;
		private var _txtSelfRes:GTextFiled;
		private var _txtSelfWeekContribution:GTextFiled;
		private var _txtSelfWeekActive:GTextFiled;
		private var _txtSelfSalary1:GTextFiled;
		private var _txtSelfSalary2:GTextFiled;
		
		//right bottom
		private var _btnGuildTerritory:GLoadedButton;
		private var _btnGuildOtherTerriory:GLoadedButton;
		private var _btnGuildTask:GLoadedButton;
		private var _btnGuildPet:GLoadedButton;
		
		private var _iconGuildDonate:GLoadedButton;
		private var _iconGuildEvent:GLoadedButton;
		private var _iconGuildActivity:GLoadedButton;
		private var _iconGuildPet:GLoadedButton;
		private var _iconGuildTreasure:GLoadedButton;
		private var _iconGuildShop:GLoadedButton;
		private var _iconGuildUnion:GLoadedButton;
		private var _iconGuildTask:GLoadedButton;
		
		//bottom
		private var _btnRecruit:GButton;
		private var _btnExitGuild:GButton;
		private var _btnDisbandGuild:GButton;
		//暂时添加
		private var _btnLevelUpGuild:GButton;
		
		//正在更改公会宗旨
		private var _isChangingGuildPurpose:Boolean = false;
		
		
		public function GuildInfoPanel()
		{
			super(ResFileConst.guildInfoPanel);
		}
		
		/**
		 * 布局UI
		 *
		 */
		override protected function layoutUI():void
		{
			//left
			UIFactory.gBitmap(ImagesConst.guildInfoBg, 18, 69, this);
			
			UIFactory.gBitmap(ImagesConst.guildLevelBg, 50, 86, this);
			_bmpTxtGuildLevel = UIFactory.bitmapNumberText(103, 112, "StrengthenNumber.png", 32, 40, -6, this);
			_bmpTxtGuildLevel.text = "24";
			
			var textFormat2:TextFormat = GlobalStyle.textFormatItemGreen;
			textFormat2.align = "center";
			_txtGuildName = UIFactory.gTextField("天下第一帮会", 58, 182, 150, 24, this, textFormat2);
			
			var guildInfoDescTitle:String = Language.getString(60020) + "：\n" + Language.getString(60021) + "：\n" + 
				Language.getString(60022) + "：\n" + Language.getString(60023) + "：\n" + Language.getString(60024) + "：\n" + 
				Language.getString(60025) + "：\n";
			var textFormat3:TextFormat = GlobalStyle.textFormatJiang;
			textFormat3.color = 0xff6600;
			textFormat3.leading = 6;
			UIFactory.gTextField(guildInfoDescTitle, 25, 215, 60, 140, this, textFormat3);
			
			var textFormat4:TextFormat = GlobalStyle.textFormatJiang;
			textFormat4.color = 0x265d6f;
			textFormat4.leading = 6;
			var guildInfoDesc:String = "生命在于折腾\n" + "809\n" + "203/204\n" + "3级(增加50人)\n" + "30/40\n" + "183131321/20000000";
			_txtGuildInfoDesc = UIFactory.gTextField(guildInfoDesc, 87, 215, 130, 140, this, textFormat4);
			_txtGuildInfoDesc.filters = null;
			
			_btnImpeachLeader = UIFactory.gButton("弹劾会长",172,215,62,24,this);
			
			_btnApplyList = UIFactory.gButton(Language.getString(60007),172,254,62,24,this);
			_bmpApply = UIFactory.gBitmap(ImagesConst.NumberBg, 218, 245, this);
			var textFormat5:TextFormat = GlobalStyle.textFormatItemWhite;
			textFormat5.size = 14;
			_txtApplyNum = UIFactory.gTextField("99", 221, 247, 24, 24, this, textFormat5);
			
			_toolTipBranchSprite = UICompomentPool.getUICompoment(ToolTipSprite);
			_toolTipBranchSprite.mouseEnabled = true;
			UIFactory.setObjAttri(_toolTipBranchSprite,172,279,62,24,this);
			_toolTipBranchSprite.toolTipData = "xxxxxxxxxxxxxx";
			_btnCreateOrLevelUpBranchGuild = UIFactory.gButton(Language.getString(60008),0,0,62,24,_toolTipBranchSprite);
			
			UIFactory.bg(25, 355, 212,123, this, ImagesConst.guildNoticeBg);
			UIFactory.gTextField(Language.getString(60006), 99, 360, 60, 24, this);
			
			
			_txtGuildPurpose = UIFactory.gTextInput(36, 390, 188, 78, this, null);
			_txtGuildPurpose.setStyle("textFormat",GlobalStyle.textFormatItemWhite);
			_txtGuildPurpose.setStyle("textPadding",4);
			_txtGuildPurpose.text = "XXXXXXXXXXXXXXXXXXXXXXXXX";
			_txtGuildPurpose.enabled = false;
			
			_btnChangeGuildPurpose = UIFactory.gLoadedButton(ImagesConst.EditBtn_upSkin, 208, 358, 24, 25, this);
			
			
			//right top
			UIFactory.bg(251, 69, 468, 185, this);
			UIFactory.bg(251, 69, 468, 26, this, ImagesConst.RegionTitleBg);
			UIFactory.gBitmap(ImagesConst.guildPlayerInfoTitle, 455, 75, this);
			UIFactory.checkBox(Language.getString(60019), 459, 100, 120, 20, this);
			var postionIntroduceLink:String = "<a href='event:positionInroduce' target = ''><font color='#00ff00'><u>"
				+ Language.getString(60015) + "</u></font></a>";
			var txtPostionIntroduceLink:GTextFiled = UIFactory.gTextField(postionIntroduceLink, 590, 100, 60, 20, this, null, true);
			var onOpenPositionIntroducePanel:Function = function(event:TextEvent):void
			{
				GuildPositonIntroducePanel.instance.show();
			};
			txtPostionIntroduceLink.configEventListener(TextEvent.LINK, onOpenPositionIntroducePanel);
			
			var guildListLink:String = "<a href='event:guildListLink' target = ''><font color='#00ff00'><u>" + "公会列表" + "</u></font></a>";
			var txtGuildListLink:GTextFiled = UIFactory.gTextField(guildListLink, 650, 100, 60, 20, this, null, true);
			var onOpenGuildListPanel:Function = function(event:TextEvent):void
			{
				GuildListPanel.instance.show();
			}
			txtGuildListLink.configEventListener(TextEvent.LINK, onOpenGuildListPanel);
			
			
			var selfPositionHtml:String = "<font color='#ffc293'>" + Language.getString(60009) + "：</font>";
			_txtSelfPosition = UIFactory.gTextField(selfPositionHtml, 260, 100, 130, 20, this, null, true);
				
			var selfContributionHtml:String = "<font color='#ffc293'>" + Language.getString(60010) + "：</font>";
			_txtSelfContribution = UIFactory.gTextField(selfContributionHtml, 260, 128, 130, 20, this, null, true);
			
			var selfWeekActiveHtml:String = "<font color='#ffc293'>" + Language.getString(60013) + "：</font>";
			_txtSelfWeekActive = UIFactory.gTextField(selfWeekActiveHtml, 260, 156, 130, 20, this, null, true);
			
			var selfWeekContributionHtml:String = "<font color='#ffc293'>" + Language.getString(60012) + "：</font>" 
				+ "<font color='#00ff00'>980000</font>";
			_txtSelfWeekContribution = UIFactory.gTextField(selfWeekContributionHtml, 260, 185, 130, 20, this, null, true);
			
			var selfResHtml:String = "<font color='#ffc293'>" + Language.getString(60011) + "：</font>";
			_txtSelfRes = UIFactory.gTextField(selfResHtml, 377, 185, 130, 20, this, null, true);
			
			var selfSalaryHtml:String = "<font color='#ffc293'>" + Language.getString(60014) + "：</font>";
			UIFactory.gTextField(selfSalaryHtml, 260, 220, 130, 20, this, null, true);
			
			var selfSalary1Html:String = "<font color='#ffc293'>980000</font>";
			_txtSelfSalary1 = UIFactory.gTextField(selfSalary1Html, 367, 220, 130, 20, this, null, true);
			
			var selfSalary2Html:String = "<font color='#ffc293'>980000</font>";
			_txtSelfSalary2 = UIFactory.gTextField(selfSalary2Html, 469, 220, 130, 20, this, null, true);
			
			UIFactory.gBitmap(ImagesConst.PackItemBg, 320, 208, this);
			UIFactory.gBitmap(ImagesConst.PackItemBg, 424, 208, this);
			
			_btnContributionsDonate = UIFactory.gButton(Language.getString(60016), 644, 125, 62, 24, this);
			_btnRecieveSalary = UIFactory.gButton(Language.getString(60017), 644, 214, 62, 24, this);
			
			
			
			//right bottom
			UIFactory.bg(251, 260, 468, 227, this);
			UIFactory.bg(251, 260, 468, 26, this, ImagesConst.RegionTitleBg);
			UIFactory.gBitmap(ImagesConst.guildFunctionTitle, 455, 268, this);
			
			var btnGuildFunctionList:Vector.<GLoadedButton> = new Vector.<GLoadedButton>();
			btnGuildFunctionList.push(_btnGuildTerritory, _btnGuildOtherTerriory, _btnGuildTask, _btnGuildPet);
			var imagesListOne:Vector.<String> = new Vector.<String>();
			imagesListOne.push(ImagesConst.guildTerritory_upSkin, ImagesConst.guildOtherTerritory_upSkin, 
				ImagesConst.guildTask_upSkin, ImagesConst.guildPet_upSkin);
			for (var i:int = 0; i < btnGuildFunctionList.length; i++)
			{
				btnGuildFunctionList[i] = UIFactory.gLoadedButton(imagesListOne[i], 257 + 115*i, 288, 111, 44, this);
			}
			
			var iconGuildFunctionList:Vector.<GLoadedButton> = new Vector.<GLoadedButton>();
			iconGuildFunctionList.push(_iconGuildDonate, _iconGuildEvent, _iconGuildActivity, _iconGuildPet, _iconGuildTreasure, 
				_iconGuildShop, _iconGuildUnion, _iconGuildTask);
			var imagesListTwo:Vector.<String> = new Vector.<String>();
			imagesListTwo.push(ImagesConst.guildDonateIcon, ImagesConst.guildEventIcon, ImagesConst.guildActivityIcon, ImagesConst.guildPetIcon, 
				ImagesConst.guildTreasureIcon, ImagesConst.guildShopIcon, ImagesConst.guildUnionIcon, ImagesConst.guildTaskIcon);
			for (var j:int = 0; j < iconGuildFunctionList.length; j++)
			{
				var x:int = 330 + (j % 4) * 80;
				var y:int = j >= 4 ? 412 : 340;
				iconGuildFunctionList[j] = UIFactory.gLoadedButton(ImagesConst.guildFunction_upSkin, x, y, 69, 69, this);
				var icon:GBitmap = UIFactory.gBitmap(imagesListTwo[j], x + 5, y + 4.5, this);
			}
			
			//bottom
			_btnRecruit = UIFactory.gButton(Language.getString(60003),219,493,62,24,this);
			_btnExitGuild = UIFactory.gButton(Language.getString(60004),332,493,62,24,this);
			_btnDisbandGuild = UIFactory.gButton(Language.getString(60005),445,493,62,24,this);
			_btnLevelUpGuild = UIFactory.gButton("升级公会",570,493,62,24,this);
			
			_isChangingGuildPurpose = false;
		}
		
		
		/**
		 * 刷新
		 *
		 */
		override public function update():void
		{
			//left
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			if (guildInfo.baseInfo == null)
				return;
			_bmpTxtGuildLevel.text = guildInfo.baseInfo.level.toString();
			if (guildInfo.baseInfo.level < 10)
			{
				_bmpTxtGuildLevel.x = 116;
			}
			else
			{
				_bmpTxtGuildLevel.x = 103;
			}
			
			_txtApplyNum.text = guildInfo.applyNum.toString();
			_txtGuildName.text = guildInfo.baseInfo.guildName;
			
			var branchLevel:int = 0;
			if (guildInfo.hasCreatedBranch)
			{
				branchLevel = guildInfo.branchInfo.level;
				var branchNowConfig:TGuildBranchTarget = GuildBranchLevelUpTargetConfig.instance.getInfoByTarget(branchLevel);
			}
			var branchTargetConfig:TGuildBranchTarget = GuildBranchLevelUpTargetConfig.instance.getInfoByTarget(branchLevel + 1);
			var branchExtendDesc:String = guildInfo.hasCreatedBranch 
				? (branchTargetConfig == null ? guildInfo.branchInfo.level + "级(满级)" : guildInfo.branchInfo.level + "级") 
				: "(未创建)";
			var branchMemberNum:int = guildInfo.branchMemberList.length;
			var branchMaxMemberNum:int = guildInfo.hasCreatedBranch ? guildInfo.branchInfo.maxPlayerNum : 0;
			
			var tipsStr:String = guildInfo.hasCreatedBranch 
				? (branchTargetConfig == null ? "下一等级：已满级" : "下一等级：" + (branchLevel + 1) +"级") : "(未创建)";
			if (branchTargetConfig != null && guildInfo.hasCreatedBranch)
				tipsStr += "/n增加" + (branchTargetConfig.amount - branchNowConfig.amount) + "人";
			_toolTipBranchSprite.toolTipData = tipsStr;
			
			_txtGuildInfoDesc.text = guildInfo.baseInfo.leader.name + "\n" + guildInfo.baseInfo.rank + "\n" + guildInfo.memberList.length + "/" + 
				guildInfo.baseInfo.maxPlayerNum + "\n" + branchExtendDesc + "\n" + branchMemberNum + "/" + branchMaxMemberNum + "\n" + guildInfo.baseInfo.resource;
			
			_txtGuildPurpose.text = guildInfo.baseInfo.purpose;
			_btnCreateOrLevelUpBranchGuild.label = guildInfo.hasCreatedBranch ? "升级分会" : "创建分会";
			
			//right top
			_txtSelfPosition.htmlText =  "<font color='#ffc293'>" + Language.getString(60009) + "：</font>"
				+ "<font color='" + GameDefConfig.instance.getItem("EGuildPostion", guildInfo.selfInfo.position).text1 + "'>" + GameDefConfig.instance.getItem("EGuildPostion", guildInfo.selfInfo.position).text + "</font>";
			_txtSelfContribution.htmlText = "<font color='#ffc293'>" + Language.getString(60010) + "：</font>" 
				+ "<font color='#ffffff'>" + guildInfo.selfInfo.totalContribution + "</font>";
			_txtSelfRes.htmlText = "<font color='#ffc293'>" + Language.getString(60011) + "：</font>" 
				+ "<font color='#ffffff'>" + guildInfo.selfInfo.resource + "</font>";
			_txtSelfWeekContribution.htmlText = "<font color='#ffc293'>" + Language.getString(60012) + "：</font>" 
				+ "<font color='#00ff00'>" + guildInfo.selfInfo.contributionWeek + "</font>";
			_txtSelfWeekActive.htmlText = "<font color='#ffc293'>" + Language.getString(60013) + "：</font>" 
				+ "<font color='#00ff00'>" + guildInfo.selfInfo.activity + "</font>";
			_txtSelfSalary1.htmlText = "<font color='#ffc293'>wait to assign</font>";
			_txtSelfSalary2.htmlText = "<font color='#ffc293'>wait to assign</font>";
			
			_txtSelfRes.visible = guildInfo.selfInfo.position == EGuildPosition._EGuildBranchMember;
			
			//set button visible
			_btnDisbandGuild.visible 				= GuildConst.hasPermissions(GuildConst.DisbandGuild);
			_btnChangeGuildPurpose.visible 			= GuildConst.hasPermissions(GuildConst.ChangePurpose);
			_btnCreateOrLevelUpBranchGuild.visible 	= GuildConst.hasPermissions(GuildConst.CreateBranch);
			_btnRecruit.visible 					= GuildConst.hasPermissions(GuildConst.Recruit);
			_btnLevelUpGuild.visible 				= GuildConst.hasPermissions(GuildConst.UpgradeGuild);
			_btnImpeachLeader.visible				= GuildConst.CanImpeachLeader;
			
			_bmpApply.visible =_txtApplyNum.visible = GuildConst.hasPermissions(GuildConst.ApproveIntoGuild) && guildInfo.applyNum > 0;
			_btnApplyList.visible 					= GuildConst.hasPermissions(GuildConst.ApproveIntoGuild);
		}
		
		
		/**
		 * 鼠标响应
		 *
		 */
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnApplyList:
					if (Cache.instance.guild.selfGuildInfo.applyNum == 0)
					{
						MsgManager.showRollTipsMsg("暂无记录");
						return;
					}
					GuildApplyListPanel.instance.show();
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_APPLY_LIST_GET, null));
					break;
				case _btnCreateOrLevelUpBranchGuild:
					if (!Cache.instance.guild.selfGuildInfo.hasCreatedBranch)
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_CREATE_BRANCH, null));
					}
					else
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_BRANCH_LEVEL_UP, null));
					}
					break;
				case _btnChangeGuildPurpose:
					if (_isChangingGuildPurpose == false)
					{
						_txtGuildPurpose.enabled = true;
						_isChangingGuildPurpose = true;
					}
					else
					{
						_txtGuildPurpose.enabled = false;
						_isChangingGuildPurpose = false;
						Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_PURPOSE_CHANGE, _txtGuildPurpose.text));
					}
					break;
				case _btnContributionsDonate:
					break;
				case _btnRecieveSalary:
					break;
				case _btnRecruit:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_RECRUIT, null));
					break;
				case _btnExitGuild:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_EXIT, null));
					break;
				case _btnDisbandGuild:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_DISBAND, null));
					break;
				case _btnImpeachLeader:
					GuildImpeachLeaderPanel.instance.show();
					break;
				case _btnLevelUpGuild:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_LEVEL_UP, null));
					break;
				case _btnGuildTerritory:
					break;
				case _btnGuildOtherTerriory:
					break;
				case _btnGuildTask:
					break;
				case _btnGuildPet:
					break;
				case _iconGuildActivity:
					break;
				case _iconGuildDonate:
					break;
				case _iconGuildEvent:
					break;
				case _iconGuildPet:
					break;
				case _iconGuildShop:
					break;
				case _iconGuildTask:
					break;
				case _iconGuildTreasure:
					break;
				case _iconGuildUnion:
					break;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			//这个按钮放在_toolTipBranchSprite容器当中，需要单独释放
			_btnCreateOrLevelUpBranchGuild.dispose(isReuse);
			_btnCreateOrLevelUpBranchGuild = null;
			
			super.disposeImpl(isReuse);
		}
	}
}