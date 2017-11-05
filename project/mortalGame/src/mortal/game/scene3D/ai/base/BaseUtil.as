package mortal.game.scene.ai.base
{
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.player.entity.RolePlayer;
	

	/**
	 *
	 * @author huangliang
	 */
	public class BaseUtil
	{
		/**
		 * 场景
		 */
		protected var _scene:GameScene3D;
		/**
		 *自己
		 */
		protected var _meRole:RolePlayer;

		/**
		 *
		 */
		public function BaseUtil()
		{
		}

		/**
		 * 初始化
		 * @param scene
		 * @param meRole
		 */
		public function init(scene:GameScene3D, meRole:RolePlayer):void
		{
			_scene=scene;
			_meRole=meRole;
		}

		/**
		 * AI控制
		 * @param target 目标，可能为：格子点、怪物、角色自己、玩家
		 */
		public function onAIControl(target:*,type:int,skillid:int=0):void
		{

		}

		/**
		 * 取消AI控制
		 */
		public function cancelAll():void
		{
		}


	}
}