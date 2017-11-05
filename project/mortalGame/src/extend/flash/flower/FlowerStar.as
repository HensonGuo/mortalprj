package extend.flash.flower
{
	import com.gengine.global.Global;
	import com.gengine.utils.MathUitl;
	
	import mortal.game.scene.modle.SWFPlayer;
	
	public class FlowerStar extends SWFPlayer
	{
		private var _acceleration:Number = 0.05; //加速度
		
		private var _speedY:Number = 0;
		
		private var _speedX:Number = 0;
		
		private var _gravity:Number = 0;//0.01
		
		private const _maxSpeedX:Number = 3;
		
		private const _minSpeedY:Number = -3;
		
		private var _alphaHeight:Number;
		
		public function FlowerStar()
		{
			reset();
		}
		
		public function reset():void
		{
			_speedX = MathUitl.random(-3,3);
			_speedY = MathUitl.random(-1,-2);
			_acceleration = 0.05 * MathUitl.getSign(_speedX);
			_alphaHeight =  Global.stage.stageHeight - MathUitl.random(130,300);
			alpha = 1;
		}
		
		public function update():void
		{
			moveXY();
		}
		
		/**
		 * 更新坐标 
		 * 
		 */		
		public function moveXY():void
		{
			var n:int;
			if (_speedX > _maxSpeedX)
			{
				n = MathUitl.random(0, 1);
				if (n == 1)
				{
					_acceleration *= -1;
				}
				_speedX = _maxSpeedX;
			}
			else if (_speedX < -_maxSpeedX)
			{
				n = MathUitl.random(0, 1);
				if (n == 1)
				{
					_acceleration *= -1;
				}
				_speedX = -_maxSpeedX;
			}
			
			_speedY += _gravity;
			if(_speedY < _minSpeedY)
			{
				_speedY = _minSpeedY;
			}
			
			_speedX += _acceleration;
			
			this.sceneX += int(_speedX);
			this.sceneY += int(_speedY);
			
			if(this.sceneY < _alphaHeight)
			{
				this.alpha -= 0.02;
			}
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			_acceleration = 0.08;
			_speedY = 0;
			_speedX = 0;
			_gravity = 0;
			alpha = 1;
			super.dispose(isReuse);
		}
	}
}