/**
 * @date	2011-3-5 下午12:54:31
 * @author  jianglang
 * 
 */	

package mortal.game.mvc
{
	import mortal.game.proxy.ChatProxy;
	import mortal.game.proxy.CopyProxy;
	import mortal.game.proxy.EquipProxy;
	import mortal.game.proxy.FriendProxy;
	import mortal.game.proxy.GroupProxy;
	import mortal.game.proxy.GuildProxy;
	import mortal.game.proxy.MailProxy;
	import mortal.game.proxy.MarketProxy;
	import mortal.game.proxy.MountProxy;
	import mortal.game.proxy.PackProxy;
	import mortal.game.proxy.PetProxy;
	import mortal.game.proxy.PlayerProxy;
	import mortal.game.proxy.RoleProxy;
	import mortal.game.proxy.SceneProxy;
	import mortal.game.proxy.ShopProxy;
	import mortal.game.proxy.TaskProxy;
	import mortal.game.proxy.TradeProxy;
	import mortal.game.proxy.WizardProxy;

	public class GameProxy
	{
		private static var _sceneProxy:SceneProxy;
		private static var _packProxy:PackProxy;
		private static var _role:RoleProxy;
		private static var _equip:EquipProxy;
		private static var _shop:ShopProxy;
		private static var _pet:PetProxy;
		private static var _group:GroupProxy;
		private static var _friend:FriendProxy;
		private static var _player:PlayerProxy;
		private static var _task:TaskProxy;
		private static var _copy:CopyProxy;
		private static var _chat:ChatProxy;
		private static var _mail:MailProxy;
		private static var _market:MarketProxy;
		private static var _trade:TradeProxy;
		private static var _mount:MountProxy;
		private static var _guild:GuildProxy;
		private static var _wizard:WizardProxy;
		
		public function GameProxy()
		{
			
		}
		
		public static function get sceneProxy():SceneProxy
		{
			return _sceneProxy || (_sceneProxy=new SceneProxy());
		}
		
		public static function get packProxy():PackProxy
		{
			return _packProxy || (_packProxy = new PackProxy());
		}
		
		public static function get role():RoleProxy
		{
			return _role || (_role = new RoleProxy());
		}
		
		public static function get equip():EquipProxy
		{
			return _equip || (_equip = new EquipProxy());
		}
		
		public static function get shop():ShopProxy
		{
			return _shop || (_shop = new ShopProxy());
		}
		
		public static function get pet():PetProxy
		{
			return _pet ||= new PetProxy();
		}
		
		public static function get group():GroupProxy
		{
			return _group || (_group = new GroupProxy());
		}
		
		public static function get friend():FriendProxy
		{
			return _friend || (_friend = new FriendProxy());
		}
		
		public static function get player():PlayerProxy
		{
			return _player || (_player = new PlayerProxy());
		}
		
		public static function get task():TaskProxy
		{
			return _task ||(_task = new TaskProxy());
		}
		
		public static function get copy():CopyProxy
		{
			return _copy || (_copy = new CopyProxy());
		}
		
		public static function get mail():MailProxy
		{
			return _mail || (_mail = new MailProxy());
		}
		
		public static function get market():MarketProxy
		{
			return _market || (_market = new MarketProxy());
		}
		
		public static function get trade():TradeProxy
		{
			return _trade || (_trade = new TradeProxy());
		}
		
		public static function get chat():ChatProxy
		{
			return _chat || (_chat = new ChatProxy());
		}
		
		public static function get mount():MountProxy
		{
			return _mount|| (_mount = new MountProxy());
		}
		
		public static function get guild():GuildProxy
		{
			return _guild || (_guild = new GuildProxy());
		}
		
		public static function get wizard():WizardProxy
		{
			return _wizard || (_wizard = new WizardProxy());
		}
	}
}
