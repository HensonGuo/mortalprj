/**
 * 2014-3-21
 * @author chenriji
 **/
package mortal.game.view.copy
{
	import Message.DB.Tables.TCopy;
	import Message.Public.SCopyGroupInfo;
	import Message.Public.SCopyWaitingInfo;
	import Message.Public.SEntityId;
	import Message.Public.SGroupPlayer;
	import Message.Public.SPlayerCopy;
	
	import fl.data.DataProvider;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.view.copy.group.CopyGroupCache;
	import mortal.game.view.copy.group.view.data.CopyTeamateData;

	public class CopyCache
	{

		public var group:CopyGroupCache;
		
		private var _enterCounts:Dictionary = new Dictionary(); // 当天进入的次数
		
		public function CopyCache()
		{
			initCaches();
		}
		
		private function initCaches():void
		{
			group = new CopyGroupCache();
		}
		
		public function updateEnterCounts(dic:Dictionary):void
		{
			_enterCounts = dic;
		}
		
		public function getTodayEnterTimes(copyCode:int):int
		{
			var info:SPlayerCopy = _enterCounts[copyCode];
			if(info == null)
			{
				return 0;
			}
			return info.enterNum;
		}
	}
}