/**
 * 鱼类 
 */
package mortal.game.view.miniGame.fishing.Obj
{
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.view.miniGame.MiniGameActionObject;
	import mortal.game.view.miniGame.fishing.ObjController.FishController;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;

	public class Fish extends FishActionObject
	{
		private var _isDead:Boolean = false;
		
		public function Fish(ctrl:FishController,swfPlayer:SWFPlayer = null)
		{
			super(ctrl,swfPlayer);
		}
		
		/**
		 * 死亡 
		 * 
		 */		
		public function dead():void
		{
			_isDead = true;
		}
		
		/**
		 * 运行 
		 * 
		 */
		override public function Do():void
		{
			if(_isDead)
			{
				//死亡则不做任何操作。。。不再自住行动
				return;
			}
			else
			{
				super.Do();
			}
		}
	}
}