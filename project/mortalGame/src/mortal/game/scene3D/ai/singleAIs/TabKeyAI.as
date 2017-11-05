/**
 * 2014-1-22
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

	public class TabKeyAI
	{
		private var _rang1:Rectangle = new Rectangle(0, 0, 400, 400);
		private var _rang2:Rectangle = SceneRange.display;
		private var _lastTime:int;
		private const egnorTime:int = 4000;
		private var _lastDic:Dictionary = new Dictionary();
		
		private var _au:Vector.<SEntityId>;
		private var _ap:Vector.<SEntityId>;
		private var _am:Vector.<SEntityId>;
		private var _myPoint:Point = new Point();
		
		public function TabKeyAI()
		{
		}
		
		private static var _instance:TabKeyAI;
		
		public static function get instance():TabKeyAI
		{
			if(_instance == null)
			{
				_instance = new TabKeyAI();
			}
			return _instance;
		}
		
		public function work():void
		{
			var now:int = getTimer();
			resetLatDic(now);
			var all:Array = ThingUtil.entityUtil.entitysMap.getEntityByRangle(_rang2);
			all = getCanTabs(all);
			var notTabs:Array = getNotTabs(all);
			var target:IEntity;
			// 找到所有在12秒之内未tab选中的， 从中选择
			if(notTabs.length > 0)
			{
				_au = FightEffectUtil.attackMeUserList;
				_ap = FightEffectUtil.attackMePetList;
				_am = FightEffectUtil.attackMeMonsterList;
				_myPoint.x = RolePlayer.instance.stagePointX;
				_myPoint.y = RolePlayer.instance.stagePointY;
				notTabs.sort(sortNotTabs);
				target = notTabs[0];
			}
			else
			{
				var tabs:Array = all;
				tabs.sort(sortTabed);
				target = tabs[0];
			}
			
			if(target == RolePlayer.instance)
			{
				return;
			}
			
			ThingUtil.selectEntity = target;
			if(target != null)
			{
				_lastDic[target.entityID] = now;
			}
		}
		
		/**
		 * 按攻击、范围、（角色、宠物、怪物）排血 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function sortNotTabs(a:IEntity, b:IEntity):int
		{
			var va:int = isAttakMe(a)?100:0;
			var vb:int = isAttakMe(b)?100:0;
			
			va += (calDistaneMe(a)<= 400?10:0);
			vb += (calDistaneMe(b)<= 400?10:0);
			
			va += calTypeValue(a);
			vb += calTypeValue(b);
			
			if(a >= b)
			{
				return -1;
			}
			return 1;
		}
		
		private function calTypeValue(a:IEntity):int
		{
			if(a is UserPlayer)
			{
				return 5;
			}
			
			if(a is MonsterPlayer)
			{
				return 0;
			}
			
			return 2;
		}
		
		private function calDistaneMe(a:IEntity):Number
		{
			return GeomUtil.calcDistance(SpritePlayer(a).stagePointX, SpritePlayer(a).stagePointY, _myPoint.x, _myPoint.y);
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
		
		private var time1:int = 0;
		private var time2:int = 0;
		/**
		 * 按上次Tab选中的顺序排序 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function sortTabed(a:IEntity, b:IEntity):int
		{
			if(a == RolePlayer.instance)
			{
				return 1;
			}
			if(b == RolePlayer.instance)
			{
				return -1;
			}
			this.time1 = this._lastDic[a.entityID];
			this.time2 = this._lastDic[b.entityID];
			if(this.time1 < this.time2)
			{
				return -1;
			}
			return 1;
		}
		
		private function getCanTabs(all:Array):Array
		{
			var res:Array = [];
			for each(var entity:IEntity in all)
			{
				var entityInfo:SEntityInfo = entity.entityInfo.entityInfo;
				//对自己友好的，而且我对对方也友好的不能tab
				if(EntityRelationUtil.isFriend(entityInfo) || EntityRelationUtil.getFriendlyLevel(entityInfo) == EntityRelationUtil.FIREND)
				{
					continue;
				}
				res.push(entity);
			}
			return res;
		}
		
		private function getNotTabs(all:Array):Array
		{
			var res:Array = [];
			if(all == null || all.length == 1)
			{
				return res;
			}
			for each(var entity:IEntity in all)
			{
				var entityInfo:SEntityInfo = entity.entityInfo.entityInfo;
				if(_lastDic[entity.entityID] != null)
				{
					continue;
				}
				res.push(entity);
			}
			return res;
		}
		
		private function resetLatDic(now:int):void
		{
			var del:Array = [];
			for(var key:* in _lastDic)
			{
				var time:int = _lastDic[key];
				if(time + egnorTime <= now)
				{
					del.push(key);
				}
			}
			for each(var delKey:* in del)
			{
				delete _lastDic[delKey];
			}
		}
	}
}