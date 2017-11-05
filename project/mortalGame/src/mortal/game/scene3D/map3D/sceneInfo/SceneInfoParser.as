/**
 * 2013-12-24
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.sceneInfo
{
	import Message.Public.EMapBelong;
	import Message.Public.EMapInstanceType;
	import Message.Public.EMapOwnerType;
	import Message.Public.EMapPointType;
	import Message.Public.ENpcType;
	import Message.Public.SMapArea;
	import Message.Public.SMapDeathEvent;
	import Message.Public.SMapDefine;
	import Message.Public.SMapSharp;
	import Message.Public.SNpc;
	import Message.Public.SPassPoint;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import flash.utils.Dictionary;

	public class SceneInfoParser
	{
		private var _totalWidth:int;
		private var _totalHeight:int;
		
		public function SceneInfoParser(tWidth:int, tHeight:int)
		{
			_totalWidth = tWidth;
			_totalHeight = tHeight;
		}
		
		public function fromObj(obj:Object):SMapDefine
		{
			var i:int,j:int;
			
			var s:SMapDefine = new SMapDefine();
			s.mapId = obj.mapId;
			s.name = obj.name;
			s.realWidth = _totalWidth;
			s.realHeight = _totalHeight;
			s.instanceType = new EMapInstanceType(obj.instanceType);
			s.clientFile = obj.clientFile;
			s.serverFile = obj.serverFile;
			s.ownerType = new EMapOwnerType(obj.ownerType);
			s.belong = new EMapBelong(obj.belong);
			s.fightMode = obj.hasOwnProperty("fightMode") ? obj["fightMode"] : 0;
			s.needLevel = obj.hasOwnProperty("needLevel") ? obj["needLevel"] : 0;
			s.enterMode = obj.hasOwnProperty("enterMode")?obj["enterMode"]:0;
			s.enterPoint = new SPoint();
			s.enterPoint.x = obj.hasOwnProperty("enterPoint") ? obj["enterPoint"].x : 0;
			s.enterPoint.y = obj.hasOwnProperty("enterPoint") ? obj["enterPoint"].y : 0;
			
			
			
			s.subline = obj.hasOwnProperty("subline") ? obj["subline"] : false;
			s.cross = obj.hasOwnProperty("cross") ? obj["cross"] : false;
			s.restrictionType = obj.hasOwnProperty("restrictionType") ? obj["restrictionType"] : 0;
			s.revivalRestriction = obj.hasOwnProperty("revivalRestriction")?this.toDictionary(obj["revivalRestriction"]) : new Dictionary();
			s.revivalMaps = obj.hasOwnProperty("revivalMaps")?this.toDictionary(obj["revivalMaps"]) : new Dictionary();
			s.passPoints = this.passPoints(obj.passPoints as Array);
			s.npcs = this.npcs(obj.npcs as Array);
			s.sharps = this.sharps(obj["sharps"]);
			s.weather = obj.weather;
			s.musicId = obj.musicId;
			s.deathEvents = this.deathEvents(obj["deathEvents"] as Array);
			s.taxRate = obj.hasOwnProperty("taxRate") ? obj["taxRate"] : 100;
			s.jumpPointSeq = this.jumpPointSeq(obj["jumpPointSeq"] as Array);
			s.areas = this.areas(obj.areas);
			s.defaultBossPoint = obj.hasOwnProperty("defaultBossPoint") ? obj["defaultBossPoint"] : false;
			///////////////////////////////////////////////////////
			var bossPoint:SPoint = new SPoint();
			bossPoint.x = obj.hasOwnProperty("bossPoint") ? obj["bossPoint"].x : 0;
			bossPoint.y = obj.hasOwnProperty("bossPoint") ? obj["bossPoint"].y : 0;
			s.bossPoint = bossPoint;
			///////////////////////////////////////////////////////
			s.showLimit = obj["showLimit"];
			return s;
		}
		
		public function toObject(sMapDefine:SMapDefine):Object
		{
			var obj:Object = new Object();
			
			obj.mapId = sMapDefine.mapId;
			obj.name = sMapDefine.name;
			obj.realWidth = sMapDefine.realWidth;
			obj.realHeight = sMapDefine.realHeight;
			obj.instanceType = sMapDefine.instanceType ? sMapDefine.instanceType.value() : 0;
			obj.clientFile = sMapDefine.clientFile;
			obj.serverFile = sMapDefine.serverFile;
			obj.ownerType = sMapDefine.ownerType ? sMapDefine.ownerType.value() : 0;
			obj.belong = sMapDefine.belong ? sMapDefine.belong.value() : 0;
			obj.fightMode = sMapDefine.fightMode;
			obj.needLevel = sMapDefine.needLevel;
			obj.enterMode = sMapDefine.enterMode;
			if(sMapDefine.enterPoint != null)
			{
				obj.enterPoint = {"x":sMapDefine.enterPoint.x, "y":sMapDefine.enterPoint.y};
			}
			else
			{
				obj.enterPoint = {"x":0, "y":0};
			}
			obj.subline = sMapDefine.subline;
			obj.cross = sMapDefine.cross;
			obj.restrictionType = sMapDefine.restrictionType;
			obj.revivalRestriction = sMapDefine.revivalRestriction;
			obj.revivalMaps = sMapDefine.revivalMaps;
			obj.passPoints = getPassPoints(sMapDefine);
			obj.npcs = getNpcs(sMapDefine);
			obj.sharps = getSharps(sMapDefine);
			obj.weather = sMapDefine.weather;
			obj.musicId = sMapDefine.musicId;
			obj.deathEvents = getDeathEvents(sMapDefine);
			obj.taxRate = sMapDefine.taxRate;
			obj.jumpPointSeq = getJumpPoints(sMapDefine);
			obj.areas = getAreas(sMapDefine);
			obj.defaultBossPoint = sMapDefine.defaultBossPoint;
			obj.bossPoint = sMapDefine.bossPoint ? {x:sMapDefine.bossPoint.x,y:sMapDefine.bossPoint.y} : {x:0,y:0};
			obj.showLimit = sMapDefine.showLimit;
			
			return obj;
		}
		
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////to
		public function toDictionary(obj:Object):Dictionary
		{
			var res:Dictionary = new Dictionary();
			for(var key:String in obj)
			{
				res[key] = obj[key];
			}
			return res;
		}
		
		public function passPoints(passPoints:Array):Array
		{
			var res:Array = [];
			var passPointObj:Object;
			for(var j:int = 0; j<passPoints.length; j++)
			{
				passPointObj = passPoints[j];
				var passPoint:SPassPoint = new SPassPoint();
				passPoint.mapId = passPointObj.mapId;
				passPoint.name = passPointObj.name;
				passPoint.passPointId = passPointObj.passPointId;
				passPoint.process = passPointObj.process ? passPointObj.process : 0;
				passPoint.type = passPointObj.type ? passPointObj.type : 0;
				passPoint.effectName = passPointObj["effectName"];
				if(passPoint.hasOwnProperty("mapPassRes"))
				{
					passPoint["mapPassRes"] = passPointObj.mapPassRes;
				}
				
				passPoint.point = new SPoint();
				passPoint.point.x = passPointObj.point.x;
				passPoint.point.y = passPointObj.point.y;
				
				passPoint.passTo = readArrToPasstos(passPointObj.passTo as Array);
				
				res.push(passPoint);
			}
			return res;
		}
		
		
		public function readArrToPasstos(arr:Array):Array
		{
			var passTos:Array = new Array();
			
			var passToObj:Object; 
			for(var j:int=0; j<arr.length; j++)
			{
				passToObj = arr[j];
				var passTo:SPassTo = new SPassTo();
				passTo.mapId = passToObj.mapId;
				passTo.name = passToObj.name;
				passTo.passToId = passToObj.passToId;
				
				passTo.toPoint = new SPoint();
				passTo.toPoint.x = passToObj.toPoint.x;
				passTo.toPoint.y = passToObj.toPoint.y;
				
				passTos.push(passTo);
			}
			
			return passTos;
		}
		
		public function npcs(npcs:Array):Array
		{
			var res:Array = [];
			var npcObj:Object;
			for(var n:int=0; n<npcs.length; n++)
			{
				npcObj = npcs[n];
				var npc:SNpc = new SNpc();
				npc.mapId = npcObj.mapId;
				npc.name = npcObj.name;
				npc.npcId = npcObj.npcId;
				
				if(npcObj.hasOwnProperty("npcType"))
				{
					npc.npcType = new ENpcType(npcObj.npcType);
				}
				else
				{
					npc.npcType = new ENpcType(0);
				}
				//增加判断是否在小地图显示字段，判断是否是老数据，如果是老数据，则此字段赋值为0
				if(npcObj.hasOwnProperty("notShowInMap"))
				{
					npc.notShowInMap = npcObj.notShowInMap;
				}
				else
				{
					npc.notShowInMap = 0;
				}
				
				npc.point = new SPoint();
				npc.point.x = npcObj.point.x;
				npc.point.y = npcObj.point.y;
				
				npc.relPoint = new SPoint();
				if(npcObj.hasOwnProperty("relPoint"))
				{
					npc.relPoint.x = npcObj.relPoint.x;
					npc.relPoint.y = npcObj.relPoint.y;
				}
				else
				{
					npc.relPoint.x = npc.point.x;
					npc.relPoint.y = npc.point.y;
				}
				
				npc.passTo = readArrToPasstos(npcObj.passTo as Array);
				res.push(npc);
			}
			return res;
		}
		
		public function areas(areas:Array):Array
		{
			var res:Array = [];
			if(areas == null)
			{
				return res;
			}
			var areaObj:Object;
			for(var m:int=0; m<areas.length; m++)
			{
				areaObj = areas[m];
				var area:SMapArea = new SMapArea();
				area.areaId = areaObj.areaId;
				area.mapId = areaObj.mapId;
				area.name = areaObj.name;
				area.plans = areaObj.plans;
				area.point = new SPoint();
				area.point.x = areaObj.point.x;
				area.point.y = areaObj.point.y;
				res.push(area);
			}
			return res;
		}
		
		public function sharps(sharps:Array):Array
		{
			var res:Array = [];
			if(sharps == null)
			{
				return res;
			}
			var sharpObj:Object;
			var points:Array;
			var point:SPoint;
			for(var i:int = 0; i < sharps.length; i++)
			{
				sharpObj = sharps[i];
				var sharp:SMapSharp = new SMapSharp();
				sharp.sharpId = sharpObj.sharpId;
				sharp.type = new EMapPointType(sharpObj.type);
				
				sharp.points = new Array();
				points = sharpObj.points as Array;
				for(var j:int = 0; j < points.length; j++)
				{
					point = new SPoint();
					point.x = points[j].x;
					point.y = points[j].y;
					sharp.points.push(point);
				}
				res.push(sharp);
			}
			return res;
			
			
			
		}
		
		public function deathEvents(arr:Array):Array
		{
			var res:Array = [];
			if(arr == null)
			{
				return res;
			}
			for(var i:int = 0; i < arr.length; i++)
			{
				var obj:Object = arr[i];
				var deathData:SMapDeathEvent = new SMapDeathEvent();
				deathData.event = obj["event"];
				deathData.lower = obj["lower"];
				deathData.type = obj["type"];
				deathData.upper = obj["upper"];
				deathData.value = obj["value"];
				res.push(deathData);
			}
			return res;
		}
		
		public function jumpPointSeq(arr:Array):Array
		{
			var res:Array = [];
			if(arr == null)
			{
				return res;
			}
			for(var i:int = 0; i < arr.length; i++)
			{
				var tmp:Array = arr[i] as Array;
				var tt:Array = [];
				for(var j:int = 0; j < tmp.length; j++)
				{
					var obj:Object = tmp[j];
					var p:SPoint = new SPoint();
					p.x = obj["x"];
					p.y = obj["y"];
					tt.push(p);
				}
				res[i] = tt;
			}
			return res;
		}
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////// get 
		private function getDeathEvents(sMapDefine:SMapDefine):Array
		{
			var arr:Array = [];
			var obj:Object;
			for each(var deadEventData:SMapDeathEvent in sMapDefine.deathEvents)
			{
				obj = {};
				obj["type"] = deadEventData.type;
				obj["event"] = deadEventData.event;
				obj["lower"] = deadEventData.lower;
				obj["upper"] = deadEventData.upper;
				obj["value"] = deadEventData.value;
				arr.push(obj);
			}
			return arr;
		}
		
		private function getPassPoints(sMapDefine:SMapDefine):Array
		{
			var arr:Array = new Array();
			var len:int = sMapDefine.passPoints.length;
			var obj:Object;
			var spassPoint:SPassPoint;
			for(var i:int=0; i<len; i++)
			{
				spassPoint = sMapDefine.passPoints[i] as SPassPoint;
				obj = {};
				obj.passPointId = spassPoint.passPointId;
				obj.mapId = spassPoint.mapId;
				obj.name = spassPoint.name;
				obj.process = spassPoint.process;
				obj.type = spassPoint.type;
				obj.effectName = spassPoint.effectName;
				if( spassPoint.hasOwnProperty("mapPassRes") )
				{
					obj.mapPassRes = spassPoint["mapPassRes"];
				}
				obj.point = {x:spassPoint.point.x,y:spassPoint.point.y};
				
				var tempArr:Array = new Array();
				var tempPassTo:SPassTo;
				var tempObj:Object;
				for(var j:int=0; j<spassPoint.passTo.length; j++)
				{
					tempPassTo = spassPoint.passTo[j] as SPassTo;
					
					tempObj = {};
					tempObj.mapId = tempPassTo.mapId;
					tempObj.name = tempPassTo.name;
					tempObj.passToId = tempPassTo.passToId;
					tempObj.toPoint = {x:tempPassTo.toPoint.x,y:tempPassTo.toPoint.y};
					
					tempArr.push(tempObj);
				}
				obj.passTo = tempArr;
				
				arr.push(obj);
			}
			return arr;
		}
		private function getNpcs(sMapDefine:SMapDefine):Array
		{
			var arr:Array = new Array();
			var obj:Object;
			var snpc:SNpc;
			var len:int = sMapDefine.npcs.length;
			for(var i:int=0; i<len; i++)
			{
				snpc = sMapDefine.npcs[i] as SNpc;
				obj = {};
				obj.mapId = snpc.mapId;
				obj.name = snpc.name;
				obj.npcId = snpc.npcId;
				obj.npcType = snpc.npcType.value();
				obj.notShowInMap = snpc.notShowInMap;
				//				obj.isTurn = snpc.isTurn;
				obj.point = {x:snpc.point.x,y:snpc.point.y};
				obj.relPoint = {x:snpc.relPoint.x,y:snpc.relPoint.y};
				
				var tempArr:Array = new Array();
				var tempPassTo:SPassTo;
				var tempObj:Object;
				for(var j:int=0; j<snpc.passTo.length; j++)
				{
					tempPassTo = snpc.passTo[j] as SPassTo;
					
					tempObj = {};
					tempObj.mapId = tempPassTo.mapId;
					tempObj.name = tempPassTo.name;
					tempObj.passToId = tempPassTo.passToId;
					tempObj.toPoint = {x:tempPassTo.toPoint.x,y:tempPassTo.toPoint.y};
					
					tempArr.push(tempObj);
				}
				obj.passTo = tempArr;
				
				arr.push(obj);
			}
			return arr;
		}
		
		private function getJumpPoints(sMapDefine:SMapDefine):Array
		{
			var len:int = sMapDefine.jumpPointSeq.length;
			var res:Array = [];
			for(var i:int = 0; i < len; i++)
			{
				var tmp:Array = [];
				res[i] = tmp;
				var arr:Array = sMapDefine.jumpPointSeq[i];
				for(var j:int = 0; j < arr.length; j++)
				{
					var p:SPoint = arr[j];
					tmp.push({"x":p.x, "y":p.y});
				}
			}
			return res;
		}
		
		private function getAreas(sMapDefine:SMapDefine):Array
		{
			var arr:Array = new Array();
			var obj:Object;
			var area:SMapArea;
			var len:int = sMapDefine.areas.length;
			for(var i:int=0; i<len; i++)
			{
				area = sMapDefine.areas[i] as SMapArea;
				obj = {};
				obj.areaId = area.areaId;
				obj.mapId = area.mapId;
				obj.name = area.name;
				obj.plans = area.plans;
				obj.point = {x:area.point.x,y:area.point.y};
				arr.push(obj);
			}
			return arr;
		}
		
		private function getSharps(sMapDefine:SMapDefine):Array
		{
			var arr:Array = new Array();
			var points:Array;
			var point:SPoint;
			var obj:Object;
			var sharp:SMapSharp;
			var len:int = sMapDefine.sharps.length;
			for(var i:int=0; i<len; i++)
			{
				sharp = sMapDefine.sharps[i] as SMapSharp;
				obj = {};
				obj.sharpId = sharp.sharpId;
				obj.type = sharp.type.value();
				
				points = new Array();
				if(sharp.points)
				{
					for(var j:int=0; j<sharp.points.length; j++)
					{
						point = sharp.points[j] as SPoint;
						points.push({x:point.x,y:point.y});
					}
				}
				obj.points = points;
				arr.push(obj);
			}
			return arr;
		}
		
	}
}