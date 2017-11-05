/**
 * 2014-2-18
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.mapToMapPath
{
	import Message.Public.SPassPoint;
	import Message.Public.SPassTo;
	
	import flash.utils.Dictionary;
	
	import mortal.game.cache.SceneCache;
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;

	public class MapPathSearcher
	{
		public function MapPathSearcher()
		{
		}
		
		/**
		 * 查找地图通路， 从地图A到地图B的最短通路 
		 * @param fromMapId
		 * @param toMapId
		 * @return 
		 * 
		 */		
		public static function findMapPath(fromMapId:int, toMapId:int):Vector.<SPassPoint>
		{
			if(fromMapId == toMapId)
			{
				return null;
			}
			var fromInfo:SceneInfo = SceneConfig.instance.getSceneInfo(fromMapId);
			var toInfo:SceneInfo = SceneConfig.instance.getSceneInfo(toMapId);
			if(fromInfo == null || toInfo == null)
			{
				return null;
			}
			var list:Array = [];
			var red:Dictionary = new Dictionary();
			var links:Dictionary = new Dictionary();
			var link:MapPathLink = new MapPathLink();
			links[fromMapId] = link;
			list.push(fromMapId);
			red[fromMapId] = true;
			var endLink:MapPathLink;
			
			while(list.length > 0)
			{
				var mapId:int = list.shift();
				var parent:MapPathLink = links[mapId];
				var info:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
				var isReach:Boolean = false;
				for each( var passPoint:SPassPoint in info.passInfos  )
				{
					if(passPoint.passTo == null || passPoint.passTo[0] == null)
					{
						continue;
					}
					var toId:int = SPassTo(passPoint.passTo[0]).mapId;
					if(red[toId])
					{
						continue;
					}
					red[toId] = true;
					list.push(toId);
					link = new MapPathLink();
					link.parent = parent;
					link.value = passPoint;
					links[toId] = link;
					if(toId == toMapId)
					{
						endLink = link;
						isReach = true;
						break;
					}
					
				}
				if(isReach)
				{
					break;
				}
			}
			
			if(endLink == null)
			{
				return null;
			}
			var res:Vector.<SPassPoint> = new Vector.<SPassPoint>();
			while(endLink.parent != null)
			{
				res.unshift(endLink.value);
				endLink = endLink.parent;
			}
			return res;
		}
		
		private static function pushToList(info:SceneInfo, list:Array):void
		{
			for each( var passPoint:SPassPoint in info.passInfos  )
			{
				
			}
		}
		
		private static function addToList(info:SceneInfo, list:Array, links:Dictionary, parent:MapPathLink):void
		{
			for each( var passPoint:SPassPoint in info.passInfos  )
			{
				list.push(passPoint);
				var link:MapPathLink = new MapPathLink();
				link.value = passPoint;
				link.parent = parent;
				var to:SPassTo = passPoint.passTo[0];
				links[to.mapId] = link;
			}
		}
	}
}