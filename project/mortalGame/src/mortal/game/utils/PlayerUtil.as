/**
 * @heartspeak
 * 2014-3-11 
 */   	

package mortal.game.utils
{
	import Message.BroadCast.SEntityInfo;
	import Message.Public.SGroupPlayer;
	import Message.Public.SMiniPlayer;
	import Message.Public.SPublicPlayer;

	public class PlayerUtil
	{
		public function PlayerUtil()
		{
		}
		
		public static function isVIP(miniPlayer:SMiniPlayer):Boolean
		{
			return miniPlayer.VIP > 0;
		}
		
		public static function copyPubicToMiniPlayer(publicPlayer:SPublicPlayer):SMiniPlayer
		{
			var miniPlayer:SMiniPlayer = new SMiniPlayer();
			miniPlayer.entityId = publicPlayer.entityId;
			miniPlayer.name = publicPlayer.name;
			miniPlayer.sex = publicPlayer.sex;
			miniPlayer.career = publicPlayer.career;
			miniPlayer.camp = publicPlayer.camp;
			miniPlayer.level = publicPlayer.level;
			miniPlayer.VIP = publicPlayer.VIP;
			miniPlayer.online = publicPlayer.online;
			miniPlayer.combat = publicPlayer.combat;
			return miniPlayer;
		}
		
		public static function copyEntityInfoToMiniPlayer(entityInfo:SEntityInfo):SMiniPlayer
		{
			var miniPlayer:SMiniPlayer = new SMiniPlayer();
			miniPlayer.entityId = entityInfo.entityId;
			miniPlayer.name = entityInfo.name;
			miniPlayer.sex = entityInfo.sex;
			miniPlayer.career = entityInfo.career;
			miniPlayer.camp = entityInfo.camp;
			miniPlayer.level = entityInfo.level;
			miniPlayer.VIP = entityInfo.VIP;
			miniPlayer.online = true;
			miniPlayer.combat = entityInfo.combat;
			return miniPlayer;
		}
		
	}
}