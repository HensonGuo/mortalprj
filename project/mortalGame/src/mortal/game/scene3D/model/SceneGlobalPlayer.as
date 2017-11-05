package mortal.game.scene3D.model
{
	import baseEngine.system.Device3D;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.resource.StaticResUrl;
	import mortal.game.scene3D.model.player.EffectPlayer;

	public class SceneGlobalPlayer
	{
		private static var _pointMask:EffectPlayer;
		private static var _selectPlayerMask:EffectPlayer;

		public static function initGlobalPlayers():void
		{
			_pointMask = new EffectPlayer(StaticResUrl.SceneClickObjName,Device3D.scene.renderLayerList);
			_pointMask.layer = Layer3DManager.MapExtendsLayer;
			
			_selectPlayerMask = new EffectPlayer(StaticResUrl.PlayerSelectObjName,Device3D.scene.renderLayerList);
			_selectPlayerMask.layer = Layer3DManager.MapExtendsLayer;
		}
		
		public static function get pointMask():EffectPlayer
		{
			return _pointMask;
		}

		public static function get selectPlayerMask():EffectPlayer
		{
			return _selectPlayerMask;
		}
	}
}