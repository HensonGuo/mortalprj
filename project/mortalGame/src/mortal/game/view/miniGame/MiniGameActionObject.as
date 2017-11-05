package mortal.game.view.miniGame
{
	public class MiniGameActionObject extends MiniGameObject
	{
		protected var controller:MiniGameBaseController;
		
		public function MiniGameActionObject(ctrl:MiniGameBaseController)
		{
			controller = ctrl;
			controller.target = this;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose();
			controller.dispose();
		}
	}
}