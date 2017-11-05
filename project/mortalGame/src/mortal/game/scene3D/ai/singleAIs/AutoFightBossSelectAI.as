/**
 * 2014-3-19
 * @author chenriji
 **/
package mortal.game.scene3D.ai.singleAIs
{
	import Message.BroadCast.SEntityInfo;
	import Message.Public.SEntityId;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.fight.FightEffectUtil;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.scene3D.player.entity.UserPlayer;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;

	/**
	 * 挂机的时候， 选怪策略， 当前目标>攻击来源>召唤怪>任务怪(选择的情况下)>筛选怪物>最近的怪 
	 * @author chenriji
	 * 
	 */	
	public class AutoFightBossSelectAI
	{
		private var _rang1:Rectangle = new Rectangle(0, 0, 400, 400);
		private var _rang2:Rectangle = SceneRange.display;
		private var _au:Vector.<SEntityId>;
		private var _ap:Vector.<SEntityId>;
		private var _am:Vector.<SEntityId>;
		private var _myPoint:Point = new Point();
		// 选怪的最大距离
		private var _range:int;
		// 开始挂机的时候自己的位置
		private var _sourcePoint:Point = new Point();
		private static var _instance:AutoFightBossSelectAI;
		
		public function AutoFightBossSelectAI()
		{
		}
		
		public function get sourcePoint():Point
		{
			return _sourcePoint;
		}

		public function set sourcePoint(value:Point):void
		{
			_sourcePoint = value;
		}

		public function get range():int
		{
			return _range;
		}

		public function set range(value:int):void
		{
			_range = value;
		}

		public static function get instance():AutoFightBossSelectAI
		{
			if(_instance == null)
			{
				_instance = new AutoFightBossSelectAI();
			}
			return _instance;
		}
		
		public function getEntity(inCludeUserPlayer:Boolean=false):IEntity
		{
			var entity:IEntity;
			// 自己当前的坐标
			updateMyPoint();
			// 当前选中的目标
			if((inCludeUserPlayer && ThingUtil.selectEntity is UserPlayer) 
				|| (!inCludeUserPlayer && ThingUtil.selectEntity is MonsterPlayer)
			)
			{
				if(ThingUtil.selectEntity != null && !ThingUtil.selectEntity.isDead)
				{
					var entityInfo:SEntityInfo = ThingUtil.selectEntity.entityInfo.entityInfo;
					if(!EntityRelationUtil.isFriend(entityInfo))
					{
						return ThingUtil.selectEntity;
					}
				}
			}
			// 攻击自己的怪物
			_au = FightEffectUtil.attackMeMonsterList;// FightEffectUtil.attackMeUserList;
			if(inCludeUserPlayer)
			{
				_au = _au.concat(FightEffectUtil.attackMeUserList, FightEffectUtil.attackMePetList);
			}
			for each(var sid:SEntityId in _au)
			{
				entity = ThingUtil.entityUtil.getEntity(sid);
				if(entity is MonsterPlayer)
				{
					if(isLiveAndInDistance(entity))
					{
						return entity;
					}
				}
			}
			
			// 对所有怪
			var all:Array = ThingUtil.entityUtil.entitysMap.getEntityByRangle(_rang2);
			AutoFightBossSelectAI.instance.updateMyPoint();
			all.sort(AutoFightBossSelectAI.instance.sortByDistance);
			// 召唤怪
			
			// 任务怪(选择的情况下)
			var i:int;
			if(!ClientSetting.local.getIsDone(IsDoneType.SelectTaskBoss))
			{
				var taskBosses:Dictionary = Cache.instance.autoFight.getCurMapTaskBoss();
				for(i = 0;  i < all.length; i++)
				{
					entity = all[i];
					if(entity is MonsterPlayer)
					{
						if(taskBosses[MonsterPlayer(entity)._bossInfo.code] == true)
						{
							if(isLiveAndInDistance(entity))
							{
								return entity;
							}
						}
					}
				}
			}
			
			// 筛选怪
			for(i = 0;  i < all.length; i++)
			{
				entity = all[i];
				if(entity is MonsterPlayer)
				{
					if(Cache.instance.autoFight.isBossSelected((entity as MonsterPlayer)._bossInfo.code))
					{
						if(isLiveAndInDistance(entity))
						{
							return entity;
						}
					}
				}
			}
			
			// 最近的怪
			var min:int = 1000000;
			var res:IEntity;
			for(i = 0;  i < all.length; i++)
			{
				entity = all[i];
				if(entity is MonsterPlayer)
				{
					if(isLiveAndInDistance(entity))
					{
						return entity;
					}
				}
			}
			return null;
		}
		
		private function calDistaneMe(a:IEntity):Number
		{
			return GeomUtil.calcDistance(SpritePlayer(a).x2d, SpritePlayer(a).y2d, _myPoint.x, _myPoint.y);
		}
		
		public function updateMyPoint():void
		{
			_myPoint.x = RolePlayer.instance.x2d;
			_myPoint.y = RolePlayer.instance.y2d;
		}
		
		public function sortByDistance(a:IEntity, b:IEntity):int
		{
			var da:Number = calDistaneMe(a);
			var db:Number = calDistaneMe(b);
			if(da <= db)
			{
				return -1;
			}
			return 1;
		}
		
		private function isLiveAndInDistance(a:IEntity):Boolean
		{
			if(!isInDistance(a))
			{
				return false;
			}
			if(a.isDead)
			{
				return false;
			}
			return true;
		}
		
		private function isInDistance(a:IEntity):Boolean
		{
			if(_range <= 0)
			{
				return true;
			}
			if(GeomUtil.calcDistance(SpritePlayer(a).stagePointX, SpritePlayer(a).stagePointY, _sourcePoint.x, _sourcePoint.y) < _range)
			{
				return true;
			}
			return false;
		}
		
		private function isAttakMe(a:IEntity):Boolean
		{
			if(_au.indexOf(a.entityInfo.entityInfo.entityId) >= 0)
			{
				return true;
			}
			
			if(_ap.indexOf(a.entityInfo.entityInfo.entityId) >= 0)
			{
				return true;
			}
			
			if(_am.indexOf(a.entityInfo.entityInfo.entityId) >= 0)
			{
				return true;
			}
			return false;
		}
	}
}