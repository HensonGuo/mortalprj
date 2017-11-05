/**
 * 匀速运动的鱼 
 */
package mortal.game.view.miniGame.fishing.ObjController
{
	import mortal.game.view.miniGame.fishing.Obj.Fish;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;

	public class UniformFishController extends FishController
	{
		private var _xSpeed:Number;
		private var _horizontalDirection:int;
		public function UniformFishController(xSpeed:Number = 0,horizontalDirection:int = FishDirection.RIGHT)
		{
			super();
			_xSpeed = xSpeed;
			_horizontalDirection = horizontalDirection;
		}
		
		override public function autoRun():void
		{
			(_target as Fish).xSpeed = _xSpeed;
			(_target as Fish).horizontalDirection = _horizontalDirection;
		}
	}
}