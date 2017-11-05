/**
 * 2014-1-21
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap
{
	import Message.Public.ENpcType;
	import Message.Public.SCustomPoint;
	import Message.Public.SPassPoint;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.geom.Point;
	
	import mortal.game.model.BossAreaInfo;
	import mortal.game.model.NPCInfo;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.SceneConfig;
	import mortal.game.resource.info.GMapInfo;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapCustomXYData;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapTypeIconData;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapWorldRegionData;

	public class SmallMapCache
	{
		private var _paths:Array = [];
		
		public var showTypes:Array = [
			{"icon":ImagesConst.MapPoint_PassPoint, "name":Language.getString(20059), "type":IsDoneType.MapShowTypePassPoint},
			{"icon":ImagesConst.MapPoint_Boss, "name":Language.getString(20060), "type":IsDoneType.MapShowTypeBoss},
			{"icon":ImagesConst.MapPoint_TaskCanGet, "name":Language.getString(20062), "type":IsDoneType.MapShowTypeTaskNPC},
			{"icon":ImagesConst.MapPoint_FuncNpc, "name":Language.getString(20064), "type":IsDoneType.MapShowTypeFuncNPC},
			{"icon":ImagesConst.MapPoint_ExchangeShop, "name":Language.getString(20065), "type":IsDoneType.MapShowTypeExchangeNPC},
			{"icon":ImagesConst.MapPoint_DailyNPC, "name":Language.getString(20061), "type":IsDoneType.MapShowTypeDailyNpc},
			{"icon":ImagesConst.MapPoint_Activity, "name":Language.getString(20063), "type":IsDoneType.MapShowTypeActivityNPC}
			
			
		];
		
		public var tipsTypes:Array = [
			{"icon":ImagesConst.MapPoint_PassPoint, "name":Language.getString(20059)},
			{"icon":ImagesConst.MapPoint_Boss, "name":Language.getString(20060)},
			{"icon":ImagesConst.MapPoint_DailyNPC, "name":Language.getString(20061)},
			{"icon":ImagesConst.MapPoint_TaskCanGet, "name":Language.getString(20068)},
			{"icon":ImagesConst.MapPoint_TaskDoing, "name":Language.getString(20070)},
			{"icon":ImagesConst.MapPoint_TaskFinish, "name":Language.getString(20071)},
			{"icon":ImagesConst.MapPoint_Activity, "name":Language.getString(20063)},
			{"icon":ImagesConst.MapPoint_FuncNpc, "name":Language.getString(20064)},
			{"icon":ImagesConst.MapPoint_ExchangeShop, "name":Language.getString(20065)},
			{"icon":ImagesConst.MapPoint_Self2, "name":Language.getString(20066)},
			{"icon":ImagesConst.MapPoint_Teamate, "name":Language.getString(20067)},
		];
		
		public var worldDatas:Array = [
			new SmallMapWorldRegionData(0, "regionDatas_0", 100, 100),
			new SmallMapWorldRegionData(0, "regionDatas_1", 300, 200)
		];
		
		public const regionDatas_0:Array = [
			new SmallMapWorldRegionData(1, "SmallMap_100101", 100, 100),
			new SmallMapWorldRegionData(1, "SmallMap_10002", 200, 300),
			new SmallMapWorldRegionData(1, "SmallMap_10003", 400, 400)
		];
		
		public const regionDatas_1:Array = [
			new SmallMapWorldRegionData(1, "SmallMap_10004", 400, 400)
		];
		
		public var allRegions:Array = [
			regionDatas_0,
			regionDatas_1
		];
		
		public function SmallMapCache()
		{
		}
		
		public function get paths():Array
		{
			return _paths;
		}
		
		public function getRegionDataByMapId(mapId:int):Array
		{
			var test:String = "SmallMap_" + mapId.toString();
			for each(var datas:Array in allRegions)
			{
				for each(var data:SmallMapWorldRegionData in datas)
				{
					if(data.value == test)
					{
						return datas;
					}
				}
			}
			return [];
		}
		
		public function removePathPoint(pp:Point):void
		{
			if(_paths == null)
			{
				return;
			}
			for(var i:int = 0; i < _paths.length; i++)
			{
				var p:Point = _paths[i];
				if(p.x == pp.x && p.y == pp.y)
				{
					_paths.splice(i, 1);
					return;
				}
			}
		}
		
		public function clearPaths():void
		{
			_paths = [];
		}
		
		public function set paths(arr:Array):void
		{
			clearPaths();
			if(arr == null)
			{
				return;
			}
			for(var i:int = 0; i < arr.length; i++)
			{
				var p:AstarTurnPoint = arr[i];
				_paths.push(GameMapUtil.getTilePoint(p._x, p._y));
			}
		}
		
		public function getDataByType(type:int, mapId:int):Array
		{
			var res:Array = [];
			var info:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			var obj:Object = getObjByType(type);
			if(type == IsDoneType.MapShowTypePassPoint)
			{
				return getPassPoint(res, obj, info);
			}
			if(type == IsDoneType.MapShowTypeBoss)
			{
				return getBoss(res, obj, info);
			}
			if(type == IsDoneType.MapShowTypeDailyNpc)
			{
				return getNPc(res, obj, info, ENpcType._ENpcTypeDaily);
			}
			if(type == IsDoneType.MapShowTypeTaskNPC)
			{
				return getNPc(res, obj, info, ENpcType._ENpcTypeTask);
			}
			if(type == IsDoneType.MapShowTypeFuncNPC)
			{
				return getNPc(res, obj, info, ENpcType._ENpcTypeFunc);
			}
			if(type == IsDoneType.MapShowTypeExchangeNPC)
			{
				return getNPc(res, obj, info, ENpcType._ENpcTypeExchange);
			}
			if(type == IsDoneType.MapShowTypeActivityNPC)
			{
				return getNPc(res, obj, info, ENpcType._ENpcTypeActivity);
			}
			return res;
		}
		
		public function initCustomMapPoints(datas:Array):void
		{
			_customMapPointDatas = [];
			for each(var info:SCustomPoint in datas)
			{
				addCustomMapPoint(info);
			}
			
			// 把没有的补足
			for(var i:int = 0; i < 5; i++)
			{
				if(_customMapPointDatas[i] != null)
				{
					continue;
				}
				var data:SmallMapCustomXYData = new SmallMapCustomXYData();
				_customMapPointDatas[i] = data;
				data.index = i;
				data.name = Language.getStringByParam(20080, i+1);
				data.mapName = Language.getString(20082);
				data.isNotSet = true;
				data.x = 0;
				data.y = 0;
				data.mapId = 0;
			}
		}
		
		public function addCustomMapPoint(info:SCustomPoint):void
		{
			var data:SmallMapCustomXYData = new SmallMapCustomXYData();
			_customMapPointDatas[info.index] = data;
			data.index = info.index;
			data.name = info.name;
			data.isNotSet = false;
			data.x = info.point.x;
			data.y = info.point.y;
			data.mapId = info.mapId;
			
			var mapInfo:GMapInfo = GameMapConfig.instance.getMapInfo(info.mapId);
			if(mapInfo != null)
			{
				data.mapName = mapInfo.name;
			}
			else
			{
				data.mapName = "";
			}
		}
		
		private var _customMapPointDatas:Array;
		public function get customMapPointData():DataProvider
		{
			var res:DataProvider = new DataProvider();
			for(var i:int = 0; i < 5; i++)
			{
				var data:SmallMapCustomXYData = _customMapPointDatas[i];
				res.addItem(data);
			}
			
			return res;
		}
		
		public function get customMapPointArr():Array
		{
			return _customMapPointDatas;
		}
		
		private function getPassPoint(arr:Array, obj:Object, info:SceneInfo):Array
		{
			var points:Array = info.passInfos;
			for each(var p:SPassPoint in points)
			{
				var data:SmallMapTypeIconData = new SmallMapTypeIconData();
				data.x = p.point.x;
				data.y = p.point.y;
				data.name = p.name;
				data.iconName = obj["icon"];
				data.type = obj["type"];
				if(p.passTo != null && p.passTo.length > 0)
				{
					data.tips = Language.getStringByParam(20072, p.passTo[0]["name"]);
				}
				else
				{
					data.tips = "";
				}
				arr.push(data);
			}
			return arr;
		}
		
		private function getBoss(arr:Array, obj:Object, sceneInfo:SceneInfo):Array
		{
			var areas:Array = sceneInfo.bossArea;
			for each(var info:BossAreaInfo in areas)
			{
				var data:SmallMapTypeIconData = new SmallMapTypeIconData();
				data.x = info.px
				data.y = info.py;
				data.name = info.name;
				data.tips = info.name;
				data.iconName = obj["icon"];
				data.type = obj["type"];
				arr.push(data);
			}
			return arr;
		}
		
		private function getNPc(arr:Array, obj:Object, info:SceneInfo, npcType:int):Array
		{
			var npcs:Array = info.npcInfos;
			for each(var npc:NPCInfo in npcs)
			{
				if(npc.tnpc.type != npcType)
				{
					continue;
				}
				var data:SmallMapTypeIconData = new SmallMapTypeIconData();
				data.name = npc.snpc.name;
				data.x = npc.snpc.point.x;
				data.y = npc.snpc.point.y;
				data.tips = npc.snpc.name;
				data.iconName = obj["icon"];
				data.type = obj["type"];
				arr.push(data);
			}
			return arr;
		}
		
		private function getObjByType(type:int):Object
		{
			for each(var obj:Object in showTypes)
			{
				if(obj["type"] == type)
				{
					return obj;
				}
			}
			return null;
		}
	}
}