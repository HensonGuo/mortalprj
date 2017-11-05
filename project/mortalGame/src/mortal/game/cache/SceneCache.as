/**
 * @date	2011-3-7 下午02:52:23
 * @author  jianglang
 * 
 */	
package mortal.game.cache
{
	import Message.Public.SPassPoint;
	import Message.Public.SPassTo;
	
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.model.TaskTargetInfo;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.SceneConfig;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	
	public class SceneCache
	{
		private var _guildTaskNpc:Array = [];				//仙盟任务npc
		private var _guideBuyNpc:Array = [];				//仙盟购买领地npc
		private var _copyNpcByMapId:Array = [];			//副本npc
		private var _bussinessNpc:Array = [];				//跑商npc
		private var _bossMapPoint:Array = [];				//boss洞入口点
		
		private var _npcByEffect:Dictionary = new Dictionary();//NPC 和 功能的字典
		private var _npcByNpcID:Dictionary = new Dictionary();//npcID字典
		
		private var _nearlyPass:TaskTargetInfo;			//最近的出口
		private var _wareHouseNpc:TaskTargetInfo;			//仓库管理员
		
		private var _nationalTreaTarget:TaskTargetInfo;	//国家宝藏任务npc
		private var _nationalNearlyTarget:TaskTargetInfo;	//最近的国家宝藏npc
		private var _nationalNearlyBoss:TaskTargetInfo;	//最近的国家宝藏boss
		
		private var _sceneInfoByCamp:Dictionary = new Dictionary;//场景信息
		
		public function SceneCache()
		{
		}
		
		/**
		 * 切换地图之后
		 * 
		 */
		public function sceneChange():void
		{
			clearCyclePointCache();
		}
		
		/**
		 * 清空已经寻找过的挂机点 
		 * 
		 */
		public function clearCyclePointCache():void
		{
			_cyclePointCache.splice(0);
		}
		
		/**
		 * 更新boss刷怪点的存活信息 
		 * @param bossList
		 * @param 
		 * 
		 */
		public function updateBossRefreshPoint(bossList:Array):Boolean
		{
			if(!bossList)
			{
				return false;
			}
			return false;
		}
		
		/**
		 * 返回挂机刷怪点
		 * 返回的元素满足 1、非同阵营 非中立阵营 2、普通怪或采集怪 3、非稀有怪、非精英怪、非boss怪
		 * @return 
		 * 
		 */
		public function getFightRefreshPoint():Array
		{
			var result:Array = [];
			return result;
		}
		
		/**
		 * 循环找挂机点
		 * 已经找过的挂机点列表
		 */
		private var _cyclePointCache:Array = [];
		
		private var _currentIndex:int = 0;
		
		/**
		 * 寻找全图怪物点坐标点 
		 * @return 
		 * 
		 */
		public function getMapBossPoint():TaskTargetInfo
		{
			return null;
		}
		
		/**
		 * 更新所有npc的任务状态 
		 * @return 
		 * 
		 */
		public function allNpcStatusUpdate():Array
		{
			if(!Game.sceneInfo)
			{
				return null;
			}
			var index:int;
			var length:int = Game.sceneInfo.npcInfos.length;
//			var npc:NPCInfo;
			var result:Array = [];
			return result;
		}
		
		/**
		 * 可接任务列表更新 npc变成可接任务状态
		 * @param list
		 * @return 
		 * 
		 */
		public function canGetTaskRefresh(list:Array):Array
		{
			return allNpcStatusUpdate();
		}
		
		/**
		 * 增加可接任务 npc变成可接状态 
		 * @param list
		 * 
		 */
		public function addCanGetTask(list:Array):Array
		{
			var index:int;
			var length:int = list.length;
//			var npc:NPCInfo;
			var result:Array = [];
			return result;
		}
		
		/**
		 * 删除可接任务 npc可接状态也许消失
		 * @param list
		 * @return 
		 * 
		 */
		public function delCanGetTask(list:Array):Array
		{
			var index:int;
			var length:int = list.length;
//			var npc:NPCInfo;
			var result:Array = [];
			return result;
		}
		
		/**
		 * 增加当前任务 npc的状态可能变成 可交 或 不可交 或 下一个npc
		 * @param list
		 * @return 
		 * 
		 */
		public function addTask(list:Array):Array
		{
			var index:int;
			var length:int = list.length;
//			var npc:NPCInfo;
			var result:Array = [];
			return result;
		}
		
		/**
		 * 删除当前任务 npc的 可交 和 不可交 和 中间 状态可能消失 也许会变成可接状态
		 * @param list
		 * @return 
		 * 
		 */
		public function delTask(list:Array):Array
		{
			var index:int;
			var length:int = list.length;
//			var npc:NPCInfo;
			var result:Array = [];
			return result;
		}
		
		/**
		 * 更新任务进度 npc可能变成 可交状态 或 不可交状态 或 下一个npc状态
		 * @param list
		 * @return 
		 * 
		 */
		public function updateTask(list:Array):Array
		{
			var index:int;
			var length:int = list.length;
//			var npc:NPCInfo;
			var result:Array = [];
			return result;
		}
		
		/**
		 * npc是否有可接任务 
		 * @param npcId
		 * @return 
		 * 
		 */
		private function hasCanGetTask(npcId:int):Boolean
		{
			return false;
		}
		
		/**
		 * 是否下一个npc
		 * @param npcId
		 * @return 
		 * 
		 */
		private function isNextNpc(npcId:int):Boolean
		{
			return false;
		}
		
		/**
		 * npc是否有可交任务 失败和可交都可交 
		 * @param npcId
		 * @return 
		 * 
		 */
		private function hasEndTask(npcId:int):Boolean
		{
			return false;
		}
		
		/**
		 * 根据功能返回NPC 
		 * @param effect
		 * @return 
		 * 
		 */
		public function getNpcByEffect(effect:int,mapId:int = -1):TaskTargetInfo
		{
//			if(!_npcByEffect[effect])
//			{
//				_npcByEffect[effect] = getNormalTarget(GameDefConfig.instance.getNpcByEffect(effect,mapId));
//			}
			return _npcByEffect[effect];
		}
		
		/**
		 * 根据npcId获取NPC 
		 * @param npcId
		 * @return 
		 * 
		 */		
		public function getTaskTargetInfoByNPCId(npcId:int):TaskTargetInfo
		{
			var taskTargetInfo:TaskTargetInfo = new TaskTargetInfo();
//			taskTargetInfo.targetType = EntityType.NPC;
//			var npcInfo:NPCInfo = SceneConfig.instance.getNpcInfo(npcId);
//			taskTargetInfo.mapId = npcInfo.snpc.mapId;
//			taskTargetInfo.id = npcId;
//			taskTargetInfo.x = npcInfo.snpc.point.x;
//			taskTargetInfo.y = npcInfo.snpc.point.y;
			return taskTargetInfo;
		}
		
		/**
		 * 是否在最后一个刷怪点附近 
		 * @return 
		 * 
		 */
		public function isNearlyLastRefreshPoint():Boolean
		{
//			var refreshPoint:BossRefreshInfo = getNextRefreshPoint(Game.sceneInfo.bossRefreshs.length - 2);
//			if(refreshPoint)
//			{
//				//格子距离
//				var dis:int = GameMapUtil.getDistance(RolePlayer.instance.currentPoint.x,RolePlayer.instance.currentPoint.y,refreshPoint.px,refreshPoint.py);
//				if(dis < 15)//直线上相差15个格子 20X15 = 300像素 600像素
//				{
//					return true;
//				}
//			}
			return false;
		}
		
		/**
		 * 返回距离最近刷怪点的序列 
		 * @return 
		 * 
		 */
		public function getNearlyPointIndex():int
		{
//			var refreshPoint:BossRefreshInfo;
			var result:int;
//			var index:int;
//			var length:int;
//			var minDis:int = 10000000000;
//			var curDis:int;
//			while(index < Game.sceneInfo.bossRefreshs.length)
//			{
//				refreshPoint = Game.sceneInfo.bossRefreshs[index];
//				curDis = GameMapUtil.getDistance(RolePlayer.instance.currentPoint.x,RolePlayer.instance.currentPoint.y,refreshPoint.px,refreshPoint.py);
//				if(curDis < minDis)
//				{
//					minDis = curDis;
//					result = index;
//				}
//				index++;
//			}
			return result;
		}
		
		/**
		 * 返回最近的仓库管理员 
		 * @return 
		 * 
		 */
		public function getNearlyWareHouseNpc():TaskTargetInfo
		{
//			var npcs:Array = GameDefConfig.instance.getWareHouseNpc();
//			var sceneInfo:SceneInfo;
//			var npcInfo:NPCInfo;
//			var npcID:int;
//			var index:int;
//			var length:int = npcs.length;
//			var item:Object;
//			while(index < length)
//			{
//				item = npcs[index];
//				npcID = int(item.text);
//				sceneInfo = SceneConfig.instance.getSceneInfo(int(item.id));
//				
//				if(Cache.instance.role.entityInfo.camp == sceneInfo.sMapDefine.campType.value() && MapFileUtil.mapID == sceneInfo.sMapDefine.mapId)//同阵营 && 地图一样
//				{
//					break;
//				}
//				else if(sceneInfo.sMapDefine.campType.value() == ECamp._ECampNeutral)//中立阵营
//				{
//					break;
//				}
//			}
			
			if(!_wareHouseNpc)
			{
				_wareHouseNpc = new TaskTargetInfo();
			}
			
//			npcInfo = sceneInfo.getNpcInfo(npcID);
//			_wareHouseNpc.id = npcID;
//			_wareHouseNpc.camp = sceneInfo.sMapDefine.campType.value();
//			_wareHouseNpc.name = npcInfo.tnpc.name;
//			_wareHouseNpc.mapId = sceneInfo.sMapDefine.mapId;
//			_wareHouseNpc.mapName = sceneInfo.sMapDefine.name;
//			_wareHouseNpc.x = npcInfo.snpc.point.x;
//			_wareHouseNpc.y = npcInfo.snpc.point.y;
//			_wareHouseNpc.targetType = EntityType.NPC;
			return _wareHouseNpc;
		}
		
		/**
		 * 根据阵营返回所需的场景信息
		 * @param camp
		 * @param sceneType 1=新手村 2=主城 3=野外地图
		 * @return 
		 * 
		 */
		public function getSceneInfoByCamp(camp:int,sceneType:int=2):SceneInfo
		{
			var sceneInfo:SceneInfo = _sceneInfoByCamp[camp+"_"+sceneType];
			if(!sceneInfo)
			{
				var mapId:int = int(camp + "0010" + sceneType);
				sceneInfo = SceneConfig.instance.getSceneInfo(mapId);
				if(sceneInfo)
				{
					_sceneInfoByCamp[camp+"_"+sceneType] = sceneInfo;
				}
			}
			return sceneInfo;
		}
		
		/**
		 * 根据阵营判断是否在某个场景 
		 * @param camp
		 * @param sceneType 1=新手村 2=主城 3=野外地图
		 * @return 
		 * 
		 */
		public function isSceneByCamp(camp:int,sceneType:int=2):Boolean
		{
			var sceneInfo:SceneInfo = getSceneInfoByCamp(camp,sceneType);
			return sceneInfo && sceneInfo.sMapDefine.mapId == Game.sceneInfo.sMapDefine.mapId;
		}
		
		/**
		 * 是否在太机城 
		 * @return 
		 * 
		 */		
		public function isTaijiScene():Boolean
		{
			return isSceneByCamp(4,1);
		}
		
		/**
		 * 是否阵营主城 
		 * @return 
		 * 
		 */
		public function isMainCity(mapId:int = -1):Boolean
		{
			if(mapId == -1)
			{
				mapId = MapFileUtil.mapID;
			}
			if(mapId == 100102 || mapId == 200102 || mapId == 300102)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 返回阵营中最近的国家宝藏NPC 区分夺宝和护宝NPC 
		 * @param mapId
		 * @return 
		 * 
		 */
		public function getNearlyNationalTaskNPC(mapId:int = -1):TaskTargetInfo
		{
			return new TaskTargetInfo();
		}
		
		/**
		 * 返回最近的国宝宝藏boss 
		 * @return 
		 * 
		 */
		public function getNearlyNationalBoss():TaskTargetInfo
		{
			return new TaskTargetInfo();
		}
		
//		/**
//		 * 返回boss地图入口点 
//		 * @return 
//		 * 
//		 */
//		public function getBossMapPoints():Array
//		{
//			if(_bossMapPoint.length == 0)
//			{
//				var items:Array = GameDefConfig.instance.getBossMapPoint();
//				var item:Object;
//				var mapId:int;
//				var passId:int;
//				var sceneInfo:SceneInfo;
//				var passInfo:SPassPoint;
//				var target:TaskTargetInfo;
//				for(var index:int=0;index<items.length;index++)
//				{
//					item = items[index];
//					mapId = int(item.id);
//					passId = int(item.text);
//					sceneInfo = SceneConfig.instance.getSceneInfo(mapId);
//					passInfo = sceneInfo.getPassPointInfo(passId);
//					target = new TaskTargetInfo();
//					target.mapId = mapId;
//					target.x = passInfo.point.x;
//					target.y = passInfo.point.y;
//					target.name = (passInfo.passTo[0] as SPassTo).name;
//					target.targetType = EntityType.Point;
//					_bossMapPoint.push(target);
//				}
//			}
//			return _bossMapPoint;
//		}
		
//		/**
//		 * 随机boss入口点 
//		 * @return 
//		 * 
//		 */
//		public function getRandomBossMap():TaskTargetInfo
//		{
//			var bossMaps:Array = getBossMapPoints();
//			var randomIndex:int = Math.random()*(bossMaps.length-2);
//			var target:TaskTargetInfo = bossMaps[randomIndex];
//			return target;
//		}
		
		private const pointStr:String = "<font size='15' color='#FFFFFF'>·</font>";
		
		/**
		 * 返回 阵营.地图名字 格式的字符串 
		 * @param color
		 * @return 
		 * 
		 */
		public function getCampMapName(camp:int=-1,mapId:int=-1,color:Boolean = false):String
		{
			return "";
		}
		
	}
}
