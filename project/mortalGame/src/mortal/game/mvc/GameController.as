package mortal.game.mvc
{
	import mortal.game.control.*;
	import mortal.game.view.autoFight.AutoFightController;
	import mortal.game.view.chat.ChatController;
	import mortal.game.view.copy.CopyController;
	import mortal.game.view.group.GroupController;
	import mortal.game.view.group.groupAvatar.GroupAvatarController;
	import mortal.game.view.guild.GuildController;
	import mortal.game.view.mainUI.petAvatar.PetAvatarController;
	import mortal.game.view.mainUI.rightTopBar.RightTopBar;
	import mortal.game.view.mainUI.selectAvatar.SelectAvatarController;
	import mortal.game.view.mainUI.shortcutbar.ShortcutBarController;
	import mortal.game.view.mainUI.smallMap.SmallMapController;
	import mortal.game.view.mount.MountController;
	import mortal.game.view.npc.NpcController;
	import mortal.game.view.pack.PackController;
	import mortal.game.view.palyer.PlayerController;
	import mortal.game.view.pet.PetController;
	import mortal.game.view.shop.ShopController;
	import mortal.game.view.skill.SkillController;
	import mortal.game.view.systemSetting.SystemSettingController;
	import mortal.game.view.task.TaskController;
	import mortal.game.view.tools.FlyEntityController;
	import mortal.game.view.wizard.WizardController;
	
	/**
	 * 所有controller 管理 
	 * @author jianglang
	 * 
	 */	
	public class GameController
	{
		public function GameController(){};
		
		/**
		 * 地图场景 
		 */		
		public static var scene:Scene3DController;
		/**
		 * 游戏模块
		 * */
		public static var system:SystemController;
		public static var chat:ChatController;
		public static var navbar:NavbarController;
		public static var rightTopBar:RightTopController;
		public static var smallMap:SmallMapController;
		public static var avatar:AvatarController;
		public static var selectAvatar:SelectAvatarController;
		public static var petAvatar:PetAvatarController;
		public static var relive:ReliveController;
		public static var pack:PackController;
		public static var team:TeamAvaterController;
		public static var mapNavBar:MapNavBarController;
		public static var skill:SkillController;
		public static var shortcut:ShortcutBarController;
		public static var cd:CDController;
		public static var player:PlayerController;
		public static var systemSetting:SystemSettingController;
		public static var flyEntity:FlyEntityController;
		public static var shopMall:ShopMallController;
		public static var mail:MailController;  //邮件
		public static var market:MarketController;  //市场 
		public static var trade:TradeController;  //交易 
		public static var group:GroupController;
		public static var task:TaskController;
		public static var pet:PetController;
		public static var friend:FriendController;
		public static var npc:NpcController;
		public static var groupAvatarController:GroupAvatarController;
		public static var shop:ShopController;
		public static var autoFight:AutoFightController;
		public static var copy:CopyController;
		public static var mount:MountController;
		public static var forging:ForgingController;
		public static var guild:GuildController;
		public static var wizard:WizardController;
		
		private static var _isInit:Boolean = false;
		
		public static function init():void
		{
			if( _isInit ) return;
			
			_isInit = true;
			
			system = new SystemController();
			
			scene = new Scene3DController(); // 场景
			
			chat = new ChatController();//聊天
			
			navbar = new NavbarController();//导航栏
			
			rightTopBar = new RightTopController();//右上角图标
			
			smallMap = new SmallMapController();//小地图
			
			avatar = new AvatarController();//头像
			
			selectAvatar = new SelectAvatarController();//选择目标头像
			
			petAvatar = new PetAvatarController();//宠物头像
			
			relive = new ReliveController(); // 复活、死亡相关
			
			pack = new PackController();  //背包
			
			team = new TeamAvaterController();  //队伍
			
			mapNavBar = new MapNavBarController();
			
			skill = new SkillController(); // 技能
			
			shortcut = new ShortcutBarController(); // 快捷栏
			
			cd = new CDController(); // CD冷却
			
			player = new PlayerController(); //任务属性
			
			systemSetting = new SystemSettingController();
			
			flyEntity = new FlyEntityController();
			
			shopMall = new ShopMallController();
			
			mail = new MailController();  //邮件
			
			market = new MarketController();  //市场
			
			trade = new TradeController();  //市场
			
			group = new GroupController(); //组队
			
			task = new TaskController(); // 任务
			
			pet = new PetController();//宠物
			
			friend = new FriendController();// 好友
			
			npc = new NpcController(); // npc对话
			
			groupAvatarController = new GroupAvatarController(); //组队头像
			
			shop = new ShopController(); // 商店
			
			autoFight = new AutoFightController(); // 自动挂机的设置面板
			
			copy = new CopyController(); // 副本
			
			mount = new MountController();//坐骑
			
			forging = new ForgingController();// 锻造
			
			guild = new GuildController();
			
			wizard = new WizardController();//精灵
		}
		
		/**
		 * 根据一模块的posType获取到相应的controller，例如背包id为0，人物为3（PosType为服务器人员定义）
		 */
	}
}