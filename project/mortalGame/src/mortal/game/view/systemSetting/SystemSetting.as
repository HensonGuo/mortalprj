/**
 * @heartspeak
 * 2014-4-28 
 */   	

package mortal.game.view.systemSetting
{
	import flash.utils.Dictionary;
	
	import mortal.game.view.systemSetting.data.SettingItem;

	public class SystemSetting
	{
		public var hideSetter:SettingItem;//玩家显示在屏幕上的设置
		public var playerOnScreen:SettingItem;//玩家显示在屏幕上的数量
		public var isHideSkill:SettingItem;//是否隐藏技能特效
		public var isHideAllEffect:SettingItem;//是否隐藏所有特效
		public var isHideLife:SettingItem;//是否隐藏血条
		public var isHideOterPlayerName:SettingItem;//是否隐藏其他玩家名字
		public var isHideTitle:SettingItem;//是否隐藏称号
		public var isHideGuildName:SettingItem;//是否隐藏公会职位称号
		public var isHideTeamChatBubble:SettingItem;//是否隐藏好友聊天冒泡提示信息
		public var isHideSystemTips:SettingItem;//是否隐藏系统提示信息
		public var isHideRumorTips:SettingItem;//是否隐藏传闻信息
		public var isRefuseTrade:SettingItem;//是否拒绝交易
//		public var isRefuseBeAddToFriend:SettingItem;//是否拒绝添加好友邀请
		public var isRefuseBeAddToGroup:SettingItem;//是否拒绝组队邀请
		public var isRefuseBeAddToGuild:SettingItem;//是否拒绝入会邀请
		public var isSelectNotAutoAttack:SettingItem;//自动攻击不自动攻击
		public var isNotAutoSelectPet:SettingItem;//自动攻击不选择宠物
		public var isNotAutoSelectPlayer:SettingItem;//自动攻击不选择玩家
		public var isNotAutoSelectMonster:SettingItem;//自动攻击不选择怪物
		public var isShortcutShowSecond:SettingItem;//快捷栏显示倒计时数字
		public var isLockShortcut:SettingItem;//是否锁定快捷栏
		public var bgMusic:SettingItem;//音乐设置
		public var effectMusic:SettingItem;//音效设置
		public var isForbidMusic:SettingItem;//是否禁音
		
		private var _settingDic:Dictionary = new Dictionary();
		
		public function SystemSetting()
		{
			init();
		}
		
		private static var _instance:SystemSetting;
		
		public static function get instance():SystemSetting
		{
			if(!_instance)
			{
				_instance = new SystemSetting();
			}
			return _instance;
		}
		
		/**
		 *  
		 * 初始化
		 */		
		public function init():void
		{
			var extendObj:Array = new Array();
			extendObj.push({value:1,text:"屏蔽所有玩家和宠物"});
			extendObj.push({value:2,text:"屏蔽友方玩家和宠物"});
			extendObj.push({value:3,text:"屏蔽敌方玩家和宠物"});
			
			//屏蔽玩家
			hideSetter = new SettingItem("屏蔽设置(快捷键F9)","a",0,SettingItem.SELECT,extendObj);
			addSetting(hideSetter);
			playerOnScreen = new SettingItem("单屏内玩家人数显示上限","b",30,SettingItem.INT,{min:5,max:200,def:30});
			addSetting(playerOnScreen);
			
			//屏蔽游戏特效
			isHideSkill = new SettingItem("隐藏技能特效","c");
			addSetting(isHideSkill);
			isHideAllEffect = new SettingItem("屏蔽所有光效","d");
			addSetting(isHideAllEffect);
			
			//屏蔽信息
			isHideLife = new SettingItem("屏蔽玩家和怪物血条","e");//仅血条
			addSetting(isHideLife);
			isHideOterPlayerName = new SettingItem("隐藏其他玩家名字信息","f");//玩家，除了自己   名字和称号其他血条外的
			addSetting(isHideOterPlayerName);
			isHideTitle = new SettingItem("屏蔽所有称号","g");//称号 所有人的
			addSetting(isHideTitle);
			
			//屏蔽消息
			isHideTeamChatBubble = new SettingItem("屏蔽组队时聊天气泡","h");
			addSetting(isHideTeamChatBubble);
			isHideSystemTips = new SettingItem("屏蔽系统提示广播","i");
			addSetting(isHideSystemTips);
			isHideRumorTips = new SettingItem("屏蔽聊天传闻广播","j");
			addSetting(isHideRumorTips);
			
			//拒绝邀请
			isRefuseTrade = new SettingItem("拒绝他人向我发起交易","k");
			addSetting(isRefuseTrade);
//			isRefuseBeAddToFriend = new SettingItem("拒绝他人将我加为好友","l");
//			addSetting(isRefuseBeAddToFriend);  好友界面已有取消
			isRefuseBeAddToGroup = new SettingItem("拒绝他人邀请我加入队伍","m");
			addSetting(isRefuseBeAddToGroup);
			isRefuseBeAddToGuild = new SettingItem("拒绝他人邀请我加入公会","n");
			addSetting(isRefuseBeAddToGuild);
			
			//选取目标
			isSelectNotAutoAttack = new SettingItem("选择目标不自动进行攻击","o");
			addSetting(isSelectNotAutoAttack);
			isNotAutoSelectPet = new SettingItem("自动选取目标是不选宠物","p");
			addSetting(isNotAutoSelectPet);
			isNotAutoSelectPlayer = new SettingItem("自动选取时不选取玩家","q");
			addSetting(isNotAutoSelectPlayer);
			isNotAutoSelectMonster = new SettingItem("自动选取时不选取怪物","r");
			addSetting(isNotAutoSelectMonster);
			
			//其他设置
			isShortcutShowSecond = new SettingItem("技能栏显示技能冷却秒数","s",1);
			addSetting(isShortcutShowSecond);
			isLockShortcut = new SettingItem("锁定快捷栏","t");
			addSetting(isLockShortcut);
			
			//音乐设置
			bgMusic = new SettingItem("音乐","u",50,SettingItem.INT);
			effectMusic = new SettingItem("音效","v",50,SettingItem.INT);
			isForbidMusic = new SettingItem("静音","w");
			addSetting(bgMusic);
			addSetting(effectMusic);
			addSetting(isForbidMusic);
			
			//后面添加的
			isHideGuildName = new SettingItem("屏蔽公会职位称号","x");
			addSetting(isHideGuildName);
		}
		
		/**
		 * 添加设置 
		 * @param setting
		 * 
		 */		
		private function addSetting(setting:SettingItem):void
		{
			_settingDic[setting.key] = setting;
		}
		
		/**
		 * 
		 * 默认设置
		 */
		public function resetToDefault():void
		{
			for each(var settingItem:SettingItem in _settingDic)
			{
				settingItem.resetToDefault();
			}
		}
		
		/**
		 * 
		 * 保存设置
		 */
		public function updateToServer():void
		{
			for each(var settingItem:SettingItem in _settingDic)
			{
				settingItem.updateToServer();
			}
		}
		
		/**
		 * 
		 * 恢复设置
		 */
		public function recover():void
		{
			for each(var settingItem:SettingItem in _settingDic)
			{
				settingItem.recover();
			}
		}
		
		/**
		 * 设置转化为Json 
		 * @return 
		 * 
		 */		
		public function getServerStr():String
		{
			var obj:Object = new Object();
			for each(var settingItem:SettingItem in _settingDic)
			{
				obj[settingItem.key] = settingItem.value;
			}
			return JSON.stringify(obj);
		}
		
		public var isInitedFromServer:Boolean = false;
		/**
		 * 服务设置转化为本地数据 
		 * @return 
		 * 
		 */		
		public function initFromServerStr(jstr:String):void
		{
			if(!jstr)
			{
				return;
			}
			var obj:Object = JSON.parse(jstr);
			for(var key:String in obj)
			{
				var settingItem:SettingItem = _settingDic[key];
				if(settingItem)
				{
					settingItem.value = int(obj[key]);
				}
			}
			isInitedFromServer = true;
		}
	}
}