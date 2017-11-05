package mortal.game.cache
{
	import com.gengine.debug.Log;
	
	import flash.system.System;
	
	import mortal.game.cache.guild.GuildCache;
	import mortal.game.cache.packCache.PackCache;
	import mortal.game.view.autoFight.AutoFightCache;
	import mortal.game.view.copy.CopyCache;
	import mortal.game.view.group.GroupCache;
	import mortal.game.view.mainUI.shortcutbar.ShortcutBarCache;
	import mortal.game.view.mainUI.smallMap.SmallMapCache;
	import mortal.game.view.mount.MountCache;
	import mortal.game.view.npc.NpcCache;
	import mortal.game.view.shopMall.ShopCache;
	import mortal.game.view.skill.SkillCache;
	import mortal.game.view.task.TaskCache;
	import mortal.game.view.wizard.WizardCache;

	public class Cache
	{
		private static var _instance:Cache;
		
		public function Cache()
		{
			if( _instance != null )
			{
				throw new Error("Cache 单例");
			}
		}
		
		public static function get instance():Cache
		{
			if(!_instance)
			{
				Log.system("准备初始化Cache","系统总内存:",System.totalMemory);
				_instance = new Cache();
				Log.system("Cache初始化完毕","系统总内存:",System.totalMemory);
			}
			return _instance;
		}
		
		public var login:LoginCache = new LoginCache();
		public var entity:EntityCache = new EntityCache();
		public var role:RoleCache = new RoleCache();
		public var scene:SceneCache = new SceneCache();
		public var pack:PackCache = new PackCache();
		public var clientSettingCache:ClientSettingCache = new ClientSettingCache();//新加客户端系统数据
		public var skill:SkillCache = new SkillCache();
		public var cd:CDCache = new CDCache(); // 冷却
		public var shortcut:ShortcutBarCache = new ShortcutBarCache(); // 快捷栏
		public var buff:BuffCache = new BuffCache();
		public var smallmap:SmallMapCache = new SmallMapCache(); //小地图
		public var pet:PetCache = new PetCache();//宠物
		public var group:GroupCache = new GroupCache(); //组队
		public var task:TaskCache = new TaskCache(); // 任务
		public var friend:FriendCache = new FriendCache();// 好友
		public var shop:ShopCache = new ShopCache(); // 商店
		public var npc:NpcCache = new NpcCache(); // npc对话
		public var mail:MailCache = new MailCache(); // 邮件
		public var market:MarketCache = new MarketCache(); // 市场
		public var trade:TradeCache = new TradeCache(); // 交易
//		public var copy:CopyCache = new CopyCache(); // 副本
		public var autoFight:AutoFightCache = new AutoFightCache(); // 挂机
		public var mount:MountCache = new MountCache();//坐骑
		public var forging:ForgingCache = new ForgingCache();// 锻造
		public var copy:CopyCache = new CopyCache(); // 副本
		public var guild:GuildCache = new GuildCache();//帮会列表
		public var wizard:WizardCache = new WizardCache();//精灵
		public var lottery:LotteryCache = new LotteryCache();//抽奖
	}
}