/**
 * 冲冲鱼
 */
package mortal.game.view.miniGame.fishing.ObjController
{
	import mortal.game.view.miniGame.fishing.Obj.Fish;
	import mortal.game.view.miniGame.fishing.defin.FishDirection;

	public class PowerForceFishController extends FishController
	{
		private var _maxSpeed:Number;
		private var _minSpeed:Number;
		private var _decPer:Number;
		private var _xSpeed:Number;
		private var _horizontalDirection:int;
		
		/**
		 * 
		 * @param maxSpeed 最大速度
		 * @param decPer   减速阻力百分比
		 * @param minSpeed 最小速度
		 * @param horizontalDirection
		 * 
		 */
		public function PowerForceFishController(maxSpeed:Number = 3,decPer:Number = 0.05,minSpeed:Number = 0.1,horizontalDirection:int = FishDirection.RIGHT)
		{
			super();
			_maxSpeed = maxSpeed;
			_minSpeed = minSpeed;
			_decPer = decPer;
			_horizontalDirection = horizontalDirection;
			_xSpeed = _maxSpeed;
		}
		
		private var _count:int = 0;
		
		override public function autoRun():void
		{
			if(_xSpeed == 0)
			{
				_xSpeed = _maxSpeed;
			}
			else
			{
				_xSpeed -= _xSpeed * _decPer;
			}
			_xSpeed = _xSpeed < _minSpeed?0:_xSpeed;
			(_target as Fish).xSpeed = _xSpeed;
			(_target as Fish).horizontalDirection = _horizontalDirection;
			_count++;
		}
	}
}