/**
 * @date	2011-3-8 下午06:16:44
 * @author  jianglang
 * 
 * 
 *   int mapId;                     //地图ID
         string name;                   //名字
         int clientFile;                //客户端文件
         string serverFile;             //服务器文件
         EMapOwnerType ownerType;       //拥有者类型
         ECamp campType;                //所属阵营
         EMapInstanceType instanceType; //实例类型
         //int revivalMapId;              //复活地图ID
		 DictIntInt revivalMaps;        //复活地图点 [阵营,地图ID]
         int restrictionType;           //地图限制 EMapRestrictionType
         DictIntInt deathEvents;        //死亡事件 EMapDeathEvent + 数值
         int rate;                      //税率(0-100)
         int weather;                   //天气
         int backgroundMusic;           //地图背景音乐
         SeqPassPoint passPoints;       //切图点列表
         SeqNpc npcs;                   //NPC类表
      };
      sequence<SMapDefine> SeqMapDefine; //地图定义数组

 */	

package mortal.game.scene3D.map3D.sceneInfo
{
	import Message.DB.Tables.TBoss;
	import Message.Public.ENpcType;
	import Message.Public.SMapDefine;
	import Message.Public.SMapSharp;
	import Message.Public.SNpc;
	import Message.Public.SPassPoint;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.model.BossAreaInfo;
	import mortal.game.model.NPCInfo;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;

//	import mortal.game.scene3D.player.entity.RolePlayer;

	public class SceneInfo
	{
		private var _sMapDefine:SMapDefine;
		
		private var _sharpsUpdater:Dictionary;
		private var _sharpsMap:Dictionary;
		private var _sharpsRawData:Dictionary;
		private var _npcInfos:Array;  // NPC
		private var _passInfos:Array;  //传送阵
		private var _sceneEffects:Array; //场景特效
		
		private var _jumpPoints:Array; // 跳跃点
		private var _bossRefreshs:Array = [];//刷怪区 [i] = BossRefreshInfo
		
		
		////////////////////////////////////////////////////////////////////////////////////////// 下面的不确定能用
		
		private var _sharpInfos:Array ;// 阻挡模型
		private var _buildInfos:Array;//建筑
		private var _statueInfos:Array;//雕塑
		private var _crossMainCityStatueInfos:Array;//跨服城主雕像
		private var _fishingPoints:Array; //钓鱼点
	
		private var _bossRefreshDic:Dictionary = new Dictionary();//刷怪区 索引数组 [i] = BossRefreshInfo
		private var _bossArea:Array = [];//怪区 [i] = BossAreaInfo
		private var _isSpa:Boolean = false;
		private var _limitInfo:SceneLimitInfo;
		private var _playerShowPartsInfos:ScenePlayerShowPartsInfo;
		
		private var _dataParser:SceneInfoParser;
		
		public function SceneInfo()
		{
			_sMapDefine = new SMapDefine();
			_npcInfos = [];
			_passInfos = [];
			_sceneEffects = [];
			_jumpPoints = [];
			_buildInfos = [];
			_sharpInfos = [];
			_crossMainCityStatueInfos = [];
			_limitInfo = new SceneLimitInfo();
			_playerShowPartsInfos = new ScenePlayerShowPartsInfo();
			
			_dataParser = new SceneInfoParser(GameMapUtil.mapWidth, GameMapUtil.mapHeight);
		}
		
		public function get jumpPoints():Array
		{
			return _jumpPoints;
		}

		public function readObj(obj:Object):void
		{
			
			_sMapDefine = _dataParser.fromObj(obj);
			_limitInfo.limitValue = _sMapDefine.restrictionType;
			_playerShowPartsInfos.showPartsValue = _sMapDefine.showLimit;
			
			parseClientData();
			readBossAreaInfo(obj);
			
		}
		
		public function get statueInfos():Array
		{
			return _statueInfos;
		}
		
		public function get sharpInfos():Array
		{
			return _sharpInfos;
		}

		public function get sharpsMap():Dictionary
		{
			return _sharpsMap;
		}

		public function set sharpsUpdater(value:Dictionary):void
		{
			_sharpsUpdater = value;
		}
		public function get sharpsUpdater():Dictionary
		{
			return _sharpsUpdater;
		}

		public function get buildInfos():Array
		{
			return _buildInfos;
		}

		public function get effectInfos():Array
		{
			return _sceneEffects;
		}

		/**
		 * 传送点  [SPassPoint]
		 * @return 
		 * 
		 */		
		public function get passInfos():Array
		{
			return _passInfos;
		}

		/**
		 * 场景中所有NPC [NPCInfo] 
		 * @return 
		 * 
		 */		
		public function get npcInfos():Array
		{
			return _npcInfos;
		}

		public function get sMapDefine():SMapDefine
		{
			return _sMapDefine;
		}
		
		public function get bossRefreshs():Array
		{
			return _bossRefreshs;
		}
		
		/**
		 * 刷怪点信息 [BossAreaInfo] 
		 * @return 
		 * 
		 */		
		public function get bossArea():Array
		{
			return _bossArea;
		}
		
		/**
		 * 返回刷怪点 
		 * @param level1
		 * @param level2
		 * @return 
		 * 
		 */
		public function getBossRefreshInfoByLevel(level1:int,level2:int):BossRefreshInfo
		{
			var index:int;
			var length:int = _bossRefreshs.length;
			var info:BossRefreshInfo;
			var boss:TBoss;
			while(index < length)
			{
				info = _bossRefreshs[index];
				boss = info.getNormalBoss();
				if(boss && boss.level >= level1 && boss.level <= level2)
				{
					return info;
				}
				index++;
			}
			return null;
		}
		
		/**
		 * 刷怪区和方案映射字典 
		 */
		private var _refreshInfoToPlan:Dictionary = new Dictionary();
		
		/**
		 * 根据刷怪方案返回刷怪区 
		 * @param plan
		 * @return 
		 * 
		 */
		public function getBossRefreshInfoByPlan(plan:int):Array
		{
			if(_refreshInfoToPlan.hasOwnProperty(plan))
			{
				return _refreshInfoToPlan[plan];
			}
			
			var index:int;
			var length:int = _bossRefreshs.length;
			var info:BossRefreshInfo;
			var result:Array = [];
			while(index < length)
			{
				info = _bossRefreshs[index];
				if(info.plan == plan)
				{
					result.push(info);
				}
				index++;
			}
			_refreshInfoToPlan[plan] = result;
			return result;
		}
		
		/**
		 * 根据bosscode返回刷怪点 
		 * @param code
		 * @return 
		 * 
		 */
		public function getBossRefreshInfoByCode(bossCode:int):BossRefreshInfo
		{
			var index:int;
			var length:int = _bossRefreshs.length;
			var info:BossRefreshInfo;
			while(index < length)
			{
				info = _bossRefreshs[index];
				if(info.hasBossCode(bossCode))
				{
					return info;
				}
				index++;
			}
			return null;
		}
		
		/**
		 * 根据目标地图返回地图出口 
		 * @param mapID
		 * @return 
		 * 
		 */
		public function gotoNextMapPoint( mapID:int ):SPassPoint
		{
			for each( var passPoint:SPassPoint in _passInfos  )
			{
				for each( var passTo:SPassTo in passPoint.passTo  )
				{
					if( passTo.mapId == mapID )
					{
						return passPoint;
					}
				}
			}
			return null;
		}
		
		public function getNpcInfo(npcId:int):NPCInfo
		{
			var npcInfo:NPCInfo;
			for each(npcInfo in npcInfos)
			{
				if(npcInfo.tnpc && npcInfo.tnpc.code == npcId)
				{
					return npcInfo
				}
			}
			return null;
		}
		
		public function getEffectData(key:String):SceneEffectData
		{
			var effectInfo:SceneEffectData;
			for each(effectInfo in effectInfos)
			{
				if(effectInfo.key == key)
				{
					return effectInfo
				}
			}
			return null;
		}
		
		public function getPassPointInfo(passId:int):SPassPoint
		{
			var passTo:SPassPoint;
			for each(passTo in passInfos)
			{
				if(passTo.passPointId == passId)
				{
					return passTo;
				}
			}
			return null;
		}
		
		/**
		 * 读取刷怪点数据 
		 * @param obj
		 * 
		 */
		public function readBossRefreshPoint(obj:Object):void
		{
			if( obj == null ) return;
			_bossRefreshs = [];
			
			var refreshInfo:BossRefreshInfo;
			var refreshs:Array = obj["refreshPoint"];
			var refreshBoss:Object;
			var index:int;
			var length:int = refreshs.length;
			while(index < length)
			{
				refreshBoss = refreshs[index];
				refreshInfo = new BossRefreshInfo();
				refreshInfo.updateData(obj["mapId"],refreshBoss["point"]["x"],refreshBoss["point"]["y"],refreshBoss["plan"]);
				if(refreshInfo.bosses.length != 0)
				{
					_bossRefreshs.push(refreshInfo);
					_bossRefreshDic[refreshBoss["plan"]] = refreshInfo;
				}
				index++;
			}
			
			_bossRefreshs.sortOn("plan");
		}
		
		/**
		 * 读取怪区数据 
		 * @param obj
		 * 
		 */
		public function readBossAreaInfo(obj:Object):void
		{
			_bossArea.length = 0;
			if(obj.areas != null)
			{
				var areas:Array = obj.areas as Array;
				var index:int;
				var length:int = areas.length;
				var areaObj:Object;
				var areaInfo:BossAreaInfo;
				while(index < length)
				{
					areaObj = areas[index];
					areaInfo = new BossAreaInfo;
					areaInfo.name = areaObj.name;
					areaInfo.id = areaObj.areaId;
					areaInfo.mapId = areaObj.mapId;
					areaInfo.px = areaObj.point.x;
					areaInfo.py = areaObj.point.y;
					areaInfo.plans = areaObj.plans;
					areaInfo.updateData(_bossRefreshDic);
					_bossArea.push(areaInfo);
					index++;
				}
			}
		}
		
		/**
		 * 场景特效数据 
		 * @param obj
		 * 
		 */
		public function readSceneEffect(obj:Object):void
		{
			_sceneEffects = SceneEffectParser.fromObj(obj);
		}
		
		public function updateBuildLevel( id:int,level:int ):void
		{
//			var info:SceneBuildInfo;
//			for( var i:int=0;i<_buildInfos.length;i++ )
//			{
//				info = _buildInfos[i];
//				if( info.id == id )
//				{
//					info.level = level;
//					return;
//				}
//			}
		}
		
		
		/**
		 * 获取地图形状 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getMapSharp( id:int ):SMapSharp
		{
			return _sharpsMap[id] as SMapSharp;
		}
		
		public function initSharpRawData(id:int,isUpdate:Boolean):void
		{
			if( _sharpsUpdater )
			{
				if(_sharpsUpdater[id] == isUpdate)
				{
					return;  
				}
			}
			var sharp:SMapSharp = _sharpsMap[id] as SMapSharp;
			if( sharp )
			{
				var type:int;
				var ary:Array = sharp.points;
				var point:SPoint;
				var dic:Dictionary = _sharpsRawData[id] as Dictionary;
				if( dic == null )
				{
					dic = new Dictionary();
					for each( point in ary )
					{
						setMapDataByPoint(dic,point.x,point.y);
					}
					_sharpsRawData[id] = dic;
				}
			}
		}
		
		public function setMapDataBySharp( id:int,isUpdate:Boolean ):void
		{
			if( _sharpsUpdater )
			{
				if(_sharpsUpdater[id] == isUpdate)
				{
					return;  
				}
			}
			var sharp:SMapSharp = _sharpsMap[id] as SMapSharp;
			if( sharp )
			{
				var type:int;
				var ary:Array = sharp.points;
				var point:SPoint;
				var dic:Dictionary = _sharpsRawData[id] as Dictionary;
				if( dic == null )
				{
					dic = new Dictionary();
					for each( point in ary )
					{
						setMapDataByPoint(dic,point.x,point.y);
					}
					_sharpsRawData[id] = dic;
				}
				if( isUpdate )
				{
					type = sharp.type.__value;
					
					for each( point in ary )
					{
//						Game.scene.astar.resetMapPoint(point.x,point.y,type);
					}
				}
				else
				{
					for each( point in ary )
					{
//						Game.scene.astar.resetMapPoint( point.x,point.y, getMapDataValue(dic,point.x,point.y) );
					}
				}
			}
		}
		
		private function setMapDataByPoint(dic:Dictionary, x:int,y:int):void
		{
			dic[x*10000+y] = GameMapUtil.getPointValue( x,y );
		}
		private function getMapDataValue(dic:Dictionary,x:int,y:int):int
		{
			return dic[x*10000+y];
		}
		
		public function get isSpa():Boolean
		{
			return _isSpa;
		}
		
		/**
		 * 获取钓鱼的最近点 
		 * @return 
		 * 
		 */		
		public function getFishingNearPoint():Point
		{
			return new Point( 128,171 )
//			if( _fishingPoints )
//			{
//				var disNum:Number = Number.MAX_VALUE;
//				var tempNum:Number = 0;
//				var tempPt:SPoint;
//				var p:AStarPoint = RolePlayer.instance.currentPoint;
//				for each( var pt:SPoint in _fishingPoints )
//				{
//					tempNum = Math.abs(p.x - pt.x) + Math.abs(p.y - pt.y);
//					if( tempNum < disNum  )
//					{
//						disNum = tempNum;
//						tempPt = pt;
//					}
//				}
//				return new Point(tempPt.x,tempPt.y);
//			}
//			return null;
		}
		/**
		 * 是否去mapId的传送阵 
		 * @param passPointId
		 * @param toMapId
		 * @return 
		 * 
		 */
		public function isPassPointToMap(passPointId:int,toMapId:int=-1):Boolean
		{
			if(toMapId == -1)
			{
				toMapId = MapFileUtil.mapID;
			}
			
			var passPoint:SPassPoint = getPassPointInfo(passPointId);
			if(passPoint && passPoint.passTo)
			{
				if(passPoint.passTo[0] != null && (passPoint.passTo[0] is SPassTo))
				{
					return 	(passPoint.passTo[0] as SPassTo).mapId == toMapId;
				}
			}
			return false;
		}
		
		private function parseClientData():void
		{
			var i:int;
			var j:int;
			// 阻挡怪 , 地图形状
			_sharpsMap = new Dictionary();
			for(i = 0; i < _sMapDefine.sharps.length; i++)
			{
				var sharp:SMapSharp = _sMapDefine.sharps[i];
				_sharpsMap[sharp.sharpId] = sharp;
			}
			_sharpsRawData = new Dictionary();
			
			// 传送阵信息
			_passInfos = _sMapDefine.passPoints.concat();
			
			// npc信息
			for each(var npc:SNpc in _sMapDefine.npcs)
			{
//				if(npc.npcType.__value == ENpcType._ENpcTypeNpc)// || npc.npcType.__value == ENpcType._ENpcTypeArenaStatue || npc.npcType.__value == ENpcType._ENpcTypeCrossMainCityStatue)
//				{
					var npcInfo:NPCInfo = new NPCInfo();
					npcInfo.snpc = npc;
					_npcInfos.push(npcInfo);
//				}
			}
			
			// 跳跃点
			_jumpPoints = [];
			if(_sMapDefine.jumpPointSeq != null)
			{
				for each(var arr:Array in _sMapDefine.jumpPointSeq)
				{
					var p:SPoint = arr[0] as SPoint;
					var pEnd:SPoint = arr[arr.length - 1] as SPoint;
					_jumpPoints.push(p);
					_jumpPoints.push(pEnd);
				}
			}
			
		}
	}
}
