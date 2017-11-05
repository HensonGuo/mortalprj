/**
 * 2014-2-18
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection
{
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIIPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridCutter;
	import mortal.game.scene3D.map3D.AstarAnyDirection.processor.MapGridLinker;
	import mortal.game.scene3D.map3D.MapNodeType;

	public class AstarCache
	{
		public function AstarCache()
		{
		}
		
		private static var _instance:AstarCache;
		private var _mapLinks:Dictionary = new Dictionary();
		
		public static function get instance():AstarCache
		{
			if(_instance == null)
			{
				_instance = new AstarCache();
			}
			return _instance;
		}
		
		public function getLink(mapId:int, minWalkValue:int):Vector.<AstarIIPoint>
		{
			var key:String = mapId.toString() + "_" + minWalkValue.toString();
			
			var res:Vector.<AstarIIPoint> = _mapLinks[key];
			if(res == null)
			{
				return null;
			}
			// 重置
			resetLink(res);
			return res;
		}
		
		public function setLink(mapId:int, mapData:Array, minWalkValue:int):void
		{
			var key:String = mapId.toString() + "_" + minWalkValue.toString();
			if(_mapLinks[key] != null)
			{
				return;
			}
			_mapLinks[key] = MapGridCutter.cutMap(mapData, minWalkValue);
			MapGridLinker.calcLink(_mapLinks[key]);
		}
		
		public function resetLink(_v:Vector.<AstarIIPoint>):void
		{
			var len:int;
			var p:AstarIIPoint;
			
			len = _v.length;
			for(var i:int = 0 ; i < len; i++)
			{
				p = _v[i];
				p.parent = null;
				p.linkTM = -1;
				p.f = 0;
				p.g = 0;
				p.h = 0;
			}
		}
	}
}