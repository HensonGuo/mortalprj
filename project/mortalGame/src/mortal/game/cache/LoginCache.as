package mortal.game.cache
{
	import Message.BroadCast.SEntityInfo;
	import Message.Game.SLoginGameReturn;
	import Message.Login.SLogin;
	import Message.Login.SLoginReturn;
	import Message.Public.SPoint;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.GameDefConfig;

	/**
	 * 登陆信息 包括验证登陆 和 游戏登陆 
	 * @author jianglang
	 * 
	 */	
	public class LoginCache
	{
		public var loginData:SLogin;
		
		public var loginReturn:SLoginReturn;
		
		private var _loginGame:SLoginGameReturn;
		
		public function LoginCache()
		{
			
		}
		
		public function get loginGame():SLoginGameReturn
		{
			return _loginGame;
		}
		
		public function set loginGame(value:SLoginGameReturn):void
		{
			_loginGame = value;
		
			var _entityInfo:SEntityInfo = Cache.instance.role.entityInfo;
			
			_entityInfo.entityId = value.entityId;
			_entityInfo.VIP = _loginGame.player.VIP;
			
			var sp:SPoint = new SPoint();
			sp.x = loginGame.pos.x;
			sp.y = loginGame.pos.y;
			
			_entityInfo.maxLife = value.baseFight.maxLife;
			_entityInfo.maxMana = value.baseFight.maxMana;
			_entityInfo.speed = loginGame.baseFight.speed;
			_entityInfo.points = [sp];
			
//			_entityInfo.titles = new Dictionary();
//			_entityInfo.weapons = new Dictionary();
		
			Cache.instance.role.roleInfo = loginGame.role;
			Cache.instance.role.playerInfo = loginGame.player;
			
//			Cache.instance.role.entityInfo.fightMode = loginGame.player.mode;
			
			Cache.instance.role.money = loginGame.money;
			
			Cache.instance.role.entityInfo = _entityInfo;
			
//			Cache.instance.guide.autoType = GameDefConfig.instance.getGuideAutoType(_entityInfo.camp);
		}
	}
}