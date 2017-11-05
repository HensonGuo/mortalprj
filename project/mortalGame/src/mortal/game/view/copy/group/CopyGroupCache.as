/**
 * 2014-3-21
 * @author chenriji
 **/
package mortal.game.view.copy.group
{
	import Message.DB.Tables.TCopy;
	import Message.Public.SCopyGroupInfo;
	import Message.Public.SCopyWaitingInfo;
	import Message.Public.SEntityId;
	import Message.Public.SGroupPlayer;
	
	import fl.data.DataProvider;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.view.copy.group.view.data.CopyTeamateData;
	
	public class CopyGroupCache
	{
		private var _waittings:SCopyWaitingInfo;
		private var _inCopy:Array;
		private var _outCopy:Array;
		
		
		public var tCopy:TCopy;
		
		public function CopyGroupCache()
		{
			_inCopy = [];
			_outCopy = [];
		}
		
		
		public function set groupInfos(info:SCopyWaitingInfo):void
		{
			_waittings = info;
			_inCopy = [];
			_outCopy = [];
			for each(var group:SCopyGroupInfo in info.groupInfos)
			{
				if(group.progress == -1)
				{
					_outCopy.push(group);
				}
				else
				{
					_inCopy.push(group);
				}
			}
		}
		
		public function getOutCopyTeamDatas():DataProvider
		{
			var res:DataProvider = new DataProvider();
			for(var i:int = 0; i < _outCopy.length; i++)
			{
//				var data:CopyTeamateData = new CopyTeamateData();
				res.addItem(_outCopy[i]);
			}
			return res;
		}
		
		public function getInCopyTeamDatas():DataProvider
		{
			var res:DataProvider = new DataProvider();
			for(var i:int = 0; i < _inCopy.length; i++)
			{
				res.addItem(_inCopy[i]);
			}
			return res;
		}
		
		public function getTodayNum(id:SEntityId):int
		{
			if(_waittings == null)
			{
				return 0;
			}
			return _waittings.memberEnterNum[id];
		}
		
		public function getMyTeamDatas(tCopy:TCopy):DataProvider
		{
			var res:DataProvider = new DataProvider();
			if(!Cache.instance.group.isInGroup)
			{
				return res;
			}
			var isCaptin:Boolean = Cache.instance.group.isCaptain;
			var teamates:Array = Cache.instance.group.players;
			for(var i:int = 0; i < teamates.length; i++)
			{
				var player:SGroupPlayer = teamates[i];
				var data:CopyTeamateData = new CopyTeamateData();
				data.amICaptin = isCaptin;
				if(player.player.entityId.id == Cache.instance.group.captain.id)
				{
					data.isCaptin = true;
				}
				data.maxNum = tCopy.dayNum;
				data.player = player.player;
				data.todayNum = getTodayNum(player.player.entityId);
				res.addItem(data);
				
				var entity:SpritePlayer = ThingUtil.entityUtil.getEntity(player.player.entityId) as SpritePlayer;
				if(entity == null)
				{
					data.isInRange = false;
				}
				else
				{
					var dis:int = GeomUtil.calcDistance(entity.x2d, entity.y2d, RolePlayer.instance.x2d, RolePlayer.instance.y2d);
					data.isInRange = (dis <= 400);
				}
			}
			return res;
		}
	}
}