package mortal.game.view.chat.data
{
	import Message.Public.SMiniPlayer;
	
	import mortal.game.utils.PlayerUtil;

	public class FaceAuthority
	{
		public static const NORMAL:int = 1;
		public static const VIP:int = 2;
		
		/**
		 * 获得满权限 
		 * @return 
		 * 
		 */		
		public static function getFullAuthority():int
		{
			return NORMAL | VIP;
		}
		
		/**
		 * 获得一个玩家的表情权限 
		 * @param playerMiniInfo
		 * @return 
		 * 
		 */		
		public static function getPlayerAuthority(miniPlayer:SMiniPlayer):int
		{
			return getFullAuthority();
			if(PlayerUtil.isVIP(miniPlayer))
			{
				return VIP | NORMAL;
			}
			else
			{
				return NORMAL;
			}
		}
		
		/**
		 * 获得一个玩家的表情权限 
		 * @param playerMiniInfo
		 * @return 
		 * 
		 */		
		public static function getMiniPlayerAuthority(player:SMiniPlayer):int
		{
			return getFullAuthority();
			if(player.VIP > 0)
			{
				return VIP | NORMAL;
			}
			else
			{
				return NORMAL;
			}
		}
		
		public static function getVIPAuthority(vip:int):int
		{
			return getFullAuthority();
			if(vip > 0)
			{
				return VIP | NORMAL;
			}
			else
			{
				return NORMAL;
			}
		}
	}
}