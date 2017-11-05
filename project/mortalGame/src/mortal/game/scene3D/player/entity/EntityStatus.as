package mortal.game.scene3D.player.entity
{
	import Message.BroadCast.SEntityInfo;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.map3D.util.GameMapUtil;

	public class EntityStatus
	{
		public var isInGroup:Boolean; //是否在队伍中
		public var isInGuild:Boolean; //是否在仙盟中
		public var isInFriend:Boolean; //是否在好友中
		public var isAttackRole:Boolean;//是否攻击主角
		public var distance:Number; //与主角的距离
		
		public var isEnemy:Boolean; //是否是敌方
		
		public var isInDisplayList:Boolean = false;
		
		public var isUpdate:Boolean = true; //是否需要更新
		
		public function EntityStatus()
		{
			
		}
		
		public function updateisInGroup( sinfo:SEntityInfo ):void
		{
//			isInGroup = Cache.instance.group.entityIsInGroup(sinfo.entityId) && !GameMapUtil.isCrossGroupMap() 
//				|| Cache.instance.crossGroup.entityIsInGroup(sinfo.entityId) && GameMapUtil.isCrossGroupMap();
		}
		
		public function clear():void
		{
			isInGroup = false;
			isInGuild = false;
			isInFriend = false;
			isAttackRole = false;
			distance = -1;
			isEnemy = false;
			isInDisplayList = false;
			isUpdate = true;
		}
	}
}