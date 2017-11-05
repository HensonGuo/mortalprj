package mortal.game.view.guild.otherpanel
{
	import Message.Game.EGuildPosition;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	
	import flash.events.MouseEvent;
	
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildImpeachLeaderPanel extends GuildOtherBasePanel
	{
		private static var _instance:GuildImpeachLeaderPanel = null;
		
		private var _txtImpeachRulesDesc:GTextFiled;
		private var _btnImpeach:GButton;
		
		public function GuildImpeachLeaderPanel($layer:ILayer=null)
		{
			super($layer);
			setSize(345,205);
			title = "会长弹劾";
		}
		
		public static function get instance():GuildImpeachLeaderPanel
		{
			if (!_instance)
				_instance = new GuildImpeachLeaderPanel();
			return _instance;
		}
		
		override protected function layoutUI():void
		{
			var impeachRules:String = "<font size='12' color='#FFCC00'>1.超过3天未在线</font><br>" +
				"<font size='12' color='##0099FF'>	本公会会长已经超过3天未在线，所有长老以上的成员可进行弹劾，弹劾需购买" +
				"“弹劾密券”，成功弹劾则你将成为新会长。</font><br>" +
				"<font size='12' color='#FFCC00'>2.弹劾期间</font><br>" + 
				"<font size='12' color='#0099FF'>	弹劾期间会长可以进行反驳，期限为2天。</font>";
			_txtImpeachRulesDesc = UIFactory.gTextField("", 15, 46, 320, 120, this, null, true);
			_txtImpeachRulesDesc.multiline = true;
			_txtImpeachRulesDesc.wordWrap = true;
			_txtImpeachRulesDesc.htmlText = impeachRules;
			_btnImpeach = UIFactory.gButton("使用弹劾密券", 123, 175, 108, 24, this);
		}
		
		override protected function onMouseClick(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _btnImpeach:
					var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
					if (guildInfo.selfInfo.position != EGuildPosition._EGuildDeputyLeader && 
					guildInfo.selfInfo.position != EGuildPosition._EGuildLeader && 
					guildInfo.selfInfo.position != EGuildPosition._EGuildPresbyter)
					{
						MsgManager.showRollTipsMsg("职位权限不够!");
						return;
					}
					if (guildInfo.selfInfo.position == EGuildPosition._EGuildLeader)
					{
						MsgManager.showRollTipsMsg("不可以自己弹劾自己噢!");
						return;
					}
					
					var hasImpeachItem:Boolean = Cache.instance.pack.backPackCache.getItemByCode(180070000) != null || 
					Cache.instance.pack.backPackCache.getItemByCode(180071000) != null;
					if (!hasImpeachItem)
					{
						//pop qucik buy panel
						MsgManager.showRollTipsMsg("不可以自己弹劾自己噢!");
						return;
					}
					Dispatcher.dispatchEvent( new DataEvent(EventName.GUILD_IMPEACH_LEADER, null));
					break;
			}
		}
		
	}
}