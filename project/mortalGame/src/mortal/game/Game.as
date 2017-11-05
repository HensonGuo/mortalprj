package mortal.game
{
	import com.fyGame.fyMap.FyMapInfo;
	
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	
	public class Game
	{
		public static var scene:GameScene3D;
		
		//public static var rolePlayer:RolePlayer;
		
		public static var mapInfo:FyMapInfo;
		
		private static var _sceneInfo:SceneInfo;
		
		public function Game()
		{
			
		}

		public static function get sceneInfo():SceneInfo
		{
			return _sceneInfo || (_sceneInfo=new SceneInfo());
		}

		public static function set sceneInfo(value:SceneInfo):void
		{
			_sceneInfo = value;
		}

		public static function isSceneInit():Boolean
		{
			return scene && scene.isInitialize;
		}
	}
}