/**
 * 鱼控制器 
 */
package mortal.game.view.miniGame.fishing.ObjController
{
	import mortal.game.view.miniGame.MiniGameActionObject;
	import mortal.game.view.miniGame.MiniGameBaseController;
	import mortal.game.view.miniGame.MiniGameObject;
	import mortal.game.view.miniGame.fishing.Obj.Fish;

	public class FishController extends FishBaseController
	{
		public function FishController()
		{
			super();
		}
		
		override public function set target(obj:MiniGameObject):void
		{
			if(obj is Fish)
			{
				super.target = obj;
			}
		}
	}
}