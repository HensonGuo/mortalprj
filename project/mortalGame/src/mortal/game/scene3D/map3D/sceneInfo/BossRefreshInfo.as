package mortal.game.scene3D.map3D.sceneInfo
{
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TBossRefresh;
	
	import flash.geom.Point;
	
	import mortal.game.resource.SceneConfig;
	import mortal.game.resource.tableConfig.BossConfig;
	import mortal.game.rules.BossRule;
	import mortal.game.scene3D.map3D.util.GameMapUtil;

	public class BossRefreshInfo
	{
		private var _mapId:int;
		private var _x:int;
		private var _y:int;
		private var _plan:int;
		private var _bosses:Array = [];//[i] = TBoss
		private var _bossRefreshs:Array = [];//[i] = TBossRefresh
		private var _isDead:Boolean;	//是否已经死亡的刷怪点
		
		public function BossRefreshInfo()
		{
		}
		
		public function get mapId():int
		{
			return _mapId
		}
		
		/**
		 * 像素点x 
		 * @return 
		 * 
		 */		
		public function get x():int
		{
			return _x;
		}
		
		/**
		 * 像素点y 
		 * @return 
		 * 
		 */		
		public function get y():int
		{
			return _y;
		}
		
		public function get plan():int
		{
			return _plan;
		}
		
		public function get bosses():Array
		{
			return _bosses;
		}
		
		public function get bossRefreshs():Array
		{
			return _bossRefreshs;
		}
		
		private var _actBosses:Array = [];
		
		public function addActBoss(tboss:TBoss):void
		{
			_actBosses.push(tboss);
		}
		
		public function removeActBoss(tboss:TBoss):void
		{
			if(_actBosses.length != 0)
			{
				var index:int = _actBosses.indexOf(tboss);
				if(index != -1)
				{
					_actBosses.splice(index,1);
				}
			}
		}
		
		public function get actBosses():Array
		{
			return _actBosses;
		}
		
		public function clearActBoss():void
		{
			if(_actBosses.length != 0)
			{
				_actBosses.splice(0);
			}
		}
		
		/**
		 * 更新 
		 * @param pmapId
		 * @param px
		 * @param py
		 * @param pplan
		 * @param porder
		 */
		public function updateData(pmapId:int, px:int, py:int, pplan:int):void
		{
			_bossRefreshs.splice(0);
			_bosses.splice(0);
			
			_mapId = pmapId;
			_x = px;
			_y = py;
			_plan = pplan;
			
			_bossRefreshs = BossConfig.instance.getRefreshByMapAndPlan(_mapId,_plan);
			
			var index:int;
			var length:int = _bossRefreshs.length;
			var bossRefresh:TBossRefresh;
			var boss:TBoss;
			while(index < length)
			{
				bossRefresh = _bossRefreshs[index];
				boss = BossConfig.instance.getInfoByCode(bossRefresh.bossCode);
				_bosses.push(boss);
				index++;
			}
		}
		
		/**
		 * 是否包含boss 
		 * @param code
		 * @return 
		 * 
		 */
		public function hasBossCode(code:int):Boolean
		{
			for each(var boss:TBoss in _bosses)
			{
				if(boss.code == code)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 返回此刷怪点的非稀有怪 非boss 非精英怪
		 * @return 
		 * 
		 */
		public function getNormalBoss():TBoss
		{
			var boss:TBoss;
			if(_actBosses.length != 0)
			{
				for each(boss in _actBosses)
				{
					if(!BossRule.isBossBoss(boss.category))
					{
						return boss;
					}
				}
			}
			
			return null;
		}
		
		/**
		 * 是否已经死亡
		 * @param value
		 * 
		 */
		public function set isDead(value:Boolean):void
		{
			_isDead = value;
		}
		
		/**
		 * 是否已经死亡
		 * @param value
		 * 
		 */
		public function get isDead():Boolean
		{
			return _isDead;
		}
		
		/**
		 * 具有boss怪 
		 * @return 
		 * 
		 */
		public function hasBossBoss():Boolean
		{
			for each(var boss:TBoss in _bosses)
			{
				if(BossRule.isBossBoss(boss.type))
				{
					return true;
				}
			}
			return false;
		}
	}
}