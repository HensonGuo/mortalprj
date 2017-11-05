/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.util
{
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.view.relive.ReliveType;

	public class GameSceneUtil
	{
		private static var _sceneInfo:SceneInfo;
		
		public function GameSceneUtil()
		{
		}
		
		public static function get sceneInfo():SceneInfo
		{
			return _sceneInfo;
		}

		public static function set sceneInfo(value:SceneInfo):void
		{
			_sceneInfo = value;
		}

		/**
		 * 获取场景的复活类型 
		 * @return 
		 * 
		 */		
		public static function getReliveType():int
		{
//			return ReliveType.Prop;
			var res:int = ReliveType.General;
			if(_sceneInfo == null || _sceneInfo.sMapDefine == null)
			{
				return res;
			}
			var dic:Dictionary = _sceneInfo.sMapDefine.revivalRestriction;
			
			// 默认常规复活， 假如1、2都不空，潜规则为常规复活
			if(dic == null || (dic[1] != null && dic[2] != null))
			{
				return ReliveType.General;
			}
			for(var key:String in dic)
			{
				break;
			}
			
			return int(key);
		}
		
		/**
		 * 复活CD时间，单位秒 
		 * @return 
		 * 
		 */		
		public static function getReliveCD():int
		{
			if(_sceneInfo == null || _sceneInfo.sMapDefine == null 
				|| _sceneInfo.sMapDefine.revivalRestriction == null)
			{
				return 0;
			}
			for each(var cd:int in _sceneInfo.sMapDefine.revivalRestriction)
			{
				break;
			}
			return cd;
		}
	}
}