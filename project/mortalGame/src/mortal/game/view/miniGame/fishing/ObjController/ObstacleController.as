package mortal.game.view.miniGame.fishing.ObjController
{
	import mortal.game.view.miniGame.MiniGameObject;
	import mortal.game.view.miniGame.fishing.Obj.Obstacle;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;
	
	public class ObstacleController extends FishBaseController
	{
		private var _xSpeed:Number;
		private var _horizontalDirection:int;
		public function ObstacleController(xSpeed:Number = 0,horizontalDirection:int = FishDirection.RIGHT)
		{
			super();
			_xSpeed = xSpeed;
			_horizontalDirection = horizontalDirection;
		}
		
		override public function set target(obj:MiniGameObject):void
		{
			if(obj is Obstacle)
			{
				super.target = obj;
			}
		}
		
		override public function autoRun():void
		{
			if((_target as Obstacle).isInShake)
			{
				(_target as Obstacle).xSpeed = 0;
			}
			else
			{
				(_target as Obstacle).xSpeed = _xSpeed;
				(_target as Obstacle).horizontalDirection = _horizontalDirection;
			}
		}
	}
}